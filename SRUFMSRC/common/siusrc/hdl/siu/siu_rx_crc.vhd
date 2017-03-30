--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : RX_CRC
--* File            : rx_crc.vhd
--* Library         : ieee
--* Description     : It is the CRC checker module, which checks the received
--*                   frames against errors by the CRC checksum.
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

entity siu_rx_crc is
  
  port (
    clock   : in  std_logic;            -- receiver clock
    arst    : in  std_logic;            -- async reset (active low)
    por     : in  std_logic;            -- Power-on Reset (active high)
    rxd     : in  std_logic_vector (15 downto 0);
    rx_dv   : in  std_logic;            -- SERDES receiver data valid
    rx_er   : in  std_logic;            -- SERDES receiver error
    err_clr : in  std_logic;            -- Clear errors
    err_crc : out std_logic);           -- CRC error

end siu_rx_crc;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_rx_crc is
  constant CODE_SC : std_logic_vector := "01010101";  -- D21.2
  constant CODE_SD : std_logic_vector := "01001010";  -- D10.2

  component siu_crc16
    port (
      clock : in  std_logic;
      srst  : in  std_logic;
      ena   : in  std_logic;
      d     : in  std_logic_vector (15 downto 0);
      q     : out std_logic_vector (15 downto 0)
    );
  end component;
  signal s_crc_srst  : std_logic;
  signal s_crc_ena   : std_logic;
  signal s_crc_d     : std_logic_vector (15 downto 0);
  signal s_crc_q     : std_logic_vector (15 downto 0);

  type crc_state is (
    CRC_RST,
    CRC_START,
    CRC_CALC,
    CRC_WAIT,
    CRC_TEST,
    CRC_ERROR,
    CRC_SKIP
  );

begin  -- SYN

  RXCRC_inst : siu_crc16
    port map (
      clock => clock,
      srst  => s_crc_srst,
      ena   => s_crc_ena,
      d     => s_crc_d,
      q     => s_crc_q
    );

  proc_main : process (clock)
    variable v_rxd_d1    : std_logic_vector (15 downto 0);
    variable b_err_clr   : boolean;
    variable b_d1LisSD   : boolean;
    variable b_d1HisSD   : boolean;
    variable b_rx_data   : boolean;
    variable b_rx_idle   : boolean;
    variable crc_present : crc_state;
    variable crc_next    : crc_state;

  begin  -- process proc_main 
  if clock'event and clock = '1' then  -- rising clock edge  
    if arst = '1' then                 -- asynchronous reset (active low)
      err_crc    <= '0';
      s_crc_d    <= (others => '0');
      s_crc_srst <= '1';
      s_crc_ena  <= '0';

      v_rxd_d1    := (others => '0');
      b_err_clr   := true;
      b_d1LisSD   := false;
      b_d1HisSD   := false;
      b_rx_data   := false;
      b_rx_idle   := true;
      crc_present := CRC_RST;
      crc_next    := CRC_RST;

      else
-- Default values. For actual values see below.
      s_crc_srst <= '1';
      s_crc_ena  <= '0';
      s_crc_d    <= v_rxd_d1;

      if b_err_clr then
        err_crc <= '0';
      elsif crc_present = CRC_ERROR then
        err_crc <= '1';
      end if;
      b_err_clr := err_clr = '1';

      case crc_present is
        when CRC_RST =>
          if b_rx_data then
            crc_next := CRC_START;
          else
            crc_next := CRC_RST;
          end if;
        when CRC_START =>
          s_crc_srst <= '0';
          s_crc_ena  <= '1';
          if b_d1LisSD and b_d1HisSD then
            crc_next := CRC_CALC;
          else
            crc_next := CRC_SKIP;
          end if;
        when CRC_CALC =>
          s_crc_srst <= '0';
          s_crc_ena <= '1';
          if b_rx_data then
            crc_next := CRC_CALC;
          elsif b_rx_idle then
            crc_next := CRC_WAIT;
          else
            crc_next := CRC_RST;
          end if;
        when CRC_WAIT =>
          crc_next := CRC_TEST;
        when CRC_TEST =>
          if (s_crc_q > int2slv(0, 16)) then
            crc_next := CRC_ERROR;
          else
            crc_next := CRC_RST;
          end if;
        when CRC_ERROR =>
          crc_next := CRC_RST;
        when CRC_SKIP =>
          if b_rx_idle then
            crc_next := CRC_RST;
          else
            crc_next := CRC_SKIP;
          end if;
      end case;
      crc_present := crc_next;

      b_d1LisSD := v_rxd_d1( 7 downto 0) = CODE_SD;
      b_d1HisSD := v_rxd_d1(15 downto 8) = CODE_SD;
      v_rxd_d1 := rxd;
      if por = '1' then
        b_rx_idle := true;
        b_rx_data := false;
      else
        b_rx_idle := rx_dv = '0' and rx_er = '0';
        b_rx_data := rx_dv = '1' and rx_er = '0';
      end if;

    end if;
    end if;
  end process proc_main ;
end SYN;
