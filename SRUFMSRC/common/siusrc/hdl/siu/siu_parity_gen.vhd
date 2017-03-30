--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : PARITY_GEN
--* File            : parity_gen.vhd
--* Library         : ieee
--* Description     : This module generates the parity bits (2 bits) for the
--*                   front-end data words.
--* Simulator       : Modelsim
--* Synthesizer     : Synplify
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--* Revision history:
--*   17-Oct-2005 CS  Original coding
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_parity_gen is
  
  port (
    clock : in  std_logic;
    arst  : in  std_logic;
    d     : in  std_logic_vector (31 downto 0);
    par   : out std_logic_vector (1 downto 0));

end siu_parity_gen;

architecture SYN of siu_parity_gen is

  signal par07_00 : std_logic;
  signal par15_08 : std_logic;
  signal par23_16 : std_logic;
  signal par31_24 : std_logic;

begin  -- SYN

  par(0) <= par07_00 xor par15_08;
  par(1) <= par23_16 xor par31_24;

  process (clock)
  begin  -- process
    if clock'event and clock = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)
        par07_00 <= '0';
        par15_08 <= '0';
        par23_16 <= '0';
        par31_24 <= '0';
      else
        par07_00 <= d(7) xor d(6) xor d(5) xor d(4) xor
                    d(3) xor d(2) xor d(1) xor d(0);
        par15_08 <= d(15) xor d(14) xor d(13) xor d(12) xor
                    d(11) xor d(10) xor d(9) xor d(8);
        par23_16 <= d(23) xor d(22) xor d(21) xor d(20) xor
                    d(19) xor d(18) xor d(17) xor d(16);
        par31_24 <= d(31) xor d(30) xor d(29) xor d(28) xor
                    d(27) xor d(26) xor d(25) xor d(24);
      end if;
    end if;
  end process;

end SYN;
