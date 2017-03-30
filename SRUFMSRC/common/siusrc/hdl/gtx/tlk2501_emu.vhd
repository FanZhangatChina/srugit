--******************************************************************************
--*
--* Module          : tlk2501_emu
--* File            : tlk2501_emu.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     14-04-14 PC TLK emulator
--*
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity tlk2501_emu is
  port (
    -- high speed serial links
    DINRXN : in std_logic;
    DINRXP : in std_logic;
    DOUTTXN : out std_logic;
    DOUTTXP : out std_logic;
    -- GTX reference clock
    REFCLK : in std_logic;
    REFCLK_BUFG : in std_logic;
    gtx_txoutclk : out std_logic;
    gtx_txusrclk2 : in std_logic;
    gtx_rxrecclk : out std_logic;
    gtx_rxusrclk2 : in std_logic;
    DCLK : in std_logic;
    --
    drp_start : in std_logic;
    drp_done : out std_logic;
    set_speed : in std_logic_vector(1 downto 0);
    --
    gtx_rst : in std_logic;
    -- parallel data interface
    RXCLK : out std_logic;
    RXD : out std_logic_vector(15 downto 0);
    RX_ER : out std_logic;
    RX_DV : out std_logic;
    TXCLK : out std_logic;
    TXD : in std_logic_vector(15 downto 0);
    TX_EN : in std_logic;
    TX_ER : in std_logic;
    ENABLE : in std_logic;
    RST : out std_logic;
    LOOPEN : in std_logic;
    lckrefn : in std_logic;
    gtx_rxlossofsync : out std_logic
    );
end tlk2501_emu;

architecture rtl of tlk2501_emu is
  -- CLOCKs
  ----- usrclk2 ---
  signal gtx_rxnotintable : std_logic_vector(1 downto 0);
  signal gtx_rxcharisk : std_logic_vector(1 downto 0);
  signal gtx_rxdata : std_logic_vector(15 downto 0); --O[31:0]
  signal gtx_txdata : std_logic_vector(15 downto 0);
  signal gtx_txcharisk : std_logic_vector(1 downto 0);
  signal gtx_rxbyteisaligned : std_logic;
  signal gtx0_rxlossofsync_i : std_logic_vector(1 downto 0);
--***********************************Parameter Declarations********************
  constant DLY : time := 1 ns;
--************************** Register Declarations ****************************  
  signal  gtx0_tx_system_reset_c          : std_logic;
  signal  gtx0_rx_system_reset_c          : std_logic;
--************************** DDL phy byte ordering ****************************
  signal rx_dataout_ordered : std_logic_vector(15 downto 0);
  signal rx_ctrldetect_ordered : std_logic_vector(1 downto 0);
  signal rx_errdetect_ordered : std_logic_vector(1 downto 0);
  signal rx_byteordering_ok,srst : std_logic;
  
begin

  -- ASSIGNMENTs
  gtx_rxlossofsync <= gtx0_rxlossofsync_i(1);
  srst <= gtx0_rxlossofsync_i(1);

  GTX_INST : entity work.gtx_wrapper
    port map (
      DINRXN => DINRXN,
      DINRXP => DINRXP,
      DOUTTXN => DOUTTXN,
      DOUTTXP => DOUTTXP,
      REFCLK => REFCLK,
      REFCLK_BUFG => REFCLK_BUFG,
      gtx_txoutclk => gtx_txoutclk,
      gtx_txusrclk2 => gtx_txusrclk2,
      gtx_rxrecclk => gtx_rxrecclk,
      gtx_rxusrclk2 => gtx_rxusrclk2,
      DCLK => DCLK,
      --
      drp_start => drp_start,
      drp_done => drp_done,
      set_speed => set_speed,
      --
      gtx_rst => gtx_rst,
      txcharisk => gtx_txcharisk,
      txdata => gtx_txdata,
      rxdata => gtx_rxdata,
      rxcharisk => gtx_rxcharisk,
      rxnotintable => gtx_rxnotintable,
      byteisaligned => gtx_rxbyteisaligned,
      gtx0_rxlossofsync_i => gtx0_rxlossofsync_i,
      loopen => loopen,
      gtx0_tx_system_reset_c => gtx0_tx_system_reset_c,
      gtx0_rx_system_reset_c => gtx0_rx_system_reset_c
      );  
  
  i_byte_ordering: entity work.ddl_phy_byte_ordering
    generic map (
      ALIGNMENT_BYTE => X"BC")
    port map (
      clock   => gtx_rxusrclk2,
      srst    => srst,
      datain  => gtx_rxdata,
      ctrlin  => gtx_rxcharisk,
      errin   => gtx_rxnotintable,
      dataout => rx_dataout_ordered,
      ctrlout => rx_ctrldetect_ordered,
      errout  => rx_errdetect_ordered,
      status  => rx_byteordering_ok);

  TX_INST : entity work.tlk2501_tx 
    port map (
      clk => gtx_txusrclk2,
      en => tx_en, 
      er => tx_er,
      din => txd,
      dout => gtx_txdata,
      charisk => gtx_txcharisk
      );

  RX_INST : entity work.tlk2501_rx 
    port map (
      clk => gtx_rxusrclk2,
      din => rx_dataout_ordered,
      byte_ordering_ok => rx_byteordering_ok,
      errdetect => rx_errdetect_ordered,
      ctrldetect => rx_ctrldetect_ordered,
      dv => rx_dv,
      er => rx_er,
      dout => rxd
      );

  TXCLK <= gtx_txusrclk2;
  RXCLK <= gtx_rxusrclk2;


  
end rtl;
