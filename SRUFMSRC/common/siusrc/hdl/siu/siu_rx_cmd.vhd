--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : RX_CMD
--* File            : rx_cmd.vhd
--* Library         : ieee
--* Description     : It is the command receiver module, which decodes the
--*                   command frames and requests the status generation.
--* Simulator       : Modelsim
--* Synthesizer     : Lenoardo Spectrum + Quartus II
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--* Revision history:
--*   11-Nov-2002 CS  Original coding of the SIU version (v1)
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_rx_cmd is
  
  port (
    clock      : in  std_logic;         -- receiver clock
    arst      : in  std_logic;         -- async reset (active low)
    por        : in  std_logic;         -- Power-on Reset (active high)
    rxd        : in  std_logic_vector (15 downto 0);
    rx_dv      : in  std_logic;         -- SERDES receiver data valid
    rx_er      : in  std_logic;         -- SERDES receiver error
    rx_diag    : out std_logic;         -- Diagnostic frame received
    rx_dxdata  : out std_logic_vector (15 downto 0);
    scmd_data  : out std_logic_vector (31 downto 0);
    scmd_req   : out std_logic;         -- SIU command request
    scmd_ack   : in  std_logic;         -- SIU command is serviced
    jcmd_data  : out std_logic_vector (31 downto 0);
    jcmd_req   : out std_logic;         -- JTAG command reqest
    jcmd_ack   : in  std_logic;         -- JTAG command is serviced
    err_clr    : in  std_logic;         -- Clear errors
    err_scof   : out std_logic;         -- SIU command overflow
    err_jcof   : out std_logic;         -- JTAG command overflow
    err_osincf : out std_logic;         -- Ordered set inside the fram
    err_cframe : out std_logic);        -- Incomplete frame

end siu_rx_cmd;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_rx_cmd is

  constant CODE_SC   : std_logic_vector := "01010101";  -- D21.2
  constant CODE_SD   : std_logic_vector := "01001010";  -- D10.2
  constant DST_SIU   : std_logic_vector := "0010";
  constant DST_JTAG  : std_logic_vector := "1000";
  constant CMD_STJWR : std_logic_vector := "1101";  -- Start JTAG block write
  constant CMD_EOJTR : std_logic_vector := "1011";  -- End JTAG block write

  -- type rxc_state
  type rxc_state is (
    RXC_IDLE,                           -- No frame, receiving IDLE
    RXC_DIAG,                           -- CEXT received, store DREG data
    RXC_SOF,                            -- Start of frame has been detected
    RXC_CWLOW2,                         -- Test low order command bits
    RXC_CWHIGH1,                        -- Demux high order command bits
    RXC_CWHIGH2,                        -- Test high order command
    RXC_CWTEST,                         -- Test control frame integrity
    RXC_SKIP                            -- Skip received data until IDLE
    );

  type scmd_state is (
    SCMD_EMPTY,
    SCMD_REQUEST,
    SCMD_GOEMPTY
    );

  type jcmd_state is (
    JCMD_EMPTY,
    JCMD_REQUEST,
    jCMD_GOEMPTY
    );

  -- SYNC
  attribute SHREG_EXTRACT : string;
  signal jcmd_ack_r1,jcmd_ack_r2 : std_logic;
  signal err_clr_r1,err_clr_r2 : std_logic;
  attribute SHREG_EXTRACT of jcmd_ack_r1,jcmd_ack_r2,err_clr_r1,err_clr_r2 : signal is "NO";
  
begin  -- SYN

  p_sync : process(clock)
    begin
      if rising_edge(clock) then
        jcmd_ack_r1 <= jcmd_ack;
        jcmd_ack_r2 <= jcmd_ack_r1;

        err_clr_r1 <= err_clr;
        err_clr_r2 <= err_clr_r1;
      end if;
  end process;
  
  proc_main : process (clock)
    variable v_rxd_d1     : std_logic_vector (15 downto 0);
    variable v_rxd_d2     : std_logic_vector (15 downto 0);
    variable v_scmd_data  : std_logic_vector (31 downto 0);
    variable v_jcmd_data  : std_logic_vector (31 downto 0);
    variable v_cmd_dest   : std_logic_vector ( 3 downto 0);
    variable rxdiag_pipe  : std_logic_vector ( 1 downto 0);
    variable b_d1LisSC    : boolean;
    variable b_d1HisSC    : boolean;
    variable b_d1LisX4    : boolean;
    variable b_d1Lis8X    : boolean;
    variable b_d1Leqd2L   : boolean;
    variable b_d1Heqd2H   : boolean;
    variable b_rx_data    : boolean;
    variable b_rx_idle    : boolean;
    variable b_rx_cext    : boolean;
    variable b_rx_rerr    : boolean;
    variable b_scmd_ack   : boolean;
    variable b_jcmd_ack   : boolean;
    variable b_err_clr    : boolean;
    variable b_osinfr     : boolean;
    variable b_ivcframe   : boolean;
    variable scmd_present : scmd_state;
    variable scmd_next    : scmd_state;
    variable jcmd_present : jcmd_state;
    variable jcmd_next    : jcmd_state;
    variable rxc_present  : rxc_state;
    variable rxc_next     : rxc_state;
  begin  -- process proc_main 
    if clock'event and clock = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)
        rx_diag    <= '0';
        rx_dxdata  <= (others => '0');
        scmd_data  <= (others => '0');
        scmd_req   <= '0';
        jcmd_data  <= (others => '0');
        jcmd_req   <= '0';
        err_scof   <= '0';
        err_jcof   <= '0';
        err_osincf <= '0';
        err_cframe <= '0';

        v_rxd_d1     := (others => '0');
        v_rxd_d2     := (others => '0');
        v_scmd_data  := (others => '0');
        v_jcmd_data  := (others => '0');
        v_cmd_dest   := (others => '0');
        rxdiag_pipe  := (others => '0');
        b_d1LisSC    := false;
        b_d1HisSC    := false;
        b_d1LisX4    := false;
        b_d1Lis8X    := false;
        b_d1Leqd2L   := true;
        b_d1Heqd2H   := true;
        b_rx_data    := false;
        b_rx_idle    := true;
        b_rx_cext    := false;
        b_rx_rerr    := false;
        b_scmd_ack   := false;
        b_jcmd_ack   := false;
        b_err_clr    := true;
        b_osinfr     := false;
        b_ivcframe   := false;
        scmd_present := SCMD_EMPTY;
        scmd_next    := SCMD_EMPTY;
        jcmd_present := JCMD_EMPTY;
        jcmd_next    := JCMD_EMPTY;
        rxc_present  := RXC_IDLE;
        rxc_next     := RXC_IDLE;
      else
        -- Default values. For actual values see the code below.
        scmd_req <= '0';
        jcmd_req <= '0';
        
        if b_err_clr then
          err_scof <= '0';
        elsif scmd_present /= SCMD_EMPTY and
          rxc_present   = RXC_CWTEST and
          v_cmd_dest    = DST_SIU    then
          err_scof <= '1';
        end if;
        if b_err_clr then
          err_jcof <= '0';
        elsif jcmd_present /= JCMD_EMPTY and
          rxc_present   = RXC_CWTEST and
          v_cmd_dest    = DST_JTAG   then
          err_jcof <= '1';
        end if;
        if b_err_clr then
          err_osincf <= '0';
        elsif b_osinfr then
          err_osincf <= '1';
        end if;
        if b_err_clr then
          err_cframe <= '0';
        elsif b_ivcframe then
          err_cframe <= '1';
        end if;
        b_osinfr   := false;
        b_ivcframe := false;
        b_err_clr  := err_clr_r2 = '1';
        case scmd_present is
          when SCMD_EMPTY =>
            if rxc_present = RXC_CWTEST and v_cmd_dest = DST_SIU then
              scmd_data <= v_scmd_data;
              scmd_next := SCMD_REQUEST;
            else
              scmd_next := SCMD_EMPTY;
            end if;
          when SCMD_REQUEST =>
            scmd_req <= '1';
            if b_scmd_ack then
              scmd_next := SCMD_GOEMPTY;
            else
              scmd_next := SCMD_REQUEST;
            end if;
          when SCMD_GOEMPTY =>
            if b_scmd_ack then
              scmd_next := SCMD_GOEMPTY;
            else
              scmd_next := SCMD_EMPTY;
            end if;
        end case;
        scmd_present := scmd_next;
        b_scmd_ack := scmd_ack = '1';
        case jcmd_present is
          when JCMD_EMPTY =>
            if rxc_present = RXC_CWTEST and v_cmd_dest = DST_JTAG then
              jcmd_data <= v_jcmd_data;
              jcmd_next := JCMD_REQUEST;
            else
              jcmd_next := JCMD_EMPTY;
            end if;
          when JCMD_REQUEST =>
            jcmd_req <= '1';
            if b_jcmd_ack then
              jcmd_next := JCMD_GOEMPTY;
            else
              jcmd_next := JCMD_REQUEST;
            end if;
          when JCMD_GOEMPTY =>
            if b_jcmd_ack then
              jcmd_next := JCMD_GOEMPTY;
            else
              jcmd_next := JCMD_EMPTY;
            end if;
        end case;
        jcmd_present := jcmd_next;
        b_jcmd_ack := jcmd_ack_r2 = '1';
        rx_diag <= rxdiag_pipe(0) or rxdiag_pipe(1);
        rxdiag_pipe(1) := rxdiag_pipe(0);
        rxdiag_pipe(0) := '0';
        case rxc_present is
          when RXC_IDLE =>                -- Waiting for no idle word
            if b_rx_cext then
              -- IF carrier extend is received THEN
              --   receive diagnostic data
              rxc_next := RXC_DIAG;
            elsif b_rx_data then
              -- ELSE IF data word is received THEN
              --   decode SOF
              rxc_next := RXC_SOF;
            else
              -- ELSE
              --   wait for non idle word
              rxc_next := RXC_IDLE;
            end if;
          when RXC_DIAG =>                -- Receiving diagnostic data
            if b_rx_data then
              -- IF data word is received THEN
              --   store it in the diagnostic data register
              rxdiag_pipe(0) := '1';
              rx_dxdata <= v_rxd_d1;
            end if;
            -- In any case wait for new frames
            rxc_next := RXC_IDLE;
          when RXC_SOF =>                 -- Decoding the SOF
            v_jcmd_data(15 downto 0) := v_rxd_d1;
            v_scmd_data(15 downto 0) := v_rxd_d1;
            v_cmd_dest := v_rxd_d1(3 downto 0);
            if (b_rx_data or b_rx_rerr) and b_d1LisSC and b_d1HisSC then
              -- IF control SOF is received THEN
              --   receive the low order bits
              rxc_next := RXC_CWLOW2;
            else
              -- ELSE
              --   skip the rest
              rxc_next := RXC_SKIP;
            end if;
          when RXC_CWLOW2 =>              -- Decoding the control frame data
            b_ivcframe := not b_rx_data;
            if b_rx_data and not b_d1LisX4 and not b_d1Lis8X then
              -- IF data word inside the control frame is sent to the SIU OR
              -- JTAG AND it is not DTCC THEN
              --   receive the high order bits
              rxc_next := RXC_CWHIGH1;
            else
              -- ELSE
              --   skip the rest
              rxc_next := RXC_SKIP;
            end if;
          when RXC_CWHIGH1 =>             -- Receiving the high order bits
            v_jcmd_data(31 downto 16) := v_rxd_d1;
            v_scmd_data(31 downto 16) := v_rxd_d1;
            -- IF frame error is detected THEN
            --   set bit31 to high
            v_jcmd_data(31) := v_jcmd_data(31) or
                               not bool2sl(b_d1Leqd2L and b_d1Heqd2H);
            v_scmd_data(31) := v_scmd_data(31) or
                               not bool2sl(b_d1Leqd2L and b_d1Heqd2H);
            b_ivcframe := not b_rx_data;
            if b_rx_data then
              -- IF data word is received THEN
              --   control the control frame
              rxc_next := RXC_CWHIGH2;
            else
              -- ELSE
              --   skip the rest
              rxc_next := RXC_SKIP;
            end if;
          when RXC_CWHIGH2 =>             -- Receiving the high order bits
            b_ivcframe := not b_rx_data;
            if b_rx_data then
              -- IF data word is received THEN
              --   Test the integrity of the frame
              rxc_next := RXC_CWTEST;
            else
              -- ELSE
              --   skip the rest
              rxc_next := RXC_SKIP;
            end if;
          when RXC_CWTEST =>              -- Testing the integrity of the frame
            -- IF control frame is corrupted THEN
            --   set bit31 to high
            v_jcmd_data(31) := v_jcmd_data(31) or
                               not bool2sl(b_d1Leqd2L and b_d1Heqd2H);
            v_scmd_data(31) := v_scmd_data(31) or
                               not bool2sl(b_d1Leqd2L and b_d1Heqd2H);
            -- In any case, we wait for a new frame
            rxc_next := RXC_IDLE;
          when RXC_SKIP =>                -- Skipping the rest of a frame
            if b_rx_idle then
              -- IF idle word is received THEN
              --   wait for new frames
              rxc_next := RXC_IDLE;
            else
              -- ELSE
              --   wait for an idle word
              rxc_next := RXC_SKIP;
            end if;
        end case;
        rxc_present := rxc_next;

        b_d1LisX4  := (v_rxd_d1( 3 downto 0) = "0100");
        b_d1Lis8X  := (v_rxd_d1( 7 downto 4) = "1000");
        b_d1LisSC  := (v_rxd_d1( 7 downto 0) = CODE_SC);
        b_d1HisSC  := (v_rxd_d1(15 downto 8) = CODE_SC);
        b_d1Leqd2L := (v_rxd_d1( 7 downto 0) = v_rxd_d2( 7 downto 0));
        b_d1Heqd2H := (v_rxd_d1(15 downto 8) = v_rxd_d2(15 downto 8));
        v_rxd_d2   := v_rxd_d1;
        v_rxd_d1   := rxd;

        if por = '1' then
          b_rx_idle := true;
          b_rx_data := false;
          b_rx_cext := false;
          b_rx_rerr := false;
        else
          b_rx_idle := rx_dv = '0' and rx_er = '0';
          b_rx_data := rx_dv = '1' and rx_er = '0';
          b_rx_cext := rx_dv = '0' and rx_er = '1';
          b_rx_rerr := rx_dv = '1' and rx_er = '1';
        end if;

      end if;
    end if;
  end process proc_main ;

end SYN;
