`timescale 1ns / 1ps
`define DLY #1

// ALICE/EMCal SRU
// This module decodes udp data to dcs command for dtc modules.
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 11 July 2015

module dtc_dcscmd_par(
		input       			dcs_rx_clk,                 
		input [7:0] 			dcs_rxd,              
		input 					dcs_rx_dv,            

		input						gclk_40m,
		
		input						udp_cmd_dv_ack,
		output reg 				udp_cmd_dv = 1'b0,				
		output reg [31:0]		udp_cmd_addr = 32'h0,			
		output reg [31:0]		udp_cmd_data = 32'h0,			

		input 					reset
    );

	reg  fifo_rd_en = 1'b0;
	wire [31:0] fifo_rd_dout;
	wire fifo_rd_empty;
	reg [7:0] clkcnt = 8'h0;

	 parameter st0  = 12'b0000_0000_0001;
	 parameter st1  = 12'b0000_0000_0010;
	 parameter st3  = 12'b0000_0000_0100;
	 parameter st4  = 12'b0000_0000_1000;
	 parameter st5  = 12'b0000_0001_0000;
	 parameter st6  = 12'b0000_0010_0000;
	 parameter st7  = 12'b0000_0100_0000;
	 parameter st8  = 12'b0000_1000_0000;
	 parameter stc2 = 12'b0001_0000_0000;
	 parameter st9  = 12'b0010_0000_0000;
	 parameter st10 = 12'b0100_0000_0000;
	 parameter st9f = 12'b1000_0000_0000;

	 reg [11:0] st = st0;
   
	(* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="12'b0000_0000_0001" *) 

	always @(posedge gclk_40m)
	if(reset)
	begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY 32'h0;
	udp_cmd_data <= `DLY 32'h0;
	
	clkcnt <= `DLY 8'd0;
	
	st <= `DLY st0;
	end else
	case(st)
	st0 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	if(fifo_rd_empty)
	st <= `DLY st0;
	else
	st <= `DLY st1;	
	end
		
	st1 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	if(dcs_rx_dv|fifo_rd_empty)
	st <= `DLY st1;
	else
	st <= `DLY stc2;
	end
	
		
	stc2 : begin
	fifo_rd_en <= `DLY 1'b1;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	st <= `DLY st3;	
	end	

	st3 : begin
	fifo_rd_en <= `DLY 1'b1;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	st <= `DLY st4;	
	end
	
	st4 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY fifo_rd_dout;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	st <= `DLY st5;	
	end
	
	st5 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b1;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY fifo_rd_dout;
	
	clkcnt <= `DLY clkcnt + 8'd1;
	
	if(udp_cmd_dv_ack)
	st <= `DLY st8;	
	else
	st <= `DLY st5;
	end	

	st8 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	if(fifo_rd_empty)
	st <= `DLY st9f;	
	else
	st <= `DLY st9;
	end	
	
	st9f : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY clkcnt + 8'd1;
	
	if(clkcnt == 8'd160)
	st <= `DLY st0;	
	else
	st <= `DLY st9f;
	end	
	
	st9 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY 8'd0;
	
	st <= `DLY st10;
	end	

	st10 : begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY udp_cmd_addr;
	udp_cmd_data <= `DLY udp_cmd_data;
	
	clkcnt <= `DLY clkcnt + 8'd1;
	
	if(clkcnt == 8'd160)
	st <= `DLY stc2;	
	else
	st <= `DLY st10;
	end	
	
	
	default: begin
	fifo_rd_en <= `DLY 1'b0;
	udp_cmd_dv <= `DLY 1'b0;
	udp_cmd_addr <= `DLY 32'h0;
	udp_cmd_data <= `DLY 32'h0;
	
	clkcnt <= `DLY 8'd0;
	
	st <= `DLY st0;
	end	
	endcase

	 
//synthesis attribute box_type fifo_8to32b "black_box" 
fifo_8to32b u_fifo_8to32b (
  .rst(reset), // input rst
  .wr_clk(dcs_rx_clk), // input wr_clk
  .rd_clk(gclk_40m), // input rd_clk
  .din(dcs_rxd), // input [7 : 0] din
  .wr_en(dcs_rx_dv), // input wr_en
  .rd_en(fifo_rd_en), // input rd_en
  .dout(fifo_rd_dout), // output [31 : 0] dout
  .full(), // output full
  .empty(fifo_rd_empty) // output empty
);


endmodule
