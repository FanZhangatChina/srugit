--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : RX_IN
--* File            : rx_in.vhd
--* Library         : ieee
--* Description     : It is a receiver module, which decodes the different
--*                   DDL specific signals (e.g. SIU reset, suspend, etc.)
--* Simulator       : Modelsim
--* Synthesizer     : Lenoardo Spectrum + Quartus II
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--* Revision history:
--*   11-Nov-2002 CS  Original coding of the SIU version (v1)
--*   16-Apr-2003 CS  New SIU reset
--*   20-06-13 PC moved to active high sync reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_rx_in is
  
  port (
    clock   : in  std_logic;            -- receiver clock
    arst    : in  std_logic;            -- async reset (active low)
    ot_sd   : in  std_logic;            -- OT signal detect
    rxd     : in  std_logic_vector (15 downto 0);
    rx_dv   : in  std_logic;            -- SERDES receiver data valid
    rx_er   : in  std_logic;            -- SERDES receiver error
    rxidle  : out std_logic;            -- Idle stream is detected
    rxlosy  : out std_logic;            -- Loss of Synchronization
    suspend : out std_logic;            -- Suspend is received
    por     : out std_logic);           -- Power-on Reset (active high)

end siu_rx_in;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_rx_in is

  type susp_state is (
    SUSP_RESET,
    SUSP_IDLE1,
    SUSP_IDLE2,
    SUSP_CEXT,
    SUSP_SUSP
  );

begin  -- SYN

  proc_main : process (clock)
    variable b_rx_data    : boolean;
    variable b_rx_idle    : boolean;
    variable b_rx_cext    : boolean;
    variable b_rx_rerr    : boolean;
    variable b_rx_losy    : boolean;
    variable b_por        : boolean;
    variable v_rxd_d1     : std_logic_vector (15 downto 0);
    variable v_por_timer  : std_logic_vector (16 downto 0);
    variable idle_count   : std_logic_vector ( 4 downto 0);
    variable susp_count   : std_logic_vector ( 1 downto 0);
    variable rxlos_hold   : std_logic_vector (3 downto 0);
    variable susp_present : susp_state;
    variable susp_next    : susp_state;
  begin  -- process proc_main 
  if clock'event and clock = '1' then  -- rising clock edge
    if arst = '1' then                 -- asynchronous reset (active low)
      rxidle  <= '1';
      rxlosy  <= '0';
      suspend <= '0';
      por     <= '1';

      b_rx_data    := false;
      b_rx_idle    := true;
      b_rx_cext    := false;
      b_rx_rerr    := false;
      b_rx_losy    := false;
      b_por        := true;
      v_rxd_d1     := (others => '0');
      v_por_timer  := (others => '0');
      idle_count   := (others => '1');
      susp_count   := (others => '0');
      rxlos_hold   := (others => '1');
      susp_present := SUSP_RESET;
      susp_next    := SUSP_RESET;
      else
      
      rxlosy <= not rxlos_hold(3);
      if b_rx_losy then
        rxlos_hold := (others => '0');
      elsif rxlos_hold(3) = '0' then
        rxlos_hold := inc(rxlos_hold);
      end if;
      b_rx_losy := v_rxd_d1(7 downto 0) = "11111111" and b_rx_rerr;

      if not b_rx_idle or ot_sd = '0' then
        rxidle <= '0';
      elsif idle_count(4) = '1' then
        rxidle <= '1';
      end if;
      if b_rx_idle and ot_sd = '1' then
        idle_count := inc(idle_count);
      else
        idle_count := (others => '0');
      end if;

      case susp_present is
        when SUSP_RESET =>
          suspend <= '0';
          susp_count := (others => '0');
          if b_rx_idle then
            susp_next := SUSP_IDLE1;
          else
            susp_next := SUSP_RESET;
          end if;
        when SUSP_IDLE1 =>
          if b_rx_idle then
            susp_next := SUSP_IDLE2;
          elsif b_rx_cext then
            susp_next := SUSP_CEXT;
          else
            susp_next := SUSP_RESET;
          end if;
        when SUSP_IDLE2 =>
          if b_rx_cext then
            susp_next := SUSP_CEXT;
          else
            susp_next := SUSP_RESET;
          end if;
        when SUSP_CEXT  =>
          if (b_rx_data and v_rxd_d1(3 downto 2) = "11") then
            susp_next := SUSP_SUSP;
          else
            susp_next := SUSP_RESET;
          end if;
        when SUSP_SUSP  =>
          if (susp_count = "11") then
            suspend <= '1';
          end if;
          susp_count := inc(susp_count);
          susp_next := SUSP_IDLE1;
      end case;
      susp_present := susp_next;

--      b_por  := v_por_timer(3) = '0';  -- for simulation use low order bit
      b_por  := v_por_timer(16
		-- synthesis translate_off
		-5
		-- synthesis translate_on
		) = '0';
      por    <= bool2sl(b_por);
      if ot_sd = '0' then
        v_por_timer := (others => '0');
      elsif b_por then
        v_por_timer := inc(v_por_timer);
      end if;
      if b_por then
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
      v_rxd_d1 := rxd;

    end if;
    end if;
  end process proc_main ;

end SYN;
