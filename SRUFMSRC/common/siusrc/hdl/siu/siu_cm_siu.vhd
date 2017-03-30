--******************************************************************************
--*
--* Module          : siu_cm_siu
--* File            : siu_cm_siu.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     28-05-13 1.0 moved the reset to sync
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_cm_siu is
  
  port (
    clock       : in  std_logic;        -- transmitter clock
    arst       : in  std_logic;        -- async reset (active low)
    lm_status   : in  std_logic_vector ( 2 downto 0);
    lm_prbsen   : out std_logic;        -- pseudo-random bit sequence enable
    scmd_data   : in  std_logic_vector (31 downto 0);
    scmd_req    : in  std_logic;        -- SIU command request
    scmd_ack    : out std_logic;        -- SIU command acknowledged
    jcmd_data   : in  std_logic_vector (31 downto 0);
    jcmd_req    : in  std_logic;        -- JTAG command request
    jcmd_ack    : out std_logic;        -- JTAG command acknowledged
    txst_data   : out std_logic_vector (31 downto 0);
    txst_req    : out std_logic;        -- Transmit status request
    txst_ack    : in  std_logic;        -- Transmit status acknowledged
    jtag_open   : out std_logic;        -- JTAG stream is open
    bwtr_open   : in  std_logic;        -- Block write stream is open
    fb_lben     : out std_logic;        -- Front-end Bus loopback enable
    i2c_address : out std_logic_vector ( 7 downto 0);
    i2c_wrdata  : out std_logic_vector ( 7 downto 0);
    i2c_rddata  : in  std_logic_vector ( 7 downto 0);
    i2c_rdwrn   : out std_logic;
    i2c_req     : out std_logic;
    i2c_ack     : in  std_logic;
    i2c_error   : in  std_logic;
    pm_value    : in  std_logic_vector (12 downto 0);
    err_clear   : out std_logic;        -- Clear errors
    err_levnt   : in  std_logic;        -- Too long frame
    err_ilfdat  : in  std_logic;        -- Illegal data word from the FEE
    err_ilfsts  : in  std_logic;        -- Illegal status word from the FEE
    err_txof    : in  std_logic;        -- Transmit FIFO overflow
    err_wrdata  : in  std_logic;        -- Illegal data from the link
    err_osinfr  : in  std_logic;        -- Ordered set inside the frame
    err_icindf  : in  std_logic;        -- SERDES indicates invalid chracter
    err_crc     : in  std_logic;        -- CRC error
    err_ildata  : in  std_logic;        -- Data word out of frame
    err_ivsof   : in  std_logic;        -- Invalid frame delimiter
    err_frlen   : in  std_logic;        -- Frame length error
    err_rxof    : in  std_logic;        -- Receiver overflow
    err_frame   : in  std_logic;        -- Frame error (incomplete)
    err_block   : in  std_logic;        -- Block length mismatch
    err_prot    : in  std_logic;        -- Protocol error
    fee_isidle  : in  std_logic);       -- FEE bus is in idle state

end siu_cm_siu;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_cm_siu is

  constant CTSTW_ERROR : std_logic_vector := X"80000000";

  constant SCMD_RCIFST : std_logic_vector := "0000";
  constant SCMD_RFWVER : std_logic_vector := "0100";
  constant SCMD_RHWVER : std_logic_vector := "0110";
  constant SCMD_RPMVAL : std_logic_vector := "0111";
  constant SCMD_IFLOOP : std_logic_vector := "1001";
  constant SCMD_TSTOP  : std_logic_vector := "1100";
  constant SCMD_TSTART : std_logic_vector := "1101";
  constant JCMD_EOJTR  : std_logic_vector := "1011";
  constant JCMD_STJWR  : std_logic_vector := "1101";

  type sts_state is (
    STS_NOCMD,
    STS_SIUCMD,
    STS_JTAGCMD,
    STS_RCIFST,
    STS_RFWVER,
    STS_RHWVER1,
    STS_RHWVER2,
    STS_WHWVER,
    STS_RPMVAL,
    STS_IFLOOP,
    STS_TESTCMD,
    STS_CTSTW,
    STS_CTSTWNOK,
    STS_SWAIT,
    STS_JWAIT
    );

  -- CROSS clock domains
  attribute SHREG_EXTRACT : string;
  signal fee_isidle_r1,fee_isidle_r2 : std_logic;
  signal err_wrdata_r1,err_wrdata_r2 : std_logic;
  signal err_prot_r1,err_prot_r2     : std_logic;
  signal err_block_r1,err_block_r2   : std_logic;
  signal err_ilfsts_r1,err_ilfsts_r2 : std_logic;
  signal err_ilfdat_r1,err_ilfdat_r2 : std_logic;
  signal bwtr_open_r1,bwtr_open_r2   : std_logic;
  signal err_txof_r1,err_txof_r2     : std_logic;
  signal jcmd_data_r1,jcmd_data_r2   : std_logic_vector(31 downto 0);
  signal jcmd_req_r1,jcmd_req_r2     : std_logic;
  attribute SHREG_EXTRACT of fee_isidle_r1,fee_isidle_r2,err_wrdata_r1,err_wrdata_r2,err_prot_r1,err_prot_r2,err_block_r1,err_block_r2,err_ilfsts_r1,err_ilfsts_r2,err_ilfdat_r1,err_ilfdat_r2,bwtr_open_r1,bwtr_open_r2,err_txof_r1,err_txof_r2,jcmd_data_r1,jcmd_data_r2,jcmd_req_r1,jcmd_req_r2 : signal is "NO";
  
begin  -- SYN

  p_sync : process(clock)
    begin
      if rising_edge(clock) then
        fee_isidle_r1 <= fee_isidle;
        fee_isidle_r2 <= fee_isidle_r1;

        err_wrdata_r1 <= err_wrdata;
        err_wrdata_r2 <= err_wrdata_r1;

        err_prot_r1 <= err_prot;
        err_prot_r2 <= err_prot_r1;

        err_block_r1 <= err_block;
        err_block_r2 <= err_block_r1;

        err_ilfsts_r1 <= err_ilfsts;
        err_ilfsts_r2 <= err_ilfsts_r1;

        err_ilfdat_r1 <= err_ilfdat;
        err_ilfdat_r2 <= err_ilfdat_r1;

        bwtr_open_r1 <= bwtr_open;
        bwtr_open_r2 <= bwtr_open_r1;

        err_txof_r1 <= err_txof;
        err_txof_r2 <= err_txof_r1;

        jcmd_data_r1 <= jcmd_data;
        jcmd_data_r2 <= jcmd_data_r1;

        jcmd_req_r1 <= jcmd_req;
        jcmd_req_r2 <= jcmd_req_r1;
      end if;
  end process;

  proc_main : process (clock)
    variable b_rcifst     : boolean;
    variable b_rfwver     : boolean;
    variable b_rhwver     : boolean;
    variable b_whwver     : boolean;
    variable b_rpmval     : boolean;
    variable b_rwhwid_to  : boolean;
    variable b_stjwr      : boolean;
    variable b_eojtr      : boolean;
    variable b_ifloop     : boolean;
    variable b_tstart     : boolean;
    variable b_tstop      : boolean;
    variable b_prbsen     : boolean;
    variable b_siu_legal  : boolean;
    variable b_jtag_legal : boolean;
    variable b_scmd_req   : boolean;
    variable b_jcmd_req   : boolean;
    variable b_bwtr_open  : boolean;
    variable b_jtag_open  : boolean;
    variable b_fb_lben    : boolean;
    variable b_any_err    : boolean;
    variable b_err_clear  : boolean;
    variable b_err_ilfdat : boolean;
    variable b_err_ilfsts : boolean;
    variable b_err_txof   : boolean;
    variable b_err_wrdata : boolean;
    variable b_err_prot   : boolean;
    variable b_err_levnt  : boolean;
    variable b_err_block  : boolean;
    variable b_fee_isidle : boolean;
    variable b_i2c_ack    : boolean;
    variable v_i2c_addr   : std_logic_vector ( 7 downto 0);
    variable v_tid        : std_logic_vector ( 3 downto 0);
    variable v_ctstw      : std_logic_vector (31 downto 0);
    variable v_jtstw      : std_logic_vector (31 downto 0);
    variable v_siustw     : std_logic_vector (31 downto 0);
    variable v_hwidstw    : std_logic_vector (31 downto 0);
    variable v_fwidstw    : std_logic_vector (31 downto 0);
    variable v_pmvstw     : std_logic_vector (31 downto 0);
    variable v_txst_d0    : std_logic_vector (31 downto 0);
    variable v_txst_d1    : std_logic_vector (31 downto 0);
    variable v_txst_d2    : std_logic_vector (31 downto 0);
    variable v_txst_d3    : std_logic_vector (31 downto 0);
    variable v_txst_d4    : std_logic_vector (31 downto 0);
    variable v_txst_d5    : std_logic_vector (31 downto 0);
    variable rwhwid_timer : std_logic_vector (20 downto 0);
    variable sts_present  : sts_state;
    variable sts_next     : sts_state;
  begin  -- process proc_main 
    if clock'event and clock = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)
        lm_prbsen   <= '0';
        scmd_ack    <= '0';
        jcmd_ack    <= '0';
        txst_data   <= (others => '0');
        txst_req    <= '0';
        jtag_open   <= '0';
        i2c_address <= (others => '0');
        i2c_wrdata  <= (others => '0');
        i2c_req     <= '0';
        i2c_rdwrn   <= '0';
        fb_lben     <= '0';
        err_clear   <= '1';

        b_rcifst     := false;
        b_rfwver     := false;
        b_rhwver     := false;
        b_whwver     := false;
        b_rpmval     := false;
        b_rwhwid_to  := false;
        b_stjwr      := false;
        b_eojtr      := false;
        b_ifloop     := false;
        b_tstart     := false;
        b_tstop      := false;
        b_prbsen     := false;
        b_siu_legal  := false;
        b_jtag_legal := false;
        b_scmd_req   := false;
        b_jcmd_req   := false;
        b_bwtr_open  := false;
        b_jtag_open  := false;
        b_fb_lben    := false;
        b_any_err    := false;
        b_err_clear  := true;
        b_err_ilfdat := false;
        b_err_ilfsts := false;
        b_err_txof   := false;
        b_err_wrdata := false;
        b_err_prot   := false;
        b_err_levnt  := false;
        b_err_block  := false;
        b_fee_isidle := false;
        b_i2c_ack    := false;
        v_i2c_addr   := (others => '0');
        v_tid        := (others => '0');
        v_ctstw      := (others => '0');
        v_jtstw      := (others => '0');
        v_siustw     := (others => '0');
        v_fwidstw    := (others => '0');
        v_hwidstw    := (others => '0');
        v_pmvstw     := (others => '0');
        v_txst_d0    := (others => '0');
        v_txst_d1    := (others => '0');
        v_txst_d2    := (others => '0');
        v_txst_d3    := (others => '0');
        v_txst_d4    := (others => '0');
        v_txst_d5    := (others => '0');
        rwhwid_timer := (others => '0');
        sts_present  := STS_NOCMD;
        sts_next     := STS_NOCMD;
      else
        -- Default values. For actual values see the code below.
        scmd_ack   <= '0';
        jcmd_ack   <= '0';
        txst_req   <= '0';
        err_clear  <= '0';

        jtag_open <= bool2sl(b_jtag_open);
        if sts_present = STS_JTAGCMD and txst_ack = '1' then
          if b_stjwr then
            b_jtag_open := true;
          elsif b_eojtr then
            b_jtag_open := false;
          end if;
        end if;

        fb_lben <= bool2sl(b_fb_lben);
        if sts_present = STS_IFLOOP then
          if b_fee_isidle and not b_fb_lben then
            b_fb_lben := true;
          elsif b_fb_lben then
            b_fb_lben := false;
          end if;
        end if;

        lm_prbsen <= '0';
        if sts_present = STS_SWAIT and b_prbsen then
          lm_prbsen <= '1';
        end if;

        b_rwhwid_to := rwhwid_timer(20) = '1';
        if sts_present = STS_RHWVER1 or sts_present = STS_WHWVER then
          rwhwid_timer := inc(rwhwid_timer);
        else
          rwhwid_timer := (others => '0');
        end if;

        txst_data <= v_txst_d0 or
                     v_txst_d1 or
                     v_txst_d2 or
                     v_txst_d3 or
                     v_txst_d4 or
                     v_txst_d5;

        v_txst_d0 := (others => '0');
        v_txst_d1 := (others => '0');
        v_txst_d2 := (others => '0');
        v_txst_d3 := (others => '0');
        v_txst_d4 := (others => '0');
        v_txst_d5 := (others => '0');
        i2c_req <= '0';
        case sts_present is
          when STS_NOCMD =>
            if b_scmd_req then
              sts_next := STS_SIUCMD;
            elsif b_jcmd_req then
              sts_next := STS_JTAGCMD;
            else
              sts_next := STS_NOCMD;
            end if;
          when STS_SIUCMD =>
            if b_rcifst then
              sts_next := STS_RCIFST;
            elsif b_rfwver then
              sts_next := STS_RFWVER;
            elsif b_rhwver then
              i2c_address <= scmd_data(19 downto 12);
              i2c_rdwrn   <= '1';
              v_i2c_addr  := scmd_data(19 downto 12);
              sts_next := STS_RHWVER1;
            elsif b_whwver then
              i2c_address <= scmd_data(19 downto 12);
              i2c_wrdata  <= scmd_data(27 downto 20);
              i2c_rdwrn   <= '0';
              v_i2c_addr  := scmd_data(19 downto 12);
              sts_next := STS_WHWVER;
            elsif b_rpmval then
              sts_next := STS_RPMVAL;
            elsif b_ifloop then
              sts_next := STS_IFLOOP;
            elsif b_tstart then
              sts_next := STS_TESTCMD;
            else
              sts_next := STS_CTSTWNOK;
            end if;
          when STS_JTAGCMD =>
            txst_req <= '1';
            v_txst_d4 := v_jtstw;
            if txst_ack = '1' then
              sts_next := STS_JWAIT;
            else
              sts_next := STS_JTAGCMD;
            end if;
          when STS_RCIFST =>
            txst_req <= '1';
            v_txst_d0 := v_siustw;
            if txst_ack = '1' then
              b_err_clear := true;
              err_clear <= '1';
              sts_next := STS_CTSTW;
            else
              sts_next := STS_RCIFST;
            end if;
          when STS_RFWVER =>
            txst_req <= '1';
            v_txst_d1 := v_fwidstw;
            if txst_ack = '1' then
              sts_next := STS_CTSTW;
            else
              sts_next := STS_RFWVER;
            end if;
          when STS_RHWVER1 =>
            i2c_req <= '1';
            if b_i2c_ack then
              sts_next := STS_RHWVER2;
            elsif b_rwhwid_to then
              sts_next := STS_CTSTWNOK;
            else
              sts_next := STS_RHWVER1;
            end if;
          when STS_RHWVER2 =>
            txst_req <= '1';
            v_txst_d2 := v_hwidstw;
            if txst_ack = '1' then
              sts_next := STS_CTSTW;
            else
              sts_next := STS_RHWVER2;
            end if;
          when STS_WHWVER =>
            i2c_req <= '1';
            if b_i2c_ack then
              sts_next := STS_CTSTW;
            elsif b_rwhwid_to then
              sts_next := STS_CTSTWNOK;
            else
              sts_next := STS_WHWVER;
            end if;
          when STS_RPMVAL =>
            txst_req <= '1';
            v_txst_d5 := v_pmvstw;
            if txst_ack = '1' then
              sts_next := STS_CTSTW;
            else
              sts_next := STS_RPMVAL;
            end if;
          when STS_IFLOOP =>
            sts_next := STS_CTSTW;
          when STS_TESTCMD =>
            b_prbsen := true;
            sts_next := STS_CTSTW;
          when STS_CTSTW =>
            txst_req <= '1';
            v_txst_d3 := v_ctstw;
            if txst_ack = '1' then
              sts_next := STS_SWAIT;
            else
              sts_next := STS_CTSTW;
            end if;
          when STS_CTSTWNOK =>
            txst_req <= '1';
            v_txst_d3 := v_ctstw or CTSTW_ERROR;
            if txst_ack = '1' then
              sts_next := STS_SWAIT;
            else
              sts_next := STS_CTSTWNOK;
            end if;
          when STS_SWAIT =>
            b_prbsen := false;
            scmd_ack <= '1';
            if b_scmd_req then
              sts_next := STS_SWAIT;
            else
              sts_next := STS_NOCMD;
            end if;
          when STS_JWAIT =>
            jcmd_ack <= '1';
            if b_jcmd_req then
              sts_next := STS_JWAIT;
            else
              sts_next := STS_NOCMD;
            end if;
        end case;
        sts_present := sts_next;
        b_i2c_ack := i2c_ack = '1';

        v_ctstw   := '0' &                -- ???
                     "0000000000000000000" &
                     v_tid &
                     "00" &
                     bool2sl(not b_siu_legal) &
                     '0' &
                     "0010";

        v_jtstw   := bool2sl(not b_jtag_legal) &
                     "0000000000000000000" &
                     v_tid &
                     "00" &
                     bool2sl(not b_jtag_legal) &
                     bool2sl(b_stjwr) &
                     "1000";

        v_hwidstw := i2c_error &
                     '0' &
                     i2c_error &
                     '0' &
                     i2c_rddata &
                     v_i2c_addr &
                     v_tid &
                     "0110" &
                     "0010";

        v_pmvstw  := '0' &
                     "000000" &
                     pm_value &
                     v_tid &
                     "0111" &
                     "0010";

        v_fwidstw := '0' &                -- ???
                     int2slv(02, 6) &     -- version
                     int2slv(15, 4) &     -- year after 2000
                     int2slv( 6, 4) &     -- month
                     int2slv(06, 5) &     -- day
                     v_tid &
                     "1110" &
                     "0010";

        v_siustw  := bool2sl(b_any_err) & -- D31
                     bool2sl(b_err_levnt) &
                     bool2sl(b_err_ilfdat or b_err_ilfsts) &
                     bool2sl(b_err_txof) &
                     bool2sl(b_err_wrdata) &
                     err_osinfr &
                     err_icindf &
                     err_crc &
                     bool2sl(b_err_block) &
                     err_ildata &
                     err_ivsof &
                     err_frlen &
                     err_rxof &
                     err_frame &
                     bool2sl(b_err_prot) &
                     bool2sl(b_fb_lben) &
                     bool2sl(not b_fee_isidle) &
                     lm_status &
                     v_tid &
                     "1100" &
                     "0010";
        b_any_err := v_siustw(29 downto 17) /= "0000000000000";

        if b_err_clear then
          b_err_ilfdat := false;
        elsif err_ilfdat_r2 = '1' then
          b_err_ilfdat := true;
        end if;
        if b_err_clear then
          b_err_ilfsts := false;
        elsif err_ilfsts_r2 = '1' then
          b_err_ilfsts := true;
        end if;
        if b_err_clear then
          b_err_txof := false;
        elsif err_txof_r2 = '1' then
          b_err_txof := true;
        end if;
        if b_err_clear then
          b_err_wrdata := false;
        elsif err_wrdata_r2 = '1' then
          b_err_wrdata := true;
        end if;
        if b_err_clear then
          b_err_prot := false;
        elsif err_prot_r2 = '1' then
          b_err_prot := true;
        end if;
        if b_err_clear then
          b_err_levnt := false;
        elsif err_levnt = '1' then
          b_err_levnt := true;
        end if;
        if b_err_clear then
          b_err_block := false;
        elsif err_block_r2 = '1' then
          b_err_block := true;
        end if;
        b_err_clear := false;

        if b_scmd_req then
          v_tid := scmd_data(11 downto 8);
        elsif b_jcmd_req then
          v_tid := jcmd_data_r2(11 downto 8);
        end if;

        b_scmd_req := scmd_req = '1';
        b_jcmd_req := jcmd_req_r2 = '1';
        b_rcifst := false;
        b_rfwver := false;
        b_rhwver := false;
        b_whwver := false;
        b_rpmval := false;
        b_ifloop := false;
        b_tstart := false;
        b_siu_legal := false;
        case scmd_data(7 downto 4) is
          when SCMD_RCIFST =>
            b_rcifst := true;
            b_siu_legal := true;
          when SCMD_RFWVER =>
            b_rfwver := true;
            b_siu_legal := true;
          when SCMD_RHWVER =>
            b_rhwver := scmd_data(30) = '0';
            b_whwver := scmd_data(30) = '1';
            b_siu_legal := true;
          when SCMD_RPMVAL =>
            b_rpmval := true;
            b_siu_legal := true;
          when SCMD_IFLOOP =>
            b_ifloop := true;
            b_siu_legal := true;
          when SCMD_TSTART =>
            b_tstart := b_fee_isidle;
            b_siu_legal := true;
          when others => null;
        end case;

        b_stjwr := false;
        b_eojtr := false;
        b_jtag_legal := false;
        case jcmd_data_r2(7 downto 4) is
          when JCMD_STJWR =>
            b_stjwr := not b_bwtr_open and not b_jtag_open;
            b_jtag_legal := not b_bwtr_open and not b_jtag_open;
          when JCMD_EOJTR =>
            b_eojtr := true;
            b_jtag_legal := b_jtag_open;
          when others => null;
        end case;
        b_bwtr_open  := bwtr_open_r2 = '1';
        b_fee_isidle := fee_isidle_r2 = '1';

      end if;
    end if;
  end process proc_main ;

end SYN;
