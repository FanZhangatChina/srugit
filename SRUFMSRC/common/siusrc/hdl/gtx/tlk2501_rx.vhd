--******************************************************************************
--*
--* Module          : TLK2501_RX
--* File            : tlk2501_rx.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     18-04-13 1.0 : TLK2501 RX 8b/10b encoder
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity tlk2501_rx is
  port (
    clk : in std_logic;
    din : in std_logic_vector(15 downto 0);
    byte_ordering_ok : in std_logic;
    errdetect : in std_logic_vector(1 downto 0);
    ctrldetect : in std_logic_vector(1 downto 0);
    dv : out std_logic;
    er : out std_logic;
    dout : out std_logic_vector(15 downto 0)
    );
end tlk2501_rx;

architecture rtl of tlk2501_rx is

begin
  -- TLK2501 Receiver Part
  p_rx_decode: process (clk)
  begin  -- process p_rx_decode
    if rising_edge(clk) then
      dout <= din;
      if byte_ordering_ok = '0' then
        -- if the byte ordering is not done
        dout <= X"FFFF";
        dv <= '1';
        er <= '1';
      elsif errdetect = "00" and
        ctrldetect(0) = '1' and
        din(7 downto 0) = X"BC" then
        -- should be IDLE, but we don't check the upper half
        dv <= '0';
        er <= '0';
      elsif errdetect = "00" and
        ctrldetect = "11" then
        -- valid special characters
        if din = X"F7F7" then
          -- carrier extend
          dv <= '0';
          er <= '1';
        else
          -- anything else, including error propagation
          dv <= '1';
          er <= '1';
        end if;
      elsif errdetect = "00" and
        ctrldetect = "00" then
        -- valid data character
        dv <= '1';
        er <= '0';
      else
        -- anything else should be treated as invalid
        dv <= '1';
        er <= '1';
      end if;
    end if;
  end process p_rx_decode;
end rtl;

