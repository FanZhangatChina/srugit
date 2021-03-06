/////////////////////////////////////////////////////////////////////////////
//
//
//
/////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /
// \   \   \/    Core:          sem
//  \   \        Module:        semv3_6_sem_example
//  /   /        Filename:      semv3_6_sem_example.v
// /___/   /\    Purpose:       System level design example.
// \   \  /  \
//  \___\/\___\
//
/////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2010 - 2013 Xilinx, Inc. All rights reserved.
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
/////////////////////////////////////////////////////////////////////////////
//
// Module Description:
//
// This module is the system level design example, the top level of what is
// intended for physical implementation.  This module is essentially an HDL
// netlist of sub-modules used to construct the solution.  The system level
// design example is customized by the Xilinx Core Generator System.
//
/////////////////////////////////////////////////////////////////////////////
//
// Port Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// clk                           input  System clock; the entire system is
//                                      synchronized to this signal, which
//                                      is distributed on a global clock
//                                      buffer and referred to as icap_clk.
//
// status_heartbeat              output Heartbeat signal for external watch
//                                      dog timer implementation; pulses
//                                      when readback runs.  Synchronous to
//                                      icap_clk.
//
// status_initialization         output Indicates initialization is taking
//                                      place.  Synchronous to icap_clk.
//
// status_observation            output Indicates observation is taking
//                                      place.  Synchronous to icap_clk.
//
// status_correction             output Indicates correction is taking
//                                      place.  Synchronous to icap_clk.
//
// status_classification         output Indicates classification is taking
//                                      place.  Synchronous to icap_clk.
//
// status_injection              output Indicates injection is taking
//                                      place.  Synchronous to icap_clk.
//
// status_essential              output Indicates essential error condition.
//                                      Qualified by de-assertion of the
//                                      status_classification signal, and
//                                      is synchronous to icap_clk.
//
// status_uncorrectable          output Indicates uncorrectable error
//                                      condition. Qualified by de-assertion
//                                      of the status_correction signal, and
//                                      is synchronous to icap_clk.
//
// monitor_tx                    output Serial status output.  Synchronous
//                                      to icap_clk, but received externally
//                                      by another device as an asynchronous
//                                      signal, perceived as lower bitrate.
//                                      Uses 8N1 protocol.
//
// monitor_rx                    input  Serial command input.  Asynchronous
//                                      signal provided by another device at
//                                      a lower bitrate, synchronized to the
//                                      icap_clk and oversampled.  Uses 8N1
//                                      protocol.
//
/////////////////////////////////////////////////////////////////////////////
//
// Parameter and Localparam Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// TCQ                           int    Sets the clock-to-out for behavioral
//                                      descriptions of sequential logic.
//
/////////////////////////////////////////////////////////////////////////////
//
// Module Dependencies:
//
// semv3_6_sem_example
// |
// +- semv3_6 (sem_controller)
// |
// +- semv3_6_sem_cfg
// |
// +- semv3_6_sem_mon
// |
// +- IBUF (unisim)
// |
// \- BUFG (unisim)
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

/////////////////////////////////////////////////////////////////////////////
// Module
/////////////////////////////////////////////////////////////////////////////

module semv3_6_sem_example (
//  input  wire        clk
//		input 					brdclk_p, //100 MHz differential clock
//		input 					brdclk_n
input 			icap_clk,
output [31:0] 	sem_status
  
//  output wire        status_heartbeat,
//  output wire        status_initialization,
//  output wire        status_observation,
//  output wire        status_correction,
//  output wire        status_classification,
//  output wire        status_injection,
//  output wire        status_essential,
//  output wire        status_uncorrectable,
//  output wire        monitor_tx,
//  input  wire        monitor_rx
  );

  ///////////////////////////////////////////////////////////////////////////
  // Define local constants.
  ///////////////////////////////////////////////////////////////////////////

  localparam TCQ = 1;

  ///////////////////////////////////////////////////////////////////////////
  // Declare signals.
  ///////////////////////////////////////////////////////////////////////////

//  wire        clk_ibufg;

  wire        status_heartbeat_internal;
  wire        status_initialization_internal;
  wire        status_observation_internal;
  wire        status_correction_internal;
  wire        status_classification_internal;
  wire        status_injection_internal;
  wire        status_essential_internal;
  wire        status_uncorrectable_internal;
  wire  [7:0] monitor_txdata;
  wire        monitor_txwrite;
  wire        monitor_txfull;
  wire  [7:0] monitor_rxdata;
  wire        monitor_rxread;
  wire        monitor_rxempty;
  wire        fecc_crcerr;
  wire        fecc_eccerr;
  wire        fecc_eccerrsingle;
  wire        fecc_syndromevalid;
  wire [12:0] fecc_syndrome;
  wire [23:0] fecc_far;
  wire  [4:0] fecc_synbit;
  wire  [6:0] fecc_synword;
  wire [31:0] icap_o;
  wire [31:0] icap_i;
  wire        icap_busy;
  wire        icap_csb;
  wire        icap_rdwrb;
  wire        icap_unused;
  wire        icap_grant;
  wire        icap_clk;

  ///////////////////////////////////////////////////////////////////////////
  // This design (the example, including the controller itself) is fully
  // synchronous; the global clock buffer is instantiated here to drive
  // the icap_clk signal.
  ///////////////////////////////////////////////////////////////////////////

//  IBUF example_ibuf (
//    .I(clk),
//    .O(clk_ibufg)
//    );
//
//  BUFG example_bufg (
//    .I(clk_ibufg),
//    .O(icap_clk)
//    );
//  brdclk instance_name
//   (// Clock in ports
//    .CLK_IN1_P(brdclk_p),    // IN
//    .CLK_IN1_N(brdclk_n),    // IN
//    // Clock out ports
//    .CLK_OUT1(icap_clk)     // OUT
//    // Status and control signals
//    //.RESET(),// IN
//    //.LOCKED()
//	 );      // OUT
// INST_TAG_END ------ End INSTANTIATION Template ---------

  ///////////////////////////////////////////////////////////////////////////
  // The controller sub-module is the kernel of the soft error mitigation
  // solution.  The port list is dynamic based on the IP core options.
  ///////////////////////////////////////////////////////////////////////////

  semv3_6 example_controller (
    .status_heartbeat(status_heartbeat_internal),
    .status_initialization(status_initialization_internal),
    .status_observation(status_observation_internal),
    .status_correction(status_correction_internal),
    .status_classification(status_classification_internal),
    .status_injection(status_injection_internal),
    .status_essential(status_essential_internal),
    .status_uncorrectable(status_uncorrectable_internal),
    .monitor_txdata(monitor_txdata),
    .monitor_txwrite(monitor_txwrite),
    .monitor_txfull(monitor_txfull),
    .monitor_rxdata(monitor_rxdata),
    .monitor_rxread(monitor_rxread),
    .monitor_rxempty(monitor_rxempty),
//	 
//	    .monitor_txdata(),
//    .monitor_txwrite(),
//    .monitor_txfull(1'b0),
//    .monitor_rxdata(8'h0),
//    .monitor_rxread(),
//    .monitor_rxempty(1'b0),
//    //.inject_strobe(1'b0),
//    //.inject_address(36'h0),
 
    .fecc_crcerr(fecc_crcerr),
    .fecc_eccerr(fecc_eccerr),
    .fecc_eccerrsingle(fecc_eccerrsingle),
    .fecc_syndromevalid(fecc_syndromevalid),
    .fecc_syndrome(fecc_syndrome),
    .fecc_far(fecc_far),
    .fecc_synbit(fecc_synbit),
    .fecc_synword(fecc_synword),
    .icap_o(icap_o),
    .icap_i(icap_i),
    .icap_busy(icap_busy),
    .icap_csb(icap_csb),
    .icap_rdwrb(icap_rdwrb),
    .icap_clk(icap_clk),
    .icap_request(icap_unused),
    .icap_grant(icap_grant)
    );

  assign icap_grant = 1'b1;
  assign status_heartbeat = status_heartbeat_internal;
  assign status_initialization = status_initialization_internal;
  assign status_observation = status_observation_internal;
  assign status_correction = status_correction_internal;
  assign status_classification = status_classification_internal;
  assign status_injection = status_injection_internal;
  assign status_essential = status_essential_internal;
  assign status_uncorrectable = status_uncorrectable_internal;

  ///////////////////////////////////////////////////////////////////////////
  // The cfg sub-module contains the device specific primitives to access
  // the internal configuration port and the frame crc/ecc status signals.
  ///////////////////////////////////////////////////////////////////////////

  semv3_6_sem_cfg example_cfg (
    .fecc_crcerr(fecc_crcerr),
    .fecc_eccerr(fecc_eccerr),
    .fecc_eccerrsingle(fecc_eccerrsingle),
    .fecc_syndromevalid(fecc_syndromevalid),
    .fecc_syndrome(fecc_syndrome),
    .fecc_far(fecc_far),
    .fecc_synbit(fecc_synbit),
    .fecc_synword(fecc_synword),
    .icap_o(icap_o),
    .icap_i(icap_i),
    .icap_busy(icap_busy),
    .icap_csb(icap_csb),
    .icap_rdwrb(icap_rdwrb),
    .icap_clk(icap_clk)
    );

  ///////////////////////////////////////////////////////////////////////////
  // The mon sub-module contains a UART for communication purposes.
  ///////////////////////////////////////////////////////////////////////////

  semv3_6_sem_mon example_mon (
    .icap_clk(icap_clk),
    .monitor_tx(monitor_tx),
    .monitor_rx(monitor_rx),
    .monitor_txdata(monitor_txdata),
    .monitor_txwrite(monitor_txwrite),
    .monitor_txfull(monitor_txfull),
    .monitor_rxdata(monitor_rxdata),
    .monitor_rxread(monitor_rxread),
    .monitor_rxempty(monitor_rxempty)
    );

  ///////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////////
  
  assign status_heartbeat = status_heartbeat_internal;
  assign status_initialization = status_initialization_internal;
  assign status_observation = status_observation_internal;
  assign status_correction = status_correction_internal;
  assign status_classification = status_classification_internal;
  assign status_injection = status_injection_internal;
  assign status_essential = status_essential_internal;
  assign status_uncorrectable = status_uncorrectable_internal;
  
  wire [7:0] status_flag_ii;
  reg [7:0] status_flag_i = 8'h0;
  
  assign status_flag_ii = {
									status_heartbeat,
									status_initialization,
									status_observation,
									status_correction,
									status_classification,
									status_injection,
									status_essential,
									status_uncorrectable
									};
  
  always @(posedge icap_clk)
  status_flag_i <= status_flag_ii;
  
  
  
  reg status_heartbeat_i = 1'b0;
  reg status_heartbeat_ii = 1'b0;
  reg status_correction_i = 1'b0;
  reg status_uncorrectable_i = 1'b0;
  reg seu_uncorrected_i = 1'b0;
  wire sem_alive;
  
	always @(posedge icap_clk)
	begin
	status_correction_i <= status_correction;
	status_uncorrectable_i <= status_uncorrectable;
	status_heartbeat_i <= status_heartbeat;
	status_heartbeat_ii <= status_heartbeat_i;
	end

	FreqTest u_HeartbeatFreqTest (
    .iCLK(icap_clk), 
    .ClkTest(status_heartbeat_ii), 
    .SigAlive(sem_alive)
    );	 
//
	reg [15:0] seu_cnt_i = 16'h0;
	always @(posedge status_correction_i)
	seu_cnt_i <= seu_cnt_i + 1'b1;
	
	always @(posedge status_uncorrectable_i)
	seu_uncorrected_i <= seu_uncorrected_i + 1'b1;
	
	assign sem_status = {sem_alive, seu_uncorrected_i, 6'h0, status_flag_i, seu_cnt_i};

//wire [35:0] CONTROL0;
//wire [7:0] ASYNC_IN;
//assign ASYNC_IN = status_flag_i;
//
//chipscope_vio u_vio (
//    .CONTROL(CONTROL0), // INOUT BUS [35:0]
//    .ASYNC_IN(ASYNC_IN) // IN BUS [7:0]
//);
//
//chipscope_icon u_icon (
//    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
//);

endmodule

/////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////
