-------------------------------------------------------------------------------
-- Title: Calculate Checksum
-- Project: Gigabit Ethernet Link
-------------------------------------------------------------------------------
-- File: calculateChecksum.vhd
-- Author: Alfonso Tarazona Martinez (ATM)
-- Company: NEXT Group (Universidad Politcnica de Valencia)
-- Last update: 2009/09/09
-- Description: 
-------------------------------------------------------------------------------
-- Revisions:
-- Date                	Version  	Author  	Description
-- 
-------------------------------------------------------------------------------
-- More Information:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity calculateChecksum is
  port (
    clk         : in  std_logic;           					 -- Clock
    rst         : in  std_logic;           					 -- Asynchronous reset
		iniChecksum : in  std_logic_vector(15 downto 0); -- Default checksum
    newChecksum : in  std_logic;           					 -- Indicates new checksum
    newByte     : in  std_logic;           					 -- Indicates new byte
    inByte      : in  std_logic_vector(7 downto 0);  -- Byte to calculate
    checksum    : out std_logic_vector(15 downto 0)  -- Current checksum
  );
end calculateChecksum;
                 
architecture calculateChecksum_arch of calculateChecksum is

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
  constant s_MSB : std_logic := '0';
  constant s_LSB : std_logic := '1';
  
-------------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------------
  signal checkState : std_logic;
  signal checksumC1 : std_logic_vector(15 downto 0);  -- stores 1's complement sum
  signal checksumC2 : std_logic_vector(16 downto 0);  -- stores 2's complement sum
  signal MSB_latch  : std_logic_vector(7 downto 0);   -- latch of the first byte

begin  -- calculateChecksum_arch

  -- performs 2's complement to one's complement conversion and invert output
  checksumC1 <= checksumC2(15 downto 0) + checksumC2(16);
  checksum <= not checksumC1;

  process (clk, rst)
  begin  
    if rst = '1' then                   
      checkState <= s_MSB;
      MSB_latch <= (others => '0');
      checksumC2 <= (others => '0');
    elsif clk'event and clk = '1' then  
      case checkState is
        when s_MSB =>
          if newChecksum = '1' then
            checkState <= s_MSB;
            checksumC2 <= '0' & inichecksum;
          elsif newByte = '1' then
            checkState <= s_LSB;
            MSB_latch <= inByte;
          else
            checkState <= s_MSB;
          end if;

        when s_LSB =>
          if newChecksum = '1' then
            checkState <= s_MSB;
            checksumC2 <= '0' & inichecksum;
          elsif newByte = '1' then
            checkState <= s_MSB;
            checksumC2 <= ('0' & checksumC1) + ('0' & MSB_latch & inByte);
          else
            checkState <= s_LSB;
          end if;
          
        when others =>
          checkState <= s_MSB;
      end case;
    end if;
  end process;
  
end calculateChecksum_arch;



