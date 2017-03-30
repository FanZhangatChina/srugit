--******************************************************************************
--*
--* Module          : TLK2501_TX
--* File            : tlk2501_tx.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     18-04-13 1.0 : TLK2501 TX 8b/10b encoder
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity tlk2501_tx is
  port (
    clk : in std_logic;
    en : in std_logic;
    er : in std_logic;
    din : in std_logic_vector(15 downto 0);
    dout : out std_logic_vector(15 downto 0);
    charisk : out std_logic_vector(1 downto 0)
    );
end tlk2501_tx;

architecture rtl of tlk2501_tx is

begin
  -- Transmitter Data Controls:
  -- TX_EN  TX_ER  Encoded 20-bit output
  -- 0      0      IDLE (<K28.5, D5.6> or <K28.5, D16.2>)
  -- 0      1      Carrier extend (<K23.7, K23.7>)
  -- 1      0      Normal data (DX.Y)
  -- 1      1      Transmit error propagation (<K30.7, K30.7>)
  --
  -- Note that the K28.5 special character has two versions; 
  -- one for positive and one for negative RD. By using a neutral 
  -- character, like D5.6, we guarantee that both the positive and 
  -- the negative K28.5 will appear in the serial data stream.
  -- -K28.5 D05.6 +K28.5 D05.6 -K28.5 D05.6 +K28.5 D05.6

  p_tx_control: process (clk)
  begin  -- process p_tx_control
    if rising_edge(clk) then
      if en = '0' and er = '0' then
        dout <= X"C5BC";           -- D05.6, K28.5
        charisk <= "01";
      elsif en = '1' and er = '1' then
        dout <= X"FEFE";           -- K30.7, K30.7
        charisk <= "11";
      elsif en = '0' and er = '1' then
        dout <= X"F7F7";           -- K23.5, K23.5
        charisk <= "11";
      else
        dout <= din;               -- Dxx.y, Dxx.y
        charisk <= "00";
      end if;
    end if;
  end process p_tx_control; 
end rtl;

