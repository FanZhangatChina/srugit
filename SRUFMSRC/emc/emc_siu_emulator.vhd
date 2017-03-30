--******************************************************************************
--*
--* Detector        : EMCal
--* File            : top.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--* 
--*  Revision history:
--*  13-12-13: PC SIU with TTC FMC interface (to be completed) and PCIe interface
--             It is possible to adjust FREQ and line speed. Fixed a bug
--             qsfp_rst not assigned correctly
--*  02-07-14: PC Added interface to DDG RESET BUTTON CASE (to reset the GTX)
--*  05-06-15: Remove fan control, fan_clk, dclk = 40 MHz, take GTX clock out, Updated by Fan.Zhang
--*  01-07-15: Add ddlinit signal (DCS command to reset DDL link in case DDL is not ready after FPGA loading)				
--*  11-07-15: Two ddl links, SIU S/N defined by input signal "siusn" (Fan.Zhang). 
--******************************************************************************

library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

library unisim; 
use unisim.vcomponents.all;

--use work.trg_pkg.all;

entity siu_emulator is
  port (
    --==============================--
    -- FPGA clock
    --==============================--
    dclk : in std_logic;
    --==============================--
    -- SFP interface
    --==============================--
    -- CLOCK 
    refclk_p : in std_logic;    -- GTX REFCLK
    refclk_n : in std_logic;    -- GTX REFCLK
    -- RX
    sfp_rx_p : in std_logic_vector(1 downto 0);  
    sfp_rx_n : in std_logic_vector(1 downto 0);  
    -- TX
    sfp_tx_p : out std_logic_vector(1 downto 0); 
    sfp_tx_n : out std_logic_vector(1 downto 0);

    --==============================--
    -- FEE interface
    --==============================--
    siu_reset : out std_logic_vector(1 downto 0);
	 siu_foCLK : out std_logic_vector(1 downto 0);
	 siu_fbd : inout std_logic_vector(63 downto 0);
    siu_fbten_n : inout std_logic_vector(1 downto 0); 
	 siu_fbctrl_n : inout std_logic_vector(1 downto 0);
    siu_fiben_n : out std_logic_vector(1 downto 0);
	 siu_fidir : out std_logic_vector(1 downto 0); 
	 siu_filf_n : out std_logic_vector(1 downto 0);
    siu_fobsy_n : in std_logic_vector(1 downto 0);
	 siu_first_n : out std_logic_vector(1 downto 0);
    --==============================--
    -- LED interface
    --==============================--
	 siusn : in std_logic_vector(31 downto 0);
	 ddl_mode : out std_logic_vector(3 downto 0);
    ddlinit  : in std_logic;
    -- GPIO
    --==============================--
    gpio_in  : in std_logic
    );
end siu_emulator;

architecture rtl of siu_emulator is
  -- FPGA clock
  -- GTX
  signal sfp_refclk_bufg : std_logic;
  signal gtx0_txoutclk : std_logic_vector(1 downto 0);
  signal gtx0_rxusrclk2,gtx0_rxrecclk : std_logic_vector(1 downto 0);
  signal gtx0_txusrclk2 : std_logic_vector(1 downto 0);
  signal qsfp_reseti_n : std_logic_vector(2 downto 0);
  -- REFCLK  
  signal refclk,refclk_bufg  : std_logic;
  -- FPGA CLOCK
  signal foCLK : std_logic_vector(1 downto 0);
  signal rst_button : std_logic;

  type states is (
    IDLE,DRP
    );
  signal state : states;
begin  -- RTL

  rst_button <= gpio_in;
  foCLK <= gtx0_txusrclk2;
  siu_foCLK <= foCLK;

  GTX_MGMT_INST : entity work.gtxclk_mgmt port map
    (
      -- GTX REFCLK
      -- IN
      refclk_p => refclk_p,
      refclk_n => refclk_n,
      gtx0_txoutclk => gtx0_txoutclk,
      gtx0_rxrecclk => gtx0_rxrecclk,
      -- OUT
      
		refclk => refclk,
      refclk_bufg => refclk_bufg,
      gtx0_txusrclk2 => gtx0_txusrclk2,
      gtx0_rxusrclk2 => gtx0_rxusrclk2);
 
  --------------------------------------------------
  -- SIU code CDH V2
  -------------------------------------------------- 
  SIU_CH_GEN : for i in 0 to 1 generate    
    SIU_WRAPPER_INST : entity work.siu_wrapper
      generic map (CDH_V => 3,DDLSIMEN => '0', CH => i)
      --generic map (CDH_V => 3,DDLSIMEN => '1', CH => i)
      port map (
        -- CLOCKs
        -- IN
        refclk => refclk,
        refclk_bufg => refclk_bufg,
        gtx0_txusrclk2 => gtx0_txusrclk2(i),
        gtx0_rxusrclk2 => gtx0_rxusrclk2(i),
        foCLK => foCLK(i),
        dclk => dclk,
        -- OUT
        gtx0_txoutclk => gtx0_txoutclk(i),
        gtx0_rxrecclk => gtx0_rxrecclk(i),
        -- RST
        reset => open,
        rst_button => rst_button,
        ddlinit => ddlinit,
		  siusn => siusn,

        -- SERIAL data
        rx_p => sfp_rx_p(i),
        rx_n => sfp_rx_n(i),
        tx_p => sfp_tx_p(i),
        tx_n => sfp_tx_n(i),
		  
		  -- FEE IF
			siu_reset => siu_reset(i),
			siu_foCLK => open,
			siu_fobsy_n => siu_fobsy_n(i),
			siu_fbd => siu_fbd(((i+1)*32-1) downto ((i+1)*32-32)),
			siu_fbten_n => siu_fbten_n(i),
			siu_fbctrl_n => siu_fbctrl_n(i),
			siu_fiben_n => siu_fiben_n(i),
			siu_fidir => siu_fidir(i),
			siu_filf_n => siu_filf_n(i),
			siu_first_n => siu_first_n(i),
        -- LED interface
		  ddl_mode => ddl_mode(((i+1)*2-1) downto ((i+1)*2-2))
        );
  end generate;  
  
  

end rtl;
