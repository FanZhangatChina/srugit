--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : RX_DATA
--* File            : rx_data.vhd
--* Library         : ieee
--* Description     : It is the data/command receiver module, which receives
--*                   the data and command, which are sent to the FEE.
--* Simulator       : Modelsim
--* Synthesizer     : Lenoardo Spectrum + Quartus II
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--* Revision history:
--*   9-Nov-2002 CS  Original coding of the SIU version (v1)
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_rx_data is
  
  port (
    clock      : in  std_logic;         -- receiver clock
    arst       : in  std_logic;         -- async reset (active low)
    por        : in  std_logic;         -- Power-on Reset (active high)
    rxd        : in  std_logic_vector (15 downto 0);
    rx_dv      : in  std_logic;         -- SERDES receiver data valid
    rx_er      : in  std_logic;         -- SERDES receiver error
    jtag_open  : in  std_logic;         -- JTAG stream is open
    rxdf_d     : out std_logic_vector (32 downto 0);
    rxdf_wrreq : out std_logic;         -- Receiver FIFO write request
    rxdf_full  : in  std_logic;         -- Receiver FIFO full (error)
    err_clr    : in  std_logic;         -- Clear errors
    err_frlen  : out std_logic;         -- Too long frame
    err_osindf : out std_logic;         -- Ordered set inside the frame
    err_ivsof  : out std_logic;         -- Invalid SOF
    err_ildata : out std_logic;         -- Data word out of frame
    err_rxfull : out std_logic;         -- Receiver FIFO overflow
    err_icindf : out std_logic;         -- Invalid character inside the frame
    err_dframe : out std_logic);        -- Incomplete frame

end siu_rx_data;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_rx_data is

  constant CODE_SC : std_logic_vector := "01010101";  -- D21.2
  constant CODE_SD : std_logic_vector := "01001010";  -- D10.2
  constant CODE_FE : std_logic_vector := "11111110";  -- 0xFE
  constant CODE_FF : std_logic_vector := "11111111";  -- 0xFF

  -- type rxd_state
  -- Decodes data frames, or command frames, if the destination is the FEE.
  -- All of these are written into the RXF fifo.
  type rxd_state is (
    RXD_IDLE,                           -- No frame, receiving IDLE + DIAG
    RXD_SOF,                            -- Start of frame has been detected
    RXD_DWLOW,                          -- Demux low order data bits
    RXD_DWHIGH,                         -- Demux high order data bits
    RXD_CWLOW2,                         -- Test low order command bits
    RXD_CWHIGH1,                        -- Demux high order command bits
    RXD_CWHIGH2,                        -- Test high order command bits
    RXD_CWTEST,                         -- Test control frame integrity
    RXD_SKIP                            -- Skip received data until IDLE
    );

  type frc_state is (
    FRC_RESET,
    FRC_DUMMY,
    FRC_ADVANCE
    );

begin  -- SYN

  proc_main : process (clock)
    variable v_rxd_d1    : std_logic_vector (15 downto 0);
    variable v_rxd_d2    : std_logic_vector (15 downto 0);
    variable b_d1LisSD   : boolean;
    variable b_d1LisSC   : boolean;
    variable b_d1HisSD   : boolean;
    variable b_d1HisSC   : boolean;
    variable b_d1LisX2   : boolean;
    variable b_d1LisX4   : boolean;
    variable b_d1Lis8X   : boolean;
    variable b_d1Leqd2L  : boolean;
    variable b_d1Heqd2H  : boolean;
    variable b_rx_data   : boolean;
    variable b_rx_idle   : boolean;
    variable b_rx_cext   : boolean;
    variable b_rx_rerr   : boolean;
    variable b_err_clr   : boolean;
    variable b_osinfr    : boolean;
    variable b_ivsof     : boolean;
    variable b_ildata    : boolean;
    variable b_ivcinfr   : boolean;
    variable b_ivdframe  : boolean;
    variable dfr_count   : std_logic_vector ( 8 downto 0);
    variable rxd_present : rxd_state;
    variable rxd_next    : rxd_state;
    variable frc_present : frc_state;
    variable frc_next    : frc_state;
  begin  -- process proc_main
    if clock'event and clock = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)

        rxdf_d     <= (others => '0');
        rxdf_wrreq <= '0';
        err_frlen  <= '0';
        err_osindf <= '0';
        err_ivsof  <= '0';
        err_ildata <= '0';
        err_rxfull <= '0';
        err_icindf <= '0';
        err_dframe <= '0';

        v_rxd_d1    := (others => '0');
        v_rxd_d2    := (others => '0');
        b_d1LisSD   := false;
        b_d1HisSD   := false;
        b_d1LisSC   := false;
        b_d1HisSC   := false;
        b_d1LisX2   := false;
        b_d1LisX4   := false;
        b_d1Lis8X   := false;
        b_d1Leqd2L  := true;
        b_d1Heqd2H  := true;
        b_rx_data   := false;
        b_rx_idle   := true;
        b_rx_cext   := false;
        b_rx_rerr   := false;
        b_err_clr   := true;
        b_osinfr    := false;
        b_ivsof     := false;
        b_ildata    := false;
        b_ivcinfr   := false;
        b_ivdframe  := false;
        dfr_count   := (others => '0');
        rxd_present := RXD_IDLE;
        rxd_next    := RXD_IDLE;
        frc_present := FRC_RESET;
        frc_next    := FRC_RESET;

      else
        rxdf_wrreq <= '0';

        if b_err_clr then
          err_frlen <= '0';
        elsif dfr_count(8) = '1' then
          err_frlen <= '1';
        end if;
        if b_err_clr then
          err_osindf <= '0';
        elsif b_osinfr then
          err_osindf <= '1';
        end if;
        if b_err_clr then
          err_ivsof <= '0';
        elsif b_ivsof then
          err_ivsof <= '1';
        end if;
        if b_err_clr then
          err_ildata <= '0';
        elsif b_ildata then
          err_ildata <= '1';
        end if;
        if b_err_clr then
          err_rxfull <= '0';
        elsif rxdf_full = '1' then
          err_rxfull <= '1';
        end if;
        if b_err_clr then
          err_icindf <= '0';
        elsif b_ivcinfr then
          err_icindf <= '1';
        end if;
        if b_err_clr then
          err_dframe <= '0';
        elsif b_ivdframe then
          err_dframe <= '1';
        end if;
        b_osinfr   := false;
        b_ivsof    := false;
        b_ildata   := false;
        b_ivcinfr  := false;
        b_ivdframe := false;
        b_err_clr  := err_clr = '1';

        case frc_present is
          when FRC_RESET =>
            dfr_count := (others => '0');
            if b_rx_data then
              frc_next := FRC_DUMMY;
            else
              frc_next := FRC_RESET;
            end if;
          when FRC_DUMMY =>
            if b_rx_data then
              frc_next := FRC_ADVANCE;
            else
              frc_next := FRC_RESET;
            end if;
          when FRC_ADVANCE =>
            if b_rx_data then
              dfr_count := inc(dfr_count);
              frc_next := FRC_DUMMY;
            else
              frc_next := FRC_RESET;
            end if;
        end case;
        frc_present := frc_next;

        case rxd_present is
          when RXD_IDLE =>                -- Waiting for non idle word
            if b_rx_cext then
              -- IF carrier extend is detected THEN
              --   skip the rest
              rxd_next := RXD_SKIP;
            elsif b_rx_data and jtag_open = '0' then
              -- ELSE IF data word is received AND JTAG stream is not open THEN
              --   decode SOF
              rxd_next := RXD_SOF;
            else
              -- ELSE
              --   wait for non idle word
              rxd_next := RXD_IDLE;
            end if;
          when RXD_SOF =>                 -- Decoding SOF
            rxdf_d(15 downto 0) <= v_rxd_d1;
            if (b_rx_data or b_rx_rerr) and b_d1LisSD and b_d1HisSD then
              -- IF data SOF is received THEN
              --   continue the data frame
              b_ivcinfr := b_rx_rerr;
              rxd_next := RXD_DWHIGH;
            elsif (b_rx_data or b_rx_rerr) and b_d1LisSC and b_d1HisSC then
              -- ELSE IF control SOF is received THEN
              --   test if it is a DTCC
              b_ivcinfr := b_rx_rerr;
              rxd_next := RXD_CWLOW2;
            else
              -- ELSE
              --   skip the rest
              b_ivsof  := b_rx_data or b_rx_rerr;
              b_ildata := b_rx_idle or b_rx_cext;
              rxd_next := RXD_SKIP;
            end if;
          when RXD_DWLOW =>               -- Receiving the low order data bits
            rxdf_d(15 downto 0) <= v_rxd_d1;
            b_osinfr   := b_rx_cext;
            b_ivcinfr  := b_rx_rerr;
            b_ivdframe := b_rx_idle;
            if b_rx_idle then
              -- IF idle is reveiced THEN
              --   it is an invalid frame (odd number of words), to be closed
              rxd_next := RXD_IDLE;
            else
              -- ELSE
              --   receive the high order data bits
              rxd_next := RXD_DWHIGH;
            end if;
          when RXD_DWHIGH =>              -- Receiving the high order data bits
            rxdf_d(31 downto 16) <= v_rxd_d1;
            rxdf_d(32) <= '0';
            b_osinfr  := b_rx_cext;
            b_ivcinfr := b_rx_rerr;
            if b_rx_idle then
              -- IF idle is received THEN
              --   close the frame and wait for a new one
              rxd_next := RXD_IDLE;
            else
              -- ELSE
              --   receive the low order data bits
              rxdf_wrreq <= '1';
              rxd_next := RXD_DWLOW;
            end if;
          when RXD_CWLOW2 =>              -- Decoding the control frame data
            b_osinfr   := b_rx_cext;
            b_ivcinfr  := b_rx_rerr;
            b_ivdframe := not b_rx_data;
            if b_rx_data and (b_d1LisX4 or (b_d1Lis8X and b_d1LisX2)) then
              -- IF data word inside the control frame is sent to the FEE OR
              -- it is a DTCC THEN
              --   receive the high order bits
              rxd_next := RXD_CWHIGH1;
            else
              -- ELSE
              --   skip the rest
              rxd_next := RXD_SKIP;
            end if;
          when RXD_CWHIGH1 =>             -- Receiving the high order bits
            b_osinfr   := b_rx_cext;
            b_ivcinfr  := b_rx_rerr;
            b_ivdframe := not b_rx_data;
            rxdf_d(31 downto 16) <= v_rxd_d1;
            -- IF control frame is corrupted THEN
            --   set bit31 to high
            rxdf_d(31) <= bool2sl(not b_d1Leqd2L or not b_d1Heqd2H);
            rxdf_d(32) <= '1';
            if b_rx_data then
              -- IF data word is received THEN
              --   continue the control frame
              rxd_next := RXD_CWHIGH2;
            else
              -- ELSE
              --   it is an invalid frame, to be closed
              rxd_next := RXD_SKIP;
            end if;
          when RXD_CWHIGH2 =>             -- Receiving the high order bits
            b_osinfr   := b_rx_cext;
            b_ivcinfr  := b_rx_rerr;
            b_ivdframe := not b_rx_data;
            if b_rx_data then
              -- IF data word is received THEN
              --   test the integrity of the frame
              rxd_next := RXD_CWTEST;
            else
              -- ELSE
              --   it is an invalid frame, to be closed
              rxd_next := RXD_SKIP;
            end if;
          when RXD_CWTEST =>              -- Testing the integrity of a CFRAME
            rxdf_wrreq <= '1';
            -- IF control frame is corrupted THEN
            --   set bit31 to high
            rxdf_d(31) <= bool2sl(not b_d1Leqd2L or not b_d1Heqd2H);
            -- In any case, wait for new frames
            rxd_next := RXD_IDLE;
          when RXD_SKIP =>                -- Skipping the rest of a frame
            if b_rx_idle then
              -- IF idle word is received THEN
              --   wait for new frames
              rxd_next := RXD_IDLE;
            else
              -- ELSE
              --   wait for an idle word
              rxd_next := RXD_SKIP;
            end if;
        end case;
        rxd_present := rxd_next;

        b_d1LisX2  := (v_rxd_d1( 3 downto 0) = "0010");
        b_d1LisX4  := (v_rxd_d1( 3 downto 0) = "0100");
        b_d1Lis8X  := (v_rxd_d1( 7 downto 4) = "1000");
        b_d1LisSC  := (v_rxd_d1( 7 downto 0) = CODE_SC);
        b_d1HisSC  := (v_rxd_d1(15 downto 8) = CODE_SC);
        b_d1LisSD  := (v_rxd_d1( 7 downto 0) = CODE_SD);
        b_d1HisSD  := (v_rxd_d1(15 downto 8) = CODE_SD);
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
  end process proc_main;
end SYN;
