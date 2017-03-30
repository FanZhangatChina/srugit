--******************************************************************************
--*
--* Module          : gtx_wrapper
--* File            : gtx_wrapper.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     14-04-14 PC modified linkspeed_handler interface 
--*
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity gtx_wrapper is
  port (
    -- CLK
    REFCLK : in std_logic;
    REFCLK_BUFG : in std_logic;
    gtx_txoutclk : out std_logic;
    gtx_txusrclk2 : in std_logic;
    gtx_rxrecclk : out std_logic;
    gtx_rxusrclk2 : in std_logic;
    DCLK : in std_logic;
    -- SERIAL DATA
    DINRXN : in std_logic;
    DINRXP : in std_logic;
    DOUTTXN : out std_logic;
    DOUTTXP : out std_logic;
    -- PCIe CMD interface
    drp_start : in std_logic;
    drp_done : out std_logic;
    set_speed : in std_logic_vector(1 downto 0);
    --
    gtx_rst : in std_logic;
    txcharisk : in std_logic_vector (1 downto 0);
    txdata : in std_logic_vector(15 downto 0);
    rxcharisk : out std_logic_vector(1 downto 0);
    rxdata : out std_logic_vector(15 downto 0);   
    rxnotintable : out std_logic_vector(1 downto 0);
    byteisaligned : out std_logic;
    gtx0_rxlossofsync_i : out std_logic_vector(1 downto 0);
    loopen : in std_logic;
    gtx0_tx_system_reset_c : out std_logic;
    gtx0_rx_system_reset_c : out std_logic
    );
end gtx_wrapper;

architecture rtl of gtx_wrapper is

  signal rst_btn : std_logic;
--***********************************Parameter Declarations********************

  constant DLY : time := 1 ns;
  
  attribute max_fanout : string; 

--************************** Register Declarations ****************************

  signal   gtx0_txresetdone_r              : std_logic;
  signal   gtx0_txresetdone_r2             : std_logic;
  signal   gtx0_rxresetdone_i_r            : std_logic;
  signal   gtx0_rxresetdone_r              : std_logic;
  signal   gtx0_rxresetdone_r2             : std_logic;
  signal   gtx0_rxresetdone_r3             : std_logic;
  attribute max_fanout of gtx0_rxresetdone_i_r : signal is "1";


--**************************** Wire Declarations ******************************
  -------------------------- MGT Wrapper Wires ------------------------------
  --________________________________________________________________________
  --________________________________________________________________________
  --GTX0   (X0Y12)

  ------------------------ Loopback and Powerdown Ports ----------------------
  signal  gtx0_loopback_i                 : std_logic_vector(2 downto 0);
  ----------------------- Receive Ports - 8b10b Decoder ----------------------
  signal  gtx0_rxchariscomma_i            : std_logic_vector(1 downto 0);
  signal  gtx0_rxcharisk_i                : std_logic_vector(1 downto 0);
  signal  gtx0_rxdisperr_i                : std_logic_vector(1 downto 0);
  signal  gtx0_rxnotintable_i             : std_logic_vector(1 downto 0);
  --------------- Receive Ports - Comma Detection and Alignment --------------
  signal  gtx0_rxenmcommaalign_i          : std_logic;
  signal  gtx0_rxenpcommaalign_i          : std_logic;
  ------------------- Receive Ports - RX Data Path interface -----------------
  signal  gtx0_rxdata_i                   : std_logic_vector(15 downto 0);
  signal  gtx0_rxrecclk_i                 : std_logic;
  signal  gtx0_rxreset_i                  : std_logic;
  ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
  signal  gtx0_rxeqmix_i                  : std_logic_vector(2 downto 0);
  --------------- Receive Ports - RX Loss-of-sync State Machine --------------
--  signal  gtx0_rxlossofsync_i             : std_logic_vector(1 downto 0);
  ------------------------ Receive Ports - RX PLL Ports ----------------------
  signal  gtx0_gtxrxreset_i               : std_logic;
  signal  gtx0_pllrxreset_i               : std_logic;
  signal  gtx0_rxplllkdet_i               : std_logic;
  signal  gtx0_rxresetdone_i              : std_logic;
  ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
  signal  gtx0_daddr_i                    : std_logic_vector(7 downto 0);
  signal  gtx0_dclk_i                     : std_logic;
  signal  gtx0_den_i                      : std_logic;
  signal  gtx0_di_i                       : std_logic_vector(15 downto 0);
  signal  gtx0_drdy_i                     : std_logic;
  signal  gtx0_drpdo_i                    : std_logic_vector(15 downto 0);
  signal  gtx0_dwe_i                      : std_logic;
  ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
  signal  gtx0_txcharisk_i                : std_logic_vector(1 downto 0);
  ------------------ Transmit Ports - TX Data Path interface -----------------
  signal  gtx0_txdata_i                   : std_logic_vector(15 downto 0);
  signal  gtx0_txoutclk_i                 : std_logic;
  signal  gtx0_txreset_i                  : std_logic;
  ---------------- Transmit Ports - TX Driver and OOB signaling --------------
  signal  gtx0_txdiffctrl_i               : std_logic_vector(3 downto 0);
  signal  gtx0_txpostemphasis_i           : std_logic_vector(4 downto 0);
  --------------- Transmit Ports - TX Driver and OOB signalling --------------
  signal  gtx0_txpreemphasis_i            : std_logic_vector(3 downto 0);
  ----------------------- Transmit Ports - TX PLL Ports ----------------------
  signal  gtx0_gtxtxreset_i               : std_logic;
  signal  gtx0_plltxreset_i               : std_logic;
  signal  gtx0_txplllkdet_i               : std_logic;
  signal  gtx0_txresetdone_i              : std_logic;

  signal  gtx0_double_reset_clk_i         : std_logic;
  signal  tied_to_ground_i                : std_logic;
  signal  tied_to_ground_vec_i            : std_logic_vector(63 downto 0);
  signal  tied_to_vcc_i                   : std_logic;
  signal  tied_to_vcc_vec_i               : std_logic_vector(7 downto 0);
  signal  drp_clk_in_i                    : std_logic;
  

  ----------------------------- User Clocks ---------------------------------

  signal  gtx0_txusrclk2_i                : std_logic;
  signal  gtx0_rxusrclk2_i                : std_logic;


  ----------------------------- Reference Clocks ----------------------------
  
  signal    q3_clk1_refclk_i                : std_logic;
  signal    q3_clk1_refclk_i_bufg           : std_logic;

  ----------------------- Frame check/gen Module Signals --------------------
  
  signal    gtx0_matchn_i                   : std_logic;
  
  signal    gtx0_txcharisk_float_i          : std_logic_vector(1 downto 0);
  
  signal    gtx0_txdata_float_i             : std_logic_vector(23 downto 0);
  
  signal    gtx0_track_data_i               : std_logic;
  signal    gtx0_block_sync_i               : std_logic;
  signal    gtx0_error_count_i              : std_logic_vector(7 downto 0);
  signal    gtx0_frame_check_reset_i        : std_logic;
  signal    gtx0_inc_in_i                   : std_logic;
  signal    gtx0_inc_out_i                  : std_logic;
  signal    gtx0_unscrambled_data_i         : std_logic_vector(15 downto 0);

  signal    reset_on_data_error_i           : std_logic;
  signal    track_data_out_i                : std_logic;   

  -- tmp signal
  signal gtx0_tx_system_reset_i : std_logic;
  signal gtx0_rx_system_reset_i : std_logic;
  
begin

  --  Static signal Assigments
  tied_to_ground_i                             <= '0';
  tied_to_ground_vec_i                         <= x"0000000000000000";
  tied_to_vcc_i                                <= '1';
  tied_to_vcc_vec_i                            <= x"ff";

  gtx0_tx_system_reset_c <= gtx0_tx_system_reset_i;
  gtx0_rx_system_reset_c <= gtx0_rx_system_reset_i;

  proc_loopback : process (REFCLK_BUFG)
  begin
    if rising_edge(REFCLK_BUFG) then
      if loopen = '1' then
        gtx0_loopback_i <= "010" ;
      else
        gtx0_loopback_i <= "000" ;
      end if;
    end if;
  end process;  

  ----------------------------- The GTX Wrapper -----------------------------
  
  -- Use the instantiation template in the example directory to add the GTX wrapper to your design.
  -- In this example, the wrapper is wired up for basic operation with a frame generator and frame 
  -- checker. The GTXs will reset, then attempt to align and transmit data. If channel bonding is 
  -- enabled, bonding should occur after alignment.


  v6_gtxwizard_v1_12_i : entity work.v6_gtxwizard_v1_12
    generic map
    (
      WRAPPER_SIM_GTXRESET_SPEEDUP    =>      1
      )
    port map
    (
      --_____________________________________________________________________
      --_____________________________________________________________________
      --GTX0  (X0Y12)
      GTX0_DOUBLE_RESET_CLK_IN        =>      REFCLK_BUFG,
      ------------------------ Loopback and Powerdown Ports ----------------------
      GTX0_LOOPBACK_IN                =>      gtx0_loopback_i,
      ----------------------- Receive Ports - 8b10b Decoder ----------------------
      GTX0_RXCHARISCOMMA_OUT          =>      gtx0_rxchariscomma_i,
      GTX0_RXCHARISK_OUT              =>      rxcharisk,
      GTX0_RXDISPERR_OUT              =>      gtx0_rxdisperr_i,
      GTX0_RXNOTINTABLE_OUT           =>      rxnotintable,
      --------------- Receive Ports - Comma Detection and Alignment --------------
      GTX0_RXBYTEISALIGNED_OUT        =>      byteisaligned,   
      GTX0_RXENMCOMMAALIGN_IN         =>      gtx0_rxenmcommaalign_i,
      GTX0_RXENPCOMMAALIGN_IN         =>      gtx0_rxenpcommaalign_i,
      ------------------- Receive Ports - RX Data Path interface -----------------
      GTX0_RXDATA_OUT                 =>      rxdata,
      GTX0_RXRECCLK_OUT               =>      gtx_rxrecclk,
      GTX0_RXRESET_IN                 =>      gtx0_rxreset_i,
      GTX0_RXUSRCLK2_IN               =>      gtx_rxusrclk2,
      ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      GTX0_RXEQMIX_IN                 =>      gtx0_rxeqmix_i,
      GTX0_RXN_IN                     =>      DINRXN,
      GTX0_RXP_IN                     =>      DINRXP,
      --------------- Receive Ports - RX Loss-of-sync State Machine --------------
      GTX0_RXLOSSOFSYNC_OUT           =>      gtx0_rxlossofsync_i,
      ------------------------ Receive Ports - RX PLL Ports ----------------------
      GTX0_GTXRXRESET_IN              =>      gtx0_gtxrxreset_i,
      GTX0_MGTREFCLKRX_IN             =>      REFCLK,
      GTX0_PLLRXRESET_IN              =>      gtx0_pllrxreset_i,
      GTX0_RXPLLLKDET_OUT             =>      gtx0_rxplllkdet_i,
      GTX0_RXRESETDONE_OUT            =>      gtx0_rxresetdone_i,
      ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
      GTX0_DADDR_IN                   =>      gtx0_daddr_i,
      GTX0_DCLK_IN                    =>      DCLK,
      GTX0_DEN_IN                     =>      gtx0_den_i,
      GTX0_DI_IN                      =>      gtx0_di_i,
      GTX0_DRDY_OUT                   =>      gtx0_drdy_i,
      GTX0_DRPDO_OUT                  =>      gtx0_drpdo_i,
      GTX0_DWE_IN                     =>      gtx0_dwe_i,
      ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
      GTX0_TXCHARISK_IN               =>      txcharisk,
      ------------------ Transmit Ports - TX Data Path interface -----------------
      GTX0_TXDATA_IN                  =>      txdata,
      GTX0_TXOUTCLK_OUT               =>      gtx_txoutclk,
      GTX0_TXRESET_IN                 =>      gtx0_txreset_i,
      GTX0_TXUSRCLK2_IN               =>      gtx_txusrclk2,
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      GTX0_TXDIFFCTRL_IN              =>      gtx0_txdiffctrl_i,
      GTX0_TXN_OUT                    =>      DOUTTXN,
      GTX0_TXP_OUT                    =>      DOUTTXP,
      GTX0_TXPOSTEMPHASIS_IN          =>      gtx0_txpostemphasis_i,
      --------------- Transmit Ports - TX Driver and OOB signalling --------------
      GTX0_TXPREEMPHASIS_IN           =>      gtx0_txpreemphasis_i,
      ----------------------- Transmit Ports - TX PLL Ports ----------------------
      GTX0_GTXTXRESET_IN              =>      gtx0_gtxtxreset_i,
      GTX0_MGTREFCLKTX_IN             =>      REFCLK,
      GTX0_PLLTXRESET_IN              =>      gtx0_plltxreset_i,
      GTX0_TXPLLLKDET_OUT             =>      gtx0_txplllkdet_i,
      GTX0_TXRESETDONE_OUT            =>      gtx0_txresetdone_i


      );

  -- Hold the TX in reset till the TX user clocks are stable
  gtx0_txreset_i <= not gtx0_txplllkdet_i;

  -- Hold the RX in reset till the RX user clocks are stable
  
  gtx0_rxreset_i <= not gtx0_rxplllkdet_i;


  -------------------------- User Module Resets -----------------------------
  -- All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
  -- are held in reset till the RESETDONE goes high. 
  -- The RESETDONE is registered a couple of times on USRCLK2 and connected 
  -- to the reset of the modules
  
  process( gtx_rxusrclk2)
  begin
    if(gtx_rxusrclk2'event and gtx_rxusrclk2 = '1') then
      gtx0_rxresetdone_i_r  <= gtx0_rxresetdone_i   after DLY;
    end if; 
  end process; 

  process( gtx_rxusrclk2,gtx0_rxresetdone_i_r)
  begin
    if(gtx0_rxresetdone_i_r = '0') then
      gtx0_rxresetdone_r    <= '0'   after DLY;
      gtx0_rxresetdone_r2   <= '0'   after DLY;
    elsif(gtx_rxusrclk2'event and gtx_rxusrclk2 = '1') then
      gtx0_rxresetdone_r    <= gtx0_rxresetdone_i_r after DLY;
      gtx0_rxresetdone_r2   <= gtx0_rxresetdone_r   after DLY;
    end if;
  end process;

  process( gtx_rxusrclk2)
  begin
    if(gtx_rxusrclk2'event and gtx_rxusrclk2 = '1') then
      gtx0_rxresetdone_r3  <= gtx0_rxresetdone_r2   after DLY;
    end if; 
  end process; 

  process( gtx_txusrclk2,gtx0_txresetdone_i)
  begin
    if(gtx0_txresetdone_i = '0') then
      gtx0_txresetdone_r  <= '0'   after DLY;
      gtx0_txresetdone_r2 <= '0'   after DLY;
    elsif(gtx_txusrclk2'event and gtx_txusrclk2 = '1') then
      gtx0_txresetdone_r  <= gtx0_txresetdone_i   after DLY;
      gtx0_txresetdone_r2 <= gtx0_txresetdone_r   after DLY;
    end if;
  end process;

  -- Drive the enamcommaalign port of the mgt for alignment
  process( gtx_rxusrclk2 )
  begin
    if rising_edge(gtx_rxusrclk2) then
      if(gtx0_rx_system_reset_i = '1') then 
        gtx0_rxenmcommaalign_i   <= '0' after DLY;
        gtx0_rxenpcommaalign_i   <= '0' after DLY;
      else              
        gtx0_rxenmcommaalign_i   <= '1' after DLY;
        gtx0_rxenpcommaalign_i   <= '1' after DLY;
      end if;
    end if;    
  end process;  
  
  LINKSPEED_HANDLER_INST : entity work.linkspeed_handler
    port map (
      clk => DCLK,
      rst => '0',
      -- PCIe CMD interface
      drp_start => drp_start,
      drp_done  => drp_done,
      set_speed => set_speed,
      -- DRP INTERFACE
      addr  => gtx0_daddr_i,
      den   => gtx0_den_i,
      di    => gtx0_di_i,
      drdy  => gtx0_drdy_i,
      drpdo => gtx0_drpdo_i,
      dwe   => gtx0_dwe_i);

  -- If Chipscope is not being used, drive GTX reset signal
  -- from the top level ports
  gtx0_gtxtxreset_i                            <= gtx_rst;
  gtx0_gtxrxreset_i                            <= gtx_rst;

  -- assign resets for frame_gen modules
  gtx0_tx_system_reset_i                       <= not gtx0_txresetdone_r2;
  -- assign resets for frame_check modules
  gtx0_rx_system_reset_i                       <= not gtx0_rxresetdone_r3;

  gtx0_plltxreset_i                            <= tied_to_ground_i;
  gtx0_txdiffctrl_i                            <= "1010";
  gtx0_txpreemphasis_i                         <= tied_to_ground_vec_i(3 downto 0);
  gtx0_txpostemphasis_i                        <= tied_to_ground_vec_i(4 downto 0);
  gtx0_pllrxreset_i                            <= tied_to_ground_i;
  gtx0_rxeqmix_i                               <= tied_to_ground_vec_i(2 downto 0);

  
end rtl;

