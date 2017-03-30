--******************************************************************************
--*
--* Module          : TOP
--* File            : top.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     28-05-13 1.0 sync reset
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_fee_if is
  
  port (
    foclk       : in    std_logic;       -- front-end clock
    arst       : in    std_logic;       -- async reset (active low)
    fiten       : in    std_logic;       -- transfer enable from the FE
    fictrl      : in    std_logic;       -- control word from the FE
    fid         : in    std_logic_vector (31 downto 0);
    foten       : out   std_logic;       -- transfer enable to the FE
    foctrl      : out   std_logic;       -- control word to the FE
    fod         : out   std_logic_vector (31 downto 0);
    fb_oen      : out   std_logic;       -- FE bus output enable
    fb_lben     : in    std_logic;       -- FE bus loopback enable
    fiben_n     : out   std_logic;       -- FE bus enable (active low)
    fidir       : out   std_logic;       -- FE bus direction
    filf_n      : out   std_logic;       -- SIU indicates link full
    fobsy_n     : in    std_logic;       -- FE indicates busy
    rxdf_q      : in    std_logic_vector (32 downto 0);
    rxdf_empty  : in    std_logic;       -- Link-to-FE FIFO is empty
    rxdf_rdreq  : out   std_logic;       -- Link-to-FE FIFO read request
    bwtr_open   : out   std_logic;       -- Block write stream is open
    brtr_open   : out   std_logic;       -- Block read stream is open
    txdf_d      : out   std_logic_vector (33 downto 0);
    txdf_wrreq  : out   std_logic;       -- FE-to-Link FIFO write request
    txdf_full   : in    std_logic;       -- FE-to-Link FIFO is full
    txdf_afull  : in    std_logic;
    txdf_aempty : in    std_logic;
    err_ilfdat  : out   std_logic;       -- Illegal FE data
    err_ilfsts  : out   std_logic;       -- Illegal FE status
    err_txof    : out   std_logic;       -- FE-to-Link FIFO overflow
    err_wrdata  : out   std_logic;       -- Illegal data from the DDL
    err_prot    : out   std_logic;       -- Protocol error
    err_levnt   : out   std_logic;       -- Too long event from the FE
    err_block   : out   std_logic;       -- Block length mismatch
    fee_isidle  : out   std_logic);      -- FE bus is in idle

end siu_fee_if;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_fee_if is

  constant CMD_FCTRL : std_logic_vector := "1100";
  constant CMD_FSTRD : std_logic_vector := "0100";
  constant CMD_STBWR : std_logic_vector := "1101";
  constant CMD_STBRD : std_logic_vector := "0101";
  constant CMD_RDYRX : std_logic_vector := "0001";
  constant CMD_EOBTR : std_logic_vector := "1011";
  constant CMD_DTCC  : std_logic_vector := "1000";

  type bdir_state is (
    BDIR_OUTPUT,                        -- FE bus is driven by the SIU
    BDIR_TURNIN1,                       -- FE bus direction is changing
    BDIR_TURNIN2,                       -- FE bus direction is changing
    BDIR_TURNIN3,                       -- FE bus direction is changing
    BDIR_TURNIN4,                       -- FE bus direction is changing
    BDIR_INPUT,                         -- FE bus is driven by the FEE
    BDIR_TURNOUT1,                      -- FE bus direction is changing
    BDIR_TURNOUT2,                      -- FE bus direction is changing
    BDIR_TURNOUT3,                      -- FE bus direction is changing
    BDIR_TURNOUT4                       -- FE bus direction is changing
    );

  type fin_state is (
    FIN_IDLE,                           -- wait for any command
    FIN_FEECMD,                         -- evaluate the command
    FIN_INVCMD,                         -- invalid command
    FIN_FCTRLCMD,                       -- send FECTRL command
    FIN_FSTRDCMD,                       -- send FESTRD command
    FIN_FSTRDWAIT,                      -- wait for front-end status
    FIN_FSTRDTERM,                      -- terminate status read transaction
    FIN_BWRCMD,                         -- send STBWR command
    FIN_BWRDATA,                        -- send block data
    FIN_BWRWAIT,                        -- wait for data to be sent
    FIN_BWRDTCC,                        -- check DTCC command
    FIN_BWRTERM,                        -- terminate block write transaction
    FIN_BRDCMD,                         -- send block RDYRX, or STBRD
    FIN_BRDWAIT,                        -- wait for EOBTR
    FIN_BRDEND,                         -- signal the end of the read
    FIN_BRDTERM,                        -- terminate block read transaction
    FIN_TESTWAIT,
    FIN_TESTDATA
    );

  type fout_state is (
    FOUT_IDLE,                          -- wait for any data/status
    FOUT_CTSTW1,                        -- service the CTSTW request (1)
    FOUT_CTSTW2,                        -- service the CTSTW request (2)
    FOUT_BUSTOSIU,                      -- wait for the bus to be input
    FOUT_FSTRD,                         -- wait for the front-end status
    FOUT_BRDDATA,                       -- receive data from the FEE
    FOUT_BRDWAIT,                       -- wait for data from the FEE
    FOUT_BRDDTSW,                       -- write the DTSTW into the FIFO
    FOUT_BRDGAP,                        -- wait for the end of the gap
    FOUT_BUSTOFEE,                      -- wait for the bus to be output
    FOUT_TESTDATA
    );

  signal s_fod_int    : std_logic_vector (31 downto 0);
  signal s_foten_int  : std_logic;
  signal s_foctrl_int : std_logic;
  signal s_filf_int   : std_logic;

begin  -- SYN

  proc_main : process (foclk)
    variable v_feecmd_reg  : std_logic_vector (31 downto 0);
    variable v_feestw_reg  : std_logic_vector (31 downto 0);
    variable fstrd_timer   : std_logic_vector (20 downto 0);
    variable word_count    : std_logic_vector (18 downto 0);
    variable wc_enable     : std_logic;
    variable wc_clear      : std_logic;
    variable dtstw_count   : std_logic_vector (19 downto 0);
    variable dc_enable     : std_logic;
    variable dc_clear      : std_logic;
    variable dc_msb        : std_logic;
    variable bwr_count     : std_logic_vector (18 downto 0);
    variable b_fstrd_to    : boolean;
    variable b_turnin_req  : boolean;
    variable b_turnin_ack  : boolean;
    variable b_turnout_req : boolean;
    variable b_turnout_ack : boolean;
    variable b_ctstw_req   : boolean;
    variable b_ctstw_ack   : boolean;
    variable b_fstrd_req   : boolean;
    variable b_fstrd_ack   : boolean;
    variable b_stbrd_req   : boolean;
    variable b_eobtr_req   : boolean;
    variable b_eobtr_ack   : boolean;
    variable b_fctrl_cmd   : boolean;
    variable b_fstrd_cmd   : boolean;
    variable b_stbwr_cmd   : boolean;
    variable b_stbrd_cmd   : boolean;
    variable b_rdyrx_cmd   : boolean;
    variable b_eobtr_cmd   : boolean;
    variable b_dtcc_cmd    : boolean;
    variable b_inval_cmd   : boolean;
    variable b_err_ilfdat  : boolean;
    variable b_err_ilfsts  : boolean;
    variable b_err_txof    : boolean;
    variable b_err_allfee  : boolean;
    variable b_err_fecmd   : boolean;
    variable b_dtcc_match  : boolean;
    variable b_fb_lben     : boolean;
    variable bdir_present  : bdir_state;
    variable bdir_next     : bdir_state;
    variable fin_present   : fin_state;
    variable fin_next      : fin_state;
    variable fout_present  : fout_state;
    variable fout_next     : fout_state;
  begin  -- process proc_main 
    if foclk'event and foclk = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)
        fiben_n      <= '0';
        fidir        <= '0';
        filf_n       <= '1';
        fb_oen       <= '0';
        fod          <= (others => '0');
        foten        <= '0';
        foctrl       <= '0';
        bwtr_open    <= '0';
        brtr_open    <= '0';
        rxdf_rdreq   <= '0';
        txdf_d       <= (others => '0');
        txdf_wrreq   <= '0';
        err_ilfdat   <= '0';
        err_ilfsts   <= '0';
        err_txof     <= '0';
        err_wrdata   <= '0';
        err_prot     <= '0';
        err_levnt    <= '0';
        err_block    <= '0';
        fee_isidle   <= '1';
        s_fod_int    <= (others => '0');
        s_foten_int  <= '0';
        s_foctrl_int <= '0';
        s_filf_int   <= '0';

        v_feecmd_reg  := (others => '0');
        v_feestw_reg  := (others => '0');
        fstrd_timer   := (others => '0');
        word_count    := (others => '0');
        wc_enable     := '0';
        wc_clear      := '0';
        dtstw_count   := (0 => '1', others => '0');
        dc_enable     := '0';
        dc_clear      := '0';
        dc_msb        := '0';
        bwr_count     := (others => '0');
        b_fstrd_to    := false;
        b_turnin_req  := false;
        b_turnin_ack  := false;
        b_turnout_req := false;
        b_turnout_ack := false;
        b_ctstw_req   := false;
        b_ctstw_ack   := false;
        b_fstrd_req   := false;
        b_fstrd_ack   := false;
        b_stbrd_req   := false;
        b_eobtr_req   := false;
        b_eobtr_ack   := false;
        b_fctrl_cmd   := false;
        b_fstrd_cmd   := false;
        b_stbwr_cmd   := false;
        b_stbrd_cmd   := false;
        b_rdyrx_cmd   := false;
        b_eobtr_cmd   := false;
        b_dtcc_cmd    := false;
        b_inval_cmd   := false;
        b_err_ilfdat  := false;
        b_err_ilfsts  := false;
        b_err_txof    := false;
        b_err_allfee  := false;
        b_err_fecmd   := false;
        b_dtcc_match  := false;
        b_fb_lben     := false;
        bdir_present  := BDIR_OUTPUT;
        bdir_next     := BDIR_OUTPUT;
        fin_present   := FIN_IDLE;
        fin_next      := FIN_IDLE;
        fout_present  := FOUT_IDLE;
        fout_next     := FOUT_IDLE;

      else
        -- Default values. For actual values see below.
        foten        <= '0';
        foctrl       <= '0';
        s_foten_int  <= '0';
        s_foctrl_int <= '0';
        rxdf_rdreq   <= '0';
        txdf_wrreq   <= '0';
        err_ilfsts   <= '0';
        err_ilfdat   <= '0';
        err_wrdata   <= '0';
        err_block    <= '0';
        err_prot     <= '0';

        b_fstrd_req := fin_present = FIN_FSTRDWAIT;
        b_fstrd_ack := fout_present = FOUT_BUSTOFEE;
        b_stbrd_req := fin_present = FIN_BRDWAIT;
        b_eobtr_req := fin_present = FIN_BRDEND;
        b_eobtr_ack := fout_present = FOUT_BUSTOFEE;
        b_ctstw_req := fin_present = FIN_INVCMD or
                       fin_present = FIN_FCTRLCMD or
                       fin_present = FIN_FSTRDTERM or
                       fin_present = FIN_BWRCMD or
                       fin_present = FIN_BWRTERM or
                       fin_present = FIN_BRDCMD or
                       fin_present = FIN_BRDTERM;
        b_ctstw_ack := fout_present = FOUT_CTSTW1;

        if fin_present = FIN_BWRCMD then
          bwr_count := (others => '0');
        elsif fin_present = FIN_BWRDATA then
          if rxdf_empty = '0' and rxdf_q(32) = '0' then
            bwr_count := inc(bwr_count);
          end if;
        end if;

        fee_isidle <= bool2sl(fin_present = FIN_IDLE);
        case fin_present is
          when FIN_IDLE =>
            b_err_fecmd := false;
            rxdf_rdreq <= not rxdf_empty;
            if rxdf_empty = '0' and rxdf_q(32) = '1' then
              v_feecmd_reg := rxdf_q(31 downto 0);
              fin_next := FIN_FEECMD;
            elsif b_fb_lben then
              fin_next := FIN_TESTWAIT;
            else
              err_wrdata <= not rxdf_empty and not rxdf_q(32);
              fin_next := FIN_IDLE;
            end if;
          when FIN_FEECMD =>
            if b_fctrl_cmd then
              fin_next := FIN_FCTRLCMD;
            elsif b_fstrd_cmd then
              fin_next := FIN_FSTRDCMD;
            elsif b_stbwr_cmd then
              fin_next := FIN_BWRCMD;
            elsif b_stbrd_cmd or b_rdyrx_cmd then
              fin_next := FIN_BRDCMD;
            elsif b_dtcc_cmd then
              err_prot <= '1';
              fin_next := FIN_IDLE;
            elsif b_eobtr_cmd then
              err_prot <= '1';
              fin_next := FIN_INVCMD;
            else
              fin_next := FIN_INVCMD;
            end if;
          when FIN_INVCMD =>
            b_err_fecmd := true;
            if b_ctstw_ack then
              fin_next := FIN_IDLE;
            else
              fin_next := FIN_INVCMD;
            end if;
          when FIN_FCTRLCMD =>
            if b_ctstw_ack then
              fod    <= v_feecmd_reg;
              foten  <= '1';
              foctrl <= '1';
              fin_next := FIN_IDLE;
            else
              fin_next := FIN_FCTRLCMD;
            end if;
          when FIN_FSTRDCMD =>
            fod    <= v_feecmd_reg;
            foten  <= '1';
            foctrl <= '1';
            fin_next := FIN_FSTRDWAIT;
          when FIN_FSTRDWAIT =>
            if b_fstrd_ack then
              fin_next := FIN_FSTRDTERM;
            else
              fin_next := FIN_FSTRDWAIT;
            end if;
          when FIN_FSTRDTERM =>
            if b_ctstw_ack then
              fin_next := FIN_IDLE;
            else
              fin_next := FIN_FSTRDTERM;
            end if;
          when FIN_BWRCMD =>
            fod    <= v_feecmd_reg;
            bwtr_open    <= '1';
            if b_ctstw_ack then
              foten  <= '1';
              foctrl <= '1';
              fin_next := FIN_BWRWAIT;
            else
              fin_next := FIN_BWRCMD;
            end if;
          when FIN_BWRDATA =>
            fod    <= rxdf_q(31 downto 0);
            foctrl <= '0';
            if rxdf_empty = '1' or rxdf_q(32) = '1' then
              fin_next := FIN_BWRWAIT;
            elsif fobsy_n = '0' then
              foten  <= '1';
              fin_next := FIN_BWRWAIT;
            elsif rxdf_empty = '0' and rxdf_q(32) = '0' then
              rxdf_rdreq <= '1';
              foten  <= '1';
              fin_next := FIN_BWRDATA;
            else
              fin_next := FIN_BWRDATA;
            end if;
          when FIN_BWRWAIT =>
            rxdf_rdreq <= not rxdf_empty and fobsy_n;
            if rxdf_empty = '0' and rxdf_q(32) = '1' and fobsy_n = '1' then
              v_feecmd_reg := rxdf_q(31 downto 8) & "10110100";
              if rxdf_q(7 downto 4) = "1000" then
                fin_next := FIN_BWRDTCC;
              else
                err_prot <= bool2sl(rxdf_q(7 downto 4) /= "1011");
                b_err_fecmd := rxdf_q(7 downto 4) /= "1011";
                fin_next := FIN_BWRTERM;
              end if;
            elsif rxdf_empty = '0' and rxdf_q(32) = '0' and fobsy_n = '1' then
              fin_next := FIN_BWRDATA;
            else
              fin_next := FIN_BWRWAIT;
            end if;
          when FIN_BWRDTCC =>
            err_block <= bool2sl(not b_dtcc_match);
            fin_next := FIN_BWRWAIT;
          when FIN_BWRTERM =>
            fod    <= v_feecmd_reg;
            bwtr_open    <= '0';
            if b_ctstw_ack then
              foten  <= '1';
              foctrl <= '1';
              fin_next := FIN_IDLE;
            else
              fin_next := FIN_BWRTERM;
            end if;
          when FIN_BRDCMD =>
            fod    <= v_feecmd_reg;
            brtr_open    <= '1';
            if b_ctstw_ack then
              foten  <= '1';
              foctrl <= '1';
              fin_next := FIN_BRDWAIT;
            else
              fin_next := FIN_BRDCMD;
            end if;
          when FIN_BRDWAIT =>
            v_feecmd_reg := rxdf_q(31 downto 0);
            rxdf_rdreq <= not rxdf_empty;
            err_wrdata <= not rxdf_empty and not rxdf_q(32);
            if rxdf_empty = '0' and rxdf_q(32) = '1' then
              b_err_fecmd := rxdf_q(7 downto 4) /= "1011";
              err_prot <= bool2sl(rxdf_q(7 downto 4) /= "1011");
              fin_next := FIN_BRDEND;
            else
              fin_next := FIN_BRDWAIT;
            end if;
          when FIN_BRDEND =>
            if b_eobtr_ack then
              fin_next := FIN_BRDTERM;
            else
              fin_next := FIN_BRDEND;
            end if;
          when FIN_BRDTERM =>
            fod    <= v_feecmd_reg;
            brtr_open    <= '0';
            if b_ctstw_ack then
              foten  <= '1';
              foctrl <= '1';
              fin_next := FIN_IDLE;
            else
              fin_next := FIN_BRDTERM;
            end if;
          when FIN_TESTWAIT =>
            if not b_fb_lben then
              fin_next := FIN_IDLE;
            elsif rxdf_empty = '0' and s_filf_int = '0' then
              rxdf_rdreq <= '1';
              fin_next := FIN_TESTDATA;
            else
              fin_next := FIN_TESTWAIT;
            end if;
          when FIN_TESTDATA =>
            s_fod_int <= rxdf_q(31 downto 0);
            if not b_fb_lben then
              fin_next := FIN_IDLE;
            elsif rxdf_empty = '1' then
              fin_next := FIN_TESTWAIT;
            elsif s_filf_int = '1' then
              s_foten_int  <= '1';
              s_foctrl_int <= rxdf_q(32);
              fin_next := FIN_TESTWAIT;
            else
              rxdf_rdreq <= '1';
              s_foten_int  <= '1';
              s_foctrl_int <= rxdf_q(32);
              fin_next := FIN_TESTDATA;
            end if;
        end case;
        fin_present := fin_next;

        b_fctrl_cmd := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_FCTRL;
        b_fstrd_cmd := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_FSTRD;
        b_stbwr_cmd := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_STBWR;
        b_stbrd_cmd := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_STBRD;
        b_rdyrx_cmd := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_RDYRX;
        b_eobtr_cmd := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_EOBTR;
        b_dtcc_cmd  := rxdf_q(32) = '1' and
                       rxdf_q(31) = '0' and
                       rxdf_q(7 downto 4) = CMD_DTCC;
        b_dtcc_match := rxdf_q(30 downto 12) = bwr_count;

        if rxdf_q(32) = '1' and rxdf_q(3 downto 0) = "0100" and
          (rxdf_q(31) = '1' or
           rxdf_q(7 downto 4) = "0000" or
           rxdf_q(7 downto 4) = "0010" or
           rxdf_q(7 downto 4) = "0011" or
           rxdf_q(7 downto 4) = "0110" or
           rxdf_q(7 downto 4) = "0111" or
           rxdf_q(7 downto 4) = "1000" or
           rxdf_q(7 downto 4) = "1001" or
           rxdf_q(7 downto 4) = "1010" or
           rxdf_q(7 downto 4) = "1110" or
           rxdf_q(7 downto 4) = "1111") then
          b_inval_cmd := true;
        elsif fout_present = FOUT_CTSTW2 then
          b_inval_cmd := false;
        end if;

        b_fstrd_to := fstrd_timer(20) = '1';
        if fout_present = FOUT_CTSTW1 then
          fstrd_timer := (others => '0');
        elsif not b_fstrd_to and fout_present = FOUT_FSTRD then
          fstrd_timer := inc(fstrd_timer);
        end if;

        b_turnin_req := fout_present = FOUT_BUSTOSIU;
        b_turnin_ack := bdir_present = BDIR_INPUT;
        b_turnout_req := fout_present = FOUT_BUSTOFEE;
        b_turnout_ack := bdir_present = BDIR_OUTPUT;
        err_levnt   <= '0';               -- !!! replace with new error
        b_err_txof  := txdf_full = '1';
        err_txof    <= bool2sl(b_err_txof);

        dc_msb := dtstw_count(19);
        if wc_clear = '1' then
          word_count := (others => '0');
        elsif wc_enable = '1' then
          if fiten = '1' and fictrl = '0' then
            if dc_msb = '1' then
              word_count := (0 => '1', others => '0');
            else
              word_count := inc(word_count);
            end if;
          end if;
        end if;
        wc_clear := '0';
        if dc_clear = '1' then
          dtstw_count := (0 => '1', others => '0');
        elsif dc_enable = '1' then
          if fiten = '1' and fictrl = '0' then
            if dc_msb = '1' then
              dtstw_count := (1 => '1', others => '0');
            else
              dtstw_count := inc(dtstw_count);
            end if;
          end if;
        end if;
        dc_clear := '0';
        case fout_present is
          when FOUT_IDLE =>
            b_err_ilfdat := false;
            b_err_ilfsts := false;
            if b_fstrd_req or b_stbrd_req then
              fout_next := FOUT_BUSTOSIU;
            elsif b_ctstw_req then
              fout_next := FOUT_CTSTW1;
            elsif b_fb_lben then
              fout_next := FOUT_TESTDATA;
            else
              fout_next := FOUT_IDLE;
            end if;
          when FOUT_CTSTW1 =>
            txdf_d(3 downto 0) <= "0100";
            txdf_d(4) <= bool2sl(b_fstrd_to);
            txdf_d(5) <= bool2sl(b_inval_cmd);
            txdf_d(6) <= '0';
            txdf_d(7) <= '0';
            txdf_d(11 downto  8) <= v_feecmd_reg(11 downto  8);
            txdf_d(30 downto 12) <= v_feecmd_reg(30 downto 12);
            txdf_d(31) <= v_feecmd_reg(31) or bool2sl(b_fstrd_to or
                                                      b_err_fecmd or
                                                      b_inval_cmd);
            txdf_d(32) <= '1';
            txdf_d(33) <= '1';
            txdf_wrreq <= '1';
            fout_next := FOUT_CTSTW2;
          when FOUT_CTSTW2 =>
            if not b_ctstw_req then
              fout_next := FOUT_IDLE;
            else
              fout_next := FOUT_CTSTW2;
            end if;
          when FOUT_BUSTOSIU =>
            if b_turnin_ack then
              if b_fstrd_req then
                fout_next := FOUT_FSTRD;
              elsif b_stbrd_req then
                fout_next := FOUT_BRDGAP;
              else
                fout_next := FOUT_BUSTOFEE;
              end if;
            else
              fout_next := FOUT_BUSTOSIU;
            end if;
          when FOUT_FSTRD =>
            txdf_d <= '1' & '1' & fiD;
            if fiten = '1' and fictrl = '0' then
              err_ilfdat   <= '1';
              b_err_ilfdat := true;
            end if;
            if fiten = '1' and fictrl = '1' then
              txdf_wrreq <= '1';
              fout_next := FOUT_BUSTOFEE;
            elsif b_fstrd_to then
              fout_next := FOUT_BUSTOFEE;
            else
              fout_next := FOUT_FSTRD;
            end if;
          when FOUT_BRDDATA =>
            txdf_d <= dc_msb & '0' & fiD;
            if fiten = '1' and fictrl = '0' then
              txdf_wrreq <= '1';
            end if;
            if fiten = '1' and fictrl = '1' then
              if fiD(7 downto 4) /= "0110" then
                err_ilfsts   <= '1';
                b_err_ilfsts := true;
              end if;
              v_feestw_reg := fiD;
              fout_next := FOUT_BRDDTSW;
            elsif fiten = '0' then
              fout_next := FOUT_BRDWAIT;
            else
              fout_next := FOUT_BRDDATA;
            end if;
          when FOUT_BRDWAIT =>
            txdf_d <= dc_msb & '0' & fiD;
            if fiten = '1' and fictrl = '0' then
              txdf_wrreq <= '1';
            end if;
            if fiten = '1' and fictrl = '1' then
              if fiD(7 downto 4) /= "0110" then
                err_ilfsts   <= '1';
                b_err_ilfsts := true;
              end if;
              v_feestw_reg := fiD;
              fout_next := FOUT_BRDDTSW;
            elsif fiten = '1' and fictrl = '0' then
              fout_next := FOUT_BRDDATA;
            else
              fout_next := FOUT_BRDWAIT;
            end if;
          when FOUT_BRDDTSW =>
            b_err_ilfsts := false;
            b_err_ilfdat := false;
            wc_clear := '1';
            dc_clear := '1';
            txdf_d( 7 downto  0) <= "10000010";
            txdf_d(11 downto  8) <= "0000";
            txdf_d(30 downto 12) <= word_count;
            txdf_d(31) <= v_feestw_reg(31) or bool2sl(b_err_allfee);
            txdf_d(32) <= '1';
            txdf_d(33) <= '1';
            txdf_wrreq <= '1';
            fout_next := FOUT_BRDGAP;
          when FOUT_BRDGAP =>
            txdf_d <= dc_msb & '0' & fiD;
            if fiten = '1' and fictrl = '1' then
              err_ilfsts   <= '1';
              b_err_ilfsts := true;
            end if;
            if fiten = '1' and fictrl = '0' then
              txdf_wrreq <= '1';
            end if;
            if fiten = '1' and fictrl = '0' then
              fout_next := FOUT_BRDDATA;
            elsif b_eobtr_req then
              fout_next := FOUT_BUSTOFEE;
            else
              fout_next := FOUT_BRDGAP;
            end if;
          when FOUT_BUSTOFEE =>
            if b_turnout_ack then
              fout_next := FOUT_IDLE;
            else
              fout_next := FOUT_BUSTOFEE;
            end if;
          when FOUT_TESTDATA =>
            if not b_fb_lben then
              fout_next := FOUT_IDLE;
            else
              txdf_wrreq <= s_foten_int;
              txdf_d <= s_foctrl_int & s_foctrl_int & s_fod_int;
              fout_next := FOUT_TESTDATA;
            end if;
        end case;
        fout_present := fout_next;
        if fout_next = FOUT_BRDGAP or
          fout_next = FOUT_BRDDATA or
          fout_next = FOUT_BRDWAIT then
          wc_enable := '1';
          dc_enable := '1';
        else
          wc_enable := '0';
          dc_enable := '0';
        end if;
        b_err_allfee := b_err_ilfsts or
                        b_err_ilfdat or
                        b_err_txof;       -- !!! add new block length error

        fiben_n <= '0';                   -- default state, bus enabled
        case bdir_present is
          when BDIR_OUTPUT =>
            fb_oen <= '1';
            if b_turnin_req then
              bdir_next := BDIR_TURNIN1;
            else
              bdir_next := BDIR_OUTPUT;
            end if;
          when BDIR_TURNIN1 =>
            fb_oen <= '0';
            fiben_n <= '1';
            bdir_next := BDIR_TURNIN2;
          when BDIR_TURNIN2 =>
            fiben_n <= '1';
            bdir_next := BDIR_TURNIN3;
          when BDIR_TURNIN3 =>
            fidir <= '1';
            fiben_n <= '1';
            bdir_next := BDIR_TURNIN4;
          when BDIR_TURNIN4 =>
            fiben_n <= '1';
            bdir_next := BDIR_INPUT;
          when BDIR_INPUT =>
            if b_turnout_req then
              bdir_next := BDIR_TURNOUT1;
            else
              bdir_next := BDIR_INPUT;
            end if;
          when BDIR_TURNOUT1 =>
            fiben_n <= '1';
            bdir_next := BDIR_TURNOUT2;
          when BDIR_TURNOUT2 =>
            fiben_n <= '1';
            bdir_next := BDIR_TURNOUT3;
          when BDIR_TURNOUT3 =>
            fidir <= '0';
            fiben_n <= '1';
            bdir_next := BDIR_TURNOUT4;
          when BDIR_TURNOUT4 =>
            fiben_n <= '1';
            bdir_next := BDIR_OUTPUT;
        end case;
        bdir_present := bdir_next;

        if txdf_afull = '1' then
          filf_n <= '0';
          s_filf_int <= '1';
        elsif txdf_aempty = '1' then
          filf_n <= '1';
          s_filf_int <= '0';
        end if;

        b_fb_lben := fb_lben = '1';
      end if;
    end if;
  end process;
end SYN;
