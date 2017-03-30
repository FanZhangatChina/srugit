`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module sru_dcscmd_par(
		input       			dcs_rx_clk,           
		input [7:0] 			dcs_rxd,              
		input 					dcs_rx_dv,            

		input						gclk_40m,
		
		output reg 				udp_cmd_dv = 1'b0,
		output reg [31:0]		udp_cmd_addr = 32'h0,
		output reg [31:0]		udp_cmd_data = 32'h0,
		input						udp_reply_stored,

		input 					reset
    );

	reg  fifo_rd_en = 1'b0;
	wire [31:0] fifo_rd_dout;
	wire fifo_rd_empty;
	

	 parameter st0 = 0;
	 parameter st1 = 1;
	 parameter st2 = 2;
	 parameter st3 = 3;
	 parameter st4 = 4;
	 parameter st5 = 5;
	 parameter st6 = 6;
	 parameter st7 = 7;
	 parameter st8 = 8;
	 parameter st9 = 9;

	 reg [3:0] st = st0;
	 
	 reg [7:0] clkcnt = 8'h0;
	

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

	always @(posedge gclk_40m)
	if(reset)
	begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= 32'h0;
	udp_cmd_data <= 32'h0;
	clkcnt <= 8'h0;
	
	st <= st0;
	end else
	case(st)
	st0 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= 32'h0;
	udp_cmd_data <= 32'h0;
	clkcnt <= 8'h0;
	
	if(fifo_rd_empty)
	st <= st0;
	else
	st <= st1;	
	end
		
	st1 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= 32'h0;
	udp_cmd_data <= 32'h0;
	clkcnt <= 8'h0;
	
	if(dcs_rx_dv)
	st <= st1;
	else
	st <= st9;	
	end	
		
	st9 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= 32'h0;
	udp_cmd_data <= 32'h0;
	clkcnt <= clkcnt + 4'd1;
	
	if(clkcnt == 4'd10)
	st <= st2;	
	else
	st <= st9;
	end
	
	st2 : begin
	fifo_rd_en <= 1'b1;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= 32'h0;
	udp_cmd_data <= 32'h0;
	clkcnt <= 8'h0;
	
	st <= st3;	
	end
	
	st3 : begin
	fifo_rd_en <= 1'b1;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= udp_cmd_addr;
	udp_cmd_data <= udp_cmd_data;
	clkcnt <= 8'h0;
	
	st <= st4;	
	end
	
	st4 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= fifo_rd_dout;
	udp_cmd_data <= udp_cmd_data;
	clkcnt <= 8'h0;
	
	st <= st5;	
	end
	
	st5 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b1;
	udp_cmd_addr <= udp_cmd_addr;
	udp_cmd_data <= fifo_rd_dout;
	clkcnt <= clkcnt + 8'h1;
	
	if(udp_cmd_addr[31])//read
		st <= st6;
	else
		st <= st7;
	end
	
	st6 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b1;
	udp_cmd_addr <= udp_cmd_addr;
	udp_cmd_data <= fifo_rd_dout;
	clkcnt <= clkcnt + 8'h1;
	
	if(udp_reply_stored)//read
		st <= st7;
	else
		if(clkcnt == 8'd250)
		st <= st8;
		else
		st <= st6;
	end

	st7 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b1;
	udp_cmd_addr <= udp_cmd_addr;
	udp_cmd_data <= fifo_rd_dout;
	clkcnt <= clkcnt + 8'h1;
	
	if(udp_reply_stored)
		if(clkcnt == 8'd200)
			st <= st8;
		else
			st <= st7;
	else
		st <= st8;
	end	
	
	st8 : begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= udp_cmd_addr;
	udp_cmd_data <= udp_cmd_data;
	clkcnt <= 8'h0;
	
	if(fifo_rd_empty)
	st <= st0;	
	else
	st <= st2;
	end	
	
	default: begin
	fifo_rd_en <= 1'b0;
	udp_cmd_dv <= 1'b0;
	udp_cmd_addr <= 32'h0;
	udp_cmd_data <= 32'h0;
	clkcnt <= 8'h0;
	
	st <= st0;
	end	
	endcase


endmodule
