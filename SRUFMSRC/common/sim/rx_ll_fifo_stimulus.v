//----------------------------------------------------------------------
// Title      : Serial Testbench
// Project    : Virtex-6 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : phy_tb.v
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
// Description: This testbench will exercise the PHY ports of the EMAC
//              to demonstrate the functionality.
//----------------------------------------------------------------------
//
// This testbench performs the following operations on the EMAC
// and its design example:
//
//  - Four frames are pushed into the receiver from the PHY
//    interface (Gigabit Trasnceiver):
//    The first is of minimum length (Length/Type = Length = 46 bytes).
//    The second frame sets Length/Type to Type = 0x8000.
//    The third frame has an ctrl inserted.
//    The fourth frame only sends 4 bytes of data: the remainder of the
//    data field is padded up to the minimum frame length i.e. 46 bytes.
//
//  - These frames are then parsed from the MAC into the MAC's design
//    example.  The design example provides a MAC client loopback
//    function so that frames which are received without ctrl will be
//    looped back to the MAC transmitter and transmitted back to the
//    testbench.  The testbench verifies that this data matches that
//    previously injected into the receiver.

`timescale 1ps / 1ps


// This module abstracts the frame data for simpler manipulation
module frame_typ_c;

   // data field
   reg [7:0]  data  [0:97];
   reg 		  valid  [0:97];
   reg [2:0]  ctrl [0:97];

`define frame_typ_c [8*98+3*98+98+1:1]

   reg `frame_typ_c bits;

   function `frame_typ_c tobits;
      input dummy;
      begin
   bits = {data[ 0],  data[ 1],  data[ 2],  data[ 3],  data[ 4],
          data[ 5],  data[ 6],  data[ 7],  data[ 8],  data[ 9],
          data[10],  data[11],  data[12],  data[13],  data[14],
          data[15],  data[16],  data[17],  data[18],  data[19],
          data[20],  data[21],  data[22],  data[23],  data[24],
          data[25],  data[26],  data[27],  data[28],  data[29],
          data[30],  data[31],  data[32],  data[33],  data[34],
          data[35],  data[36],  data[37],  data[38],  data[39],
          data[40],  data[41],  data[42],  data[43],  data[44],
          data[45],  data[46],  data[47],  data[48],  data[49],
          data[50],  data[51],  data[52],  data[53],  data[54],
          data[55],  data[56],  data[57],  data[58],  data[59],
          data[60],  data[61],  data[62],  data[63],  data[64],
          data[65],  data[66],  data[67],  data[68],  data[69],
          data[70],  data[71],  data[72],  data[73],  data[74],
          data[75],  data[76],  data[77],  data[78],  data[79],
          data[80],  data[81],  data[82],  data[83],  data[84],
          data[85],  data[86],  data[87],	 data[88],  data[89],
          data[90],  data[91],  data[92],  data[93],  data[94],
          data[95],  data[96],  data[97],			 

          valid[ 0], valid[ 1], valid[ 2], valid[ 3], valid[ 4],
          valid[ 5], valid[ 6], valid[ 7], valid[ 8], valid[ 9],
          valid[10], valid[11], valid[12], valid[13], valid[14],
          valid[15], valid[16], valid[17], valid[18], valid[19],
          valid[20], valid[21], valid[22], valid[23], valid[24],
          valid[25], valid[26], valid[27], valid[28], valid[29],
          valid[30], valid[31], valid[32], valid[33], valid[34],
          valid[35], valid[36], valid[37], valid[38], valid[39],
          valid[40], valid[41], valid[42], valid[43], valid[44],
          valid[45], valid[46], valid[47], valid[48], valid[49],
          valid[50], valid[51], valid[52], valid[53], valid[54],
          valid[55], valid[56], valid[57], valid[58], valid[59],
          valid[60], valid[61], valid[62], valid[63], valid[64],
          valid[65], valid[66], valid[67], valid[68], valid[69],
          valid[70], valid[71], valid[72], valid[73], valid[74],
          valid[75], valid[76], valid[77], valid[78], valid[79],
          valid[80], valid[81], valid[82],  valid[83],  valid[84],
          valid[85],  valid[86],  valid[87],	 valid[88],  valid[89],
          valid[90],  valid[91],  valid[92],  valid[93],  valid[94],
          valid[95],  valid[96],  valid[97],		

          ctrl[ 0], ctrl[ 1], ctrl[ 2], ctrl[ 3], ctrl[ 4],
          ctrl[ 5], ctrl[ 6], ctrl[ 7], ctrl[ 8], ctrl[ 9],
          ctrl[10], ctrl[11], ctrl[12], ctrl[13], ctrl[14],
          ctrl[15], ctrl[16], ctrl[17], ctrl[18], ctrl[19],
          ctrl[20], ctrl[21], ctrl[22], ctrl[23], ctrl[24],
          ctrl[25], ctrl[26], ctrl[27], ctrl[28], ctrl[29],
          ctrl[30], ctrl[31], ctrl[32], ctrl[33], ctrl[34],
          ctrl[35], ctrl[36], ctrl[37], ctrl[38], ctrl[39],
          ctrl[40], ctrl[41], ctrl[42], ctrl[43], ctrl[44],
          ctrl[45], ctrl[46], ctrl[47], ctrl[48], ctrl[49],
          ctrl[50], ctrl[51], ctrl[52], ctrl[53], ctrl[54],
          ctrl[55], ctrl[56], ctrl[57], ctrl[58], ctrl[59],
          ctrl[60], ctrl[61], ctrl[62], ctrl[63], ctrl[64],
          ctrl[65], ctrl[66], ctrl[67], ctrl[68], ctrl[69],
          ctrl[70], ctrl[71], ctrl[72], ctrl[73], ctrl[74],
          ctrl[75], ctrl[76], ctrl[77], ctrl[78], ctrl[79],
          ctrl[80], ctrl[81],ctrl[82],  ctrl[83],  ctrl[84],
          ctrl[85],  ctrl[86],  ctrl[87],	 ctrl[88],  ctrl[89],
          ctrl[90],  ctrl[91],  ctrl[92],  ctrl[93],  ctrl[94],
          ctrl[95],  ctrl[96],  ctrl[97]};
   tobits = bits;
      end
   endfunction // tobits

   task frombits;
      input `frame_typ_c frame;
      begin
   bits = frame;
          {data[ 0],  data[ 1],  data[ 2],  data[ 3],  data[ 4],
          data[ 5],  data[ 6],  data[ 7],  data[ 8],  data[ 9],
          data[10],  data[11],  data[12],  data[13],  data[14],
          data[15],  data[16],  data[17],  data[18],  data[19],
          data[20],  data[21],  data[22],  data[23],  data[24],
          data[25],  data[26],  data[27],  data[28],  data[29],
          data[30],  data[31],  data[32],  data[33],  data[34],
          data[35],  data[36],  data[37],  data[38],  data[39],
          data[40],  data[41],  data[42],  data[43],  data[44],
          data[45],  data[46],  data[47],  data[48],  data[49],
          data[50],  data[51],  data[52],  data[53],  data[54],
          data[55],  data[56],  data[57],  data[58],  data[59],
          data[60],  data[61],  data[62],  data[63],  data[64],
          data[65],  data[66],  data[67],  data[68],  data[69],
          data[70],  data[71],  data[72],  data[73],  data[74],
          data[75],  data[76],  data[77],  data[78],  data[79],
          data[80],  data[81],  data[82],  data[83],  data[84],
          data[85],  data[86],  data[87],	 data[88],  data[89],
          data[90],  data[91],  data[92],  data[93],  data[94],
          data[95],  data[96],  data[97],

          valid[ 0], valid[ 1], valid[ 2], valid[ 3], valid[ 4],
          valid[ 5], valid[ 6], valid[ 7], valid[ 8], valid[ 9],
          valid[10], valid[11], valid[12], valid[13], valid[14],
          valid[15], valid[16], valid[17], valid[18], valid[19],
          valid[20], valid[21], valid[22], valid[23], valid[24],
          valid[25], valid[26], valid[27], valid[28], valid[29],
          valid[30], valid[31], valid[32], valid[33], valid[34],
          valid[35], valid[36], valid[37], valid[38], valid[39],
          valid[40], valid[41], valid[42], valid[43], valid[44],
          valid[45], valid[46], valid[47], valid[48], valid[49],
          valid[50], valid[51], valid[52], valid[53], valid[54],
          valid[55], valid[56], valid[57], valid[58], valid[59],
          valid[60], valid[61], valid[62], valid[63], valid[64],
          valid[65], valid[66], valid[67], valid[68], valid[69],
          valid[70], valid[71], valid[72], valid[73], valid[74],
          valid[75], valid[76], valid[77], valid[78], valid[79],
          valid[80], valid[81], valid[82],  valid[83],  valid[84],
          valid[85],  valid[86],  valid[87],	 valid[88],  valid[89],
          valid[90],  valid[91],  valid[92],  valid[93],  valid[94],
          valid[95],  valid[96],  valid[97],	


          ctrl[ 0], ctrl[ 1], ctrl[ 2], ctrl[ 3], ctrl[ 4],
          ctrl[ 5], ctrl[ 6], ctrl[ 7], ctrl[ 8], ctrl[ 9],
          ctrl[10], ctrl[11], ctrl[12], ctrl[13], ctrl[14],
          ctrl[15], ctrl[16], ctrl[17], ctrl[18], ctrl[19],
          ctrl[20], ctrl[21], ctrl[22], ctrl[23], ctrl[24],
          ctrl[25], ctrl[26], ctrl[27], ctrl[28], ctrl[29],
          ctrl[30], ctrl[31], ctrl[32], ctrl[33], ctrl[34],
          ctrl[35], ctrl[36], ctrl[37], ctrl[38], ctrl[39],
          ctrl[40], ctrl[41], ctrl[42], ctrl[43], ctrl[44],
          ctrl[45], ctrl[46], ctrl[47], ctrl[48], ctrl[49],
          ctrl[50], ctrl[51], ctrl[52], ctrl[53], ctrl[54],
          ctrl[55], ctrl[56], ctrl[57], ctrl[58], ctrl[59],
          ctrl[60], ctrl[61], ctrl[62], ctrl[63], ctrl[64],
          ctrl[65], ctrl[66], ctrl[67], ctrl[68], ctrl[69],
          ctrl[70], ctrl[71], ctrl[72], ctrl[73], ctrl[74],
          ctrl[75], ctrl[76], ctrl[77], ctrl[78], ctrl[79],
          ctrl[80], ctrl[81],	ctrl[82],  ctrl[83],  ctrl[84],
          ctrl[85],  ctrl[86],  ctrl[87],	 ctrl[88],  ctrl[89],
          ctrl[90],  ctrl[91],  ctrl[92],  ctrl[93],  ctrl[94],
          ctrl[95],  ctrl[96],  ctrl[97]} = bits;
      end
   endtask // frombits

endmodule // frame_typ_c

// This module is the rx locallink fifo stimulus, it outputs 
// rx_ll_clock, rx_ll_data, rx_ll_sof_n, rx_ll_eof_n, rx_ll_src_rdy_n.
module rx_ll_fifo_stimulus
  (
  output reg rx_ll_clock = 1'b0,
	output reg [7:0] rx_ll_data = 0,
	output  rx_ll_sof_n,
	output  rx_ll_eof_n,
	output  rx_ll_src_rdy_n
    );

	reg [2:0] rx_ll_ctrl_i = 3'b111;
  //--------------------------------------------------------------------
  // Clock drivers
  //--------------------------------------------------------------------
  parameter UI  = 4000;  // 4 ns
  // Drives bitclock at line rate
  initial
  begin
    rx_ll_clock <= 1'b0;
    forever
    begin
      rx_ll_clock <= 1'b0;
      #(UI/2);
      rx_ll_clock <= 1'b1;
      #(UI/2);
    end
  end
  //--------------------------------------------------------------------
  // Types to support frame data
  //--------------------------------------------------------------------

   frame_typ_c frameArp();
   frame_typ_c frameIcmpWindows();
   frame_typ_c frameIcmpLinux();
   frame_typ_c frameUdpDtc();
   frame_typ_c frameUdpFlash();
	frame_typ_c frameUdpSruRdVer();
	frame_typ_c frameUdpSruPhaseSet();
	frame_typ_c frameUdpSruStrig();
	frame_typ_c frameUdpSruReset();
	frame_typ_c frameUdpSruWrOReg();
	frame_typ_c frameUdpSruRdOReg();
	frame_typ_c frameUdpSruBusyClr();
	

   frame_typ_c rx_stimulus_working_frame();
   frame_typ_c tx_monitor_working_frame();

  //--------------------------------------------------------------------
  // Stimulus - Frame data
  //--------------------------------------------------------------------
  // The following constant holds the stimulus for the testbench. 
  // The frames are: frameArp, frameIcmpWindows,frameIcmpLinux, frameUdpCmd, frameUdpFlash.
  // PC MAC: 00 30 48 C1 08 79; PC IP: C0 A0 84 64
  // FPGA MAC: 0a350aa08479 ;PC IP: 0AA088479  
  //--------------------------------------------------------------------
  initial
  begin
  //frameArp :  arp_req  
    frameArp.data[0]  = 8'hff;  frameArp.valid[0]  = 1'b1;  frameArp.ctrl[0]  = 3'b010; // Destination Address (DA) : broadcast
    frameArp.data[1]  = 8'hff;  frameArp.valid[1]  = 1'b1;  frameArp.ctrl[1]  = 3'b110;
    frameArp.data[2]  = 8'hff;  frameArp.valid[2]  = 1'b1;  frameArp.ctrl[2]  = 3'b110;
    frameArp.data[3]  = 8'hff;  frameArp.valid[3]  = 1'b1;  frameArp.ctrl[3]  = 3'b110;
    frameArp.data[4]  = 8'hff;  frameArp.valid[4]  = 1'b1;  frameArp.ctrl[4]  = 3'b110;
    frameArp.data[5]  = 8'hff;  frameArp.valid[5]  = 1'b1;  frameArp.ctrl[5]  = 3'b110;
	
    frameArp.data[6]  = 8'h00;  frameArp.valid[6]  = 1'b1;  frameArp.ctrl[6]  = 3'b110; // Source Address (5A)
    frameArp.data[7]  = 8'h30;  frameArp.valid[7]  = 1'b1;  frameArp.ctrl[7]  = 3'b110;
    frameArp.data[8]  = 8'h48;  frameArp.valid[8]  = 1'b1;  frameArp.ctrl[8]  = 3'b110;
    frameArp.data[9]  = 8'hc1;  frameArp.valid[9]  = 1'b1;  frameArp.ctrl[9]  = 3'b110;
    frameArp.data[10] = 8'h08;  frameArp.valid[10] = 1'b1;  frameArp.ctrl[10] = 3'b110;
    frameArp.data[11] = 8'h79;  frameArp.valid[11] = 1'b1;  frameArp.ctrl[11] = 3'b110;
	
    frameArp.data[12] = 8'h08;  frameArp.valid[12] = 1'b1;  frameArp.ctrl[12] = 3'b110; // Ethernet type (0x0806, arp)	
    frameArp.data[13] = 8'h06;  frameArp.valid[13] = 1'b1;  frameArp.ctrl[13] = 3'b110;
   
    frameArp.data[14] = 8'h00;  frameArp.valid[14] = 1'b1;  frameArp.ctrl[14] = 3'b110; //ethernet
    frameArp.data[15] = 8'h01;  frameArp.valid[15] = 1'b1;  frameArp.ctrl[15] = 3'b110;
	
    frameArp.data[16] = 8'h08;  frameArp.valid[16] = 1'b1;  frameArp.ctrl[16] = 3'b110;// ip
    frameArp.data[17] = 8'h00;  frameArp.valid[17] = 1'b1;  frameArp.ctrl[17] = 3'b110;
	
    frameArp.data[18] = 8'h06;  frameArp.valid[18] = 1'b1;  frameArp.ctrl[18] = 3'b110;
    frameArp.data[19] = 8'h04;  frameArp.valid[19] = 1'b1;  frameArp.ctrl[19] = 3'b110;
    frameArp.data[20] = 8'h00;  frameArp.valid[20] = 1'b1;  frameArp.ctrl[20] = 3'b110;
    frameArp.data[21] = 8'h01;  frameArp.valid[21] = 1'b1;  frameArp.ctrl[21] = 3'b110;
	
    frameArp.data[22] = 8'h00;  frameArp.valid[22] = 1'b1;  frameArp.ctrl[22] = 3'b110;// Sender MAC
    frameArp.data[23] = 8'h30;  frameArp.valid[23] = 1'b1;  frameArp.ctrl[23] = 3'b110;
    frameArp.data[24] = 8'h48;  frameArp.valid[24] = 1'b1;  frameArp.ctrl[24] = 3'b110;
    frameArp.data[25] = 8'hc1;  frameArp.valid[25] = 1'b1;  frameArp.ctrl[25] = 3'b110;	
    frameArp.data[26] = 8'h08;  frameArp.valid[26] = 1'b1;  frameArp.ctrl[26] = 3'b110;
    frameArp.data[27] = 8'h79;  frameArp.valid[27] = 1'b1;  frameArp.ctrl[27] = 3'b110;
	
    frameArp.data[28] = 8'hc0;  frameArp.valid[28] = 1'b1;  frameArp.ctrl[28] = 3'b110;// Sender IP
    frameArp.data[29] = 8'ha0;  frameArp.valid[29] = 1'b1;  frameArp.ctrl[29] = 3'b110;	
    frameArp.data[30] = 8'h84;  frameArp.valid[30] = 1'b1;  frameArp.ctrl[30] = 3'b110;
    frameArp.data[31] = 8'h64;  frameArp.valid[31] = 1'b1;  frameArp.ctrl[31] = 3'b110;
	
    frameArp.data[32] = 8'h00;  frameArp.valid[32] = 1'b1;  frameArp.ctrl[32] = 3'b110;//Target MAC
    frameArp.data[33] = 8'h00;  frameArp.valid[33] = 1'b1;  frameArp.ctrl[33] = 3'b110;	
    frameArp.data[34] = 8'h00;  frameArp.valid[34] = 1'b1;  frameArp.ctrl[34] = 3'b110;	
    frameArp.data[35] = 8'h00;  frameArp.valid[35] = 1'b1;  frameArp.ctrl[35] = 3'b110;//	
    frameArp.data[36] = 8'h00;  frameArp.valid[36] = 1'b1;  frameArp.ctrl[36] = 3'b110;
    frameArp.data[37] = 8'h00;  frameArp.valid[37] = 1'b1;  frameArp.ctrl[37] = 3'b110;
	
    frameArp.data[38] = 8'h0a;  frameArp.valid[38] = 1'b1;  frameArp.ctrl[38] = 3'b110;// Target IP
    frameArp.data[39] = 8'ha0;  frameArp.valid[39] = 1'b1;  frameArp.ctrl[39] = 3'b110; 	
    frameArp.data[40] = 8'h84;  frameArp.valid[40] = 1'b1;  frameArp.ctrl[40] = 3'b110;
    frameArp.data[41] = 8'h79;  frameArp.valid[41] = 1'b1;  frameArp.ctrl[41] = 3'b110;
		
    frameArp.data[42] = 8'h00;  frameArp.valid[42] = 1'b1;  frameArp.ctrl[42] = 3'b110;// Data
    frameArp.data[43] = 8'h00;  frameArp.valid[43] = 1'b1;  frameArp.ctrl[43] = 3'b110;
    frameArp.data[44] = 8'h00;  frameArp.valid[44] = 1'b1;  frameArp.ctrl[44] = 3'b110;
    frameArp.data[45] = 8'h00;  frameArp.valid[45] = 1'b1;  frameArp.ctrl[45] = 3'b110;	
    frameArp.data[46] = 8'h00;  frameArp.valid[46] = 1'b1;  frameArp.ctrl[46] = 3'b110;
    frameArp.data[47] = 8'h00;  frameArp.valid[47] = 1'b1;  frameArp.ctrl[47] = 3'b110;
    frameArp.data[48] = 8'h00;  frameArp.valid[48] = 1'b1;  frameArp.ctrl[48] = 3'b110;
    frameArp.data[49] = 8'h00;  frameArp.valid[49] = 1'b1;  frameArp.ctrl[49] = 3'b110;	
    frameArp.data[50] = 8'h00;  frameArp.valid[50] = 1'b1;  frameArp.ctrl[50] = 3'b110;//
    frameArp.data[51] = 8'h00;  frameArp.valid[51] = 1'b1;  frameArp.ctrl[51] = 3'b110;
    frameArp.data[52] = 8'h00;  frameArp.valid[52] = 1'b1;  frameArp.ctrl[52] = 3'b110;
    frameArp.data[53] = 8'h00;  frameArp.valid[53] = 1'b1;  frameArp.ctrl[53] = 3'b110;   
	 frameArp.data[54] = 8'h00;  frameArp.valid[54] = 1'b1;  frameArp.ctrl[54] = 3'b110;
    frameArp.data[55] = 8'h00;  frameArp.valid[55] = 1'b1;  frameArp.ctrl[55] = 3'b110;
    frameArp.data[56] = 8'h00;  frameArp.valid[56] = 1'b1;  frameArp.ctrl[56] = 3'b110;
    frameArp.data[57] = 8'h00;  frameArp.valid[57] = 1'b1;  frameArp.ctrl[57] = 3'b110;   
	
	 frameArp.data[58] = 8'h00;  frameArp.valid[58] = 1'b1;  frameArp.ctrl[58] = 3'b110;
    frameArp.data[59] = 8'h00;  frameArp.valid[59] = 1'b1;  frameArp.ctrl[59] = 3'b110;
    frameArp.data[60] = 8'h00;  frameArp.valid[60] = 1'b1;  frameArp.ctrl[60] = 3'b110;
    frameArp.data[61] = 8'h00;  frameArp.valid[61] = 1'b1;  frameArp.ctrl[61] = 3'b110;	 
    frameArp.data[62] = 8'h00;  frameArp.valid[62] = 1'b1;  frameArp.ctrl[62] = 3'b110;
    frameArp.data[63] = 8'h00;  frameArp.valid[63] = 1'b1;  frameArp.ctrl[63] = 3'b100;
    frameArp.data[64] = 8'h00;  frameArp.valid[64] = 1'b0;  frameArp.ctrl[64] = 3'b111;
    frameArp.data[65] = 8'h00;  frameArp.valid[65] = 1'b0;  frameArp.ctrl[65] = 3'b111;	 
    frameArp.data[66] = 8'h00;  frameArp.valid[66] = 1'b0;  frameArp.ctrl[66] = 3'b111;
    frameArp.data[67] = 8'h00;  frameArp.valid[67] = 1'b0;  frameArp.ctrl[67] = 3'b111;
    frameArp.data[68] = 8'h1a;  frameArp.valid[68] = 1'b0;  frameArp.ctrl[68] = 3'b111;
    frameArp.data[69] = 8'h1b;  frameArp.valid[69] = 1'b0;  frameArp.ctrl[69] = 3'b111;	 
    frameArp.data[70] = 8'h1c;  frameArp.valid[70] = 1'b0;  frameArp.ctrl[70] = 3'b111;
    frameArp.data[71] = 8'h1d;  frameArp.valid[71] = 1'b0;  frameArp.ctrl[71] = 3'b111;
    frameArp.data[72] = 8'h1e;  frameArp.valid[72] = 1'b0;  frameArp.ctrl[72] = 3'b111;
    frameArp.data[73] = 8'h1f;  frameArp.valid[73] = 1'b0;  frameArp.ctrl[73] = 3'b111;
    frameArp.data[74] = 8'h20;  frameArp.valid[74] = 1'b0;  frameArp.ctrl[74] = 3'b111;
    frameArp.data[75] = 8'h21;  frameArp.valid[75] = 1'b0;  frameArp.ctrl[75] = 3'b111;
    frameArp.data[76] = 8'h22;  frameArp.valid[76] = 1'b0;  frameArp.ctrl[76] = 3'b111;
    frameArp.data[77] = 8'h23;  frameArp.valid[77] = 1'b0;  frameArp.ctrl[77] = 3'b111;	 
    frameArp.data[78] = 8'h24;  frameArp.valid[78] = 1'b0;  frameArp.ctrl[78] = 3'b111;
    frameArp.data[79] = 8'h25;  frameArp.valid[79] = 1'b0;  frameArp.ctrl[79] = 3'b111;
    frameArp.data[80] = 8'h26;  frameArp.valid[80] = 1'b0;  frameArp.ctrl[80] = 3'b111;
    frameArp.data[81] = 8'h27;  frameArp.valid[81] = 1'b0;  frameArp.ctrl[81] = 3'b111;	

	frameArp.data[82] = 8'h28;  frameArp.valid[82] = 1'b0;  frameArp.ctrl[82] = 3'b111;
    frameArp.data[83] = 8'h29;  frameArp.valid[83] = 1'b0;  frameArp.ctrl[83] = 3'b111;
    frameArp.data[84] = 8'h2a;  frameArp.valid[84] = 1'b0;  frameArp.ctrl[84] = 3'b111;
    frameArp.data[85] = 8'h2b;  frameArp.valid[85] = 1'b0;  frameArp.ctrl[85] = 3'b111;	 
    frameArp.data[86] = 8'h2c;  frameArp.valid[86] = 1'b0;  frameArp.ctrl[86] = 3'b111;
    frameArp.data[87] = 8'h2d;  frameArp.valid[87] = 1'b0;  frameArp.ctrl[87] = 3'b111;
    frameArp.data[88] = 8'h2e;  frameArp.valid[88] = 1'b0;  frameArp.ctrl[88] = 3'b111;
    frameArp.data[89] = 8'h2f;  frameArp.valid[89] = 1'b0;  frameArp.ctrl[89] = 3'b111;
    frameArp.data[90] = 8'h30;  frameArp.valid[90] = 1'b0;  frameArp.ctrl[90] = 3'b111;
    frameArp.data[91] = 8'h31;  frameArp.valid[91] = 1'b0;  frameArp.ctrl[91] = 3'b111;
    frameArp.data[92] = 8'h32;  frameArp.valid[92] = 1'b0;  frameArp.ctrl[92] = 3'b111;
    frameArp.data[93] = 8'h33;  frameArp.valid[93] = 1'b0;  frameArp.ctrl[93] = 3'b111;	 
    frameArp.data[94] = 8'h34;  frameArp.valid[94] = 1'b0;  frameArp.ctrl[94] = 3'b111;
    frameArp.data[95] = 8'h35;  frameArp.valid[95] = 1'b0;  frameArp.ctrl[95] = 3'b111;
    frameArp.data[96] = 8'h36;  frameArp.valid[96] = 1'b0;  frameArp.ctrl[96] = 3'b111;
    frameArp.data[97] = 8'h37;  frameArp.valid[97] = 1'b0;  frameArp.ctrl[97] = 3'b111;	 // 98th Byte of Data

  
/*  Data stream has been captured by the wireshark in the windows computer.
//Dest MAC : 00 00 c0 a8 01 29
3	0.000046	192.168.1.63	192.168.1.41	ICMP	Echo (ping) request  (id=0x0001, seq(be/le)=22/5632, ttl=128)
0000   00 00 c0 a8 01 29 00 1b 21 68 3d fd 08 00 45 00  .....)..!h=...E.
0010   00 3c 00 5d 00 00 80 01 b6 ab c0 a8 01 3f c0 a8  .<.].........?..
0020   01 29 08 00 4d 45 00 01 00 16 61 62 63 64 65 66  .)..ME....abcdef
0030   67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76  ghijklmnopqrstuv
0040   77 61 62 63 64 65 66 67 68 69                    wabcdefghi
*/
    frameIcmpWindows.data[0]  = 8'h00;  frameIcmpWindows.valid[0]  = 1'b1;  frameIcmpWindows.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameIcmpWindows.data[1]  = 8'h00;  frameIcmpWindows.valid[1]  = 1'b1;  frameIcmpWindows.ctrl[1]  = 3'b110;
    frameIcmpWindows.data[2]  = 8'hc0;  frameIcmpWindows.valid[2]  = 1'b1;  frameIcmpWindows.ctrl[2]  = 3'b110;
    frameIcmpWindows.data[3]  = 8'ha8;  frameIcmpWindows.valid[3]  = 1'b1;  frameIcmpWindows.ctrl[3]  = 3'b110;
    frameIcmpWindows.data[4]  = 8'h01;  frameIcmpWindows.valid[4]  = 1'b1;  frameIcmpWindows.ctrl[4]  = 3'b110;
    frameIcmpWindows.data[5]  = 8'h29;  frameIcmpWindows.valid[5]  = 1'b1;  frameIcmpWindows.ctrl[5]  = 3'b110;
	
    frameIcmpWindows.data[6]  = 8'h00;  frameIcmpWindows.valid[6]  = 1'b1;  frameIcmpWindows.ctrl[6]  = 3'b110; // Source Address (5A)
    frameIcmpWindows.data[7]  = 8'h1b;  frameIcmpWindows.valid[7]  = 1'b1;  frameIcmpWindows.ctrl[7]  = 3'b110;
    frameIcmpWindows.data[8]  = 8'h21;  frameIcmpWindows.valid[8]  = 1'b1;  frameIcmpWindows.ctrl[8]  = 3'b110;
    frameIcmpWindows.data[9]  = 8'h68;  frameIcmpWindows.valid[9]  = 1'b1;  frameIcmpWindows.ctrl[9]  = 3'b110;
    frameIcmpWindows.data[10] = 8'h3d;  frameIcmpWindows.valid[10] = 1'b1;  frameIcmpWindows.ctrl[10] = 3'b110;
    frameIcmpWindows.data[11] = 8'hfd;  frameIcmpWindows.valid[11] = 1'b1;  frameIcmpWindows.ctrl[11] = 3'b110;
	
    frameIcmpWindows.data[12] = 8'h08;  frameIcmpWindows.valid[12] = 1'b1;  frameIcmpWindows.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameIcmpWindows.data[13] = 8'h00;  frameIcmpWindows.valid[13] = 1'b1;  frameIcmpWindows.ctrl[13] = 3'b110;
   
    frameIcmpWindows.data[14] = 8'h45;  frameIcmpWindows.valid[14] = 1'b1;  frameIcmpWindows.ctrl[14] = 3'b110;
    frameIcmpWindows.data[15] = 8'h00;  frameIcmpWindows.valid[15] = 1'b1;  frameIcmpWindows.ctrl[15] = 3'b110;
	
    frameIcmpWindows.data[16] = 8'h00;  frameIcmpWindows.valid[16] = 1'b1;  frameIcmpWindows.ctrl[16] = 3'b110;// 16 bit total length (0054:84)
    frameIcmpWindows.data[17] = 8'h3c;  frameIcmpWindows.valid[17] = 1'b1;  frameIcmpWindows.ctrl[17] = 3'b110;
	
    frameIcmpWindows.data[18] = 8'h00;  frameIcmpWindows.valid[18] = 1'b1;  frameIcmpWindows.ctrl[18] = 3'b110;
    frameIcmpWindows.data[19] = 8'h5d;  frameIcmpWindows.valid[19] = 1'b1;  frameIcmpWindows.ctrl[19] = 3'b110;
	
    frameIcmpWindows.data[20] = 8'h00;  frameIcmpWindows.valid[20] = 1'b1;  frameIcmpWindows.ctrl[20] = 3'b110;
    frameIcmpWindows.data[21] = 8'h00;  frameIcmpWindows.valid[21] = 1'b1;  frameIcmpWindows.ctrl[21] = 3'b110;
    frameIcmpWindows.data[22] = 8'h80;  frameIcmpWindows.valid[22] = 1'b1;  frameIcmpWindows.ctrl[22] = 3'b110;	
    frameIcmpWindows.data[23] = 8'h01;  frameIcmpWindows.valid[23] = 1'b1;  frameIcmpWindows.ctrl[23] = 3'b110;// Protocol (icmp: 0x01)
	
    frameIcmpWindows.data[24] = 8'hb6;  frameIcmpWindows.valid[24] = 1'b1;  frameIcmpWindows.ctrl[24] = 3'b110;// Header checker
    frameIcmpWindows.data[25] = 8'hab;  frameIcmpWindows.valid[25] = 1'b1;  frameIcmpWindows.ctrl[25] = 3'b110;
	
    frameIcmpWindows.data[26] = 8'hc0;  frameIcmpWindows.valid[26] = 1'b1;  frameIcmpWindows.ctrl[26] = 3'b110;// Source IP
    frameIcmpWindows.data[27] = 8'ha8;  frameIcmpWindows.valid[27] = 1'b1;  frameIcmpWindows.ctrl[27] = 3'b110;
    frameIcmpWindows.data[28] = 8'h01;  frameIcmpWindows.valid[28] = 1'b1;  frameIcmpWindows.ctrl[28] = 3'b110;
    frameIcmpWindows.data[29] = 8'h3f;  frameIcmpWindows.valid[29] = 1'b1;  frameIcmpWindows.ctrl[29] = 3'b110;
	
    frameIcmpWindows.data[30] = 8'hc0;  frameIcmpWindows.valid[30] = 1'b1;  frameIcmpWindows.ctrl[30] = 3'b110;// Destination IP
    frameIcmpWindows.data[31] = 8'ha8;  frameIcmpWindows.valid[31] = 1'b1;  frameIcmpWindows.ctrl[31] = 3'b110;
    frameIcmpWindows.data[32] = 8'h01;  frameIcmpWindows.valid[32] = 1'b1;  frameIcmpWindows.ctrl[32] = 3'b110;
    frameIcmpWindows.data[33] = 8'h29;  frameIcmpWindows.valid[33] = 1'b1;  frameIcmpWindows.ctrl[33] = 3'b110;
	
    frameIcmpWindows.data[34] = 8'h08;  frameIcmpWindows.valid[34] = 1'b1;  frameIcmpWindows.ctrl[34] = 3'b110;//Ping req	
    frameIcmpWindows.data[35] = 8'h00;  frameIcmpWindows.valid[35] = 1'b1;  frameIcmpWindows.ctrl[35] = 3'b110;//
	
    frameIcmpWindows.data[36] = 8'h00;  frameIcmpWindows.valid[36] = 1'b1;  frameIcmpWindows.ctrl[36] = 3'b110;// Checksum  (4d45)
    frameIcmpWindows.data[37] = 8'h00;  frameIcmpWindows.valid[37] = 1'b1;  frameIcmpWindows.ctrl[37] = 3'b110;
	
    frameIcmpWindows.data[38] = 8'h00;  frameIcmpWindows.valid[38] = 1'b1;  frameIcmpWindows.ctrl[38] = 3'b110;// identifier
    frameIcmpWindows.data[39] = 8'h01;  frameIcmpWindows.valid[39] = 1'b1;  frameIcmpWindows.ctrl[39] = 3'b110; 
	
    frameIcmpWindows.data[40] = 8'h00;  frameIcmpWindows.valid[40] = 1'b1;  frameIcmpWindows.ctrl[40] = 3'b110;// Seq num
    frameIcmpWindows.data[41] = 8'h16;  frameIcmpWindows.valid[41] = 1'b1;  frameIcmpWindows.ctrl[41] = 3'b110;
		
    frameIcmpWindows.data[42] = 8'h61;  frameIcmpWindows.valid[42] = 1'b1;  frameIcmpWindows.ctrl[42] = 3'b110;// Data
    frameIcmpWindows.data[43] = 8'h62;  frameIcmpWindows.valid[43] = 1'b1;  frameIcmpWindows.ctrl[43] = 3'b110;
    frameIcmpWindows.data[44] = 8'h63;  frameIcmpWindows.valid[44] = 1'b1;  frameIcmpWindows.ctrl[44] = 3'b110;
    frameIcmpWindows.data[45] = 8'h64;  frameIcmpWindows.valid[45] = 1'b1;  frameIcmpWindows.ctrl[45] = 3'b110;
	
    frameIcmpWindows.data[46] = 8'h65;  frameIcmpWindows.valid[46] = 1'b1;  frameIcmpWindows.ctrl[46] = 3'b110;
    frameIcmpWindows.data[47] = 8'h66;  frameIcmpWindows.valid[47] = 1'b1;  frameIcmpWindows.ctrl[47] = 3'b110;
    frameIcmpWindows.data[48] = 8'h67;  frameIcmpWindows.valid[48] = 1'b1;  frameIcmpWindows.ctrl[48] = 3'b110;
    frameIcmpWindows.data[49] = 8'h68;  frameIcmpWindows.valid[49] = 1'b1;  frameIcmpWindows.ctrl[49] = 3'b110;
	
    frameIcmpWindows.data[50] = 8'h69;  frameIcmpWindows.valid[50] = 1'b1;  frameIcmpWindows.ctrl[50] = 3'b110;
    frameIcmpWindows.data[51] = 8'h6a;  frameIcmpWindows.valid[51] = 1'b1;  frameIcmpWindows.ctrl[51] = 3'b110;
    frameIcmpWindows.data[52] = 8'h6b;  frameIcmpWindows.valid[52] = 1'b1;  frameIcmpWindows.ctrl[52] = 3'b110;
    frameIcmpWindows.data[53] = 8'h6c;  frameIcmpWindows.valid[53] = 1'b1;  frameIcmpWindows.ctrl[53] = 3'b110;
    
	 frameIcmpWindows.data[54] = 8'h6d;  frameIcmpWindows.valid[54] = 1'b1;  frameIcmpWindows.ctrl[54] = 3'b110;
    frameIcmpWindows.data[55] = 8'h6e;  frameIcmpWindows.valid[55] = 1'b1;  frameIcmpWindows.ctrl[55] = 3'b110;
    frameIcmpWindows.data[56] = 8'h6f;  frameIcmpWindows.valid[56] = 1'b1;  frameIcmpWindows.ctrl[56] = 3'b110;
    frameIcmpWindows.data[57] = 8'h70;  frameIcmpWindows.valid[57] = 1'b1;  frameIcmpWindows.ctrl[57] = 3'b110;
	
	frameIcmpWindows.data[58] = 8'h71;  frameIcmpWindows.valid[58] = 1'b1;  frameIcmpWindows.ctrl[58] = 3'b110;
    frameIcmpWindows.data[59] = 8'h72;  frameIcmpWindows.valid[59] = 1'b1;  frameIcmpWindows.ctrl[59] = 3'b110;
    frameIcmpWindows.data[60] = 8'h73;  frameIcmpWindows.valid[60] = 1'b1;  frameIcmpWindows.ctrl[60] = 3'b110;
    frameIcmpWindows.data[61] = 8'h74;  frameIcmpWindows.valid[61] = 1'b1;  frameIcmpWindows.ctrl[61] = 3'b110; 
    frameIcmpWindows.data[62] = 8'h75;  frameIcmpWindows.valid[62] = 1'b1;  frameIcmpWindows.ctrl[62] = 3'b110;
    frameIcmpWindows.data[63] = 8'h76;  frameIcmpWindows.valid[63] = 1'b1;  frameIcmpWindows.ctrl[63] = 3'b110;
    frameIcmpWindows.data[64] = 8'h77;  frameIcmpWindows.valid[64] = 1'b1;  frameIcmpWindows.ctrl[64] = 3'b110;
    frameIcmpWindows.data[65] = 8'h61;  frameIcmpWindows.valid[65] = 1'b1;  frameIcmpWindows.ctrl[65] = 3'b110;	 
    frameIcmpWindows.data[66] = 8'h62;  frameIcmpWindows.valid[66] = 1'b1;  frameIcmpWindows.ctrl[66] = 3'b110;
    frameIcmpWindows.data[67] = 8'h63;  frameIcmpWindows.valid[67] = 1'b1;  frameIcmpWindows.ctrl[67] = 3'b110;
    frameIcmpWindows.data[68] = 8'h64;  frameIcmpWindows.valid[68] = 1'b1;  frameIcmpWindows.ctrl[68] = 3'b110;
    frameIcmpWindows.data[69] = 8'h65;  frameIcmpWindows.valid[69] = 1'b1;  frameIcmpWindows.ctrl[69] = 3'b110;	 
    frameIcmpWindows.data[70] = 8'h66;  frameIcmpWindows.valid[70] = 1'b1;  frameIcmpWindows.ctrl[70] = 3'b110;
    frameIcmpWindows.data[71] = 8'h67;  frameIcmpWindows.valid[71] = 1'b1;  frameIcmpWindows.ctrl[71] = 3'b110;
    frameIcmpWindows.data[72] = 8'h68;  frameIcmpWindows.valid[72] = 1'b1;  frameIcmpWindows.ctrl[72] = 3'b110;
    frameIcmpWindows.data[73] = 8'h69;  frameIcmpWindows.valid[73] = 1'b1;  frameIcmpWindows.ctrl[73] = 3'b100;
	
    frameIcmpWindows.data[74] = 8'h20;  frameIcmpWindows.valid[74] = 1'b0;  frameIcmpWindows.ctrl[74] = 3'b111;
    frameIcmpWindows.data[75] = 8'h21;  frameIcmpWindows.valid[75] = 1'b0;  frameIcmpWindows.ctrl[75] = 3'b111;
    frameIcmpWindows.data[76] = 8'h22;  frameIcmpWindows.valid[76] = 1'b0;  frameIcmpWindows.ctrl[76] = 3'b111;
    frameIcmpWindows.data[77] = 8'h23;  frameIcmpWindows.valid[77] = 1'b0;  frameIcmpWindows.ctrl[77] = 3'b111;	 
    frameIcmpWindows.data[78] = 8'h24;  frameIcmpWindows.valid[78] = 1'b0;  frameIcmpWindows.ctrl[78] = 3'b111;
    frameIcmpWindows.data[79] = 8'h25;  frameIcmpWindows.valid[79] = 1'b0;  frameIcmpWindows.ctrl[79] = 3'b111;
    frameIcmpWindows.data[80] = 8'h26;  frameIcmpWindows.valid[80] = 1'b0;  frameIcmpWindows.ctrl[80] = 3'b111;
    frameIcmpWindows.data[81] = 8'h27;  frameIcmpWindows.valid[81] = 1'b0;  frameIcmpWindows.ctrl[81] = 3'b111;

	frameIcmpWindows.data[82] = 8'h28;  frameIcmpWindows.valid[82] = 1'b0;  frameIcmpWindows.ctrl[82] = 3'b111;
    frameIcmpWindows.data[83] = 8'h29;  frameIcmpWindows.valid[83] = 1'b0;  frameIcmpWindows.ctrl[83] = 3'b111;
    frameIcmpWindows.data[84] = 8'h2a;  frameIcmpWindows.valid[84] = 1'b0;  frameIcmpWindows.ctrl[84] = 3'b111;
    frameIcmpWindows.data[85] = 8'h2b;  frameIcmpWindows.valid[85] = 1'b0;  frameIcmpWindows.ctrl[85] = 3'b111; 
    frameIcmpWindows.data[86] = 8'h2c;  frameIcmpWindows.valid[86] = 1'b0;  frameIcmpWindows.ctrl[86] = 3'b111;
    frameIcmpWindows.data[87] = 8'h2d;  frameIcmpWindows.valid[87] = 1'b0;  frameIcmpWindows.ctrl[87] = 3'b111;
    frameIcmpWindows.data[88] = 8'h2e;  frameIcmpWindows.valid[88] = 1'b0;  frameIcmpWindows.ctrl[88] = 3'b111;
    frameIcmpWindows.data[89] = 8'h2f;  frameIcmpWindows.valid[89] = 1'b0;  frameIcmpWindows.ctrl[89] = 3'b111;
    frameIcmpWindows.data[90] = 8'h30;  frameIcmpWindows.valid[90] = 1'b0;  frameIcmpWindows.ctrl[90] = 3'b111;
    frameIcmpWindows.data[91] = 8'h31;  frameIcmpWindows.valid[91] = 1'b0;  frameIcmpWindows.ctrl[91] = 3'b111;
    frameIcmpWindows.data[92] = 8'h32;  frameIcmpWindows.valid[92] = 1'b0;  frameIcmpWindows.ctrl[92] = 3'b111;
    frameIcmpWindows.data[93] = 8'h33;  frameIcmpWindows.valid[93] = 1'b0;  frameIcmpWindows.ctrl[93] = 3'b111;
    frameIcmpWindows.data[94] = 8'h34;  frameIcmpWindows.valid[94] = 1'b0;  frameIcmpWindows.ctrl[94] = 3'b111;
    frameIcmpWindows.data[95] = 8'h35;  frameIcmpWindows.valid[95] = 1'b0;  frameIcmpWindows.ctrl[95] = 3'b111;
    frameIcmpWindows.data[96] = 8'h36;  frameIcmpWindows.valid[96] = 1'b0;  frameIcmpWindows.ctrl[96] = 3'b111;
    frameIcmpWindows.data[97] = 8'h37;  frameIcmpWindows.valid[97] = 1'b0;  frameIcmpWindows.ctrl[97] = 3'b111;	 // 82th Byte of Data

  
  //frameIcmpLinux :  icmp_req (Expected checkcusm in Reply: 3b7f (wrong: 7fe2, 727f))
    frameIcmpLinux.data[0]  = 8'h0a;  frameIcmpLinux.valid[0]  = 1'b1;  frameIcmpLinux.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameIcmpLinux.data[1]  = 8'h35;  frameIcmpLinux.valid[1]  = 1'b1;  frameIcmpLinux.ctrl[1]  = 3'b110;
    frameIcmpLinux.data[2]  = 8'h0a;  frameIcmpLinux.valid[2]  = 1'b1;  frameIcmpLinux.ctrl[2]  = 3'b110;
    frameIcmpLinux.data[3]  = 8'ha0;  frameIcmpLinux.valid[3]  = 1'b1;  frameIcmpLinux.ctrl[3]  = 3'b110;
    frameIcmpLinux.data[4]  = 8'h84;  frameIcmpLinux.valid[4]  = 1'b1;  frameIcmpLinux.ctrl[4]  = 3'b110;
    frameIcmpLinux.data[5]  = 8'h79;  frameIcmpLinux.valid[5]  = 1'b1;  frameIcmpLinux.ctrl[5]  = 3'b110;
	
    frameIcmpLinux.data[6]  = 8'h00;  frameIcmpLinux.valid[6]  = 1'b1;  frameIcmpLinux.ctrl[6]  = 3'b110;// Source Address (5A)
    frameIcmpLinux.data[7]  = 8'h30;  frameIcmpLinux.valid[7]  = 1'b1;  frameIcmpLinux.ctrl[7]  = 3'b110;
    frameIcmpLinux.data[8]  = 8'h48;  frameIcmpLinux.valid[8]  = 1'b1;  frameIcmpLinux.ctrl[8]  = 3'b110;
    frameIcmpLinux.data[9]  = 8'hc1;  frameIcmpLinux.valid[9]  = 1'b1;  frameIcmpLinux.ctrl[9]  = 3'b110;
    frameIcmpLinux.data[10] = 8'h08;  frameIcmpLinux.valid[10] = 1'b1;  frameIcmpLinux.ctrl[10] = 3'b110;
    frameIcmpLinux.data[11] = 8'h79;  frameIcmpLinux.valid[11] = 1'b1;  frameIcmpLinux.ctrl[11] = 3'b110;
	
    frameIcmpLinux.data[12] = 8'h08;  frameIcmpLinux.valid[12] = 1'b1;  frameIcmpLinux.ctrl[12] = 3'b110;// Ethernet type (0x0800, IP)	
    frameIcmpLinux.data[13] = 8'h00;  frameIcmpLinux.valid[13] = 1'b1;  frameIcmpLinux.ctrl[13] = 3'b110;
   
    frameIcmpLinux.data[14] = 8'h45;  frameIcmpLinux.valid[14] = 1'b1;  frameIcmpLinux.ctrl[14] = 3'b110;
    frameIcmpLinux.data[15] = 8'h00;  frameIcmpLinux.valid[15] = 1'b1;  frameIcmpLinux.ctrl[15] = 3'b110;
	
    frameIcmpLinux.data[16] = 8'h00;  frameIcmpLinux.valid[16] = 1'b1;  frameIcmpLinux.ctrl[16] = 3'b110;// 16 bit total length (0054:84)
    frameIcmpLinux.data[17] = 8'h54;  frameIcmpLinux.valid[17] = 1'b1;  frameIcmpLinux.ctrl[17] = 3'b110;
	
    frameIcmpLinux.data[18] = 8'h00;  frameIcmpLinux.valid[18] = 1'b1;  frameIcmpLinux.ctrl[18] = 3'b110;
    frameIcmpLinux.data[19] = 8'h00;  frameIcmpLinux.valid[19] = 1'b1;  frameIcmpLinux.ctrl[19] = 3'b110;
    frameIcmpLinux.data[20] = 8'h40;  frameIcmpLinux.valid[20] = 1'b1;  frameIcmpLinux.ctrl[20] = 3'b110;
    frameIcmpLinux.data[21] = 8'h00;  frameIcmpLinux.valid[21] = 1'b1;  frameIcmpLinux.ctrl[21] = 3'b110;
    frameIcmpLinux.data[22] = 8'h40;  frameIcmpLinux.valid[22] = 1'b1;  frameIcmpLinux.ctrl[22] = 3'b110;
	
    frameIcmpLinux.data[23] = 8'h01;  frameIcmpLinux.valid[23] = 1'b1;  frameIcmpLinux.ctrl[23] = 3'b110;// Protocol (icmp: 0x01)
	
    frameIcmpLinux.data[24] = 8'h1c;  frameIcmpLinux.valid[24] = 1'b1;  frameIcmpLinux.ctrl[24] = 3'b110;// Header checker
    frameIcmpLinux.data[25] = 8'h8c;  frameIcmpLinux.valid[25] = 1'b1;  frameIcmpLinux.ctrl[25] = 3'b110;
	
    frameIcmpLinux.data[26] = 8'h0a;  frameIcmpLinux.valid[26] = 1'b1;  frameIcmpLinux.ctrl[26] = 3'b110;// Source IP
    frameIcmpLinux.data[27] = 8'ha0;  frameIcmpLinux.valid[27] = 1'b1;  frameIcmpLinux.ctrl[27] = 3'b110;
    frameIcmpLinux.data[28] = 8'h84;  frameIcmpLinux.valid[28] = 1'b1;  frameIcmpLinux.ctrl[28] = 3'b110;
    frameIcmpLinux.data[29] = 8'h64;  frameIcmpLinux.valid[29] = 1'b1;  frameIcmpLinux.ctrl[29] = 3'b110;
	
    frameIcmpLinux.data[30] = 8'h0a;  frameIcmpLinux.valid[30] = 1'b1;  frameIcmpLinux.ctrl[30] = 3'b110;// Destination IP
    frameIcmpLinux.data[31] = 8'ha0;  frameIcmpLinux.valid[31] = 1'b1;  frameIcmpLinux.ctrl[31] = 3'b110;
    frameIcmpLinux.data[32] = 8'h84;  frameIcmpLinux.valid[32] = 1'b1;  frameIcmpLinux.ctrl[32] = 3'b110;
    frameIcmpLinux.data[33] = 8'h79;  frameIcmpLinux.valid[33] = 1'b1;  frameIcmpLinux.ctrl[33] = 3'b110;
	
    frameIcmpLinux.data[34] = 8'h08;  frameIcmpLinux.valid[34] = 1'b1;  frameIcmpLinux.ctrl[34] = 3'b110;//Ping req	
    frameIcmpLinux.data[35] = 8'h00;  frameIcmpLinux.valid[35] = 1'b1;  frameIcmpLinux.ctrl[35] = 3'b110;//
	
    frameIcmpLinux.data[36] = 8'h00;  frameIcmpLinux.valid[36] = 1'b1;  frameIcmpLinux.ctrl[36] = 3'b110;// Checksum
    frameIcmpLinux.data[37] = 8'h00;  frameIcmpLinux.valid[37] = 1'b1;  frameIcmpLinux.ctrl[37] = 3'b110;
	
    frameIcmpLinux.data[38] = 8'ha7;  frameIcmpLinux.valid[38] = 1'b1;  frameIcmpLinux.ctrl[38] = 3'b110;// identifier
    frameIcmpLinux.data[39] = 8'h43;  frameIcmpLinux.valid[39] = 1'b1;  frameIcmpLinux.ctrl[39] = 3'b110; 
	
    frameIcmpLinux.data[40] = 8'h00;  frameIcmpLinux.valid[40] = 1'b1;  frameIcmpLinux.ctrl[40] = 3'b110;// Seq num
    frameIcmpLinux.data[41] = 8'h09;  frameIcmpLinux.valid[41] = 1'b1;  frameIcmpLinux.ctrl[41] = 3'b110;
		
    frameIcmpLinux.data[42] = 8'h66;  frameIcmpLinux.valid[42] = 1'b1;  frameIcmpLinux.ctrl[42] = 3'b110;// Data
    frameIcmpLinux.data[43] = 8'h1c;  frameIcmpLinux.valid[43] = 1'b1;  frameIcmpLinux.ctrl[43] = 3'b110;
    frameIcmpLinux.data[44] = 8'h71;  frameIcmpLinux.valid[44] = 1'b1;  frameIcmpLinux.ctrl[44] = 3'b110;
    frameIcmpLinux.data[45] = 8'h50;  frameIcmpLinux.valid[45] = 1'b1;  frameIcmpLinux.ctrl[45] = 3'b110;
	
    frameIcmpLinux.data[46] = 8'h00;  frameIcmpLinux.valid[46] = 1'b1;  frameIcmpLinux.ctrl[46] = 3'b110;
    frameIcmpLinux.data[47] = 8'h00;  frameIcmpLinux.valid[47] = 1'b1;  frameIcmpLinux.ctrl[47] = 3'b110;
    frameIcmpLinux.data[48] = 8'h00;  frameIcmpLinux.valid[48] = 1'b1;  frameIcmpLinux.ctrl[48] = 3'b110;
    frameIcmpLinux.data[49] = 8'h00;  frameIcmpLinux.valid[49] = 1'b1;  frameIcmpLinux.ctrl[49] = 3'b110;
	
    frameIcmpLinux.data[50] = 8'h47;  frameIcmpLinux.valid[50] = 1'b1;  frameIcmpLinux.ctrl[50] = 3'b110;//
    frameIcmpLinux.data[51] = 8'hf4;  frameIcmpLinux.valid[51] = 1'b1;  frameIcmpLinux.ctrl[51] = 3'b110;
    frameIcmpLinux.data[52] = 8'h08;  frameIcmpLinux.valid[52] = 1'b1;  frameIcmpLinux.ctrl[52] = 3'b110;
    frameIcmpLinux.data[53] = 8'h00;  frameIcmpLinux.valid[53] = 1'b1;  frameIcmpLinux.ctrl[53] = 3'b110;
    
	 frameIcmpLinux.data[54] = 8'h00;  frameIcmpLinux.valid[54] = 1'b1;  frameIcmpLinux.ctrl[54] = 3'b110;
    frameIcmpLinux.data[55] = 8'h00;  frameIcmpLinux.valid[55] = 1'b1;  frameIcmpLinux.ctrl[55] = 3'b110;
    frameIcmpLinux.data[56] = 8'h00;  frameIcmpLinux.valid[56] = 1'b1;  frameIcmpLinux.ctrl[56] = 3'b110;
    frameIcmpLinux.data[57] = 8'h00;  frameIcmpLinux.valid[57] = 1'b1;  frameIcmpLinux.ctrl[57] = 3'b110;
	
	 frameIcmpLinux.data[58] = 8'h10;  frameIcmpLinux.valid[58] = 1'b1;  frameIcmpLinux.ctrl[58] = 3'b110;
    frameIcmpLinux.data[59] = 8'h11;  frameIcmpLinux.valid[59] = 1'b1;  frameIcmpLinux.ctrl[59] = 3'b110;
    frameIcmpLinux.data[60] = 8'h12;  frameIcmpLinux.valid[60] = 1'b1;  frameIcmpLinux.ctrl[60] = 3'b110;
    frameIcmpLinux.data[61] = 8'h13;  frameIcmpLinux.valid[61] = 1'b1;  frameIcmpLinux.ctrl[61] = 3'b110;
    frameIcmpLinux.data[62] = 8'h14;  frameIcmpLinux.valid[62] = 1'b1;  frameIcmpLinux.ctrl[62] = 3'b110;
    frameIcmpLinux.data[63] = 8'h15;  frameIcmpLinux.valid[63] = 1'b1;  frameIcmpLinux.ctrl[63] = 3'b110;
    frameIcmpLinux.data[64] = 8'h16;  frameIcmpLinux.valid[64] = 1'b1;  frameIcmpLinux.ctrl[64] = 3'b110;
    frameIcmpLinux.data[65] = 8'h17;  frameIcmpLinux.valid[65] = 1'b1;  frameIcmpLinux.ctrl[65] = 3'b110; 
    frameIcmpLinux.data[66] = 8'h18;  frameIcmpLinux.valid[66] = 1'b1;  frameIcmpLinux.ctrl[66] = 3'b110;
    frameIcmpLinux.data[67] = 8'h19;  frameIcmpLinux.valid[67] = 1'b1;  frameIcmpLinux.ctrl[67] = 3'b110;
    frameIcmpLinux.data[68] = 8'h1a;  frameIcmpLinux.valid[68] = 1'b1;  frameIcmpLinux.ctrl[68] = 3'b110;
    frameIcmpLinux.data[69] = 8'h1b;  frameIcmpLinux.valid[69] = 1'b1;  frameIcmpLinux.ctrl[69] = 3'b110;	 
    frameIcmpLinux.data[70] = 8'h1c;  frameIcmpLinux.valid[70] = 1'b1;  frameIcmpLinux.ctrl[70] = 3'b110;
    frameIcmpLinux.data[71] = 8'h1d;  frameIcmpLinux.valid[71] = 1'b1;  frameIcmpLinux.ctrl[71] = 3'b110;
    frameIcmpLinux.data[72] = 8'h1e;  frameIcmpLinux.valid[72] = 1'b1;  frameIcmpLinux.ctrl[72] = 3'b110;
    frameIcmpLinux.data[73] = 8'h1f;  frameIcmpLinux.valid[73] = 1'b1;  frameIcmpLinux.ctrl[73] = 3'b110;
    frameIcmpLinux.data[74] = 8'h20;  frameIcmpLinux.valid[74] = 1'b1;  frameIcmpLinux.ctrl[74] = 3'b110;
    frameIcmpLinux.data[75] = 8'h21;  frameIcmpLinux.valid[75] = 1'b1;  frameIcmpLinux.ctrl[75] = 3'b110;
    frameIcmpLinux.data[76] = 8'h22;  frameIcmpLinux.valid[76] = 1'b1;  frameIcmpLinux.ctrl[76] = 3'b110;
    frameIcmpLinux.data[77] = 8'h23;  frameIcmpLinux.valid[77] = 1'b1;  frameIcmpLinux.ctrl[77] = 3'b110;
    frameIcmpLinux.data[78] = 8'h24;  frameIcmpLinux.valid[78] = 1'b1;  frameIcmpLinux.ctrl[78] = 3'b110;
    frameIcmpLinux.data[79] = 8'h25;  frameIcmpLinux.valid[79] = 1'b1;  frameIcmpLinux.ctrl[79] = 3'b110;
    frameIcmpLinux.data[80] = 8'h26;  frameIcmpLinux.valid[80] = 1'b1;  frameIcmpLinux.ctrl[80] = 3'b110;
    frameIcmpLinux.data[81] = 8'h27;  frameIcmpLinux.valid[81] = 1'b1;  frameIcmpLinux.ctrl[81] = 3'b110;

	frameIcmpLinux.data[82] = 8'h28;  frameIcmpLinux.valid[82] = 1'b1;  frameIcmpLinux.ctrl[82] = 3'b110;
    frameIcmpLinux.data[83] = 8'h29;  frameIcmpLinux.valid[83] = 1'b1;  frameIcmpLinux.ctrl[83] = 3'b110;
    frameIcmpLinux.data[84] = 8'h2a;  frameIcmpLinux.valid[84] = 1'b1;  frameIcmpLinux.ctrl[84] = 3'b110;
    frameIcmpLinux.data[85] = 8'h2b;  frameIcmpLinux.valid[85] = 1'b1;  frameIcmpLinux.ctrl[85] = 3'b110;
    frameIcmpLinux.data[86] = 8'h2c;  frameIcmpLinux.valid[86] = 1'b1;  frameIcmpLinux.ctrl[86] = 3'b110;
    frameIcmpLinux.data[87] = 8'h2d;  frameIcmpLinux.valid[87] = 1'b1;  frameIcmpLinux.ctrl[87] = 3'b110;
    frameIcmpLinux.data[88] = 8'h2e;  frameIcmpLinux.valid[88] = 1'b1;  frameIcmpLinux.ctrl[88] = 3'b110;
    frameIcmpLinux.data[89] = 8'h2f;  frameIcmpLinux.valid[89] = 1'b1;  frameIcmpLinux.ctrl[89] = 3'b110;
    frameIcmpLinux.data[90] = 8'h30;  frameIcmpLinux.valid[90] = 1'b1;  frameIcmpLinux.ctrl[90] = 3'b110;
    frameIcmpLinux.data[91] = 8'h31;  frameIcmpLinux.valid[91] = 1'b1;  frameIcmpLinux.ctrl[91] = 3'b110;
    frameIcmpLinux.data[92] = 8'h32;  frameIcmpLinux.valid[92] = 1'b1;  frameIcmpLinux.ctrl[92] = 3'b110;
    frameIcmpLinux.data[93] = 8'h33;  frameIcmpLinux.valid[93] = 1'b1;  frameIcmpLinux.ctrl[93] = 3'b110;
    frameIcmpLinux.data[94] = 8'h34;  frameIcmpLinux.valid[94] = 1'b1;  frameIcmpLinux.ctrl[94] = 3'b110;
    frameIcmpLinux.data[95] = 8'h35;  frameIcmpLinux.valid[95] = 1'b1;  frameIcmpLinux.ctrl[95] = 3'b110;
    frameIcmpLinux.data[96] = 8'h36;  frameIcmpLinux.valid[96] = 1'b1;  frameIcmpLinux.ctrl[96] = 3'b110;
    frameIcmpLinux.data[97] = 8'h37;  frameIcmpLinux.valid[97] = 1'b1;  frameIcmpLinux.ctrl[97] = 3'b100;	 // 82th Byte of Data
 
 //frameUdpDtc :  dtc0_cmd_test.txt
  // write to fee0
  // write 0x12345678 to 0x60
  // read 0x60
  // read 0x4e (fee verison: 0x50)
    //-----------
    // Frame 2
    //-----------
    frameUdpDtc.data[0]  = 8'h0a;  frameUdpDtc.valid[0]  = 1'b1;  frameUdpDtc.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpDtc.data[1]  = 8'h35;  frameUdpDtc.valid[1]  = 1'b1;  frameUdpDtc.ctrl[1]  = 3'b110;
    frameUdpDtc.data[2]  = 8'h0a;  frameUdpDtc.valid[2]  = 1'b1;  frameUdpDtc.ctrl[2]  = 3'b110;
    frameUdpDtc.data[3]  = 8'ha0;  frameUdpDtc.valid[3]  = 1'b1;  frameUdpDtc.ctrl[3]  = 3'b110;
    frameUdpDtc.data[4]  = 8'h84;  frameUdpDtc.valid[4]  = 1'b1;  frameUdpDtc.ctrl[4]  = 3'b110;
    frameUdpDtc.data[5]  = 8'h79;  frameUdpDtc.valid[5]  = 1'b1;  frameUdpDtc.ctrl[5]  = 3'b110;
	
    frameUdpDtc.data[6]  = 8'h00;  frameUdpDtc.valid[6]  = 1'b1;  frameUdpDtc.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpDtc.data[7]  = 8'h30;  frameUdpDtc.valid[7]  = 1'b1;  frameUdpDtc.ctrl[7]  = 3'b110;
    frameUdpDtc.data[8]  = 8'h48;  frameUdpDtc.valid[8]  = 1'b1;  frameUdpDtc.ctrl[8]  = 3'b110;
    frameUdpDtc.data[9]  = 8'hc1;  frameUdpDtc.valid[9]  = 1'b1;  frameUdpDtc.ctrl[9]  = 3'b110;
    frameUdpDtc.data[10] = 8'h08;  frameUdpDtc.valid[10] = 1'b1;  frameUdpDtc.ctrl[10] = 3'b110;
    frameUdpDtc.data[11] = 8'h79;  frameUdpDtc.valid[11] = 1'b1;  frameUdpDtc.ctrl[11] = 3'b110;
	
    frameUdpDtc.data[12] = 8'h08;  frameUdpDtc.valid[12] = 1'b1;  frameUdpDtc.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpDtc.data[13] = 8'h00;  frameUdpDtc.valid[13] = 1'b1;  frameUdpDtc.ctrl[13] = 3'b110;
   
    frameUdpDtc.data[14] = 8'h45;  frameUdpDtc.valid[14] = 1'b1;  frameUdpDtc.ctrl[14] = 3'b110;
    frameUdpDtc.data[15] = 8'h00;  frameUdpDtc.valid[15] = 1'b1;  frameUdpDtc.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpDtc.data[16] = 8'h00;  frameUdpDtc.valid[16] = 1'b1;  frameUdpDtc.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpDtc.data[17] = 8'h3c;  frameUdpDtc.valid[17] = 1'b1;  frameUdpDtc.ctrl[17] = 3'b110;
	
    frameUdpDtc.data[18] = 8'h00;  frameUdpDtc.valid[18] = 1'b1;  frameUdpDtc.ctrl[18] = 3'b110;
    frameUdpDtc.data[19] = 8'h00;  frameUdpDtc.valid[19] = 1'b1;  frameUdpDtc.ctrl[19] = 3'b110;
    frameUdpDtc.data[20] = 8'h40;  frameUdpDtc.valid[20] = 1'b1;  frameUdpDtc.ctrl[20] = 3'b110;
    frameUdpDtc.data[21] = 8'h00;  frameUdpDtc.valid[21] = 1'b1;  frameUdpDtc.ctrl[21] = 3'b110;
    frameUdpDtc.data[22] = 8'h40;  frameUdpDtc.valid[22] = 1'b1;  frameUdpDtc.ctrl[22] = 3'b110;
	
    frameUdpDtc.data[23] = 8'h11;  frameUdpDtc.valid[23] = 1'b1;  frameUdpDtc.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpDtc.data[24] = 8'hb6;  frameUdpDtc.valid[24] = 1'b1;  frameUdpDtc.ctrl[24] = 3'b110;// Header checker
    frameUdpDtc.data[25] = 8'hf8;  frameUdpDtc.valid[25] = 1'b1;  frameUdpDtc.ctrl[25] = 3'b110;
	
    frameUdpDtc.data[26] = 8'hc0;  frameUdpDtc.valid[26] = 1'b1;  frameUdpDtc.ctrl[26] = 3'b110;// Source IP
    frameUdpDtc.data[27] = 8'ha8;  frameUdpDtc.valid[27] = 1'b1;  frameUdpDtc.ctrl[27] = 3'b110;
    frameUdpDtc.data[28] = 8'h01;  frameUdpDtc.valid[28] = 1'b1;  frameUdpDtc.ctrl[28] = 3'b110;
    frameUdpDtc.data[29] = 8'h3f;  frameUdpDtc.valid[29] = 1'b1;  frameUdpDtc.ctrl[29] = 3'b110;
	
    frameUdpDtc.data[30] = 8'h0a;  frameUdpDtc.valid[30] = 1'b1;  frameUdpDtc.ctrl[30] = 3'b110;// Destination IP
    frameUdpDtc.data[31] = 8'ha0;  frameUdpDtc.valid[31] = 1'b1;  frameUdpDtc.ctrl[31] = 3'b110;
    frameUdpDtc.data[32] = 8'h84;  frameUdpDtc.valid[32] = 1'b1;  frameUdpDtc.ctrl[32] = 3'b110;
    frameUdpDtc.data[33] = 8'h79;  frameUdpDtc.valid[33] = 1'b1;  frameUdpDtc.ctrl[33] = 3'b110;
	
    frameUdpDtc.data[34] = 8'h17;  frameUdpDtc.valid[34] = 1'b1;  frameUdpDtc.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpDtc.data[35] = 8'h77;  frameUdpDtc.valid[35] = 1'b1;  frameUdpDtc.ctrl[35] = 3'b110;
	
    frameUdpDtc.data[36] = 8'h10;  frameUdpDtc.valid[36] = 1'b1;  frameUdpDtc.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpDtc.data[37] = 8'h01;  frameUdpDtc.valid[37] = 1'b1;  frameUdpDtc.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpDtc.data[38] = 8'h00;  frameUdpDtc.valid[38] = 1'b1;  frameUdpDtc.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpDtc.data[39] = 8'h28;  frameUdpDtc.valid[39] = 1'b1;  frameUdpDtc.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpDtc.data[40] = 8'h00;  frameUdpDtc.valid[40] = 1'b1;  frameUdpDtc.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpDtc.data[41] = 8'h00;  frameUdpDtc.valid[41] = 1'b1;  frameUdpDtc.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpDtc.data[42] = 8'h00;  frameUdpDtc.valid[42] = 1'b1;  frameUdpDtc.ctrl[42] = 3'b110;// dtc_sel: dtc0
    frameUdpDtc.data[43] = 8'h00;  frameUdpDtc.valid[43] = 1'b1;  frameUdpDtc.ctrl[43] = 3'b110;
    frameUdpDtc.data[44] = 8'h00;  frameUdpDtc.valid[44] = 1'b1;  frameUdpDtc.ctrl[44] = 3'b110;
    frameUdpDtc.data[45] = 8'h00;  frameUdpDtc.valid[45] = 1'b1;  frameUdpDtc.ctrl[45] = 3'b110;
	
    frameUdpDtc.data[46] = 8'h00;  frameUdpDtc.valid[46] = 1'b1;  frameUdpDtc.ctrl[46] = 3'b110;
    frameUdpDtc.data[47] = 8'h00;  frameUdpDtc.valid[47] = 1'b1;  frameUdpDtc.ctrl[47] = 3'b110;
    frameUdpDtc.data[48] = 8'h00;  frameUdpDtc.valid[48] = 1'b1;  frameUdpDtc.ctrl[48] = 3'b110;
    frameUdpDtc.data[49] = 8'h01;  frameUdpDtc.valid[49] = 1'b1;  frameUdpDtc.ctrl[49] = 3'b110;
	//change it according to the frame	
    frameUdpDtc.data[50] = 8'h00;  frameUdpDtc.valid[50] = 1'b1;  frameUdpDtc.ctrl[50] = 3'b110;//wcmd: 0x60 : 0x12345678
    frameUdpDtc.data[51] = 8'h00;  frameUdpDtc.valid[51] = 1'b1;  frameUdpDtc.ctrl[51] = 3'b110;
    frameUdpDtc.data[52] = 8'h00;  frameUdpDtc.valid[52] = 1'b1;  frameUdpDtc.ctrl[52] = 3'b110;
    frameUdpDtc.data[53] = 8'h60;  frameUdpDtc.valid[53] = 1'b1;  frameUdpDtc.ctrl[53] = 3'b110;
    
	 frameUdpDtc.data[54] = 8'h00;  frameUdpDtc.valid[54] = 1'b1;  frameUdpDtc.ctrl[54] = 3'b110;
    frameUdpDtc.data[55] = 8'h00;  frameUdpDtc.valid[55] = 1'b1;  frameUdpDtc.ctrl[55] = 3'b110;
    frameUdpDtc.data[56] = 8'h02;  frameUdpDtc.valid[56] = 1'b1;  frameUdpDtc.ctrl[56] = 3'b110;
    frameUdpDtc.data[57] = 8'h10;  frameUdpDtc.valid[57] = 1'b1;  frameUdpDtc.ctrl[57] = 3'b110;   
	
	 frameUdpDtc.data[58] = 8'h80;  frameUdpDtc.valid[58] = 1'b1;  frameUdpDtc.ctrl[58] = 3'b110;//rcmd: 0x60
    frameUdpDtc.data[59] = 8'h00;  frameUdpDtc.valid[59] = 1'b1;  frameUdpDtc.ctrl[59] = 3'b110;
    frameUdpDtc.data[60] = 8'h00;  frameUdpDtc.valid[60] = 1'b1;  frameUdpDtc.ctrl[60] = 3'b110;
    frameUdpDtc.data[61] = 8'h60;  frameUdpDtc.valid[61] = 1'b1;  frameUdpDtc.ctrl[61] = 3'b110;
	
    frameUdpDtc.data[62] = 8'h00;  frameUdpDtc.valid[62] = 1'b1;  frameUdpDtc.ctrl[62] = 3'b110;
    frameUdpDtc.data[63] = 8'h00;  frameUdpDtc.valid[63] = 1'b1;  frameUdpDtc.ctrl[63] = 3'b110;
    frameUdpDtc.data[64] = 8'h00;  frameUdpDtc.valid[64] = 1'b1;  frameUdpDtc.ctrl[64] = 3'b110;
    frameUdpDtc.data[65] = 8'h00;  frameUdpDtc.valid[65] = 1'b1;  frameUdpDtc.ctrl[65] = 3'b110;
	
    frameUdpDtc.data[66] = 8'h80;  frameUdpDtc.valid[66] = 1'b1;  frameUdpDtc.ctrl[66] = 3'b110;//rcmd: 0x4e (fee bc versiion)
    frameUdpDtc.data[67] = 8'h00;  frameUdpDtc.valid[67] = 1'b1;  frameUdpDtc.ctrl[67] = 3'b110;
    frameUdpDtc.data[68] = 8'h00;  frameUdpDtc.valid[68] = 1'b1;  frameUdpDtc.ctrl[68] = 3'b110;
    frameUdpDtc.data[69] = 8'h20;  frameUdpDtc.valid[69] = 1'b1;  frameUdpDtc.ctrl[69] = 3'b110;
	
    frameUdpDtc.data[70] = 8'h00;  frameUdpDtc.valid[70] = 1'b1;  frameUdpDtc.ctrl[70] = 3'b110;
    frameUdpDtc.data[71] = 8'h00;  frameUdpDtc.valid[71] = 1'b1;  frameUdpDtc.ctrl[71] = 3'b110;
    frameUdpDtc.data[72] = 8'h00;  frameUdpDtc.valid[72] = 1'b1;  frameUdpDtc.ctrl[72] = 3'b110;
    frameUdpDtc.data[73] = 8'h00;  frameUdpDtc.valid[73] = 1'b1;  frameUdpDtc.ctrl[73] = 3'b100;
	
    frameUdpDtc.data[74] = 8'h00;  frameUdpDtc.valid[74] = 1'b0;  frameUdpDtc.ctrl[74] = 3'b111;
    frameUdpDtc.data[75] = 8'h00;  frameUdpDtc.valid[75] = 1'b0;  frameUdpDtc.ctrl[75] = 3'b111;
    frameUdpDtc.data[76] = 8'h00;  frameUdpDtc.valid[76] = 1'b0;  frameUdpDtc.ctrl[76] = 3'b111;
    frameUdpDtc.data[77] = 8'h00;  frameUdpDtc.valid[77] = 1'b0;  frameUdpDtc.ctrl[77] = 3'b111;
    frameUdpDtc.data[78] = 8'h00;  frameUdpDtc.valid[78] = 1'b0;  frameUdpDtc.ctrl[78] = 3'b111;
    frameUdpDtc.data[79] = 8'h00;  frameUdpDtc.valid[79] = 1'b0;  frameUdpDtc.ctrl[79] = 3'b111;
    frameUdpDtc.data[80] = 8'h00;  frameUdpDtc.valid[80] = 1'b0;  frameUdpDtc.ctrl[80] = 3'b111;
    frameUdpDtc.data[81] = 8'h00;  frameUdpDtc.valid[81] = 1'b0;  frameUdpDtc.ctrl[81] = 3'b111;	 // 82th Byte of Data


	frameUdpDtc.data[82] = 8'h28;  frameUdpDtc.valid[82] = 1'b0;  frameUdpDtc.ctrl[82] = 3'b111;
    frameUdpDtc.data[83] = 8'h29;  frameUdpDtc.valid[83] = 1'b0;  frameUdpDtc.ctrl[83] = 3'b111;
    frameUdpDtc.data[84] = 8'h2a;  frameUdpDtc.valid[84] = 1'b0;  frameUdpDtc.ctrl[84] = 3'b111;
    frameUdpDtc.data[85] = 8'h2b;  frameUdpDtc.valid[85] = 1'b0;  frameUdpDtc.ctrl[85] = 3'b111;
    frameUdpDtc.data[86] = 8'h2c;  frameUdpDtc.valid[86] = 1'b0;  frameUdpDtc.ctrl[86] = 3'b111;
    frameUdpDtc.data[87] = 8'h2d;  frameUdpDtc.valid[87] = 1'b0;  frameUdpDtc.ctrl[87] = 3'b111;
    frameUdpDtc.data[88] = 8'h2e;  frameUdpDtc.valid[88] = 1'b0;  frameUdpDtc.ctrl[88] = 3'b111;
    frameUdpDtc.data[89] = 8'h2f;  frameUdpDtc.valid[89] = 1'b0;  frameUdpDtc.ctrl[89] = 3'b111;
    frameUdpDtc.data[90] = 8'h30;  frameUdpDtc.valid[90] = 1'b0;  frameUdpDtc.ctrl[90] = 3'b111;
    frameUdpDtc.data[91] = 8'h31;  frameUdpDtc.valid[91] = 1'b0;  frameUdpDtc.ctrl[91] = 3'b111;
    frameUdpDtc.data[92] = 8'h32;  frameUdpDtc.valid[92] = 1'b0;  frameUdpDtc.ctrl[92] = 3'b111;
    frameUdpDtc.data[93] = 8'h33;  frameUdpDtc.valid[93] = 1'b0;  frameUdpDtc.ctrl[93] = 3'b111;
    frameUdpDtc.data[94] = 8'h34;  frameUdpDtc.valid[94] = 1'b0;  frameUdpDtc.ctrl[94] = 3'b111;
    frameUdpDtc.data[95] = 8'h35;  frameUdpDtc.valid[95] = 1'b0;  frameUdpDtc.ctrl[95] = 3'b111;
    frameUdpDtc.data[96] = 8'h36;  frameUdpDtc.valid[96] = 1'b0;  frameUdpDtc.ctrl[96] = 3'b111;
    frameUdpDtc.data[97] = 8'h37;  frameUdpDtc.valid[97] = 1'b0;  frameUdpDtc.ctrl[97] = 3'b111;	 // 98th Byte of Data
	
    //-----------
    // Query Flash 
    //-----------	 
    frameUdpFlash.data[0]  = 8'h0a;  frameUdpFlash.valid[0]  = 1'b1;  frameUdpFlash.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpFlash.data[1]  = 8'h35;  frameUdpFlash.valid[1]  = 1'b1;  frameUdpFlash.ctrl[1]  = 3'b110;
    frameUdpFlash.data[2]  = 8'h0a;  frameUdpFlash.valid[2]  = 1'b1;  frameUdpFlash.ctrl[2]  = 3'b110;
    frameUdpFlash.data[3]  = 8'ha0;  frameUdpFlash.valid[3]  = 1'b1;  frameUdpFlash.ctrl[3]  = 3'b110;
    frameUdpFlash.data[4]  = 8'h84;  frameUdpFlash.valid[4]  = 1'b1;  frameUdpFlash.ctrl[4]  = 3'b110;
    frameUdpFlash.data[5]  = 8'h79;  frameUdpFlash.valid[5]  = 1'b1;  frameUdpFlash.ctrl[5]  = 3'b110;
	
    frameUdpFlash.data[6]  = 8'h00;  frameUdpFlash.valid[6]  = 1'b1;  frameUdpFlash.ctrl[6]  = 3'b110; // Source Address (5A)
    frameUdpFlash.data[7]  = 8'h30;  frameUdpFlash.valid[7]  = 1'b1;  frameUdpFlash.ctrl[7]  = 3'b110;
    frameUdpFlash.data[8]  = 8'h48;  frameUdpFlash.valid[8]  = 1'b1;  frameUdpFlash.ctrl[8]  = 3'b110;
    frameUdpFlash.data[9]  = 8'hc1;  frameUdpFlash.valid[9]  = 1'b1;  frameUdpFlash.ctrl[9]  = 3'b110;
    frameUdpFlash.data[10] = 8'h08;  frameUdpFlash.valid[10] = 1'b1;  frameUdpFlash.ctrl[10] = 3'b110;
    frameUdpFlash.data[11] = 8'h79;  frameUdpFlash.valid[11] = 1'b1;  frameUdpFlash.ctrl[11] = 3'b110;
	
    frameUdpFlash.data[12] = 8'h08;  frameUdpFlash.valid[12] = 1'b1;  frameUdpFlash.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpFlash.data[13] = 8'h00;  frameUdpFlash.valid[13] = 1'b1;  frameUdpFlash.ctrl[13] = 3'b110;
   
    frameUdpFlash.data[14] = 8'h45;  frameUdpFlash.valid[14] = 1'b1;  frameUdpFlash.ctrl[14] = 3'b110;
    frameUdpFlash.data[15] = 8'h00;  frameUdpFlash.valid[15] = 1'b1;  frameUdpFlash.ctrl[15] = 3'b110;
	
    frameUdpFlash.data[16] = 8'h00;  frameUdpFlash.valid[16] = 1'b1;  frameUdpFlash.ctrl[16] = 3'b110;// 16 bit total length (0054:84)
    frameUdpFlash.data[17] = 8'h54;  frameUdpFlash.valid[17] = 1'b1;  frameUdpFlash.ctrl[17] = 3'b110;
	
    frameUdpFlash.data[18] = 8'h00;  frameUdpFlash.valid[18] = 1'b1;  frameUdpFlash.ctrl[18] = 3'b110;
    frameUdpFlash.data[19] = 8'h00;  frameUdpFlash.valid[19] = 1'b1;  frameUdpFlash.ctrl[19] = 3'b110;
    frameUdpFlash.data[20] = 8'h40;  frameUdpFlash.valid[20] = 1'b1;  frameUdpFlash.ctrl[20] = 3'b110;
    frameUdpFlash.data[21] = 8'h00;  frameUdpFlash.valid[21] = 1'b1;  frameUdpFlash.ctrl[21] = 3'b110;
    frameUdpFlash.data[22] = 8'h40;  frameUdpFlash.valid[22] = 1'b1;  frameUdpFlash.ctrl[22] = 3'b110;
	
    frameUdpFlash.data[23] = 8'h11;  frameUdpFlash.valid[23] = 1'b1;  frameUdpFlash.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	
    frameUdpFlash.data[24] = 8'h1c;  frameUdpFlash.valid[24] = 1'b1;  frameUdpFlash.ctrl[24] = 3'b110;// Header checker
    frameUdpFlash.data[25] = 8'ha4;  frameUdpFlash.valid[25] = 1'b1;  frameUdpFlash.ctrl[25] = 3'b110;
	
    frameUdpFlash.data[26] = 8'h0a;  frameUdpFlash.valid[26] = 1'b1;  frameUdpFlash.ctrl[26] = 3'b110;// Source IP
    frameUdpFlash.data[27] = 8'ha0;  frameUdpFlash.valid[27] = 1'b1;  frameUdpFlash.ctrl[27] = 3'b110;
    frameUdpFlash.data[28] = 8'h84;  frameUdpFlash.valid[28] = 1'b1;  frameUdpFlash.ctrl[28] = 3'b110;
    frameUdpFlash.data[29] = 8'h64;  frameUdpFlash.valid[29] = 1'b1;  frameUdpFlash.ctrl[29] = 3'b110;
	
    frameUdpFlash.data[30] = 8'h0a;  frameUdpFlash.valid[30] = 1'b1;  frameUdpFlash.ctrl[30] = 3'b110;// Destination IP
    frameUdpFlash.data[31] = 8'ha0;  frameUdpFlash.valid[31] = 1'b1;  frameUdpFlash.ctrl[31] = 3'b110;
    frameUdpFlash.data[32] = 8'h84;  frameUdpFlash.valid[32] = 1'b1;  frameUdpFlash.ctrl[32] = 3'b110;
    frameUdpFlash.data[33] = 8'h79;  frameUdpFlash.valid[33] = 1'b1;  frameUdpFlash.ctrl[33] = 3'b110;
	
    frameUdpFlash.data[34] = 8'h17;  frameUdpFlash.valid[34] = 1'b1;  frameUdpFlash.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpFlash.data[35] = 8'h77;  frameUdpFlash.valid[35] = 1'b1;  frameUdpFlash.ctrl[35] = 3'b110;
	
    frameUdpFlash.data[36] = 8'h27;  frameUdpFlash.valid[36] = 1'b1;  frameUdpFlash.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpFlash.data[37] = 8'h77;  frameUdpFlash.valid[37] = 1'b1;  frameUdpFlash.ctrl[37] = 3'b110;
	
    frameUdpFlash.data[38] = 8'h00;  frameUdpFlash.valid[38] = 1'b1;  frameUdpFlash.ctrl[38] = 3'b110;// UDP length (0x40:64) ???
    frameUdpFlash.data[39] = 8'h18;  frameUdpFlash.valid[39] = 1'b1;  frameUdpFlash.ctrl[39] = 3'b110;
	
    frameUdpFlash.data[40] = 8'h14;  frameUdpFlash.valid[40] = 1'b1;  frameUdpFlash.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpFlash.data[41] = 8'h47;  frameUdpFlash.valid[41] = 1'b1;  frameUdpFlash.ctrl[41] = 3'b110;
		
    frameUdpFlash.data[42] = 8'hb9;  frameUdpFlash.valid[42] = 1'b1;  frameUdpFlash.ctrl[42] = 3'b110;// dtc_sel: sru
    frameUdpFlash.data[43] = 8'h1b;  frameUdpFlash.valid[43] = 1'b1;  frameUdpFlash.ctrl[43] = 3'b110;
    frameUdpFlash.data[44] = 8'h4f;  frameUdpFlash.valid[44] = 1'b1;  frameUdpFlash.ctrl[44] = 3'b110;
    frameUdpFlash.data[45] = 8'haa;  frameUdpFlash.valid[45] = 1'b1;  frameUdpFlash.ctrl[45] = 3'b110;
	
    frameUdpFlash.data[46] = 8'h00;  frameUdpFlash.valid[46] = 1'b1;  frameUdpFlash.ctrl[46] = 3'b110;
    frameUdpFlash.data[47] = 8'h00;  frameUdpFlash.valid[47] = 1'b1;  frameUdpFlash.ctrl[47] = 3'b110;
    frameUdpFlash.data[48] = 8'h00;  frameUdpFlash.valid[48] = 1'b1;  frameUdpFlash.ctrl[48] = 3'b110;
    frameUdpFlash.data[49] = 8'h90;  frameUdpFlash.valid[49] = 1'b1;  frameUdpFlash.ctrl[49] = 3'b110;
	
    frameUdpFlash.data[50] = 8'hbb;  frameUdpFlash.valid[50] = 1'b1;  frameUdpFlash.ctrl[50] = 3'b110;//write command: dtcfeetru_sync_cmd: 0x00 03
    frameUdpFlash.data[51] = 8'haa;  frameUdpFlash.valid[51] = 1'b1;  frameUdpFlash.ctrl[51] = 3'b110;
    frameUdpFlash.data[52] = 8'hff;  frameUdpFlash.valid[52] = 1'b1;  frameUdpFlash.ctrl[52] = 3'b110;
    frameUdpFlash.data[53] = 8'hff;  frameUdpFlash.valid[53] = 1'b1;  frameUdpFlash.ctrl[53] = 3'b110;
    
	 frameUdpFlash.data[54] = 8'h00;  frameUdpFlash.valid[54] = 1'b1;  frameUdpFlash.ctrl[54] = 3'b110;//command info
    frameUdpFlash.data[55] = 8'h00;  frameUdpFlash.valid[55] = 1'b1;  frameUdpFlash.ctrl[55] = 3'b110;
    frameUdpFlash.data[56] = 8'h00;  frameUdpFlash.valid[56] = 1'b1;  frameUdpFlash.ctrl[56] = 3'b110;
    frameUdpFlash.data[57] = 8'h00;  frameUdpFlash.valid[57] = 1'b1;  frameUdpFlash.ctrl[57] = 3'b110;
	
	 frameUdpFlash.data[58] = 8'h00;  frameUdpFlash.valid[58] = 1'b1;  frameUdpFlash.ctrl[58] = 3'b110;// unused
    frameUdpFlash.data[59] = 8'h00;  frameUdpFlash.valid[59] = 1'b1;  frameUdpFlash.ctrl[59] = 3'b110;
    frameUdpFlash.data[60] = 8'h00;  frameUdpFlash.valid[60] = 1'b1;  frameUdpFlash.ctrl[60] = 3'b110;
    frameUdpFlash.data[61] = 8'h00;  frameUdpFlash.valid[61] = 1'b1;  frameUdpFlash.ctrl[61] = 3'b110;
	
    frameUdpFlash.data[62] = 8'h00;  frameUdpFlash.valid[62] = 1'b1;  frameUdpFlash.ctrl[62] = 3'b110;
    frameUdpFlash.data[63] = 8'h00;  frameUdpFlash.valid[63] = 1'b1;  frameUdpFlash.ctrl[63] = 3'b110;
    frameUdpFlash.data[64] = 8'h00;  frameUdpFlash.valid[64] = 1'b1;  frameUdpFlash.ctrl[64] = 3'b110;
    frameUdpFlash.data[65] = 8'h01;  frameUdpFlash.valid[65] = 1'b1;  frameUdpFlash.ctrl[65] = 3'b110; //read command 1
	
    frameUdpFlash.data[66] = 8'h00;  frameUdpFlash.valid[66] = 1'b1;  frameUdpFlash.ctrl[66] = 3'b110;
    frameUdpFlash.data[67] = 8'h00;  frameUdpFlash.valid[67] = 1'b1;  frameUdpFlash.ctrl[67] = 3'b110;
    frameUdpFlash.data[68] = 8'h00;  frameUdpFlash.valid[68] = 1'b1;  frameUdpFlash.ctrl[68] = 3'b110;
    frameUdpFlash.data[69] = 8'h02;  frameUdpFlash.valid[69] = 1'b1;  frameUdpFlash.ctrl[69] = 3'b110;
	
    frameUdpFlash.data[70] = 8'h00;  frameUdpFlash.valid[70] = 1'b1;  frameUdpFlash.ctrl[70] = 3'b110;
    frameUdpFlash.data[71] = 8'h00;  frameUdpFlash.valid[71] = 1'b1;  frameUdpFlash.ctrl[71] = 3'b110;
    frameUdpFlash.data[72] = 8'h00;  frameUdpFlash.valid[72] = 1'b1;  frameUdpFlash.ctrl[72] = 3'b110;
    frameUdpFlash.data[73] = 8'h81;  frameUdpFlash.valid[73] = 1'b1;  frameUdpFlash.ctrl[73] = 3'b110;
	
    frameUdpFlash.data[74] = 8'h00;  frameUdpFlash.valid[74] = 1'b1;  frameUdpFlash.ctrl[74] = 3'b110;
    frameUdpFlash.data[75] = 8'h00;  frameUdpFlash.valid[75] = 1'b1;  frameUdpFlash.ctrl[75] = 3'b110;
    frameUdpFlash.data[76] = 8'h00;  frameUdpFlash.valid[76] = 1'b1;  frameUdpFlash.ctrl[76] = 3'b110;
    frameUdpFlash.data[77] = 8'h82;  frameUdpFlash.valid[77] = 1'b1;  frameUdpFlash.ctrl[77] = 3'b110;	 
	
    frameUdpFlash.data[78] = 8'h00;  frameUdpFlash.valid[78] = 1'b1;  frameUdpFlash.ctrl[78] = 3'b110;
    frameUdpFlash.data[79] = 8'h00;  frameUdpFlash.valid[79] = 1'b1;  frameUdpFlash.ctrl[79] = 3'b110;
    frameUdpFlash.data[80] = 8'h00;  frameUdpFlash.valid[80] = 1'b1;  frameUdpFlash.ctrl[80] = 3'b110;
    frameUdpFlash.data[81] = 8'h83;  frameUdpFlash.valid[81] = 1'b1;  frameUdpFlash.ctrl[81] = 3'b110;

	frameUdpFlash.data[82] = 8'h00;  frameUdpFlash.valid[82] = 1'b1;  frameUdpFlash.ctrl[82] = 3'b110;
    frameUdpFlash.data[83] = 8'h00;  frameUdpFlash.valid[83] = 1'b1;  frameUdpFlash.ctrl[83] = 3'b110;
    frameUdpFlash.data[84] = 8'h00;  frameUdpFlash.valid[84] = 1'b1;  frameUdpFlash.ctrl[84] = 3'b110;
    frameUdpFlash.data[85] = 8'h85;  frameUdpFlash.valid[85] = 1'b1;  frameUdpFlash.ctrl[85] = 3'b110;
	
    frameUdpFlash.data[86] = 8'h00;  frameUdpFlash.valid[86] = 1'b1;  frameUdpFlash.ctrl[86] = 3'b110;
    frameUdpFlash.data[87] = 8'h00;  frameUdpFlash.valid[87] = 1'b1;  frameUdpFlash.ctrl[87] = 3'b110;
    frameUdpFlash.data[88] = 8'h00;  frameUdpFlash.valid[88] = 1'b1;  frameUdpFlash.ctrl[88] = 3'b110;
    frameUdpFlash.data[89] = 8'h86;  frameUdpFlash.valid[89] = 1'b1;  frameUdpFlash.ctrl[89] = 3'b110;
	
    frameUdpFlash.data[90] = 8'h00;  frameUdpFlash.valid[90] = 1'b1;  frameUdpFlash.ctrl[90] = 3'b110;
    frameUdpFlash.data[91] = 8'h00;  frameUdpFlash.valid[91] = 1'b1;  frameUdpFlash.ctrl[91] = 3'b110;
    frameUdpFlash.data[92] = 8'h00;  frameUdpFlash.valid[92] = 1'b1;  frameUdpFlash.ctrl[92] = 3'b110;
    frameUdpFlash.data[93] = 8'h87;  frameUdpFlash.valid[93] = 1'b1;  frameUdpFlash.ctrl[93] = 3'b110;
	
    frameUdpFlash.data[94] = 8'h00;  frameUdpFlash.valid[94] = 1'b1;  frameUdpFlash.ctrl[94] = 3'b110;
    frameUdpFlash.data[95] = 8'h00;  frameUdpFlash.valid[95] = 1'b1;  frameUdpFlash.ctrl[95] = 3'b110;
    frameUdpFlash.data[96] = 8'h00;  frameUdpFlash.valid[96] = 1'b1;  frameUdpFlash.ctrl[96] = 3'b110;
    frameUdpFlash.data[97] = 8'h88;  frameUdpFlash.valid[97] = 1'b1;  frameUdpFlash.ctrl[97] = 3'b100;	 // 98th Byte of Data

    //-----------
    // Read SRU IP and Version number, sent a software trigger
    //-----------
    frameUdpSruRdVer.data[0]  = 8'h0a;  frameUdpSruRdVer.valid[0]  = 1'b1;  frameUdpSruRdVer.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruRdVer.data[1]  = 8'h35;  frameUdpSruRdVer.valid[1]  = 1'b1;  frameUdpSruRdVer.ctrl[1]  = 3'b110;
    frameUdpSruRdVer.data[2]  = 8'h0a;  frameUdpSruRdVer.valid[2]  = 1'b1;  frameUdpSruRdVer.ctrl[2]  = 3'b110;
    frameUdpSruRdVer.data[3]  = 8'ha0;  frameUdpSruRdVer.valid[3]  = 1'b1;  frameUdpSruRdVer.ctrl[3]  = 3'b110;
    frameUdpSruRdVer.data[4]  = 8'h84;  frameUdpSruRdVer.valid[4]  = 1'b1;  frameUdpSruRdVer.ctrl[4]  = 3'b110;
    frameUdpSruRdVer.data[5]  = 8'h79;  frameUdpSruRdVer.valid[5]  = 1'b1;  frameUdpSruRdVer.ctrl[5]  = 3'b110;
	
    frameUdpSruRdVer.data[6]  = 8'h00;  frameUdpSruRdVer.valid[6]  = 1'b1;  frameUdpSruRdVer.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruRdVer.data[7]  = 8'h30;  frameUdpSruRdVer.valid[7]  = 1'b1;  frameUdpSruRdVer.ctrl[7]  = 3'b110;
    frameUdpSruRdVer.data[8]  = 8'h48;  frameUdpSruRdVer.valid[8]  = 1'b1;  frameUdpSruRdVer.ctrl[8]  = 3'b110;
    frameUdpSruRdVer.data[9]  = 8'hc1;  frameUdpSruRdVer.valid[9]  = 1'b1;  frameUdpSruRdVer.ctrl[9]  = 3'b110;
    frameUdpSruRdVer.data[10] = 8'h08;  frameUdpSruRdVer.valid[10] = 1'b1;  frameUdpSruRdVer.ctrl[10] = 3'b110;
    frameUdpSruRdVer.data[11] = 8'h79;  frameUdpSruRdVer.valid[11] = 1'b1;  frameUdpSruRdVer.ctrl[11] = 3'b110;
	
    frameUdpSruRdVer.data[12] = 8'h08;  frameUdpSruRdVer.valid[12] = 1'b1;  frameUdpSruRdVer.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruRdVer.data[13] = 8'h00;  frameUdpSruRdVer.valid[13] = 1'b1;  frameUdpSruRdVer.ctrl[13] = 3'b110;
   
    frameUdpSruRdVer.data[14] = 8'h45;  frameUdpSruRdVer.valid[14] = 1'b1;  frameUdpSruRdVer.ctrl[14] = 3'b110;
    frameUdpSruRdVer.data[15] = 8'h00;  frameUdpSruRdVer.valid[15] = 1'b1;  frameUdpSruRdVer.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruRdVer.data[16] = 8'h00;  frameUdpSruRdVer.valid[16] = 1'b1;  frameUdpSruRdVer.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruRdVer.data[17] = 8'h3c;  frameUdpSruRdVer.valid[17] = 1'b1;  frameUdpSruRdVer.ctrl[17] = 3'b110;
	
    frameUdpSruRdVer.data[18] = 8'h00;  frameUdpSruRdVer.valid[18] = 1'b1;  frameUdpSruRdVer.ctrl[18] = 3'b110;
    frameUdpSruRdVer.data[19] = 8'h00;  frameUdpSruRdVer.valid[19] = 1'b1;  frameUdpSruRdVer.ctrl[19] = 3'b110;
    frameUdpSruRdVer.data[20] = 8'h40;  frameUdpSruRdVer.valid[20] = 1'b1;  frameUdpSruRdVer.ctrl[20] = 3'b110;
    frameUdpSruRdVer.data[21] = 8'h00;  frameUdpSruRdVer.valid[21] = 1'b1;  frameUdpSruRdVer.ctrl[21] = 3'b110;
    frameUdpSruRdVer.data[22] = 8'h40;  frameUdpSruRdVer.valid[22] = 1'b1;  frameUdpSruRdVer.ctrl[22] = 3'b110;
	
    frameUdpSruRdVer.data[23] = 8'h11;  frameUdpSruRdVer.valid[23] = 1'b1;  frameUdpSruRdVer.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruRdVer.data[24] = 8'hb6;  frameUdpSruRdVer.valid[24] = 1'b1;  frameUdpSruRdVer.ctrl[24] = 3'b110;// Header checker
    frameUdpSruRdVer.data[25] = 8'hf8;  frameUdpSruRdVer.valid[25] = 1'b1;  frameUdpSruRdVer.ctrl[25] = 3'b110;
	
    frameUdpSruRdVer.data[26] = 8'hc0;  frameUdpSruRdVer.valid[26] = 1'b1;  frameUdpSruRdVer.ctrl[26] = 3'b110;// Source IP
    frameUdpSruRdVer.data[27] = 8'ha8;  frameUdpSruRdVer.valid[27] = 1'b1;  frameUdpSruRdVer.ctrl[27] = 3'b110;
    frameUdpSruRdVer.data[28] = 8'h01;  frameUdpSruRdVer.valid[28] = 1'b1;  frameUdpSruRdVer.ctrl[28] = 3'b110;
    frameUdpSruRdVer.data[29] = 8'h3f;  frameUdpSruRdVer.valid[29] = 1'b1;  frameUdpSruRdVer.ctrl[29] = 3'b110;
	
    frameUdpSruRdVer.data[30] = 8'h0a;  frameUdpSruRdVer.valid[30] = 1'b1;  frameUdpSruRdVer.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruRdVer.data[31] = 8'ha0;  frameUdpSruRdVer.valid[31] = 1'b1;  frameUdpSruRdVer.ctrl[31] = 3'b110;
    frameUdpSruRdVer.data[32] = 8'h84;  frameUdpSruRdVer.valid[32] = 1'b1;  frameUdpSruRdVer.ctrl[32] = 3'b110;
    frameUdpSruRdVer.data[33] = 8'h79;  frameUdpSruRdVer.valid[33] = 1'b1;  frameUdpSruRdVer.ctrl[33] = 3'b110;
	
    frameUdpSruRdVer.data[34] = 8'h17;  frameUdpSruRdVer.valid[34] = 1'b1;  frameUdpSruRdVer.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruRdVer.data[35] = 8'h77;  frameUdpSruRdVer.valid[35] = 1'b1;  frameUdpSruRdVer.ctrl[35] = 3'b110;
	
    frameUdpSruRdVer.data[36] = 8'h10;  frameUdpSruRdVer.valid[36] = 1'b1;  frameUdpSruRdVer.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruRdVer.data[37] = 8'h01;  frameUdpSruRdVer.valid[37] = 1'b1;  frameUdpSruRdVer.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruRdVer.data[38] = 8'h00;  frameUdpSruRdVer.valid[38] = 1'b1;  frameUdpSruRdVer.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruRdVer.data[39] = 8'h28;  frameUdpSruRdVer.valid[39] = 1'b1;  frameUdpSruRdVer.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruRdVer.data[40] = 8'h00;  frameUdpSruRdVer.valid[40] = 1'b1;  frameUdpSruRdVer.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruRdVer.data[41] = 8'h00;  frameUdpSruRdVer.valid[41] = 1'b1;  frameUdpSruRdVer.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruRdVer.data[42] = 8'h00;  frameUdpSruRdVer.valid[42] = 1'b1;  frameUdpSruRdVer.ctrl[42] = 3'b110;// SRU
    frameUdpSruRdVer.data[43] = 8'h10;  frameUdpSruRdVer.valid[43] = 1'b1;  frameUdpSruRdVer.ctrl[43] = 3'b110;
    frameUdpSruRdVer.data[44] = 8'h00;  frameUdpSruRdVer.valid[44] = 1'b1;  frameUdpSruRdVer.ctrl[44] = 3'b110;
    frameUdpSruRdVer.data[45] = 8'h00;  frameUdpSruRdVer.valid[45] = 1'b1;  frameUdpSruRdVer.ctrl[45] = 3'b110;
	
    frameUdpSruRdVer.data[46] = 8'h00;  frameUdpSruRdVer.valid[46] = 1'b1;  frameUdpSruRdVer.ctrl[46] = 3'b110;
    frameUdpSruRdVer.data[47] = 8'h00;  frameUdpSruRdVer.valid[47] = 1'b1;  frameUdpSruRdVer.ctrl[47] = 3'b110;
    frameUdpSruRdVer.data[48] = 8'h00;  frameUdpSruRdVer.valid[48] = 1'b1;  frameUdpSruRdVer.ctrl[48] = 3'b110;
    frameUdpSruRdVer.data[49] = 8'h00;  frameUdpSruRdVer.valid[49] = 1'b1;  frameUdpSruRdVer.ctrl[49] = 3'b110;
	//change it according to the frame	
    frameUdpSruRdVer.data[50] = 8'h80;  frameUdpSruRdVer.valid[50] = 1'b1;  frameUdpSruRdVer.ctrl[50] = 3'b110;//Read Reg 0x2: SRU IP
    frameUdpSruRdVer.data[51] = 8'h00;  frameUdpSruRdVer.valid[51] = 1'b1;  frameUdpSruRdVer.ctrl[51] = 3'b110;
    frameUdpSruRdVer.data[52] = 8'h00;  frameUdpSruRdVer.valid[52] = 1'b1;  frameUdpSruRdVer.ctrl[52] = 3'b110;
    frameUdpSruRdVer.data[53] = 8'h02;  frameUdpSruRdVer.valid[53] = 1'b1;  frameUdpSruRdVer.ctrl[53] = 3'b110;
    
	 frameUdpSruRdVer.data[54] = 8'h21;  frameUdpSruRdVer.valid[54] = 1'b1;  frameUdpSruRdVer.ctrl[54] = 3'b110;
    frameUdpSruRdVer.data[55] = 8'h43;  frameUdpSruRdVer.valid[55] = 1'b1;  frameUdpSruRdVer.ctrl[55] = 3'b110;
    frameUdpSruRdVer.data[56] = 8'h65;  frameUdpSruRdVer.valid[56] = 1'b1;  frameUdpSruRdVer.ctrl[56] = 3'b110;
    frameUdpSruRdVer.data[57] = 8'h87;  frameUdpSruRdVer.valid[57] = 1'b1;  frameUdpSruRdVer.ctrl[57] = 3'b110;   
	
	 frameUdpSruRdVer.data[58] = 8'h80;  frameUdpSruRdVer.valid[58] = 1'b1;  frameUdpSruRdVer.ctrl[58] = 3'b110;//Read Reg 0x3: SRU FM ver
    frameUdpSruRdVer.data[59] = 8'h00;  frameUdpSruRdVer.valid[59] = 1'b1;  frameUdpSruRdVer.ctrl[59] = 3'b110;
    frameUdpSruRdVer.data[60] = 8'h00;  frameUdpSruRdVer.valid[60] = 1'b1;  frameUdpSruRdVer.ctrl[60] = 3'b110;
    frameUdpSruRdVer.data[61] = 8'h03;  frameUdpSruRdVer.valid[61] = 1'b1;  frameUdpSruRdVer.ctrl[61] = 3'b110;
	
    frameUdpSruRdVer.data[62] = 8'h00;  frameUdpSruRdVer.valid[62] = 1'b1;  frameUdpSruRdVer.ctrl[62] = 3'b110;
    frameUdpSruRdVer.data[63] = 8'h00;  frameUdpSruRdVer.valid[63] = 1'b1;  frameUdpSruRdVer.ctrl[63] = 3'b110;
    frameUdpSruRdVer.data[64] = 8'h00;  frameUdpSruRdVer.valid[64] = 1'b1;  frameUdpSruRdVer.ctrl[64] = 3'b110;
    frameUdpSruRdVer.data[65] = 8'h00;  frameUdpSruRdVer.valid[65] = 1'b1;  frameUdpSruRdVer.ctrl[65] = 3'b110;
	 //---------------------------------------------------------------------------------------------------------
    frameUdpSruRdVer.data[66] = 8'h00;  frameUdpSruRdVer.valid[66] = 1'b1;  frameUdpSruRdVer.ctrl[66] = 3'b110;//Sent 1 software trigger (0x11)
    frameUdpSruRdVer.data[67] = 8'h00;  frameUdpSruRdVer.valid[67] = 1'b1;  frameUdpSruRdVer.ctrl[67] = 3'b110;
    frameUdpSruRdVer.data[68] = 8'h00;  frameUdpSruRdVer.valid[68] = 1'b1;  frameUdpSruRdVer.ctrl[68] = 3'b110;
    frameUdpSruRdVer.data[69] = 8'h9f;  frameUdpSruRdVer.valid[69] = 1'b1;  frameUdpSruRdVer.ctrl[69] = 3'b110;
	
    frameUdpSruRdVer.data[70] = 8'h00;  frameUdpSruRdVer.valid[70] = 1'b1;  frameUdpSruRdVer.ctrl[70] = 3'b110;
    frameUdpSruRdVer.data[71] = 8'h0f;  frameUdpSruRdVer.valid[71] = 1'b1;  frameUdpSruRdVer.ctrl[71] = 3'b110;
    frameUdpSruRdVer.data[72] = 8'hff;  frameUdpSruRdVer.valid[72] = 1'b1;  frameUdpSruRdVer.ctrl[72] = 3'b110;
    frameUdpSruRdVer.data[73] = 8'hff;  frameUdpSruRdVer.valid[73] = 1'b1;  frameUdpSruRdVer.ctrl[73] = 3'b110;
	 //---------------------------------------------------------------------------------------------------------
    frameUdpSruRdVer.data[74] = 8'h00;  frameUdpSruRdVer.valid[74] = 1'b0;  frameUdpSruRdVer.ctrl[74] = 3'b110;
    frameUdpSruRdVer.data[75] = 8'h00;  frameUdpSruRdVer.valid[75] = 1'b0;  frameUdpSruRdVer.ctrl[75] = 3'b110;
    frameUdpSruRdVer.data[76] = 8'h00;  frameUdpSruRdVer.valid[76] = 1'b0;  frameUdpSruRdVer.ctrl[76] = 3'b110;
    frameUdpSruRdVer.data[77] = 8'h06;  frameUdpSruRdVer.valid[77] = 1'b0;  frameUdpSruRdVer.ctrl[77] = 3'b110;
    frameUdpSruRdVer.data[78] = 8'h00;  frameUdpSruRdVer.valid[78] = 1'b0;  frameUdpSruRdVer.ctrl[78] = 3'b110;
    frameUdpSruRdVer.data[79] = 8'h0f;  frameUdpSruRdVer.valid[79] = 1'b0;  frameUdpSruRdVer.ctrl[79] = 3'b110;
    frameUdpSruRdVer.data[80] = 8'hff;  frameUdpSruRdVer.valid[80] = 1'b0;  frameUdpSruRdVer.ctrl[80] = 3'b110;
    frameUdpSruRdVer.data[81] = 8'hff;  frameUdpSruRdVer.valid[81] = 1'b0;  frameUdpSruRdVer.ctrl[81] = 3'b110;	

	 //---------------------------------------------------------------------------------------------------------
	 frameUdpSruRdVer.data[82] = 8'h00;  frameUdpSruRdVer.valid[82] = 1'b0;  frameUdpSruRdVer.ctrl[82] = 3'b110;
    frameUdpSruRdVer.data[83] = 8'h00;  frameUdpSruRdVer.valid[83] = 1'b0;  frameUdpSruRdVer.ctrl[83] = 3'b110;
    frameUdpSruRdVer.data[84] = 8'h00;  frameUdpSruRdVer.valid[84] = 1'b0;  frameUdpSruRdVer.ctrl[84] = 3'b110;
    frameUdpSruRdVer.data[85] = 8'h07;  frameUdpSruRdVer.valid[85] = 1'b0;  frameUdpSruRdVer.ctrl[85] = 3'b110;
    frameUdpSruRdVer.data[86] = 8'h00;  frameUdpSruRdVer.valid[86] = 1'b0;  frameUdpSruRdVer.ctrl[86] = 3'b110;
    frameUdpSruRdVer.data[87] = 8'h0f;  frameUdpSruRdVer.valid[87] = 1'b0;  frameUdpSruRdVer.ctrl[87] = 3'b110;
    frameUdpSruRdVer.data[88] = 8'hff;  frameUdpSruRdVer.valid[88] = 1'b0;  frameUdpSruRdVer.ctrl[88] = 3'b110;
    frameUdpSruRdVer.data[89] = 8'hff;  frameUdpSruRdVer.valid[89] = 1'b0;  frameUdpSruRdVer.ctrl[89] = 3'b100;
	 
    frameUdpSruRdVer.data[90] = 8'h30;  frameUdpSruRdVer.valid[90] = 1'b0;  frameUdpSruRdVer.ctrl[90] = 3'b111;
    frameUdpSruRdVer.data[91] = 8'h31;  frameUdpSruRdVer.valid[91] = 1'b0;  frameUdpSruRdVer.ctrl[91] = 3'b111;
    frameUdpSruRdVer.data[92] = 8'h32;  frameUdpSruRdVer.valid[92] = 1'b0;  frameUdpSruRdVer.ctrl[92] = 3'b111;
    frameUdpSruRdVer.data[93] = 8'h33;  frameUdpSruRdVer.valid[93] = 1'b0;  frameUdpSruRdVer.ctrl[93] = 3'b111;
    frameUdpSruRdVer.data[94] = 8'h34;  frameUdpSruRdVer.valid[94] = 1'b0;  frameUdpSruRdVer.ctrl[94] = 3'b111;
    frameUdpSruRdVer.data[95] = 8'h35;  frameUdpSruRdVer.valid[95] = 1'b0;  frameUdpSruRdVer.ctrl[95] = 3'b111;
    frameUdpSruRdVer.data[96] = 8'h36;  frameUdpSruRdVer.valid[96] = 1'b0;  frameUdpSruRdVer.ctrl[96] = 3'b111;
    frameUdpSruRdVer.data[97] = 8'h37;  frameUdpSruRdVer.valid[97] = 1'b0;  frameUdpSruRdVer.ctrl[97] = 3'b111;	 // 98th Byte of Data
  end

//------------------------------------------------------------------------------------------------------------------------------------------
initial
	begin
    frameUdpSruPhaseSet.data[0]  = 8'h0a;  frameUdpSruPhaseSet.valid[0]  = 1'b1;  frameUdpSruPhaseSet.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruPhaseSet.data[1]  = 8'h35;  frameUdpSruPhaseSet.valid[1]  = 1'b1;  frameUdpSruPhaseSet.ctrl[1]  = 3'b110;
    frameUdpSruPhaseSet.data[2]  = 8'h0a;  frameUdpSruPhaseSet.valid[2]  = 1'b1;  frameUdpSruPhaseSet.ctrl[2]  = 3'b110;
    frameUdpSruPhaseSet.data[3]  = 8'ha0;  frameUdpSruPhaseSet.valid[3]  = 1'b1;  frameUdpSruPhaseSet.ctrl[3]  = 3'b110;
    frameUdpSruPhaseSet.data[4]  = 8'h84;  frameUdpSruPhaseSet.valid[4]  = 1'b1;  frameUdpSruPhaseSet.ctrl[4]  = 3'b110;
    frameUdpSruPhaseSet.data[5]  = 8'h79;  frameUdpSruPhaseSet.valid[5]  = 1'b1;  frameUdpSruPhaseSet.ctrl[5]  = 3'b110;
	
    frameUdpSruPhaseSet.data[6]  = 8'h00;  frameUdpSruPhaseSet.valid[6]  = 1'b1;  frameUdpSruPhaseSet.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruPhaseSet.data[7]  = 8'h30;  frameUdpSruPhaseSet.valid[7]  = 1'b1;  frameUdpSruPhaseSet.ctrl[7]  = 3'b110;
    frameUdpSruPhaseSet.data[8]  = 8'h48;  frameUdpSruPhaseSet.valid[8]  = 1'b1;  frameUdpSruPhaseSet.ctrl[8]  = 3'b110;
    frameUdpSruPhaseSet.data[9]  = 8'hc1;  frameUdpSruPhaseSet.valid[9]  = 1'b1;  frameUdpSruPhaseSet.ctrl[9]  = 3'b110;
    frameUdpSruPhaseSet.data[10] = 8'h08;  frameUdpSruPhaseSet.valid[10] = 1'b1;  frameUdpSruPhaseSet.ctrl[10] = 3'b110;
    frameUdpSruPhaseSet.data[11] = 8'h79;  frameUdpSruPhaseSet.valid[11] = 1'b1;  frameUdpSruPhaseSet.ctrl[11] = 3'b110;
	
    frameUdpSruPhaseSet.data[12] = 8'h08;  frameUdpSruPhaseSet.valid[12] = 1'b1;  frameUdpSruPhaseSet.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruPhaseSet.data[13] = 8'h00;  frameUdpSruPhaseSet.valid[13] = 1'b1;  frameUdpSruPhaseSet.ctrl[13] = 3'b110;
   
    frameUdpSruPhaseSet.data[14] = 8'h45;  frameUdpSruPhaseSet.valid[14] = 1'b1;  frameUdpSruPhaseSet.ctrl[14] = 3'b110;
    frameUdpSruPhaseSet.data[15] = 8'h00;  frameUdpSruPhaseSet.valid[15] = 1'b1;  frameUdpSruPhaseSet.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruPhaseSet.data[16] = 8'h00;  frameUdpSruPhaseSet.valid[16] = 1'b1;  frameUdpSruPhaseSet.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruPhaseSet.data[17] = 8'h3c;  frameUdpSruPhaseSet.valid[17] = 1'b1;  frameUdpSruPhaseSet.ctrl[17] = 3'b110;
	
    frameUdpSruPhaseSet.data[18] = 8'h00;  frameUdpSruPhaseSet.valid[18] = 1'b1;  frameUdpSruPhaseSet.ctrl[18] = 3'b110;
    frameUdpSruPhaseSet.data[19] = 8'h00;  frameUdpSruPhaseSet.valid[19] = 1'b1;  frameUdpSruPhaseSet.ctrl[19] = 3'b110;
    frameUdpSruPhaseSet.data[20] = 8'h40;  frameUdpSruPhaseSet.valid[20] = 1'b1;  frameUdpSruPhaseSet.ctrl[20] = 3'b110;
    frameUdpSruPhaseSet.data[21] = 8'h00;  frameUdpSruPhaseSet.valid[21] = 1'b1;  frameUdpSruPhaseSet.ctrl[21] = 3'b110;
    frameUdpSruPhaseSet.data[22] = 8'h40;  frameUdpSruPhaseSet.valid[22] = 1'b1;  frameUdpSruPhaseSet.ctrl[22] = 3'b110;
	
    frameUdpSruPhaseSet.data[23] = 8'h11;  frameUdpSruPhaseSet.valid[23] = 1'b1;  frameUdpSruPhaseSet.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruPhaseSet.data[24] = 8'hb6;  frameUdpSruPhaseSet.valid[24] = 1'b1;  frameUdpSruPhaseSet.ctrl[24] = 3'b110;// Header checker
    frameUdpSruPhaseSet.data[25] = 8'hf8;  frameUdpSruPhaseSet.valid[25] = 1'b1;  frameUdpSruPhaseSet.ctrl[25] = 3'b110;
	
    frameUdpSruPhaseSet.data[26] = 8'hc0;  frameUdpSruPhaseSet.valid[26] = 1'b1;  frameUdpSruPhaseSet.ctrl[26] = 3'b110;// Source IP
    frameUdpSruPhaseSet.data[27] = 8'ha8;  frameUdpSruPhaseSet.valid[27] = 1'b1;  frameUdpSruPhaseSet.ctrl[27] = 3'b110;
    frameUdpSruPhaseSet.data[28] = 8'h01;  frameUdpSruPhaseSet.valid[28] = 1'b1;  frameUdpSruPhaseSet.ctrl[28] = 3'b110;
    frameUdpSruPhaseSet.data[29] = 8'h3f;  frameUdpSruPhaseSet.valid[29] = 1'b1;  frameUdpSruPhaseSet.ctrl[29] = 3'b110;
	
    frameUdpSruPhaseSet.data[30] = 8'h0a;  frameUdpSruPhaseSet.valid[30] = 1'b1;  frameUdpSruPhaseSet.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruPhaseSet.data[31] = 8'ha0;  frameUdpSruPhaseSet.valid[31] = 1'b1;  frameUdpSruPhaseSet.ctrl[31] = 3'b110;
    frameUdpSruPhaseSet.data[32] = 8'h84;  frameUdpSruPhaseSet.valid[32] = 1'b1;  frameUdpSruPhaseSet.ctrl[32] = 3'b110;
    frameUdpSruPhaseSet.data[33] = 8'h79;  frameUdpSruPhaseSet.valid[33] = 1'b1;  frameUdpSruPhaseSet.ctrl[33] = 3'b110;
	
    frameUdpSruPhaseSet.data[34] = 8'h17;  frameUdpSruPhaseSet.valid[34] = 1'b1;  frameUdpSruPhaseSet.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruPhaseSet.data[35] = 8'h77;  frameUdpSruPhaseSet.valid[35] = 1'b1;  frameUdpSruPhaseSet.ctrl[35] = 3'b110;
	
    frameUdpSruPhaseSet.data[36] = 8'h10;  frameUdpSruPhaseSet.valid[36] = 1'b1;  frameUdpSruPhaseSet.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruPhaseSet.data[37] = 8'h01;  frameUdpSruPhaseSet.valid[37] = 1'b1;  frameUdpSruPhaseSet.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruPhaseSet.data[38] = 8'h00;  frameUdpSruPhaseSet.valid[38] = 1'b1;  frameUdpSruPhaseSet.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruPhaseSet.data[39] = 8'h28;  frameUdpSruPhaseSet.valid[39] = 1'b1;  frameUdpSruPhaseSet.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruPhaseSet.data[40] = 8'h00;  frameUdpSruPhaseSet.valid[40] = 1'b1;  frameUdpSruPhaseSet.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruPhaseSet.data[41] = 8'h00;  frameUdpSruPhaseSet.valid[41] = 1'b1;  frameUdpSruPhaseSet.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruPhaseSet.data[42] = 8'h00;  frameUdpSruPhaseSet.valid[42] = 1'b1;  frameUdpSruPhaseSet.ctrl[42] = 3'b110;// SRU
    frameUdpSruPhaseSet.data[43] = 8'h10;  frameUdpSruPhaseSet.valid[43] = 1'b1;  frameUdpSruPhaseSet.ctrl[43] = 3'b110;
    frameUdpSruPhaseSet.data[44] = 8'h00;  frameUdpSruPhaseSet.valid[44] = 1'b1;  frameUdpSruPhaseSet.ctrl[44] = 3'b110;
    frameUdpSruPhaseSet.data[45] = 8'h00;  frameUdpSruPhaseSet.valid[45] = 1'b1;  frameUdpSruPhaseSet.ctrl[45] = 3'b110;
	
    frameUdpSruPhaseSet.data[46] = 8'h00;  frameUdpSruPhaseSet.valid[46] = 1'b1;  frameUdpSruPhaseSet.ctrl[46] = 3'b110;
    frameUdpSruPhaseSet.data[47] = 8'h00;  frameUdpSruPhaseSet.valid[47] = 1'b1;  frameUdpSruPhaseSet.ctrl[47] = 3'b110;
    frameUdpSruPhaseSet.data[48] = 8'h00;  frameUdpSruPhaseSet.valid[48] = 1'b1;  frameUdpSruPhaseSet.ctrl[48] = 3'b110;
    frameUdpSruPhaseSet.data[49] = 8'h00;  frameUdpSruPhaseSet.valid[49] = 1'b1;  frameUdpSruPhaseSet.ctrl[49] = 3'b110;
	//change it according to the frame	
    frameUdpSruPhaseSet.data[50] = 8'h00;  frameUdpSruPhaseSet.valid[50] = 1'b1;  frameUdpSruPhaseSet.ctrl[50] = 3'b110;//Phase shift command
    frameUdpSruPhaseSet.data[51] = 8'h00;  frameUdpSruPhaseSet.valid[51] = 1'b1;  frameUdpSruPhaseSet.ctrl[51] = 3'b110;
    frameUdpSruPhaseSet.data[52] = 8'h00;  frameUdpSruPhaseSet.valid[52] = 1'b1;  frameUdpSruPhaseSet.ctrl[52] = 3'b110;
    frameUdpSruPhaseSet.data[53] = 8'h11;  frameUdpSruPhaseSet.valid[53] = 1'b1;  frameUdpSruPhaseSet.ctrl[53] = 3'b110;
    frameUdpSruPhaseSet.data[54] = 8'h00;  frameUdpSruPhaseSet.valid[54] = 1'b1;  frameUdpSruPhaseSet.ctrl[54] = 3'b110;//Phase shift command
    frameUdpSruPhaseSet.data[55] = 8'h00;  frameUdpSruPhaseSet.valid[55] = 1'b1;  frameUdpSruPhaseSet.ctrl[55] = 3'b110;
    frameUdpSruPhaseSet.data[56] = 8'h00;  frameUdpSruPhaseSet.valid[56] = 1'b1;  frameUdpSruPhaseSet.ctrl[56] = 3'b110;
    frameUdpSruPhaseSet.data[57] = 8'h64;  frameUdpSruPhaseSet.valid[57] = 1'b1;  frameUdpSruPhaseSet.ctrl[57] = 3'b100;
end
	
genvar j;
generate
for(j=58; j<98;j=j+1)
begin: frameUdpSruPhaseSetRest2
initial
begin
frameUdpSruPhaseSet.data[j] = 8'h00;  frameUdpSruPhaseSet.valid[j] = 1'b0;  frameUdpSruPhaseSet.ctrl[j] = 3'b111;
end
end
endgenerate

//------------------------------------------------------------------------------------------------------------------------------------------

initial
	begin
    frameUdpSruStrig.data[0]  = 8'h0a;  frameUdpSruStrig.valid[0]  = 1'b1;  frameUdpSruStrig.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruStrig.data[1]  = 8'h35;  frameUdpSruStrig.valid[1]  = 1'b1;  frameUdpSruStrig.ctrl[1]  = 3'b110;
    frameUdpSruStrig.data[2]  = 8'h0a;  frameUdpSruStrig.valid[2]  = 1'b1;  frameUdpSruStrig.ctrl[2]  = 3'b110;
    frameUdpSruStrig.data[3]  = 8'ha0;  frameUdpSruStrig.valid[3]  = 1'b1;  frameUdpSruStrig.ctrl[3]  = 3'b110;
    frameUdpSruStrig.data[4]  = 8'h84;  frameUdpSruStrig.valid[4]  = 1'b1;  frameUdpSruStrig.ctrl[4]  = 3'b110;
    frameUdpSruStrig.data[5]  = 8'h79;  frameUdpSruStrig.valid[5]  = 1'b1;  frameUdpSruStrig.ctrl[5]  = 3'b110;
	
    frameUdpSruStrig.data[6]  = 8'h00;  frameUdpSruStrig.valid[6]  = 1'b1;  frameUdpSruStrig.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruStrig.data[7]  = 8'h30;  frameUdpSruStrig.valid[7]  = 1'b1;  frameUdpSruStrig.ctrl[7]  = 3'b110;
    frameUdpSruStrig.data[8]  = 8'h48;  frameUdpSruStrig.valid[8]  = 1'b1;  frameUdpSruStrig.ctrl[8]  = 3'b110;
    frameUdpSruStrig.data[9]  = 8'hc1;  frameUdpSruStrig.valid[9]  = 1'b1;  frameUdpSruStrig.ctrl[9]  = 3'b110;
    frameUdpSruStrig.data[10] = 8'h08;  frameUdpSruStrig.valid[10] = 1'b1;  frameUdpSruStrig.ctrl[10] = 3'b110;
    frameUdpSruStrig.data[11] = 8'h79;  frameUdpSruStrig.valid[11] = 1'b1;  frameUdpSruStrig.ctrl[11] = 3'b110;
	
    frameUdpSruStrig.data[12] = 8'h08;  frameUdpSruStrig.valid[12] = 1'b1;  frameUdpSruStrig.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruStrig.data[13] = 8'h00;  frameUdpSruStrig.valid[13] = 1'b1;  frameUdpSruStrig.ctrl[13] = 3'b110;
   
    frameUdpSruStrig.data[14] = 8'h45;  frameUdpSruStrig.valid[14] = 1'b1;  frameUdpSruStrig.ctrl[14] = 3'b110;
    frameUdpSruStrig.data[15] = 8'h00;  frameUdpSruStrig.valid[15] = 1'b1;  frameUdpSruStrig.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruStrig.data[16] = 8'h00;  frameUdpSruStrig.valid[16] = 1'b1;  frameUdpSruStrig.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruStrig.data[17] = 8'h3c;  frameUdpSruStrig.valid[17] = 1'b1;  frameUdpSruStrig.ctrl[17] = 3'b110;
	
    frameUdpSruStrig.data[18] = 8'h00;  frameUdpSruStrig.valid[18] = 1'b1;  frameUdpSruStrig.ctrl[18] = 3'b110;
    frameUdpSruStrig.data[19] = 8'h00;  frameUdpSruStrig.valid[19] = 1'b1;  frameUdpSruStrig.ctrl[19] = 3'b110;
    frameUdpSruStrig.data[20] = 8'h40;  frameUdpSruStrig.valid[20] = 1'b1;  frameUdpSruStrig.ctrl[20] = 3'b110;
    frameUdpSruStrig.data[21] = 8'h00;  frameUdpSruStrig.valid[21] = 1'b1;  frameUdpSruStrig.ctrl[21] = 3'b110;
    frameUdpSruStrig.data[22] = 8'h40;  frameUdpSruStrig.valid[22] = 1'b1;  frameUdpSruStrig.ctrl[22] = 3'b110;
	
    frameUdpSruStrig.data[23] = 8'h11;  frameUdpSruStrig.valid[23] = 1'b1;  frameUdpSruStrig.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruStrig.data[24] = 8'hb6;  frameUdpSruStrig.valid[24] = 1'b1;  frameUdpSruStrig.ctrl[24] = 3'b110;// Header checker
    frameUdpSruStrig.data[25] = 8'hf8;  frameUdpSruStrig.valid[25] = 1'b1;  frameUdpSruStrig.ctrl[25] = 3'b110;
	
    frameUdpSruStrig.data[26] = 8'hc0;  frameUdpSruStrig.valid[26] = 1'b1;  frameUdpSruStrig.ctrl[26] = 3'b110;// Source IP
    frameUdpSruStrig.data[27] = 8'ha8;  frameUdpSruStrig.valid[27] = 1'b1;  frameUdpSruStrig.ctrl[27] = 3'b110;
    frameUdpSruStrig.data[28] = 8'h01;  frameUdpSruStrig.valid[28] = 1'b1;  frameUdpSruStrig.ctrl[28] = 3'b110;
    frameUdpSruStrig.data[29] = 8'h3f;  frameUdpSruStrig.valid[29] = 1'b1;  frameUdpSruStrig.ctrl[29] = 3'b110;
	
    frameUdpSruStrig.data[30] = 8'h0a;  frameUdpSruStrig.valid[30] = 1'b1;  frameUdpSruStrig.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruStrig.data[31] = 8'ha0;  frameUdpSruStrig.valid[31] = 1'b1;  frameUdpSruStrig.ctrl[31] = 3'b110;
    frameUdpSruStrig.data[32] = 8'h84;  frameUdpSruStrig.valid[32] = 1'b1;  frameUdpSruStrig.ctrl[32] = 3'b110;
    frameUdpSruStrig.data[33] = 8'h79;  frameUdpSruStrig.valid[33] = 1'b1;  frameUdpSruStrig.ctrl[33] = 3'b110;
	
    frameUdpSruStrig.data[34] = 8'h17;  frameUdpSruStrig.valid[34] = 1'b1;  frameUdpSruStrig.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruStrig.data[35] = 8'h77;  frameUdpSruStrig.valid[35] = 1'b1;  frameUdpSruStrig.ctrl[35] = 3'b110;
	
    frameUdpSruStrig.data[36] = 8'h10;  frameUdpSruStrig.valid[36] = 1'b1;  frameUdpSruStrig.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruStrig.data[37] = 8'h01;  frameUdpSruStrig.valid[37] = 1'b1;  frameUdpSruStrig.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruStrig.data[38] = 8'h00;  frameUdpSruStrig.valid[38] = 1'b1;  frameUdpSruStrig.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruStrig.data[39] = 8'h28;  frameUdpSruStrig.valid[39] = 1'b1;  frameUdpSruStrig.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruStrig.data[40] = 8'h00;  frameUdpSruStrig.valid[40] = 1'b1;  frameUdpSruStrig.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruStrig.data[41] = 8'h00;  frameUdpSruStrig.valid[41] = 1'b1;  frameUdpSruStrig.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruStrig.data[42] = 8'h00;  frameUdpSruStrig.valid[42] = 1'b1;  frameUdpSruStrig.ctrl[42] = 3'b110;// SRU
    frameUdpSruStrig.data[43] = 8'h10;  frameUdpSruStrig.valid[43] = 1'b1;  frameUdpSruStrig.ctrl[43] = 3'b110;
    frameUdpSruStrig.data[44] = 8'h00;  frameUdpSruStrig.valid[44] = 1'b1;  frameUdpSruStrig.ctrl[44] = 3'b110;
    frameUdpSruStrig.data[45] = 8'h00;  frameUdpSruStrig.valid[45] = 1'b1;  frameUdpSruStrig.ctrl[45] = 3'b110;
	
    frameUdpSruStrig.data[46] = 8'h00;  frameUdpSruStrig.valid[46] = 1'b1;  frameUdpSruStrig.ctrl[46] = 3'b110;
    frameUdpSruStrig.data[47] = 8'h00;  frameUdpSruStrig.valid[47] = 1'b1;  frameUdpSruStrig.ctrl[47] = 3'b110;
    frameUdpSruStrig.data[48] = 8'h00;  frameUdpSruStrig.valid[48] = 1'b1;  frameUdpSruStrig.ctrl[48] = 3'b110;
    frameUdpSruStrig.data[49] = 8'h00;  frameUdpSruStrig.valid[49] = 1'b1;  frameUdpSruStrig.ctrl[49] = 3'b110;
	//change it according to the frame	
    frameUdpSruStrig.data[50] = 8'h00;  frameUdpSruStrig.valid[50] = 1'b1;  frameUdpSruStrig.ctrl[50] = 3'b110;//Phase shift command
    frameUdpSruStrig.data[51] = 8'h00;  frameUdpSruStrig.valid[51] = 1'b1;  frameUdpSruStrig.ctrl[51] = 3'b110;
    frameUdpSruStrig.data[52] = 8'h00;  frameUdpSruStrig.valid[52] = 1'b1;  frameUdpSruStrig.ctrl[52] = 3'b110;
    frameUdpSruStrig.data[53] = 8'h50;  frameUdpSruStrig.valid[53] = 1'b1;  frameUdpSruStrig.ctrl[53] = 3'b110;
    frameUdpSruStrig.data[54] = 8'h00;  frameUdpSruStrig.valid[54] = 1'b1;  frameUdpSruStrig.ctrl[54] = 3'b110;//Phase shift command
    frameUdpSruStrig.data[55] = 8'h01;  frameUdpSruStrig.valid[55] = 1'b1;  frameUdpSruStrig.ctrl[55] = 3'b110;
    frameUdpSruStrig.data[56] = 8'h03;  frameUdpSruStrig.valid[56] = 1'b1;  frameUdpSruStrig.ctrl[56] = 3'b110;
    frameUdpSruStrig.data[57] = 8'h20;  frameUdpSruStrig.valid[57] = 1'b1;  frameUdpSruStrig.ctrl[57] = 3'b100;
end
	
genvar k;
generate
for(k=58; k<98;k=k+1)
begin: frameUdpSruStrigRest2
initial
begin
frameUdpSruStrig.data[k] = 8'h00;  frameUdpSruStrig.valid[k] = 1'b0;  frameUdpSruStrig.ctrl[k] = 3'b111;
end
end
endgenerate

initial
	begin
    frameUdpSruReset.data[0]  = 8'h0a;  frameUdpSruReset.valid[0]  = 1'b1;  frameUdpSruReset.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruReset.data[1]  = 8'h35;  frameUdpSruReset.valid[1]  = 1'b1;  frameUdpSruReset.ctrl[1]  = 3'b110;
    frameUdpSruReset.data[2]  = 8'h0a;  frameUdpSruReset.valid[2]  = 1'b1;  frameUdpSruReset.ctrl[2]  = 3'b110;
    frameUdpSruReset.data[3]  = 8'ha0;  frameUdpSruReset.valid[3]  = 1'b1;  frameUdpSruReset.ctrl[3]  = 3'b110;
    frameUdpSruReset.data[4]  = 8'h84;  frameUdpSruReset.valid[4]  = 1'b1;  frameUdpSruReset.ctrl[4]  = 3'b110;
    frameUdpSruReset.data[5]  = 8'h79;  frameUdpSruReset.valid[5]  = 1'b1;  frameUdpSruReset.ctrl[5]  = 3'b110;
	
    frameUdpSruReset.data[6]  = 8'h00;  frameUdpSruReset.valid[6]  = 1'b1;  frameUdpSruReset.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruReset.data[7]  = 8'h30;  frameUdpSruReset.valid[7]  = 1'b1;  frameUdpSruReset.ctrl[7]  = 3'b110;
    frameUdpSruReset.data[8]  = 8'h48;  frameUdpSruReset.valid[8]  = 1'b1;  frameUdpSruReset.ctrl[8]  = 3'b110;
    frameUdpSruReset.data[9]  = 8'hc1;  frameUdpSruReset.valid[9]  = 1'b1;  frameUdpSruReset.ctrl[9]  = 3'b110;
    frameUdpSruReset.data[10] = 8'h08;  frameUdpSruReset.valid[10] = 1'b1;  frameUdpSruReset.ctrl[10] = 3'b110;
    frameUdpSruReset.data[11] = 8'h79;  frameUdpSruReset.valid[11] = 1'b1;  frameUdpSruReset.ctrl[11] = 3'b110;
	
    frameUdpSruReset.data[12] = 8'h08;  frameUdpSruReset.valid[12] = 1'b1;  frameUdpSruReset.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruReset.data[13] = 8'h00;  frameUdpSruReset.valid[13] = 1'b1;  frameUdpSruReset.ctrl[13] = 3'b110;
   
    frameUdpSruReset.data[14] = 8'h45;  frameUdpSruReset.valid[14] = 1'b1;  frameUdpSruReset.ctrl[14] = 3'b110;
    frameUdpSruReset.data[15] = 8'h00;  frameUdpSruReset.valid[15] = 1'b1;  frameUdpSruReset.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruReset.data[16] = 8'h00;  frameUdpSruReset.valid[16] = 1'b1;  frameUdpSruReset.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruReset.data[17] = 8'h3c;  frameUdpSruReset.valid[17] = 1'b1;  frameUdpSruReset.ctrl[17] = 3'b110;
	
    frameUdpSruReset.data[18] = 8'h00;  frameUdpSruReset.valid[18] = 1'b1;  frameUdpSruReset.ctrl[18] = 3'b110;
    frameUdpSruReset.data[19] = 8'h00;  frameUdpSruReset.valid[19] = 1'b1;  frameUdpSruReset.ctrl[19] = 3'b110;
    frameUdpSruReset.data[20] = 8'h40;  frameUdpSruReset.valid[20] = 1'b1;  frameUdpSruReset.ctrl[20] = 3'b110;
    frameUdpSruReset.data[21] = 8'h00;  frameUdpSruReset.valid[21] = 1'b1;  frameUdpSruReset.ctrl[21] = 3'b110;
    frameUdpSruReset.data[22] = 8'h40;  frameUdpSruReset.valid[22] = 1'b1;  frameUdpSruReset.ctrl[22] = 3'b110;
	
    frameUdpSruReset.data[23] = 8'h11;  frameUdpSruReset.valid[23] = 1'b1;  frameUdpSruReset.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruReset.data[24] = 8'hb6;  frameUdpSruReset.valid[24] = 1'b1;  frameUdpSruReset.ctrl[24] = 3'b110;// Header checker
    frameUdpSruReset.data[25] = 8'hf8;  frameUdpSruReset.valid[25] = 1'b1;  frameUdpSruReset.ctrl[25] = 3'b110;
	
    frameUdpSruReset.data[26] = 8'hc0;  frameUdpSruReset.valid[26] = 1'b1;  frameUdpSruReset.ctrl[26] = 3'b110;// Source IP
    frameUdpSruReset.data[27] = 8'ha8;  frameUdpSruReset.valid[27] = 1'b1;  frameUdpSruReset.ctrl[27] = 3'b110;
    frameUdpSruReset.data[28] = 8'h01;  frameUdpSruReset.valid[28] = 1'b1;  frameUdpSruReset.ctrl[28] = 3'b110;
    frameUdpSruReset.data[29] = 8'h3f;  frameUdpSruReset.valid[29] = 1'b1;  frameUdpSruReset.ctrl[29] = 3'b110;
	
    frameUdpSruReset.data[30] = 8'h0a;  frameUdpSruReset.valid[30] = 1'b1;  frameUdpSruReset.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruReset.data[31] = 8'ha0;  frameUdpSruReset.valid[31] = 1'b1;  frameUdpSruReset.ctrl[31] = 3'b110;
    frameUdpSruReset.data[32] = 8'h84;  frameUdpSruReset.valid[32] = 1'b1;  frameUdpSruReset.ctrl[32] = 3'b110;
    frameUdpSruReset.data[33] = 8'h79;  frameUdpSruReset.valid[33] = 1'b1;  frameUdpSruReset.ctrl[33] = 3'b110;
	
    frameUdpSruReset.data[34] = 8'h17;  frameUdpSruReset.valid[34] = 1'b1;  frameUdpSruReset.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruReset.data[35] = 8'h77;  frameUdpSruReset.valid[35] = 1'b1;  frameUdpSruReset.ctrl[35] = 3'b110;
	
    frameUdpSruReset.data[36] = 8'h10;  frameUdpSruReset.valid[36] = 1'b1;  frameUdpSruReset.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruReset.data[37] = 8'h01;  frameUdpSruReset.valid[37] = 1'b1;  frameUdpSruReset.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruReset.data[38] = 8'h00;  frameUdpSruReset.valid[38] = 1'b1;  frameUdpSruReset.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruReset.data[39] = 8'h28;  frameUdpSruReset.valid[39] = 1'b1;  frameUdpSruReset.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruReset.data[40] = 8'h00;  frameUdpSruReset.valid[40] = 1'b1;  frameUdpSruReset.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruReset.data[41] = 8'h00;  frameUdpSruReset.valid[41] = 1'b1;  frameUdpSruReset.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruReset.data[42] = 8'h00;  frameUdpSruReset.valid[42] = 1'b1;  frameUdpSruReset.ctrl[42] = 3'b110;// SRU
    frameUdpSruReset.data[43] = 8'h10;  frameUdpSruReset.valid[43] = 1'b1;  frameUdpSruReset.ctrl[43] = 3'b110;
    frameUdpSruReset.data[44] = 8'h00;  frameUdpSruReset.valid[44] = 1'b1;  frameUdpSruReset.ctrl[44] = 3'b110;
    frameUdpSruReset.data[45] = 8'h00;  frameUdpSruReset.valid[45] = 1'b1;  frameUdpSruReset.ctrl[45] = 3'b110;
	
    frameUdpSruReset.data[46] = 8'h00;  frameUdpSruReset.valid[46] = 1'b1;  frameUdpSruReset.ctrl[46] = 3'b110;
    frameUdpSruReset.data[47] = 8'h00;  frameUdpSruReset.valid[47] = 1'b1;  frameUdpSruReset.ctrl[47] = 3'b110;
    frameUdpSruReset.data[48] = 8'h00;  frameUdpSruReset.valid[48] = 1'b1;  frameUdpSruReset.ctrl[48] = 3'b110;
    frameUdpSruReset.data[49] = 8'h00;  frameUdpSruReset.valid[49] = 1'b1;  frameUdpSruReset.ctrl[49] = 3'b110;
	//change it according to the frame	
    frameUdpSruReset.data[50] = 8'h00;  frameUdpSruReset.valid[50] = 1'b1;  frameUdpSruReset.ctrl[50] = 3'b110;//Phase shift command
    frameUdpSruReset.data[51] = 8'h00;  frameUdpSruReset.valid[51] = 1'b1;  frameUdpSruReset.ctrl[51] = 3'b110;
    frameUdpSruReset.data[52] = 8'h00;  frameUdpSruReset.valid[52] = 1'b1;  frameUdpSruReset.ctrl[52] = 3'b110;
    frameUdpSruReset.data[53] = 8'h10;  frameUdpSruReset.valid[53] = 1'b1;  frameUdpSruReset.ctrl[53] = 3'b110;
    frameUdpSruReset.data[54] = 8'h00;  frameUdpSruReset.valid[54] = 1'b1;  frameUdpSruReset.ctrl[54] = 3'b110;//Phase shift command
    frameUdpSruReset.data[55] = 8'h00;  frameUdpSruReset.valid[55] = 1'b1;  frameUdpSruReset.ctrl[55] = 3'b110;
    frameUdpSruReset.data[56] = 8'h00;  frameUdpSruReset.valid[56] = 1'b1;  frameUdpSruReset.ctrl[56] = 3'b110;
    frameUdpSruReset.data[57] = 8'h00;  frameUdpSruReset.valid[57] = 1'b1;  frameUdpSruReset.ctrl[57] = 3'b100;
end
	
genvar m;
generate
for(m=58; m<98;m=m+1)
begin: frameUdpSruResetRest2
initial
begin
frameUdpSruReset.data[m] = 8'h00;  frameUdpSruReset.valid[m] = 1'b0;  frameUdpSruReset.ctrl[m] = 3'b111;
end
end
endgenerate

 initial
	begin
	frameUdpSruRdOReg.data[0]  = 8'h0a;  frameUdpSruRdOReg.valid[0]  = 1'b1;  frameUdpSruRdOReg.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruRdOReg.data[1]  = 8'h35;  frameUdpSruRdOReg.valid[1]  = 1'b1;  frameUdpSruRdOReg.ctrl[1]  = 3'b110;
    frameUdpSruRdOReg.data[2]  = 8'h0a;  frameUdpSruRdOReg.valid[2]  = 1'b1;  frameUdpSruRdOReg.ctrl[2]  = 3'b110;
    frameUdpSruRdOReg.data[3]  = 8'ha0;  frameUdpSruRdOReg.valid[3]  = 1'b1;  frameUdpSruRdOReg.ctrl[3]  = 3'b110;
    frameUdpSruRdOReg.data[4]  = 8'h84;  frameUdpSruRdOReg.valid[4]  = 1'b1;  frameUdpSruRdOReg.ctrl[4]  = 3'b110;
    frameUdpSruRdOReg.data[5]  = 8'h79;  frameUdpSruRdOReg.valid[5]  = 1'b1;  frameUdpSruRdOReg.ctrl[5]  = 3'b110;
	
    frameUdpSruRdOReg.data[6]  = 8'h00;  frameUdpSruRdOReg.valid[6]  = 1'b1;  frameUdpSruRdOReg.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruRdOReg.data[7]  = 8'h30;  frameUdpSruRdOReg.valid[7]  = 1'b1;  frameUdpSruRdOReg.ctrl[7]  = 3'b110;
    frameUdpSruRdOReg.data[8]  = 8'h48;  frameUdpSruRdOReg.valid[8]  = 1'b1;  frameUdpSruRdOReg.ctrl[8]  = 3'b110;
    frameUdpSruRdOReg.data[9]  = 8'hc1;  frameUdpSruRdOReg.valid[9]  = 1'b1;  frameUdpSruRdOReg.ctrl[9]  = 3'b110;
    frameUdpSruRdOReg.data[10] = 8'h08;  frameUdpSruRdOReg.valid[10] = 1'b1;  frameUdpSruRdOReg.ctrl[10] = 3'b110;
    frameUdpSruRdOReg.data[11] = 8'h79;  frameUdpSruRdOReg.valid[11] = 1'b1;  frameUdpSruRdOReg.ctrl[11] = 3'b110;
	
    frameUdpSruRdOReg.data[12] = 8'h08;  frameUdpSruRdOReg.valid[12] = 1'b1;  frameUdpSruRdOReg.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruRdOReg.data[13] = 8'h00;  frameUdpSruRdOReg.valid[13] = 1'b1;  frameUdpSruRdOReg.ctrl[13] = 3'b110;
   
    frameUdpSruRdOReg.data[14] = 8'h45;  frameUdpSruRdOReg.valid[14] = 1'b1;  frameUdpSruRdOReg.ctrl[14] = 3'b110;
    frameUdpSruRdOReg.data[15] = 8'h00;  frameUdpSruRdOReg.valid[15] = 1'b1;  frameUdpSruRdOReg.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruRdOReg.data[16] = 8'h00;  frameUdpSruRdOReg.valid[16] = 1'b1;  frameUdpSruRdOReg.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruRdOReg.data[17] = 8'h3c;  frameUdpSruRdOReg.valid[17] = 1'b1;  frameUdpSruRdOReg.ctrl[17] = 3'b110;
	
    frameUdpSruRdOReg.data[18] = 8'h00;  frameUdpSruRdOReg.valid[18] = 1'b1;  frameUdpSruRdOReg.ctrl[18] = 3'b110;
    frameUdpSruRdOReg.data[19] = 8'h00;  frameUdpSruRdOReg.valid[19] = 1'b1;  frameUdpSruRdOReg.ctrl[19] = 3'b110;
    frameUdpSruRdOReg.data[20] = 8'h40;  frameUdpSruRdOReg.valid[20] = 1'b1;  frameUdpSruRdOReg.ctrl[20] = 3'b110;
    frameUdpSruRdOReg.data[21] = 8'h00;  frameUdpSruRdOReg.valid[21] = 1'b1;  frameUdpSruRdOReg.ctrl[21] = 3'b110;
    frameUdpSruRdOReg.data[22] = 8'h40;  frameUdpSruRdOReg.valid[22] = 1'b1;  frameUdpSruRdOReg.ctrl[22] = 3'b110;
	
    frameUdpSruRdOReg.data[23] = 8'h11;  frameUdpSruRdOReg.valid[23] = 1'b1;  frameUdpSruRdOReg.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruRdOReg.data[24] = 8'hb6;  frameUdpSruRdOReg.valid[24] = 1'b1;  frameUdpSruRdOReg.ctrl[24] = 3'b110;// Header checker
    frameUdpSruRdOReg.data[25] = 8'hf8;  frameUdpSruRdOReg.valid[25] = 1'b1;  frameUdpSruRdOReg.ctrl[25] = 3'b110;
	
    frameUdpSruRdOReg.data[26] = 8'hc0;  frameUdpSruRdOReg.valid[26] = 1'b1;  frameUdpSruRdOReg.ctrl[26] = 3'b110;// Source IP
    frameUdpSruRdOReg.data[27] = 8'ha8;  frameUdpSruRdOReg.valid[27] = 1'b1;  frameUdpSruRdOReg.ctrl[27] = 3'b110;
    frameUdpSruRdOReg.data[28] = 8'h01;  frameUdpSruRdOReg.valid[28] = 1'b1;  frameUdpSruRdOReg.ctrl[28] = 3'b110;
    frameUdpSruRdOReg.data[29] = 8'h3f;  frameUdpSruRdOReg.valid[29] = 1'b1;  frameUdpSruRdOReg.ctrl[29] = 3'b110;
	
    frameUdpSruRdOReg.data[30] = 8'h0a;  frameUdpSruRdOReg.valid[30] = 1'b1;  frameUdpSruRdOReg.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruRdOReg.data[31] = 8'ha0;  frameUdpSruRdOReg.valid[31] = 1'b1;  frameUdpSruRdOReg.ctrl[31] = 3'b110;
    frameUdpSruRdOReg.data[32] = 8'h84;  frameUdpSruRdOReg.valid[32] = 1'b1;  frameUdpSruRdOReg.ctrl[32] = 3'b110;
    frameUdpSruRdOReg.data[33] = 8'h79;  frameUdpSruRdOReg.valid[33] = 1'b1;  frameUdpSruRdOReg.ctrl[33] = 3'b110;
	
    frameUdpSruRdOReg.data[34] = 8'h17;  frameUdpSruRdOReg.valid[34] = 1'b1;  frameUdpSruRdOReg.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruRdOReg.data[35] = 8'h77;  frameUdpSruRdOReg.valid[35] = 1'b1;  frameUdpSruRdOReg.ctrl[35] = 3'b110;
	
    frameUdpSruRdOReg.data[36] = 8'h10;  frameUdpSruRdOReg.valid[36] = 1'b1;  frameUdpSruRdOReg.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruRdOReg.data[37] = 8'h01;  frameUdpSruRdOReg.valid[37] = 1'b1;  frameUdpSruRdOReg.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruRdOReg.data[38] = 8'h00;  frameUdpSruRdOReg.valid[38] = 1'b1;  frameUdpSruRdOReg.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruRdOReg.data[39] = 8'h28;  frameUdpSruRdOReg.valid[39] = 1'b1;  frameUdpSruRdOReg.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruRdOReg.data[40] = 8'h00;  frameUdpSruRdOReg.valid[40] = 1'b1;  frameUdpSruRdOReg.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruRdOReg.data[41] = 8'h00;  frameUdpSruRdOReg.valid[41] = 1'b1;  frameUdpSruRdOReg.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruRdOReg.data[42] = 8'h00;  frameUdpSruRdOReg.valid[42] = 1'b1;  frameUdpSruRdOReg.ctrl[42] = 3'b110;// SRU
    frameUdpSruRdOReg.data[43] = 8'h10;  frameUdpSruRdOReg.valid[43] = 1'b1;  frameUdpSruRdOReg.ctrl[43] = 3'b110;
    frameUdpSruRdOReg.data[44] = 8'h00;  frameUdpSruRdOReg.valid[44] = 1'b1;  frameUdpSruRdOReg.ctrl[44] = 3'b110;
    frameUdpSruRdOReg.data[45] = 8'h00;  frameUdpSruRdOReg.valid[45] = 1'b1;  frameUdpSruRdOReg.ctrl[45] = 3'b110;
	
    frameUdpSruRdOReg.data[46] = 8'h00;  frameUdpSruRdOReg.valid[46] = 1'b1;  frameUdpSruRdOReg.ctrl[46] = 3'b110;
    frameUdpSruRdOReg.data[47] = 8'h00;  frameUdpSruRdOReg.valid[47] = 1'b1;  frameUdpSruRdOReg.ctrl[47] = 3'b110;
    frameUdpSruRdOReg.data[48] = 8'h00;  frameUdpSruRdOReg.valid[48] = 1'b1;  frameUdpSruRdOReg.ctrl[48] = 3'b110;
    frameUdpSruRdOReg.data[49] = 8'h00;  frameUdpSruRdOReg.valid[49] = 1'b1;  frameUdpSruRdOReg.ctrl[49] = 3'b110;
	//change it according to the frame	
    frameUdpSruRdOReg.data[50] = 8'h80;  frameUdpSruRdOReg.valid[50] = 1'b1;  frameUdpSruRdOReg.ctrl[50] = 3'b110;//Read Reg 0x2: SRU IP
    frameUdpSruRdOReg.data[51] = 8'h00;  frameUdpSruRdOReg.valid[51] = 1'b1;  frameUdpSruRdOReg.ctrl[51] = 3'b110;
    frameUdpSruRdOReg.data[52] = 8'h00;  frameUdpSruRdOReg.valid[52] = 1'b1;  frameUdpSruRdOReg.ctrl[52] = 3'b110;
    frameUdpSruRdOReg.data[53] = 8'h03;  frameUdpSruRdOReg.valid[53] = 1'b1;  frameUdpSruRdOReg.ctrl[53] = 3'b110;
    
	frameUdpSruRdOReg.data[54] = 8'h00;  frameUdpSruRdOReg.valid[54] = 1'b1;  frameUdpSruRdOReg.ctrl[54] = 3'b110;
    frameUdpSruRdOReg.data[55] = 8'h00;  frameUdpSruRdOReg.valid[55] = 1'b1;  frameUdpSruRdOReg.ctrl[55] = 3'b110;
    frameUdpSruRdOReg.data[56] = 8'h00;  frameUdpSruRdOReg.valid[56] = 1'b1;  frameUdpSruRdOReg.ctrl[56] = 3'b110;
    frameUdpSruRdOReg.data[57] = 8'h00;  frameUdpSruRdOReg.valid[57] = 1'b1;  frameUdpSruRdOReg.ctrl[57] = 3'b100;   
	end
	
genvar b;
generate
for(b=58; b<98;b=b+1)
begin: frameUdpSruRdORegRest2
initial
begin
frameUdpSruRdOReg.data[b] = 8'h00;  frameUdpSruRdOReg.valid[b] = 1'b0;  frameUdpSruRdOReg.ctrl[b] = 3'b111;
end
end
endgenerate

 initial
	begin
	frameUdpSruWrOReg.data[0]  = 8'h0a;  frameUdpSruWrOReg.valid[0]  = 1'b1;  frameUdpSruWrOReg.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruWrOReg.data[1]  = 8'h35;  frameUdpSruWrOReg.valid[1]  = 1'b1;  frameUdpSruWrOReg.ctrl[1]  = 3'b110;
    frameUdpSruWrOReg.data[2]  = 8'h0a;  frameUdpSruWrOReg.valid[2]  = 1'b1;  frameUdpSruWrOReg.ctrl[2]  = 3'b110;
    frameUdpSruWrOReg.data[3]  = 8'ha0;  frameUdpSruWrOReg.valid[3]  = 1'b1;  frameUdpSruWrOReg.ctrl[3]  = 3'b110;
    frameUdpSruWrOReg.data[4]  = 8'h84;  frameUdpSruWrOReg.valid[4]  = 1'b1;  frameUdpSruWrOReg.ctrl[4]  = 3'b110;
    frameUdpSruWrOReg.data[5]  = 8'h79;  frameUdpSruWrOReg.valid[5]  = 1'b1;  frameUdpSruWrOReg.ctrl[5]  = 3'b110;
	
    frameUdpSruWrOReg.data[6]  = 8'h00;  frameUdpSruWrOReg.valid[6]  = 1'b1;  frameUdpSruWrOReg.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruWrOReg.data[7]  = 8'h30;  frameUdpSruWrOReg.valid[7]  = 1'b1;  frameUdpSruWrOReg.ctrl[7]  = 3'b110;
    frameUdpSruWrOReg.data[8]  = 8'h48;  frameUdpSruWrOReg.valid[8]  = 1'b1;  frameUdpSruWrOReg.ctrl[8]  = 3'b110;
    frameUdpSruWrOReg.data[9]  = 8'hc1;  frameUdpSruWrOReg.valid[9]  = 1'b1;  frameUdpSruWrOReg.ctrl[9]  = 3'b110;
    frameUdpSruWrOReg.data[10] = 8'h08;  frameUdpSruWrOReg.valid[10] = 1'b1;  frameUdpSruWrOReg.ctrl[10] = 3'b110;
    frameUdpSruWrOReg.data[11] = 8'h79;  frameUdpSruWrOReg.valid[11] = 1'b1;  frameUdpSruWrOReg.ctrl[11] = 3'b110;
	
    frameUdpSruWrOReg.data[12] = 8'h08;  frameUdpSruWrOReg.valid[12] = 1'b1;  frameUdpSruWrOReg.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruWrOReg.data[13] = 8'h00;  frameUdpSruWrOReg.valid[13] = 1'b1;  frameUdpSruWrOReg.ctrl[13] = 3'b110;
   
    frameUdpSruWrOReg.data[14] = 8'h45;  frameUdpSruWrOReg.valid[14] = 1'b1;  frameUdpSruWrOReg.ctrl[14] = 3'b110;
    frameUdpSruWrOReg.data[15] = 8'h00;  frameUdpSruWrOReg.valid[15] = 1'b1;  frameUdpSruWrOReg.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruWrOReg.data[16] = 8'h00;  frameUdpSruWrOReg.valid[16] = 1'b1;  frameUdpSruWrOReg.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruWrOReg.data[17] = 8'h3c;  frameUdpSruWrOReg.valid[17] = 1'b1;  frameUdpSruWrOReg.ctrl[17] = 3'b110;
	
    frameUdpSruWrOReg.data[18] = 8'h00;  frameUdpSruWrOReg.valid[18] = 1'b1;  frameUdpSruWrOReg.ctrl[18] = 3'b110;
    frameUdpSruWrOReg.data[19] = 8'h00;  frameUdpSruWrOReg.valid[19] = 1'b1;  frameUdpSruWrOReg.ctrl[19] = 3'b110;
    frameUdpSruWrOReg.data[20] = 8'h40;  frameUdpSruWrOReg.valid[20] = 1'b1;  frameUdpSruWrOReg.ctrl[20] = 3'b110;
    frameUdpSruWrOReg.data[21] = 8'h00;  frameUdpSruWrOReg.valid[21] = 1'b1;  frameUdpSruWrOReg.ctrl[21] = 3'b110;
    frameUdpSruWrOReg.data[22] = 8'h40;  frameUdpSruWrOReg.valid[22] = 1'b1;  frameUdpSruWrOReg.ctrl[22] = 3'b110;
	
    frameUdpSruWrOReg.data[23] = 8'h11;  frameUdpSruWrOReg.valid[23] = 1'b1;  frameUdpSruWrOReg.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruWrOReg.data[24] = 8'hb6;  frameUdpSruWrOReg.valid[24] = 1'b1;  frameUdpSruWrOReg.ctrl[24] = 3'b110;// Header checker
    frameUdpSruWrOReg.data[25] = 8'hf8;  frameUdpSruWrOReg.valid[25] = 1'b1;  frameUdpSruWrOReg.ctrl[25] = 3'b110;
	
    frameUdpSruWrOReg.data[26] = 8'hc0;  frameUdpSruWrOReg.valid[26] = 1'b1;  frameUdpSruWrOReg.ctrl[26] = 3'b110;// Source IP
    frameUdpSruWrOReg.data[27] = 8'ha8;  frameUdpSruWrOReg.valid[27] = 1'b1;  frameUdpSruWrOReg.ctrl[27] = 3'b110;
    frameUdpSruWrOReg.data[28] = 8'h01;  frameUdpSruWrOReg.valid[28] = 1'b1;  frameUdpSruWrOReg.ctrl[28] = 3'b110;
    frameUdpSruWrOReg.data[29] = 8'h3f;  frameUdpSruWrOReg.valid[29] = 1'b1;  frameUdpSruWrOReg.ctrl[29] = 3'b110;
	
    frameUdpSruWrOReg.data[30] = 8'h0a;  frameUdpSruWrOReg.valid[30] = 1'b1;  frameUdpSruWrOReg.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruWrOReg.data[31] = 8'ha0;  frameUdpSruWrOReg.valid[31] = 1'b1;  frameUdpSruWrOReg.ctrl[31] = 3'b110;
    frameUdpSruWrOReg.data[32] = 8'h84;  frameUdpSruWrOReg.valid[32] = 1'b1;  frameUdpSruWrOReg.ctrl[32] = 3'b110;
    frameUdpSruWrOReg.data[33] = 8'h79;  frameUdpSruWrOReg.valid[33] = 1'b1;  frameUdpSruWrOReg.ctrl[33] = 3'b110;
	
    frameUdpSruWrOReg.data[34] = 8'h17;  frameUdpSruWrOReg.valid[34] = 1'b1;  frameUdpSruWrOReg.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruWrOReg.data[35] = 8'h77;  frameUdpSruWrOReg.valid[35] = 1'b1;  frameUdpSruWrOReg.ctrl[35] = 3'b110;
	
    frameUdpSruWrOReg.data[36] = 8'h10;  frameUdpSruWrOReg.valid[36] = 1'b1;  frameUdpSruWrOReg.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruWrOReg.data[37] = 8'h01;  frameUdpSruWrOReg.valid[37] = 1'b1;  frameUdpSruWrOReg.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruWrOReg.data[38] = 8'h00;  frameUdpSruWrOReg.valid[38] = 1'b1;  frameUdpSruWrOReg.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruWrOReg.data[39] = 8'h28;  frameUdpSruWrOReg.valid[39] = 1'b1;  frameUdpSruWrOReg.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruWrOReg.data[40] = 8'h00;  frameUdpSruWrOReg.valid[40] = 1'b1;  frameUdpSruWrOReg.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruWrOReg.data[41] = 8'h00;  frameUdpSruWrOReg.valid[41] = 1'b1;  frameUdpSruWrOReg.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruWrOReg.data[42] = 8'h00;  frameUdpSruWrOReg.valid[42] = 1'b1;  frameUdpSruWrOReg.ctrl[42] = 3'b110;// SRU
    frameUdpSruWrOReg.data[43] = 8'h10;  frameUdpSruWrOReg.valid[43] = 1'b1;  frameUdpSruWrOReg.ctrl[43] = 3'b110;
    frameUdpSruWrOReg.data[44] = 8'h00;  frameUdpSruWrOReg.valid[44] = 1'b1;  frameUdpSruWrOReg.ctrl[44] = 3'b110;
    frameUdpSruWrOReg.data[45] = 8'h00;  frameUdpSruWrOReg.valid[45] = 1'b1;  frameUdpSruWrOReg.ctrl[45] = 3'b110;
	
    frameUdpSruWrOReg.data[46] = 8'h00;  frameUdpSruWrOReg.valid[46] = 1'b1;  frameUdpSruWrOReg.ctrl[46] = 3'b110;
    frameUdpSruWrOReg.data[47] = 8'h00;  frameUdpSruWrOReg.valid[47] = 1'b1;  frameUdpSruWrOReg.ctrl[47] = 3'b110;
    frameUdpSruWrOReg.data[48] = 8'h00;  frameUdpSruWrOReg.valid[48] = 1'b1;  frameUdpSruWrOReg.ctrl[48] = 3'b110;
    frameUdpSruWrOReg.data[49] = 8'h00;  frameUdpSruWrOReg.valid[49] = 1'b1;  frameUdpSruWrOReg.ctrl[49] = 3'b110;
	//DTC word alignment	
    frameUdpSruWrOReg.data[50] = 8'h00;  frameUdpSruWrOReg.valid[50] = 1'b1;  frameUdpSruWrOReg.ctrl[50] = 3'b110;//Read Reg 0x2: SRU IP
    frameUdpSruWrOReg.data[51] = 8'h00;  frameUdpSruWrOReg.valid[51] = 1'b1;  frameUdpSruWrOReg.ctrl[51] = 3'b110;
    frameUdpSruWrOReg.data[52] = 8'h00;  frameUdpSruWrOReg.valid[52] = 1'b1;  frameUdpSruWrOReg.ctrl[52] = 3'b110;
    frameUdpSruWrOReg.data[53] = 8'h12;  frameUdpSruWrOReg.valid[53] = 1'b1;  frameUdpSruWrOReg.ctrl[53] = 3'b110;
    
	 frameUdpSruWrOReg.data[54] = 8'h00;  frameUdpSruWrOReg.valid[54] = 1'b1;  frameUdpSruWrOReg.ctrl[54] = 3'b110;
    frameUdpSruWrOReg.data[55] = 8'h00;  frameUdpSruWrOReg.valid[55] = 1'b1;  frameUdpSruWrOReg.ctrl[55] = 3'b110;
    frameUdpSruWrOReg.data[56] = 8'h00;  frameUdpSruWrOReg.valid[56] = 1'b1;  frameUdpSruWrOReg.ctrl[56] = 3'b110;
    frameUdpSruWrOReg.data[57] = 8'h00;  frameUdpSruWrOReg.valid[57] = 1'b1;  frameUdpSruWrOReg.ctrl[57] = 3'b100;   
	end
	
genvar a;
generate
for(a=58; a<98;a=a+1)
begin: frameUdpSruWrORegRest2
initial
begin
frameUdpSruWrOReg.data[a] = 8'h00;  frameUdpSruWrOReg.valid[a] = 1'b0;  frameUdpSruWrOReg.ctrl[a] = 3'b111;
end
end
endgenerate

 initial
	begin
	frameUdpSruBusyClr.data[0]  = 8'h0a;  frameUdpSruBusyClr.valid[0]  = 1'b1;  frameUdpSruBusyClr.ctrl[0]  = 3'b010; // Destination Address (DA)
    frameUdpSruBusyClr.data[1]  = 8'h35;  frameUdpSruBusyClr.valid[1]  = 1'b1;  frameUdpSruBusyClr.ctrl[1]  = 3'b110;
    frameUdpSruBusyClr.data[2]  = 8'h0a;  frameUdpSruBusyClr.valid[2]  = 1'b1;  frameUdpSruBusyClr.ctrl[2]  = 3'b110;
    frameUdpSruBusyClr.data[3]  = 8'ha0;  frameUdpSruBusyClr.valid[3]  = 1'b1;  frameUdpSruBusyClr.ctrl[3]  = 3'b110;
    frameUdpSruBusyClr.data[4]  = 8'h84;  frameUdpSruBusyClr.valid[4]  = 1'b1;  frameUdpSruBusyClr.ctrl[4]  = 3'b110;
    frameUdpSruBusyClr.data[5]  = 8'h79;  frameUdpSruBusyClr.valid[5]  = 1'b1;  frameUdpSruBusyClr.ctrl[5]  = 3'b110;
	
    frameUdpSruBusyClr.data[6]  = 8'h00;  frameUdpSruBusyClr.valid[6]  = 1'b1;  frameUdpSruBusyClr.ctrl[6]  = 3'b110;// Source Address (5A)
    frameUdpSruBusyClr.data[7]  = 8'h30;  frameUdpSruBusyClr.valid[7]  = 1'b1;  frameUdpSruBusyClr.ctrl[7]  = 3'b110;
    frameUdpSruBusyClr.data[8]  = 8'h48;  frameUdpSruBusyClr.valid[8]  = 1'b1;  frameUdpSruBusyClr.ctrl[8]  = 3'b110;
    frameUdpSruBusyClr.data[9]  = 8'hc1;  frameUdpSruBusyClr.valid[9]  = 1'b1;  frameUdpSruBusyClr.ctrl[9]  = 3'b110;
    frameUdpSruBusyClr.data[10] = 8'h08;  frameUdpSruBusyClr.valid[10] = 1'b1;  frameUdpSruBusyClr.ctrl[10] = 3'b110;
    frameUdpSruBusyClr.data[11] = 8'h79;  frameUdpSruBusyClr.valid[11] = 1'b1;  frameUdpSruBusyClr.ctrl[11] = 3'b110;
	
    frameUdpSruBusyClr.data[12] = 8'h08;  frameUdpSruBusyClr.valid[12] = 1'b1;  frameUdpSruBusyClr.ctrl[12] = 3'b110; // Ethernet type (0x0800, IP)	
    frameUdpSruBusyClr.data[13] = 8'h00;  frameUdpSruBusyClr.valid[13] = 1'b1;  frameUdpSruBusyClr.ctrl[13] = 3'b110;
   
    frameUdpSruBusyClr.data[14] = 8'h45;  frameUdpSruBusyClr.valid[14] = 1'b1;  frameUdpSruBusyClr.ctrl[14] = 3'b110;
    frameUdpSruBusyClr.data[15] = 8'h00;  frameUdpSruBusyClr.valid[15] = 1'b1;  frameUdpSruBusyClr.ctrl[15] = 3'b110;
	//change it according to the frame
    frameUdpSruBusyClr.data[16] = 8'h00;  frameUdpSruBusyClr.valid[16] = 1'b1;  frameUdpSruBusyClr.ctrl[16] = 3'b110;// 16 bit total length (002c:60)
    frameUdpSruBusyClr.data[17] = 8'h3c;  frameUdpSruBusyClr.valid[17] = 1'b1;  frameUdpSruBusyClr.ctrl[17] = 3'b110;
	
    frameUdpSruBusyClr.data[18] = 8'h00;  frameUdpSruBusyClr.valid[18] = 1'b1;  frameUdpSruBusyClr.ctrl[18] = 3'b110;
    frameUdpSruBusyClr.data[19] = 8'h00;  frameUdpSruBusyClr.valid[19] = 1'b1;  frameUdpSruBusyClr.ctrl[19] = 3'b110;
    frameUdpSruBusyClr.data[20] = 8'h40;  frameUdpSruBusyClr.valid[20] = 1'b1;  frameUdpSruBusyClr.ctrl[20] = 3'b110;
    frameUdpSruBusyClr.data[21] = 8'h00;  frameUdpSruBusyClr.valid[21] = 1'b1;  frameUdpSruBusyClr.ctrl[21] = 3'b110;
    frameUdpSruBusyClr.data[22] = 8'h40;  frameUdpSruBusyClr.valid[22] = 1'b1;  frameUdpSruBusyClr.ctrl[22] = 3'b110;
	
    frameUdpSruBusyClr.data[23] = 8'h11;  frameUdpSruBusyClr.valid[23] = 1'b1;  frameUdpSruBusyClr.ctrl[23] = 3'b110;// Protocol (UDP: 0x11)
	//change it according to the frame	
    frameUdpSruBusyClr.data[24] = 8'hb6;  frameUdpSruBusyClr.valid[24] = 1'b1;  frameUdpSruBusyClr.ctrl[24] = 3'b110;// Header checker
    frameUdpSruBusyClr.data[25] = 8'hf8;  frameUdpSruBusyClr.valid[25] = 1'b1;  frameUdpSruBusyClr.ctrl[25] = 3'b110;
	
    frameUdpSruBusyClr.data[26] = 8'hc0;  frameUdpSruBusyClr.valid[26] = 1'b1;  frameUdpSruBusyClr.ctrl[26] = 3'b110;// Source IP
    frameUdpSruBusyClr.data[27] = 8'ha8;  frameUdpSruBusyClr.valid[27] = 1'b1;  frameUdpSruBusyClr.ctrl[27] = 3'b110;
    frameUdpSruBusyClr.data[28] = 8'h01;  frameUdpSruBusyClr.valid[28] = 1'b1;  frameUdpSruBusyClr.ctrl[28] = 3'b110;
    frameUdpSruBusyClr.data[29] = 8'h3f;  frameUdpSruBusyClr.valid[29] = 1'b1;  frameUdpSruBusyClr.ctrl[29] = 3'b110;
	
    frameUdpSruBusyClr.data[30] = 8'h0a;  frameUdpSruBusyClr.valid[30] = 1'b1;  frameUdpSruBusyClr.ctrl[30] = 3'b110;// Destination IP
    frameUdpSruBusyClr.data[31] = 8'ha0;  frameUdpSruBusyClr.valid[31] = 1'b1;  frameUdpSruBusyClr.ctrl[31] = 3'b110;
    frameUdpSruBusyClr.data[32] = 8'h84;  frameUdpSruBusyClr.valid[32] = 1'b1;  frameUdpSruBusyClr.ctrl[32] = 3'b110;
    frameUdpSruBusyClr.data[33] = 8'h79;  frameUdpSruBusyClr.valid[33] = 1'b1;  frameUdpSruBusyClr.ctrl[33] = 3'b110;
	
    frameUdpSruBusyClr.data[34] = 8'h17;  frameUdpSruBusyClr.valid[34] = 1'b1;  frameUdpSruBusyClr.ctrl[34] = 3'b110;// Source port (0x1777)
    frameUdpSruBusyClr.data[35] = 8'h77;  frameUdpSruBusyClr.valid[35] = 1'b1;  frameUdpSruBusyClr.ctrl[35] = 3'b110;
	
    frameUdpSruBusyClr.data[36] = 8'h10;  frameUdpSruBusyClr.valid[36] = 1'b1;  frameUdpSruBusyClr.ctrl[36] = 3'b110;// Des Port (0x03e9)
    frameUdpSruBusyClr.data[37] = 8'h01;  frameUdpSruBusyClr.valid[37] = 1'b1;  frameUdpSruBusyClr.ctrl[37] = 3'b110;
	//change it according to the frame	
    frameUdpSruBusyClr.data[38] = 8'h00;  frameUdpSruBusyClr.valid[38] = 1'b1;  frameUdpSruBusyClr.ctrl[38] = 3'b110;// UDP length (0x28:40)
    frameUdpSruBusyClr.data[39] = 8'h28;  frameUdpSruBusyClr.valid[39] = 1'b1;  frameUdpSruBusyClr.ctrl[39] = 3'b110; 
	//always zero, udp checksum is not used	
    frameUdpSruBusyClr.data[40] = 8'h00;  frameUdpSruBusyClr.valid[40] = 1'b1;  frameUdpSruBusyClr.ctrl[40] = 3'b110;// UDP checksum (0x0000)
    frameUdpSruBusyClr.data[41] = 8'h00;  frameUdpSruBusyClr.valid[41] = 1'b1;  frameUdpSruBusyClr.ctrl[41] = 3'b110;
	//change it according to the frame		
    frameUdpSruBusyClr.data[42] = 8'h00;  frameUdpSruBusyClr.valid[42] = 1'b1;  frameUdpSruBusyClr.ctrl[42] = 3'b110;// SRU
    frameUdpSruBusyClr.data[43] = 8'h10;  frameUdpSruBusyClr.valid[43] = 1'b1;  frameUdpSruBusyClr.ctrl[43] = 3'b110;
    frameUdpSruBusyClr.data[44] = 8'h00;  frameUdpSruBusyClr.valid[44] = 1'b1;  frameUdpSruBusyClr.ctrl[44] = 3'b110;
    frameUdpSruBusyClr.data[45] = 8'h00;  frameUdpSruBusyClr.valid[45] = 1'b1;  frameUdpSruBusyClr.ctrl[45] = 3'b110;
	
    frameUdpSruBusyClr.data[46] = 8'h00;  frameUdpSruBusyClr.valid[46] = 1'b1;  frameUdpSruBusyClr.ctrl[46] = 3'b110;
    frameUdpSruBusyClr.data[47] = 8'h00;  frameUdpSruBusyClr.valid[47] = 1'b1;  frameUdpSruBusyClr.ctrl[47] = 3'b110;
    frameUdpSruBusyClr.data[48] = 8'h00;  frameUdpSruBusyClr.valid[48] = 1'b1;  frameUdpSruBusyClr.ctrl[48] = 3'b110;
    frameUdpSruBusyClr.data[49] = 8'h00;  frameUdpSruBusyClr.valid[49] = 1'b1;  frameUdpSruBusyClr.ctrl[49] = 3'b110;
	//DTC word alignment	
    frameUdpSruBusyClr.data[50] = 8'h00;  frameUdpSruBusyClr.valid[50] = 1'b1;  frameUdpSruBusyClr.ctrl[50] = 3'b110;//Read Reg 0x2: SRU IP
    frameUdpSruBusyClr.data[51] = 8'h00;  frameUdpSruBusyClr.valid[51] = 1'b1;  frameUdpSruBusyClr.ctrl[51] = 3'b110;
    frameUdpSruBusyClr.data[52] = 8'h00;  frameUdpSruBusyClr.valid[52] = 1'b1;  frameUdpSruBusyClr.ctrl[52] = 3'b110;
    frameUdpSruBusyClr.data[53] = 8'h13;  frameUdpSruBusyClr.valid[53] = 1'b1;  frameUdpSruBusyClr.ctrl[53] = 3'b110;
    
	 frameUdpSruBusyClr.data[54] = 8'h00;  frameUdpSruBusyClr.valid[54] = 1'b1;  frameUdpSruBusyClr.ctrl[54] = 3'b110;
    frameUdpSruBusyClr.data[55] = 8'h00;  frameUdpSruBusyClr.valid[55] = 1'b1;  frameUdpSruBusyClr.ctrl[55] = 3'b110;
    frameUdpSruBusyClr.data[56] = 8'h00;  frameUdpSruBusyClr.valid[56] = 1'b1;  frameUdpSruBusyClr.ctrl[56] = 3'b110;
    frameUdpSruBusyClr.data[57] = 8'h00;  frameUdpSruBusyClr.valid[57] = 1'b1;  frameUdpSruBusyClr.ctrl[57] = 3'b100;   
	end
	
genvar f;
generate
for(f=58; f<98;f=f+1)
begin: frameUdpSruBusyClr2
initial
begin
frameUdpSruBusyClr.data[f] = 8'h00;  frameUdpSruBusyClr.valid[f] = 1'b0;  frameUdpSruBusyClr.ctrl[f] = 3'b111;
end
end
endgenerate


//frame end

  //---------------------------------------------------
  // Rx stimulus process. This task will drive following interface signals
  // rx_ll_data = 0
  // rx_ll_ctrl_i (rx_ll_sof_n, rx_ll_eof_n, rx_ll_src_rdy_n)
  //---------------------------------------------------
  task rx_stimulus_send_frame;
    input   `frame_typ_c frame;
    input   integer frame_number;
    integer current_col;
    begin
      // import the frame into scratch space
      rx_stimulus_working_frame.frombits(frame);

      $display("Sending Frame %d", frame_number);

       rx_ll_data <= 8'h55;
	   rx_ll_ctrl_i <= 3'b111;    
	   @(posedge rx_ll_clock);

      // Sending the MAC frame
      //----------------------------------
      current_col = 0;
	  for(current_col = 0; current_col < 98; current_col = current_col + 1)
      begin
          rx_ll_data <= rx_stimulus_working_frame.data[current_col];
		  rx_ll_ctrl_i <= rx_stimulus_working_frame.ctrl[current_col];
          @(posedge rx_ll_clock);
		   end// while
       rx_ll_data <= 8'h55;
	   rx_ll_ctrl_i <= 3'b111;    
	   @(posedge rx_ll_clock);
    end
  endtask // rx_stimulus_send_frame;
  
  		assign rx_ll_sof_n = rx_ll_ctrl_i[2];
  		assign rx_ll_eof_n = rx_ll_ctrl_i[1];
  		assign rx_ll_src_rdy_n = rx_ll_ctrl_i[0];		

  //---------------------------------------------------
  // Inject the frames
  // The frames are: frameArp, frameIcmpWindows,frameIcmpLinux, frameUdpDtc, frameUdpFlash,frameUdpSruRdOReg
  //---------------------------------------------------

  initial
  begin : p_rx_stimulus
       rx_ll_data <= 8'h55;
	   rx_ll_ctrl_i <= 3'b111; 
	   @(posedge rx_ll_clock);

		repeat(200)
		begin
		  repeat(125)
		  begin
		  @(posedge rx_ll_clock);
		  end	
		end		
		
      rx_stimulus_send_frame(frameUdpSruReset.tobits(0), 0);
		$display("** frameUdpSruReset packet %t", $realtime);
		
		repeat(200)
		begin
		  repeat(125)
		  begin
		  @(posedge rx_ll_clock);
		  end	
		end	
		
//      rx_stimulus_send_frame(frameArp.tobits(0), 0);
//		$display("** Just sent a frameArp packet %t", $realtime);
//		repeat(200)
//		begin
//		@(posedge rx_ll_clock);	
//		end		
//
//      rx_stimulus_send_frame(frameIcmpWindows.tobits(0), 1);
//		$display("** Windows frameIcmpWindows packet %t", $realtime);
//		repeat(500)
//		begin
//		@(posedge rx_ll_clock);	
//		end			
//      rx_stimulus_send_frame(frameIcmpLinux.tobits(0), 2);
//		$display("** Just sent a frameIcmpLinux packet %t", $realtime);
//

		repeat(500)
		begin
		@(posedge rx_ll_clock);	
		end		

      rx_stimulus_send_frame(frameUdpSruPhaseSet.tobits(0), 5);
		$display("** Sent a frameUdpSruPhaseSet packet %t", $realtime);	
		
		repeat(2000)
		begin
		  repeat(125)
		  begin
		  @(posedge rx_ll_clock);
		  end	
		end	


		repeat(500)
		begin
		@(posedge rx_ll_clock);	
		end		

      rx_stimulus_send_frame(frameUdpSruRdOReg.tobits(0), 5);
		$display("** Sent a frameUdpSruRdOReg packet %t", $realtime);	

		repeat(500)
		begin
		@(posedge rx_ll_clock);	
		end		

      rx_stimulus_send_frame(frameUdpSruWrOReg.tobits(0), 5);
		$display("** Sent a frameUdpSruWrOReg packet %t", $realtime);


		repeat(500)
		begin
		@(posedge rx_ll_clock);	
		end		

//      rx_stimulus_send_frame(frameUdpSruRdVer.tobits(0), 5);
//		$display("** Sent a frameUdpSruRdVer packet %t", $realtime);	
		
		repeat(100)
		begin
		  repeat(125)
		  begin
		  @(posedge rx_ll_clock);
		  end	
		end	
      rx_stimulus_send_frame(frameUdpDtc.tobits(0), 3);
		$display("** Windows frameUdpDtc packet %t", $realtime);


		repeat(5)
		begin
		  repeat(125)
		  begin
		  @(posedge rx_ll_clock);
		  end	
		end	
		
	
//		repeat(500)
//		begin
//		@(posedge rx_ll_clock);	
//		end	
//      rx_stimulus_send_frame(frameUdpFlash.tobits(0), 4);
//		$display("** Just sent a frameUdpFlash packet %t", $realtime);

		
		repeat(1000)
		begin
		@(posedge rx_ll_clock);	
		end	
      rx_stimulus_send_frame(frameUdpDtc.tobits(0), 3);
		$display("** Windows frameUdpDtc packet %t", $realtime);
		
		repeat(200)
		begin
		@(posedge rx_ll_clock);	
		end	
      rx_stimulus_send_frame(frameUdpSruStrig.tobits(0), 4);
		$display("** frameUdpSruStrig packet %t", $realtime);		


		repeat(1500)
		begin
		  repeat(125)
		  begin
		  @(posedge rx_ll_clock);
		  end	
		  end

//		repeat(200)
//		begin
//		@(posedge rx_ll_clock);	
//		end	
//      rx_stimulus_send_frame(frameUdpSruBusyClr.tobits(0), 5);
//		$display("** frameUdpSruBusyClr packet %t", $realtime);		
		
    forever
		begin
       rx_ll_data <= 8'h55;
	   rx_ll_ctrl_i <= 3'b111;   
			@(posedge rx_ll_clock);	
		end
  end // p_rx_stimulus

endmodule // phy_tb