--******************************************************************************
-- PHOS SRU
-- Designer : Fan Zhang (zhangfan@mail.hbut.edu.cn)
-- Last Updated: 2015-06-25
--*******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--use work.trg_pkg.all;

entity siu_wrapper is
  generic (CDH_V : integer range 0 to 3 := 3;
			  DDLSIMEN : std_logic := '1';
           CH : integer range 0 to 11 := 0);
  port (
    --==============================--
    -- CLOCKS
    --==============================--
    -- IN
    refclk : in std_logic;
    refclk_bufg : in std_logic;
    gtx0_txusrclk2 : in std_logic;
    gtx0_rxusrclk2 : in std_logic;
    foCLK : in std_logic;
    dclk : in std_logic;
    -- OUT
    gtx0_txoutclk : out std_logic;
    gtx0_rxrecclk : out std_logic;
    --==============================--
    -- RST
    --==============================--
    reset : out std_logic;  --ddg_reset
	 ddlinit : in std_logic;
    rst_button : in std_logic;
    --==============================--
    -- SERIAL data
    --==============================--
    rx_p : in std_logic;
    rx_n : in std_logic;
    tx_p : out std_logic;
    tx_n : out std_logic;
    --==============================--
    -- FEE interface
    --==============================--
    siu_reset : out std_logic;
	 siu_foCLK : out std_logic;
	 siu_fbd : inout std_logic_vector(31 downto 0);
    siu_fbten_n : inout std_logic; 
	 siu_fbctrl_n : inout std_logic;
    siu_fiben_n : out std_logic;
	 siu_fidir : out std_logic; 
	 siu_filf_n : out std_logic;
    siu_fobsy_n : in std_logic;
	 siu_first_n : out std_logic;
    --==============================--
    -- LED interface
    --==============================-- 
	 siusn : in std_logic_vector(31 downto 0);
	 ddl_mode : out std_logic_vector ( 1 downto 0);
    led_g : out std_logic
    );
end siu_wrapper;


architecture rtl of siu_wrapper is
  -- SIU
  signal siu_rst : std_logic;
  signal siu_rst_n : std_logic;
  signal siu_phy_txd, siu_phy_rxd : std_logic_vector(15 downto 0);
  signal siu_phy_tx_er, siu_phy_tx_en : std_logic;
  signal siu_phy_rx_er, siu_phy_rx_dv : std_logic;
  signal siu_phy_enable, siu_phy_loopen : std_logic;
  -- GTX signals
  signal gtx0_rxlossofsync : std_logic;
  --
  signal reset_i : std_logic;
  signal gtx_rst : std_logic;
  
  -- DRP
  signal drp_start : std_logic;
  signal drp_done : std_logic;
  signal set_speed : std_logic_vector(1 downto 0);
  
  
  	COMPONENT ddl_tlk_stimulus
	PORT(
		reset : IN std_logic;          
		ddl_usrclk : OUT std_logic;
		gtx_txoutclk : OUT std_logic;
		gtx_rxrecclk : OUT std_logic;
		ddl0_rxdata : OUT std_logic_vector(15 downto 0);
		ddl0_rx_er : OUT std_logic;
		ddl0_rx_dv : OUT std_logic;
		ddl1_rxdata : OUT std_logic_vector(15 downto 0);
		ddl1_rx_er : OUT std_logic;
		ddl1_rx_dv : OUT std_logic
		);
	END COMPONENT;
  

begin
  -- assignment
  reset <= reset_i;
  siu_rst_n <= not siu_rst;
  siu_foCLK <= foCLK;
  siu_first_n <= siu_rst_n;
  siu_reset <= reset_i;
  set_speed <="00";

TLKEUM : 
	if(DDLSIMEN = '0') generate
	begin
  TLK2501_EMU_INST : entity work.tlk2501_emu
    port map (
      -- high speed setial link
      DINRXN => rx_n,
      DINRXP => rx_p,
      DOUTTXN => tx_n,
      DOUTTXP => tx_p,
      -- GTX clocks
      REFCLK => refclk,
      refclk_bufg => refclk_bufg,
      gtx_txoutclk => gtx0_txoutclk,
      gtx_txusrclk2 => gtx0_txusrclk2,
      gtx_rxrecclk => gtx0_rxrecclk,
      gtx_rxusrclk2 => gtx0_rxusrclk2,
      dclk => dclk,
      -- DRP signals
      drp_start => drp_start,
      drp_done => drp_done,
      set_speed => set_speed,
      --
      gtx_rst => gtx_rst,
      -- parallel interface
      RXD => siu_phy_rxd,
      RX_ER => siu_phy_rx_er,
      RX_DV => siu_phy_rx_dv,
      TXD => siu_phy_txd,
      TX_EN => siu_phy_tx_en,
      TX_ER => siu_phy_tx_er,
      ENABLE => siu_phy_enable, -- not used (to be checked)
      LOOPEN => siu_phy_loopen,
      gtx_rxlossofsync => gtx0_rxlossofsync,
      RST => siu_rst,
      lckrefn => '0'
      );
end generate;

DDL_SIM:
   if (DDLSIMEN = '1') generate
      begin	
  DDLSIM_INST : ddl_tlk_stimulus 
  port map (
      ddl_usrclk => open,
      gtx_txoutclk => gtx0_txoutclk,
      gtx_rxrecclk => gtx0_rxrecclk,
		ddl0_rxdata => siu_phy_rxd,
      ddl0_rx_er => siu_phy_rx_er,
      ddl0_rx_dv => siu_phy_rx_dv,
      ddl1_rxdata => open,
      ddl1_rx_dv => open,
      ddl1_rx_er => open,
		reset => rst_button
  );
   end generate;

  SIU_TOP_INST : entity work.siu_top 
    generic map (CH => CH)
    port map (
      reset => reset_i,
      reset_dcs => ddlinit,
      --
      -- TLK201 interface
      --
      -- TX interface
      tx_clk => gtx0_txusrclk2,
      txd => siu_phy_txd,
      tx_en => siu_phy_tx_en,
      tx_er => siu_phy_tx_er,
      -- RX interface
      rx_clk => gtx0_rxusrclk2,
      rxd => siu_phy_rxd,
      rx_dv => siu_phy_rx_dv,
      rx_er => siu_phy_rx_er,
      prbsen => open,
      enable => siu_phy_enable,
      loopen => siu_phy_loopen, -- fixed to 0
      lckrefn => open,          -- fixed to 1
      --
      -- FEE interface
      --
      fbD => siu_fbd,
      fbTEN_N => siu_fbten_n,
      fbCTRL_N => siu_fbctrl_n,
      fiBEN_N => siu_fiben_n,
      fiDIR => siu_fidir,
      fiLF_N => siu_filf_n,
      foBSY_N => siu_fobsy_n,
      foCLK => foCLK,
      --rod => x"00000000",
      --rocmd_n => '0',
      --roten_n => '0',
      --tap_tck => '0',
      --tap_tdo => '0',
      --tap_tdi => '0',
      --tap_trst => '0',
      --tap_tms => '0',
      --self_tdo => '0',
      --self_tdi => '0',
      --self_tms => '0',
      --self_tck => '0',
      ot_los => gtx0_rxlossofsync,
      ot_td => open,
      ot_tf => '0',
      ot_rs => '0',
      md => "000",
      led1 => open,
      led2 => open,
      led3 => led_g,
      led4 => open,
      pm_dout => '0',
      pm_ncs => open,
      pm_clk => open,
      i2c_scl => open,
      i2c_sda => open,
      pwr_good => siu_rst_n,
      --
      ddl_mode => ddl_mode,
		siusn => siusn,
		set_speed => set_speed
      );

  ---------------------------------------
  ---- GTX RESET TO BE CHECKED WITH THE CRORC ONE
  ---- it generates the different reset
  ---- for the QSFP and GTX
  --------------------------------------
  GTX_RESET_INST: entity work.gtx_reset
    port map (
      clk => foCLK,
      rst => rst_button, -- rst button on the case of the board
      --
      drp_start => drp_start,
      drp_done => drp_done,
      --
      gtx_rst => gtx_rst
      );

end rtl;
