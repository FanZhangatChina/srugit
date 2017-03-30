----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:36:06 06/03/2015 
-- Design Name: 
-- Module Name:    gtxclk_mgmt - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

library unisim; 
use unisim.vcomponents.all;

entity gtxclk_mgmt is
port (
    --==============================--
    -- GTX REFCLK
    --==============================--
    -- IN
    refclk_p : in std_logic;
    refclk_n : in std_logic;
    gtx0_txoutclk : in std_logic;
    gtx0_rxrecclk : in std_logic_vector (0 downto 0);    
    -- OUT
--    foCLK : out std_logic;
	 refclk : out std_logic;
    refclk_bufg : out std_logic;
    gtx0_txusrclk2 : out std_logic;
    gtx0_rxusrclk2 : out std_logic_vector(0 downto 0));
end gtxclk_mgmt;

architecture rtl of gtxclk_mgmt is
  -- GTX REFCLK
  signal refclk_i : std_logic;
begin
  --------------------------------------------------------- 
  -- GTX refclock (DEFAULT 212.5 MHz)
  --------------------------------------------------------- 
  U_GTXREFCLKBUF : IBUFDS_GTXE1
    PORT MAP (
      O => refclk_i,
      ODIV2 => OPEN,
      CEB => '0',
      I => refclk_p,
      IB => refclk_n 
      );

  U_GTXREFCLKBUFG : BUFG
    port map (
      I => refclk_i,
      O => refclk_bufg
      );
  refclk <= refclk_i;

  txoutclk_bufg03_i : BUFG
    port map (
      I => gtx0_txoutclk,
      O => gtx0_txusrclk2
      );

  RXRECCLK_LOOP : for i in 0 to 0 generate
    rxrecclk_bufr1_i : BUFG
      port map (
        I => gtx0_rxrecclk(i),
        O => gtx0_rxusrclk2(i)
        );
    end generate;
--
--  txoutclk_bufg04_i : BUFG
--    port map (
--      I => gtx0_txoutclk,
--      O => foCLK
--      );

	--foCLK <= gtx0_txoutclk;
end rtl;

