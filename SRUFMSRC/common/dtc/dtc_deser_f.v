// file: dtc_deser_v2.v
// (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
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
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//----------------------------------------------------------------------------

`timescale 1ps/1ps

(* CORE_GENERATION_INFO = "dtc_deser_f,selectio_wiz_v3_3,{component_name=dtc_deser_f,bus_dir=INPUTS,bus_sig_type=DIFF,bus_io_std=LVDS_25,use_serialization=true,use_phase_detector=false,serialization_factor=8,enable_bitslip=false,enable_train=false,system_data_width=2,bus_in_delay=NONE,bus_out_delay=NONE,clk_sig_type=DIFF,clk_io_std=LVCMOS18,clk_buf=BUFIO2,active_edge=RISING,clk_delay=NONE,v6_bus_in_delay=NONE,v6_bus_out_delay=NONE,v6_clk_buf=MMCM,v6_active_edge=DDR,v6_ddr_alignment=SAME_EDGE_PIPELINED,v6_oddr_alignment=SAME_EDGE,ddr_alignment=C0,v6_interface_type=NETWORKING,interface_type=NETWORKING,v6_bus_in_tap=0,v6_bus_out_tap=0,v6_clk_io_std=LVDS_25,v6_clk_sig_type=DIFF}" *)

module dtc_deser_f
   // width of the data for the system
 #(parameter sys_w = 2,
   // width of the data for the device
   parameter dev_w = 16)
 (
  // From the system into the device
  input  [sys_w-1:0] DATA_IN_FROM_PINS_P,
  input  [sys_w-1:0] DATA_IN_FROM_PINS_N,
  output [dev_w-1:0] DATA_IN_TO_DEVICE,
  input              BITSLIP,       // Bitslip module is enabled in NETWORKING mode
                                    // User should tie it to '0' if not needed
  input              CLK_IN,        // Fast clock input from PLL/MMCM
  input              CLK_DIV_IN,    // Slow clock input from PLL/MMCM
  input              CLK_RESET,
  input              IO_RESET);
  localparam         num_serial_bits = dev_w/sys_w;
  // Signal declarations
  ////------------------------------
  wire               clock_enable = 1'b1;
  // After the buffer
  wire   [sys_w-1:0] data_in_from_pins_int;
  // Between the delay and serdes
  wire [sys_w-1:0]  data_in_from_pins_delay;
  // Array to use intermediately from the serdes to the internal
  //  devices. bus "0" is the leftmost bus
  wire [sys_w-1:0]  iserdes_q[0:9];   // fills in starting with 0
  // Create the clock logic

  // We have multiple bits- step over every bit, instantiating the required elements
  genvar pin_count;
  genvar slice_count;
  generate for (pin_count = 0; pin_count < sys_w; pin_count = pin_count + 1) begin: pins
    // Instantiate the buffers
    ////------------------------------
    // Instantiate a buffer for every bit of the data bus
    IBUFDS
      #(.DIFF_TERM  ("FALSE"),             // Differential termination
        .IOSTANDARD ("LVDS_25"))
     ibufds_inst
       (.I          (DATA_IN_FROM_PINS_P  [pin_count]),
        .IB         (DATA_IN_FROM_PINS_N  [pin_count]),
        .O          (data_in_from_pins_int[pin_count]));

    // Pass through the delay
    ////-------------------------------
   assign data_in_from_pins_delay[pin_count] = data_in_from_pins_int[pin_count];
 
     // Instantiate the serdes primitive
     ////------------------------------

     // local wire only for use in this generate loop
     wire cascade_shift;
     wire [sys_w-1:0] icascade1;
     wire [sys_w-1:0] icascade2;
     wire clk_in_int_inv;

     assign clk_in_int_inv = ~ CLK_IN;

     // declare the iserdes
     ISERDESE1
       # (
         .DATA_RATE         ("DDR"),
         .DATA_WIDTH        (8),
         .INTERFACE_TYPE    ("NETWORKING"), 
         .DYN_CLKDIV_INV_EN ("FALSE"),
         .DYN_CLK_INV_EN    ("FALSE"),
         .NUM_CE            (2),
 
         .OFB_USED          ("FALSE"),
         .IOBDELAY          ("NONE"),                               // Use input at D to output the data on Q
         .SERDES_MODE       ("MASTER"))
       iserdese1_master (
         .Q1                (iserdes_q[0][pin_count]),
         .Q2                (iserdes_q[1][pin_count]),
         .Q3                (iserdes_q[2][pin_count]),
         .Q4                (iserdes_q[3][pin_count]),
         .Q5                (iserdes_q[4][pin_count]),
         .Q6                (iserdes_q[5][pin_count]),
         .SHIFTOUT1         (icascade1[pin_count]),                 // Cascade connections to Slave ISERDES
         .SHIFTOUT2         (icascade2[pin_count]),                 // Cascade connections to Slave ISERDES
         .BITSLIP           (BITSLIP),                             // 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
                                                                   // The amount of bitslip is fixed by the DATA_WIDTH selection.
         .CE1               (clock_enable),                        // 1-bit Clock enable input
         .CE2               (clock_enable),                        // 1-bit Clock enable input
         .CLK               (CLK_IN),                              // Fast clock driven by MMCM
         .CLKB              (clk_in_int_inv),                      // Locally inverted fast 
         .CLKDIV            (CLK_DIV_IN),                          // Slow clock from MMCM
         .D                 (data_in_from_pins_delay[pin_count]),  // 1-bit Input signal from IOB 
         .DDLY              (1'b0),                                // 1-bit Input from Input Delay component 
         .RST               (IO_RESET),                            // 1-bit Asynchronous reset only.
         .SHIFTIN1          (1'b0),
         .SHIFTIN2          (1'b0),
    // unused connections
         .DYNCLKDIVSEL      (1'b0),
         .DYNCLKSEL         (1'b0),
         .OFB               (1'b0),
         .OCLK              (1'b0),
         .O                 ());                                   // unregistered output of ISERDESE1

     ISERDESE1
       # (
         .DATA_RATE         ("DDR"),
         .DATA_WIDTH        (8),
         .INTERFACE_TYPE    ("NETWORKING"),
         .DYN_CLKDIV_INV_EN ("FALSE"),
         .DYN_CLK_INV_EN    ("FALSE"),
         .NUM_CE            (2),
 
         .OFB_USED          ("FALSE"),
         .IOBDELAY          ("NONE"),               // Use input at D to output the data on Q
         .SERDES_MODE       ("SLAVE"))
       iserdese1_slave (
         .Q1                (),
         .Q2                (),
         .Q3                (iserdes_q[6][pin_count]),
         .Q4                (iserdes_q[7][pin_count]),
         .Q5                (iserdes_q[8][pin_count]),
         .Q6                (iserdes_q[9][pin_count]),
         .SHIFTOUT1         (),
         .SHIFTOUT2         (),
         .SHIFTIN1          (icascade1[pin_count]),  // Cascade connection with Master ISERDES
         .SHIFTIN2          (icascade2[pin_count]),  // Cascade connection with Master ISERDES
         .BITSLIP           (BITSLIP),               // 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
                                                     // The amount of bitslip is fixed by the DATA_WIDTH selection .
         .CE1               (clock_enable),          // 1-bit Clock enable input
         .CE2               (clock_enable),          // 1-bit Clock enable input 
         .CLK               (CLK_IN),                // Fast clock driven by MMCM
         .CLKB              (clk_in_int_inv),        // Locally inverted fast clock
         .CLKDIV            (CLK_DIV_IN),            // Slow clock driven by MMCM
         .D                 (1'b0),                  // Slave ISERDES. No need to connect D, DDLY
         .DDLY              (1'b0),
         .RST               (IO_RESET),              // 1-bit Asynchronous reset only.
   // unused connections
         .DYNCLKDIVSEL      (1'b0),
         .DYNCLKSEL         (1'b0),
         .OFB               (1'b0),
         .OCLK              (1'b0),
         .O                 ());                     // unregistered output of ISERDESE1
     // Concatenate the serdes outputs together. Keep the timesliced
     //   bits together, and placing the earliest bits on the right
     //   ie, if data comes in 0, 1, 2, 3, 4, 5, 6, 7, ...
     //       the output will be 3210, 7654, ...
     ////---------------------------------------------------------
     for (slice_count = 0; slice_count < num_serial_bits; slice_count = slice_count + 1) begin: in_slices
        // This places the first data in time on the right
        assign DATA_IN_TO_DEVICE[slice_count*sys_w+:sys_w] =
          iserdes_q[num_serial_bits-slice_count-1];
        // To place the first data in time on the left, use the
        //   following code, instead
        // assign DATA_IN_TO_DEVICE[slice_count*sys_w+:sys_w] =
        //   iserdes_q[slice_count];
     end
  end
  endgenerate

endmodule
