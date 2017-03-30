//-----------------------------------------------------------------------------
// Title      : Top-level GTX wrapper for Ethernet MAC
// Project    : Virtex-6 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : v6_gtxwizard_top.v
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
//----------------------------------------------------------------------
// Description:  This is the top-level GTX wrapper. It
//               instantiates the lower-level wrappers produced by
//               the Virtex-6 FPGA GTX Wrapper Wizard.
//----------------------------------------------------------------------

`timescale 1 ps / 1 ps

module v6_gtxwizard_top (
   RESETDONE,
   ENMCOMMAALIGN,
   ENPCOMMAALIGN,
   LOOPBACK,
   POWERDOWN,
   RXUSRCLK2,
   RXRESET,
   TXCHARDISPMODE,
   TXCHARDISPVAL,
   TXCHARISK,
   TXDATA,
   TXUSRCLK2,
   TXRESET,
   RXCHARISCOMMA,
   RXCHARISK,
   RXCLKCORCNT,
   RXDATA,
   RXDISPERR,
   RXNOTINTABLE,
   RXRUNDISP,
   RXBUFERR,
   TXBUFERR,
   PLLLKDET,
   TXOUTCLK,
   RXELECIDLE,
   TXN,
   TXP,
   RXN,
   RXP,
   CLK_DS,
   PMARESET
);

   output          RESETDONE;
   input           ENMCOMMAALIGN;
   input           ENPCOMMAALIGN;
   input           LOOPBACK;
   input           POWERDOWN;
   input           RXUSRCLK2;
   input           RXRESET;
   input           TXCHARDISPMODE;
   input           TXCHARDISPVAL;
   input           TXCHARISK;
   input  [ 7:0]   TXDATA;
   input           TXUSRCLK2;
   input           TXRESET;
   output          RXCHARISCOMMA;
   output          RXCHARISK;
   output [ 2:0]   RXCLKCORCNT;
   output [ 7:0]   RXDATA;
   output          RXDISPERR;
   output          RXNOTINTABLE;
   output          RXRUNDISP;
   output          RXBUFERR;
   output          TXBUFERR;
   output          PLLLKDET;
   output          TXOUTCLK;
   output          RXELECIDLE;
   output          TXN;
   output          TXP;
   input           RXN;
   input           RXP;
   input           CLK_DS;
   input           PMARESET;

  //--------------------------------------------------------------------
  // Signal declarations
  //--------------------------------------------------------------------
   wire [ 1:0] RXBUFSTATUS_float;
   wire        TXBUFSTATUS_float;

   wire        clk_ds_i;
   wire        pma_reset_i;

   (* ASYNC_REG = "TRUE" *)
   reg  [ 3:0] reset_r;

   wire        resetdone_tx_i;
   reg         resetdone_tx_r;
   wire        resetdone_rx_i;
   reg         resetdone_rx_r;
   wire        resetdone_i;

   //--------------------------------------------------------------------
   // GTX PMA reset circuitry
   //--------------------------------------------------------------------

   // Locally buffer the output of the IBUFDS_GTXE1 for reset logic
   BUFR #(
      .BUFR_DIVIDE("1"), // "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
      .SIM_DEVICE("VIRTEX6")  // Specify target device, "VIRTEX4", "VIRTEX5", "VIRTEX6" 
	) bufr_clk_ds (
      .I   (CLK_DS),
      .O   (clk_ds_i),
      .CE  (1'b1),
      .CLR (1'b0)
   );

   always@(posedge clk_ds_i or posedge PMARESET)
      if (PMARESET == 1'b1)
         reset_r <= 4'b1111;
      else
         reset_r <= {reset_r[2:0], PMARESET};

   assign pma_reset_i = reset_r[3];

   //--------------------------------------------------------------------
   // Instantiate the Virtex-6 GTX
   //--------------------------------------------------------------------
   // Direct from the GTX Wizard output
   V6_GTXWIZARD #
   (
      .WRAPPER_SIM_GTXRESET_SPEEDUP (1)
   )
   v6_gtxwizard_inst
   (
      .GTX0_DOUBLE_RESET_CLK_IN (clk_ds_i),
      //---------------------- Loopback and Powerdown Ports ----------------------
      .GTX0_LOOPBACK_IN         ({2'b00, LOOPBACK}),
      .GTX0_RXPOWERDOWN_IN      ({POWERDOWN, POWERDOWN}),
      .GTX0_TXPOWERDOWN_IN      ({POWERDOWN, POWERDOWN}),
      //--------------------- Receive Ports - 8b10b Decoder ----------------------
      .GTX0_RXCHARISCOMMA_OUT   (RXCHARISCOMMA),
      .GTX0_RXCHARISK_OUT       (RXCHARISK),
      .GTX0_RXDISPERR_OUT       (RXDISPERR),
      .GTX0_RXNOTINTABLE_OUT    (RXNOTINTABLE),
      .GTX0_RXRUNDISP_OUT       (RXRUNDISP),
      //----------------- Receive Ports - Clock Correction Ports -----------------
      .GTX0_RXCLKCORCNT_OUT     (RXCLKCORCNT),
      //------------- Receive Ports - Comma Detection and Alignment --------------
      .GTX0_RXENMCOMMAALIGN_IN  (ENMCOMMAALIGN),
      .GTX0_RXENPCOMMAALIGN_IN  (ENPCOMMAALIGN),
      //----------------- Receive Ports - RX Data Path interface -----------------
      .GTX0_RXDATA_OUT          (RXDATA),
      .GTX0_RXRECCLK_OUT        (),
      .GTX0_RXRESET_IN          (RXRESET),
      .GTX0_RXUSRCLK2_IN        (RXUSRCLK2),
      //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
      .GTX0_RXBUFRESET_IN       (RXRESET),
      .GTX0_RXBUFSTATUS_OUT     ({RXBUFERR, RXBUFSTATUS_float}),
      //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      .GTX0_RXELECIDLE_OUT      (RXELECIDLE),
      .GTX0_RXN_IN              (RXN),
      .GTX0_RXP_IN              (RXP),
      //---------------------- Receive Ports - RX PLL Ports ----------------------
      .GTX0_GTXRXRESET_IN       (pma_reset_i),
      .GTX0_MGTREFCLKRX_IN      (CLK_DS),
      .GTX0_PLLRXRESET_IN       (pma_reset_i),
      .GTX0_RXPLLLKDET_OUT      (PLLLKDET),
      .GTX0_RXRESETDONE_OUT     (resetdone_rx_i),
      //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
      .GTX0_TXCHARDISPMODE_IN   (TXCHARDISPMODE),
      .GTX0_TXCHARDISPVAL_IN    (TXCHARDISPVAL),
      .GTX0_TXCHARISK_IN        (TXCHARISK),
      //----------------------- Transmit Ports - GTX Ports -----------------------
      .GTX0_GTXTEST_IN          (13'b1000000000000),
      //---------------- Transmit Ports - TX Data Path interface -----------------
      .GTX0_TXDATA_IN           (TXDATA),
      .GTX0_TXOUTCLK_OUT        (TXOUTCLK),
      .GTX0_TXRESET_IN          (TXRESET),
      .GTX0_TXUSRCLK2_IN        (TXUSRCLK2),
      //-------------- Transmit Ports - TX Driver and OOB signaling --------------
      .GTX0_TXN_OUT             (TXN),
      .GTX0_TXP_OUT             (TXP),
      //--------- Transmit Ports - TX Elastic Buffer and Phase Alignment ---------
      .GTX0_TXBUFSTATUS_OUT     ({TXBUFERR, TXBUFSTATUS_float}),
      //--------------------- Transmit Ports - TX PLL Ports ----------------------
      .GTX0_GTXTXRESET_IN       (pma_reset_i),
      .GTX0_TXRESETDONE_OUT     (resetdone_tx_i)
   );

   // Register the Tx and Rx resetdone signals, and AND them to provide a
   // single RESETDONE output
   always @(posedge TXUSRCLK2 or posedge TXRESET)
      if (TXRESET === 1'b1)
         resetdone_tx_r <= 1'b0;
      else
         resetdone_tx_r <= resetdone_tx_i;

   always @(posedge RXUSRCLK2 or posedge RXRESET)
      if (RXRESET === 1'b1)
         resetdone_rx_r <= 1'b0;
      else
         resetdone_rx_r <= resetdone_rx_i;

   assign resetdone_i = resetdone_tx_r && resetdone_rx_r;
   assign RESETDONE   = resetdone_i;

endmodule
