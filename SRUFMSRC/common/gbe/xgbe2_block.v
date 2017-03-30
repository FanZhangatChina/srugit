//-----------------------------------------------------------------------------
// Title      : Block-level Virtex-6 Embedded Tri-Mode Ethernet MAC Wrapper
// Project    : Virtex-6 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : xgbe2_block.v
// Version    : 1.5
//-----------------------------------------------------------------------------
//
// (c) Copyright 2009-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Description:  This is the block-level wrapper for the Virtex-6 Embedded
//               Tri-Mode Ethernet MAC. It is intended that this example design
//               can be quickly adapted and downloaded onto an FPGA to provide
//               a hardware test environment.
//
//               The block-level wrapper:
//
//               * instantiates appropriate PHY interface modules (GMII, MII,
//                 RGMII, SGMII or 1000BASE-X) as required per the user
//                 configuration;
//
//               * instantiates some clocking and reset resources to operate
//                 the EMAC and its example design.
//
//               Please refer to the Datasheet, Getting Started Guide, and
//               the Virtex-6 Embedded Tri-Mode Ethernet MAC User Gude for
//               further information.
//-----------------------------------------------------------------------------

`timescale 1 ps / 1 ps


//-----------------------------------------------------------------------------
// Module declaration for the block-level wrapper
//-----------------------------------------------------------------------------

module xgbe2_block
#(parameter EMAC_PHYINITAUTONEG_ENABLE = "TRUE")
(

    // 125MHz clock output from transceiver
    CLK125_OUT,
    // 125MHz clock input from BUFG
    CLK125,

    // Client receiver interface
    EMACCLIENTRXD,
    EMACCLIENTRXDVLD,
    EMACCLIENTRXGOODFRAME,
    EMACCLIENTRXBADFRAME,
    EMACCLIENTRXFRAMEDROP,
    EMACCLIENTRXSTATS,
    EMACCLIENTRXSTATSVLD,
    EMACCLIENTRXSTATSBYTEVLD,

    // Client transmitter interface
    CLIENTEMACTXD,
    CLIENTEMACTXDVLD,
    EMACCLIENTTXACK,
    CLIENTEMACTXFIRSTBYTE,
    CLIENTEMACTXUNDERRUN,
    EMACCLIENTTXCOLLISION,
    EMACCLIENTTXRETRANSMIT,
    CLIENTEMACTXIFGDELAY,
    EMACCLIENTTXSTATS,
    EMACCLIENTTXSTATSVLD,
    EMACCLIENTTXSTATSBYTEVLD,

    // MAC control interface
    CLIENTEMACPAUSEREQ,
    CLIENTEMACPAUSEVAL,

    // EMAC-transceiver link status
    EMACCLIENTSYNCACQSTATUS,
    // Auto-Negotiation interrupt
    EMACANINTERRUPT,

    // 1000BASE-X PCS/PMA interface
    TXP,
    TXN,
    RXP,
    RXN,
    PHYAD,
    RESETDONE,

    // 1000BASE-X PCS/PMA clock buffer input
    CLK_DS,

    // Asynchronous reset
    RESET
);

//	 parameter Simulation = 1'b0;
//-----------------------------------------------------------------------------
// Port declarations
//-----------------------------------------------------------------------------

    // 125MHz clock output from transceiver
    output          CLK125_OUT;
    // 125MHz clock input from BUFG
    input           CLK125;

    // Client receiver interface
    output   [7:0]  EMACCLIENTRXD;
    output          EMACCLIENTRXDVLD;
    output          EMACCLIENTRXGOODFRAME;
    output          EMACCLIENTRXBADFRAME;
    output          EMACCLIENTRXFRAMEDROP;
    output   [6:0]  EMACCLIENTRXSTATS;
    output          EMACCLIENTRXSTATSVLD;
    output          EMACCLIENTRXSTATSBYTEVLD;

    // Client transmitter interface
    input    [7:0]  CLIENTEMACTXD;
    input           CLIENTEMACTXDVLD;
    output          EMACCLIENTTXACK;
    input           CLIENTEMACTXFIRSTBYTE;
    input           CLIENTEMACTXUNDERRUN;
    output          EMACCLIENTTXCOLLISION;
    output          EMACCLIENTTXRETRANSMIT;
    input    [7:0]  CLIENTEMACTXIFGDELAY;
    output          EMACCLIENTTXSTATS;
    output          EMACCLIENTTXSTATSVLD;
    output          EMACCLIENTTXSTATSBYTEVLD;

    // MAC control interface
    input           CLIENTEMACPAUSEREQ;
    input   [15:0]  CLIENTEMACPAUSEVAL;

    // EMAC-transceiver link status
    output          EMACCLIENTSYNCACQSTATUS;
    // Auto-Negotiation interrupt
    output          EMACANINTERRUPT;

    // 1000BASE-X PCS/PMA interface
    output          TXP;
    output          TXN;
    input           RXP;
    input           RXN;
    input           [4:0] PHYAD;
    output          RESETDONE;

    // 1000BASE-X PCS/PMA clock buffer inputs
    input           CLK_DS;

    // Asynchronous reset
    input           RESET;


//-----------------------------------------------------------------------------
// Wire and register declarations
//-----------------------------------------------------------------------------

    // Asynchronous reset signals
    wire            reset_ibuf_i;
    wire            reset_i;
    // ASYNC_REG attribute added to simulate actual behavior under
    // asynchronous operating conditions.
    (* ASYNC_REG = "TRUE" *)
    reg      [3:0]  reset_r;

    // Client clocking signals
    wire            rx_client_clk_out_i;
    wire            rx_client_clk_in_i;
    wire            tx_client_clk_out_i;
    wire            tx_client_clk_in_i;

    // Physical interface signals
    wire            emac_locked_i;
    wire     [7:0]  mgt_rx_data_i;
    wire     [7:0]  mgt_tx_data_i;
    wire            signal_detect_i;
    wire            rxelecidle_i;
    wire            resetdone_i;
    wire            encommaalign_i;
    wire            loopback_i;
    wire            mgt_rx_reset_i;
    wire            mgt_tx_reset_i;
    wire            powerdown_i;
    wire     [2:0]  rxclkcorcnt_i;
    wire            rxchariscomma_i;
    wire            rxcharisk_i;
    wire            rxdisperr_i;
    wire            rxnotintable_i;
    wire            rxrundisp_i;
    wire            txbuferr_i;
    wire            txchardispmode_i;
    wire            txchardispval_i;
    wire            txcharisk_i;
    wire            rxbufstatus_i;
    //reg      [3:0]  tx_reset_sm_r;
    reg             tx_pcs_reset_r;
    reg      [3:0]  rx_reset_sm_r;
    reg             rx_pcs_reset_r;
    reg             rxchariscomma_r;
    reg             rxcharisk_r;
    reg      [2:0]  rxclkcorcnt_r;
    reg      [7:0]  mgt_rx_data_r;
    reg             rxdisperr_r;
    reg             rxnotintable_r;
    reg             rxrundisp_r;
    reg             txchardispmode_r;
    reg             txchardispval_r;
    reg             txcharisk_r;
    reg      [7:0]  mgt_tx_data_r;

    // Transceiver clocking signals
    wire            usrclk2;
    wire            txoutclk;
    wire            plllock_i;

//-----------------------------------------------------------------------------
// Main body of code
//-----------------------------------------------------------------------------

    //-------------------------------------------------------------------------
    // Main reset circuitry
    //-------------------------------------------------------------------------

    assign reset_ibuf_i = RESET;

    // Synchronize and extend the external reset signal
    always @(posedge usrclk2 or posedge reset_ibuf_i)
    begin
        if (reset_ibuf_i == 1)
            reset_r <= 4'b1111;
        else
        begin
            if (plllock_i == 1)
                reset_r <= {reset_r[2:0], reset_ibuf_i};
        end
    end

    // Apply the extended reset pulse to the EMAC
    assign reset_i = reset_r[3];

    //-------------------------------------------------------------------------
    // Instantiate GTX for SGMII or 1000BASE-X PCS/PMA physical interface
    //-------------------------------------------------------------------------

    v6_gtxwizard_top v6_gtxwizard_top_inst (
        .RESETDONE      (resetdone_i),
        .ENMCOMMAALIGN  (encommaalign_i),
        .ENPCOMMAALIGN  (encommaalign_i),
        .LOOPBACK       (loopback_i),
        .POWERDOWN      (powerdown_i),
        .RXUSRCLK2      (usrclk2),
        .RXRESET        (mgt_rx_reset_i),
        .TXCHARDISPMODE (txchardispmode_r),
        .TXCHARDISPVAL  (txchardispval_r),
        .TXCHARISK      (txcharisk_r),
        .TXDATA         (mgt_tx_data_r),
        .TXUSRCLK2      (usrclk2),
        .TXRESET        (mgt_tx_reset_i),
        .RXCHARISCOMMA  (rxchariscomma_i),
        .RXCHARISK      (rxcharisk_i),
        .RXCLKCORCNT    (rxclkcorcnt_i),
        .RXDATA         (mgt_rx_data_i),
        .RXDISPERR      (rxdisperr_i),
        .RXNOTINTABLE   (rxnotintable_i),
        .RXRUNDISP      (rxrundisp_i),
        .RXBUFERR       (rxbufstatus_i),
        .TXBUFERR       (txbuferr_i),
        .PLLLKDET       (plllock_i),
        .TXOUTCLK       (txoutclk),
        .RXELECIDLE     (rxelecidle_i),
        .TXN            (TXN),
        .TXP            (TXP),
        .RXN            (RXN),
        .RXP            (RXP),
        .CLK_DS         (CLK_DS),
        .PMARESET       (reset_ibuf_i)
    );

    assign RESETDONE = resetdone_i;

    //-------------------------------------------------------------------------
    // Register the signals between the TEMAC and the GT for timing
    // purposes.
    //-------------------------------------------------------------------------

    always @(posedge usrclk2, posedge reset_i)
    begin
      if (reset_i == 1'b1)
      begin
          rxchariscomma_r  <= 1'b0;
          rxcharisk_r      <= 1'b0;
          rxclkcorcnt_r    <= 3'b000;
          mgt_rx_data_r    <= 8'h00;
          rxdisperr_r      <= 1'b0;
          rxnotintable_r   <= 1'b0;
          rxrundisp_r      <= 1'b0;
          txchardispmode_r <= 1'b0;
          txchardispval_r  <= 1'b0;
          txcharisk_r      <= 1'b0;
          mgt_tx_data_r    <= 8'h00;
      end
      else
      begin
          rxchariscomma_r  <= rxchariscomma_i;
          rxcharisk_r      <= rxcharisk_i;
          rxclkcorcnt_r    <= rxclkcorcnt_i;
          mgt_rx_data_r    <= mgt_rx_data_i;
          rxdisperr_r      <= rxdisperr_i;
          rxnotintable_r   <= rxnotintable_i;
          rxrundisp_r      <= rxrundisp_i;
          txchardispmode_r <= txchardispmode_i;
          txchardispval_r  <= txchardispval_i;
          txcharisk_r      <= txcharisk_i;
          mgt_tx_data_r    <= mgt_tx_data_i;
      end
    end

    // Detect when there has been a disconnect
    assign signal_detect_i = ~(rxelecidle_i);

    //--------------------------------------------------------------------
    // GTX clock management
    //--------------------------------------------------------------------

    // 125MHz clock is used for GT user clocks and used
    // to clock all Ethernet core logic
    assign usrclk2 = CLK125;

    // PLL lock
    assign emac_locked_i = plllock_i;

    // GTX reference clock
    assign gtx_clk_ibufg_i = usrclk2;

    // PCS/PMA client-side receive clock
    assign rx_client_clk_in_i = usrclk2;

    // PCS/PMA client-side transmit clock
    assign tx_client_clk_in_i = usrclk2;

    // 125MHz clock output from transceiver
    assign CLK125_OUT = txoutclk;

    //------------------------------------------------------------------------
    // Instantiate the primitive-level EMAC wrapper (xgbe2.v)
    //------------------------------------------------------------------------

    xgbe2 #(.EMAC_PHYINITAUTONEG_ENABLE(EMAC_PHYINITAUTONEG_ENABLE)) 
	 xgbe2_inst
    (
        // Client receiver interface
        .EMACCLIENTRXCLIENTCLKOUT    (rx_client_clk_out_i),
        .CLIENTEMACRXCLIENTCLKIN     (rx_client_clk_in_i),
        .EMACCLIENTRXD               (EMACCLIENTRXD),
        .EMACCLIENTRXDVLD            (EMACCLIENTRXDVLD),
        .EMACCLIENTRXDVLDMSW         (),
        .EMACCLIENTRXGOODFRAME       (EMACCLIENTRXGOODFRAME),
        .EMACCLIENTRXBADFRAME        (EMACCLIENTRXBADFRAME),
        .EMACCLIENTRXFRAMEDROP       (EMACCLIENTRXFRAMEDROP),
        .EMACCLIENTRXSTATS           (EMACCLIENTRXSTATS),
        .EMACCLIENTRXSTATSVLD        (EMACCLIENTRXSTATSVLD),
        .EMACCLIENTRXSTATSBYTEVLD    (EMACCLIENTRXSTATSBYTEVLD),

        // Client transmitter interface
        .EMACCLIENTTXCLIENTCLKOUT    (tx_client_clk_out_i),
        .CLIENTEMACTXCLIENTCLKIN     (tx_client_clk_in_i),
        .CLIENTEMACTXD               (CLIENTEMACTXD),
        .CLIENTEMACTXDVLD            (CLIENTEMACTXDVLD),
        .CLIENTEMACTXDVLDMSW         (1'b0),
        .EMACCLIENTTXACK             (EMACCLIENTTXACK),
        .CLIENTEMACTXFIRSTBYTE       (CLIENTEMACTXFIRSTBYTE),
        .CLIENTEMACTXUNDERRUN        (CLIENTEMACTXUNDERRUN),
        .EMACCLIENTTXCOLLISION       (EMACCLIENTTXCOLLISION),
        .EMACCLIENTTXRETRANSMIT      (EMACCLIENTTXRETRANSMIT),
        .CLIENTEMACTXIFGDELAY        (CLIENTEMACTXIFGDELAY),
        .EMACCLIENTTXSTATS           (EMACCLIENTTXSTATS),
        .EMACCLIENTTXSTATSVLD        (EMACCLIENTTXSTATSVLD),
        .EMACCLIENTTXSTATSBYTEVLD    (EMACCLIENTTXSTATSBYTEVLD),

        // MAC control interface
        .CLIENTEMACPAUSEREQ          (CLIENTEMACPAUSEREQ),
        .CLIENTEMACPAUSEVAL          (CLIENTEMACPAUSEVAL),

        // Clock signals
        .GTX_CLK                     (usrclk2),
        .EMACPHYTXGMIIMIICLKOUT      (),
        .PHYEMACTXGMIIMIICLKIN       (1'b0),

        // 1000BASE-X PCS/PMA interface
        .RXDATA                      (mgt_rx_data_r),
        .TXDATA                      (mgt_tx_data_i),
        .MMCM_LOCKED                 (emac_locked_i),
        .AN_INTERRUPT                (EMACANINTERRUPT),
        .SIGNAL_DETECT               (signal_detect_i),
        .PHYAD                       (PHYAD),
        .ENCOMMAALIGN                (encommaalign_i),
        .LOOPBACKMSB                 (loopback_i),
        .MGTRXRESET                  (mgt_rx_reset_i),
        .MGTTXRESET                  (mgt_tx_reset_i),
        .POWERDOWN                   (powerdown_i),
        .SYNCACQSTATUS               (EMACCLIENTSYNCACQSTATUS),
        .RXCLKCORCNT                 (rxclkcorcnt_r),
        .RXBUFSTATUS                 (rxbufstatus_i),
        .RXCHARISCOMMA               (rxchariscomma_r),
        .RXCHARISK                   (rxcharisk_r),
        .RXDISPERR                   (rxdisperr_r),
        .RXNOTINTABLE                (rxnotintable_r),
        .RXREALIGN                   (1'b0),
        .RXRUNDISP                   (rxrundisp_r),
        .TXBUFERR                    (txbuferr_i),
        .TXCHARDISPMODE              (txchardispmode_i),
        .TXCHARDISPVAL               (txchardispval_i),
        .TXCHARISK                   (txcharisk_i),

        // Asynchronous reset
        .RESET                       (reset_i)
    );


endmodule
