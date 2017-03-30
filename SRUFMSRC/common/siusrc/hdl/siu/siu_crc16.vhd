--******************************************************************************
--*
--* Module          : TOP
--* File            : top.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_crc16 is
  port (
    clock : in  std_logic;
    srst  : in  std_logic;
    ena   : in  std_logic;
    d     : in  std_logic_vector (15 downto 0);
    q     : out std_logic_vector (15 downto 0)
  );
end siu_crc16;

architecture SYN of siu_crc16 is

    signal q0 : std_logic_vector (15 downto 0);
    signal q1 : std_logic_vector (15 downto 0);

begin

  q <= q0;

  proc_main : process (clock)
    variable ena_d1 : std_logic;
  begin
    if (clock'event and clock = '1') then

      q1(15) <= d(15) xor d(11) xor d( 7) xor d( 4) xor d( 3);
      q1(14) <= d(14) xor d(10) xor d( 6) xor d( 3) xor d( 2);
      q1(13) <= d(13) xor d( 9) xor d( 5) xor d( 2) xor d( 1);
      q1(12) <= d(12) xor d( 8) xor d( 4) xor d( 1) xor d( 0);
      q1(11) <= d(11) xor d( 7) xor d( 3) xor d( 0);
      q1(10) <= d(15) xor d(11) xor d(10) xor d( 7) xor d( 6) xor
                d( 4) xor d( 3) xor d( 2);
      q1( 9) <= d(14) xor d(10) xor d( 9) xor d( 6) xor d( 5) xor
                d( 3) xor d( 2) xor d( 1);
      q1( 8) <= d(13) xor d( 9) xor d( 8) xor d( 5) xor d( 4) xor
                d( 2) xor d( 1) xor d( 0);
      q1( 7) <= d(12) xor d( 8) xor d( 7) xor d( 4) xor d( 3) xor
                d( 1) xor d( 0);
      q1( 6) <= d(11) xor d( 7) xor d( 6) xor d( 3) xor d( 2) xor d( 0);
      q1( 5) <= d(10) xor d( 6) xor d( 5) xor d( 2) xor d( 1);
      q1( 4) <= d( 9) xor d( 5) xor d( 4) xor d( 1) xor d( 0);
      q1( 3) <= d(15) xor d(11) xor d( 8) xor d( 7) xor d( 0);
      q1( 2) <= d(14) xor d(10) xor d( 7) xor d( 6);
      q1( 1) <= d(13) xor d( 9) xor d( 6) xor d( 5);
      q1( 0) <= d(12) xor d( 8) xor d( 5) xor d( 4);

      if (srst = '1') then
        if (ena_d1 = '1') then
          q0(15) <= not q1(15);
          q0(14) <= not q1(14);
          q0(13) <= not q1(13);
          q0(12) <= not q1(12);
          q0(11) <=     q1(11);
          q0(10) <=     q1(10);
          q0( 9) <=     q1( 9);
          q0( 8) <=     q1( 8);
          q0( 7) <= not q1( 7);
          q0( 6) <=     q1( 6);
          q0( 5) <= not q1( 5);
          q0( 4) <= not q1( 4);
          q0( 3) <= not q1( 3);
          q0( 2) <=     q1( 2);
          q0( 1) <=     q1( 1);
          q0( 0) <=     q1( 0);
        else
          q0     <= (others => '1');
        end if;
      else
        if (ena_d1 = '1') then
          q0(15) <= q1(15) xor q0(15) xor q0(11) xor q0( 7) xor q0( 4) xor
                    q0( 3);
          q0(14) <= q1(14) xor q0(14) xor q0(10) xor q0( 6) xor q0( 3) xor
                    q0( 2);
          q0(13) <= q1(13) xor q0(13) xor q0( 9) xor q0( 5) xor q0( 2) xor
                    q0( 1);
          q0(12) <= q1(12) xor q0(12) xor q0( 8) xor q0( 4) xor q0( 1) xor
                    q0( 0);
          q0(11) <= q1(11) xor q0(11) xor q0( 7) xor q0( 3) xor q0( 0);
          q0(10) <= q1(10) xor q0(15) xor q0(11) xor q0(10) xor q0( 7) xor
                    q0( 6) xor q0( 4) xor q0( 3) xor q0( 2);
          q0( 9) <= q1( 9) xor q0(14) xor q0(10) xor q0( 9) xor q0( 6) xor
                    q0( 5) xor q0( 3) xor q0( 2) xor q0( 1);
          q0( 8) <= q1( 8) xor q0(13) xor q0( 9) xor q0( 8) xor q0( 5) xor
                    q0( 4) xor q0( 2) xor q0( 1) xor q0( 0);
          q0( 7) <= q1( 7) xor q0(12) xor q0( 8) xor q0( 7) xor q0( 4) xor
                    q0( 3) xor q0( 1) xor q0( 0);
          q0( 6) <= q1( 6) xor q0(11) xor q0( 7) xor q0( 6) xor q0( 3) xor
                    q0( 2) xor q0( 0);
          q0( 5) <= q1( 5) xor q0(10) xor q0( 6) xor q0( 5) xor q0( 2) xor
                    q0( 1);
          q0( 4) <= q1( 4) xor q0( 9) xor q0( 5) xor q0( 4) xor q0( 1) xor
                    q0( 0);
          q0( 3) <= q1( 3) xor q0(15) xor q0(11) xor q0( 8) xor q0( 7) xor
                    q0( 0);
          q0( 2) <= q1( 2) xor q0(14) xor q0(10) xor q0( 7) xor q0( 6);
          q0( 1) <= q1( 1) xor q0(13) xor q0( 9) xor q0( 6) xor q0( 5);
          q0( 0) <= q1( 0) xor q0(12) xor q0( 8) xor q0( 5) xor q0( 4);
        else
          q0     <= q0;
        end if;
      end if;
      ena_d1 := ena;

    end if;

  end process;

end SYN;
