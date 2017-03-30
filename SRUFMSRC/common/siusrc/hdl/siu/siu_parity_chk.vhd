--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : PARITY_CHK
--* File            : parity_chk.vhd
--* Library         : ieee
--* Description     : This module checks the parity bits (2 bits) of the
--*                   front-end data words stored in the TXD FIFO.
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

entity siu_parity_chk is
  
  port (
    clock : in  std_logic;
    arst  : in  std_logic;
    d     : in  std_logic_vector (31 downto 0);
    ena   : in  std_logic;
    par   : in  std_logic_vector ( 1 downto 0);
    perr  : out std_logic);

end siu_parity_chk;

architecture SYN of siu_parity_chk is

  signal par07_00 : std_logic;
  signal par15_08 : std_logic;
  signal par23_16 : std_logic;
  signal par31_24 : std_logic;

begin  -- SYN

  process (clock)
    variable ena_d1 : std_logic;
    variable ena_d2 : std_logic;
    variable par0   : std_logic;
    variable par1   : std_logic;
    variable perr0  : std_logic;
    variable perr1  : std_logic;
  begin  -- process
  if clock'event and clock = '1' then  -- rising clock edge
    if arst = '1' then                 -- asynchronous reset (active low)
      perr     <= '0';
      par07_00 <= '0';
      par15_08 <= '0';
      par23_16 <= '0';
      par31_24 <= '0';
      ena_d1   := '0';
      ena_d2   := '0';
      par0     := '0';
      par1     := '0';
      perr0    := '0';
      perr1    := '0';
      else
      perr <= (perr0 or perr1) and ena_d2;
      par07_00 <= d(7) xor d(6) xor d(5) xor d(4) xor
                  d(3) xor d(2) xor d(1) xor d(0);
      par15_08 <= d(15) xor d(14) xor d(13) xor d(12) xor
                  d(11) xor d(10) xor d(9) xor d(8);
      perr0 := par07_00 xor par15_08 xor par0;
      par0  := par(0);
      par23_16 <= d(23) xor d(22) xor d(21) xor d(20) xor
                  d(19) xor d(18) xor d(17) xor d(16);
      par31_24 <= d(31) xor d(30) xor d(29) xor d(28) xor
                  d(27) xor d(26) xor d(25) xor d(24);
      perr1 := par23_16 xor par31_24 xor par1;
      par1  := par(1);
      ena_d2 := ena_d1;
      ena_d1 := ena;
    end if;
    end if;
  end process;

end SYN;
