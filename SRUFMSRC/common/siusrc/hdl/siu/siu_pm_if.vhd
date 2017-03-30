--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : PM_IF
--* File            : pm_if.vhd
--* Library         : ieee
--* Description     : It is a module, which handles the power monitor circuit.
--* Simulator       : Modelsim
--* Synthesizer     : Lenoardo Spectrum + Quartus II
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--* Revision history:
--*   18-Feb-2003 CS  Original coding
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_pm_if is
  
  port (
    clock    : in  std_logic;
    arst     : in  std_logic;
    pm_clk   : out std_logic;
    pm_ncs   : out std_logic;
    pm_dout  : in  std_logic;
    pm_value : out std_logic_vector (12 downto 0));

end siu_pm_if;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_pm_if is

begin  -- SYN

  proc_main : process (clock)
    variable clkdiv_cnt   : std_logic_vector (10 downto 0);
    variable b_clkdiv_to  : boolean;
    variable pm_value_int : std_logic_vector (12 downto 0);
    variable pm_clk_int   : std_logic;
    variable pm_sample    : std_logic;
    variable bit_cnt      : std_logic_vector ( 3 downto 0);
  begin  -- process
    if clock'event and clock = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)
        pm_clk   <= '1';
        pm_ncs   <= '1';
        pm_value <= (others => '0');

        clkdiv_cnt   := (0 => '1', others => '0');
        b_clkdiv_to  := false;
        pm_value_int := (others => '0');
        pm_clk_int   := '0';
        pm_sample    := '0';
        bit_cnt      := (others => '0');
      else
        case bit_cnt is
          when "0000" =>
            pm_clk <= '1';
            pm_ncs <= '1';
            pm_value <= pm_value_int;
          when "0001" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
          when "0010" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
          when "0011" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int(12) := pm_dout;
            end if;
          when "0100" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int(11) := pm_dout;
            end if;
          when "0101" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int(10) := pm_dout;
            end if;
          when "0110" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 9) := pm_dout;
            end if;
          when "0111" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 8) := pm_dout;
            end if;
          when "1000" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 7) := pm_dout;
            end if;
          when "1001" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 6) := pm_dout;
            end if;
          when "1010" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 5) := pm_dout;
            end if;
          when "1011" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 4) := pm_dout;
            end if;
          when "1100" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 3) := pm_dout;
            end if;
          when "1101" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 2) := pm_dout;
            end if;
          when "1110" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 1) := pm_dout;
            end if;
          when "1111" =>
            pm_clk <= pm_clk_int;
            pm_ncs <= '0';
            if pm_sample = '1' then
              pm_value_int( 0) := pm_dout;
            end if;
          when others => null;
                         pm_clk <= '1';
                         pm_ncs <= '1';
        end case;
        pm_sample   := not pm_clk_int and clkdiv_cnt(9);
        pm_clk_int  := clkdiv_cnt(9);
        b_clkdiv_to := clkdiv_cnt(10) = '1';
        if b_clkdiv_to then
          clkdiv_cnt := (0 => '1', others => '0');
        else
          clkdiv_cnt := inc(clkdiv_cnt);
        end if;
        if b_clkdiv_to then
          bit_cnt := inc(bit_cnt);
        end if;
      end if;
    end if;

  end process;

end SYN;
