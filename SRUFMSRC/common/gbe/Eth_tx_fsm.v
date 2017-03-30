`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module Eth_tx_fsm( 
		//Eth reply transmit interface
		input  				Eth_tx_clk,
		output 				Eth_tx_sof_n,
		output [7:0] 		Eth_tx_data_out,
		output 				Eth_tx_eof_n,
		output 				Eth_tx_src_rdy_n,
		input  				Eth_tx_dst_rdy_n,
		output [3:0]  		Eth_tx_fifo_status,
		output 				Eth_tx_overflow,		
		//No flow control
		output  				Eth_reply_rd_clk,
		input 				Eth_reply_rd_sof_n,
		input [7:0] 		Eth_reply_rd_data_out,
		input 				Eth_reply_rd_eof_n,
		input 				Eth_reply_rd_src_rdy_n,
		output reg			Eth_reply_rd_dst_rdy_n = 1'b1,
		output [5:0]      Eth_reply_rd_fifo_addr,
		
		//Configuration parameters
		input [95:0]		Eth_reply_MAC,
		
		input 				reset
);

   //parameter EthIP = 16'h0800;
   //parameter EthARP = 16'h0806;
   wire [15:0] Eth_type ;
   reg eth_ch_sel = 1'b0;
   assign Eth_type = {12'h080,1'b0,eth_ch_sel,eth_ch_sel,1'b0};
   wire Eth_wr_clk;
   
   //14 bytes
   wire [111:0] eth_header_wire;
   reg [111:0] eth_header_reg = 112'h0;
   
   reg Eth_wr_enable = 1'b0, Eth_wr_data_valid = 1'b0, Eth_wr_good_frame = 1'b0;
   reg [7:0] Eth_wr_data = 8'h0;
   reg [7:0] cnt = 8'd0;
   wire Eth_wr_bad_frame;

   parameter EthReplyChSwitch_s = 3'd0; parameter EthHeaderLoad_s = 3'd1;
   parameter EthHeaderWr_s = 3'd2; 		parameter EthSof_s = 3'd3;
   parameter EthDataWr_s = 3'd4;      	parameter EthWe_s = 3'd5; 	
   parameter EthReplyChSwitch2_s = 3'd6;
   
   reg [2:0] EthReplySt = EthReplyChSwitch_s;
   
   always @(posedge Eth_wr_clk)
   if(reset)
   begin
   eth_ch_sel <= 1'b0;
   Eth_wr_enable <= 1'b0;
   Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= 112'h0;
   Eth_reply_rd_dst_rdy_n <= 1'b1;
   cnt <= 8'd0;
   Eth_wr_data <= 8'h0;
   Eth_wr_data_valid <= 1'h0;
   
   EthReplySt <= EthReplyChSwitch_s;
   end else case(EthReplySt)
   EthReplyChSwitch_s: begin
   eth_ch_sel <= ~eth_ch_sel;
   Eth_wr_enable <= 1'b0;
   Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= 112'h0;
   Eth_reply_rd_dst_rdy_n <= 1'b1;
   cnt <= 8'd0;
   Eth_wr_data <= 8'h0;
   Eth_wr_data_valid <= 1'h0;
   
   if(Eth_tx_fifo_status > 4'he)
   EthReplySt <= EthReplyChSwitch_s;
   else
   EthReplySt <= EthReplyChSwitch2_s;
   end
   
   EthReplyChSwitch2_s: begin
   eth_ch_sel <= eth_ch_sel;
   Eth_wr_enable <= 1'b0;
   Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= 112'h0;
   Eth_reply_rd_dst_rdy_n <= 1'b1;
   cnt <= cnt+ 8'd1;
   Eth_wr_data <= 8'h0;
   Eth_wr_data_valid <= 1'h0;
   
   if(cnt == 8'd3)
	   if(Eth_reply_rd_src_rdy_n|Eth_reply_rd_sof_n)
	   EthReplySt <= EthReplyChSwitch_s;
	   else
	   EthReplySt <= EthHeaderLoad_s;
   else
   EthReplySt <= EthReplyChSwitch2_s;
   end  
   
   EthHeaderLoad_s: begin
   eth_ch_sel <= eth_ch_sel;
   Eth_wr_enable <= 1'b1;
   Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= eth_header_wire;
   Eth_reply_rd_dst_rdy_n <= 1'b1;
   cnt <= 8'd0;
   Eth_wr_data <= 8'h0;
   Eth_wr_data_valid <= 1'h0;
   
   EthReplySt <= EthHeaderWr_s;
   end  
   
   EthHeaderWr_s: begin
   eth_ch_sel <= eth_ch_sel;
   Eth_wr_enable <= 1'b1;
   Eth_wr_good_frame <= 1'b0;
   Eth_wr_data <= eth_header_reg[111:104];
   eth_header_reg <= {eth_header_reg[103:0],8'h0};
   Eth_reply_rd_dst_rdy_n <= 1'b1;  
   Eth_wr_data_valid <= 1'h1;   
   
   if(cnt == 8'd13)
	   begin
	   cnt <= 8'd0;
	   EthReplySt <= EthSof_s;
	   end
   else
	   begin
	   cnt <= cnt + 4'd1;
	   EthReplySt <= EthHeaderWr_s;
	   end
   end  

   EthSof_s: begin
   eth_ch_sel <= eth_ch_sel;
   Eth_wr_enable <= 1'b1;
   Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= 112'h0;
   Eth_reply_rd_dst_rdy_n <= 1'b0;
   cnt <= 8'd0;
   Eth_wr_data <= 8'h0;
   Eth_wr_data_valid <= 1'h0;

   EthReplySt <= EthDataWr_s;
   end 
   
   EthDataWr_s: begin
   eth_ch_sel <= eth_ch_sel;
   Eth_wr_enable <= 1'b1;
   Eth_wr_data <= Eth_reply_rd_data_out;
   //Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= 112'h0;
   
   cnt <= 8'd0;
   Eth_wr_data_valid <= 1'h1;
   
   if(Eth_reply_rd_eof_n)
		begin
		Eth_wr_good_frame <= 1'b0;
		Eth_reply_rd_dst_rdy_n <= 1'b0;
		EthReplySt <= EthDataWr_s;
		end
	else
		begin
		Eth_wr_good_frame <= 1'b1;
		Eth_reply_rd_dst_rdy_n <= 1'b1;
		EthReplySt <= EthWe_s;
		end
   end 
   
   EthWe_s: begin
   eth_ch_sel <= eth_ch_sel;
   Eth_wr_enable <= 1'b1;
   Eth_wr_good_frame <= 1'b0;
   eth_header_reg <= 112'h0;
   Eth_reply_rd_dst_rdy_n <= 1'b1;
   cnt <= cnt + 4'd1;
   Eth_wr_data <= 8'h0;
   Eth_wr_data_valid <= 1'h0;
   
   if(cnt == 8'd3)
   EthReplySt <= EthReplyChSwitch_s;
   else
   EthReplySt <= EthWe_s;
   end  
   
	default: begin
	eth_ch_sel <= eth_ch_sel;
	Eth_wr_enable <= 1'b0;
	Eth_wr_data_valid <= 1'b0;
	Eth_wr_good_frame <= 1'b0;
	eth_header_reg <= 112'h0;
	Eth_reply_rd_dst_rdy_n <= 1'b1;
	cnt <= 8'd0;
	Eth_wr_data <= 8'h0;
	Eth_wr_data_valid <= 1'h0;
	end
	endcase
   
   rx_client_fifo_8_f1 Eth_tx_tx_fifo_8_f1 (
      .rd_clk          (Eth_tx_clk),
      .rd_sreset       (reset),
      .rd_data_out     (Eth_tx_data_out),
      .rd_sof_n        (Eth_tx_sof_n),
      .rd_eof_n        (Eth_tx_eof_n),
      .rd_src_rdy_n    (Eth_tx_src_rdy_n),
      .rd_dst_rdy_n    (Eth_tx_dst_rdy_n),
      .rx_fifo_status  (Eth_tx_fifo_status),
	
      .wr_sreset       (reset),
      .wr_clk          (Eth_wr_clk),
      .wr_enable       (Eth_wr_enable),
      .rx_data         (Eth_wr_data),
      .rx_data_valid   (Eth_wr_data_valid),
      .rx_good_frame   (Eth_wr_good_frame),
      .rx_bad_frame    (Eth_wr_bad_frame),
      .overflow        (Eth_tx_overflow)		
   );   		
   
assign Eth_wr_clk = Eth_tx_clk;
assign Eth_reply_rd_clk = Eth_tx_clk;
assign eth_header_wire = {Eth_reply_MAC,Eth_type};		
assign Eth_reply_rd_fifo_addr = {5'h0, eth_ch_sel};	
	
   
 /*  always @(posedge Eth_wr_clk)
   case(EthReplySt)
   EthHeaderWr_s: Eth_wr_data <= eth_header_reg[111:104];
   EthDataWr_s : Eth_wr_data <= Eth_reply_rd_data_out;
   default: Eth_wr_data <= 8'h0;
   endcase

   always @(posedge Eth_wr_clk)
   case(EthReplySt)
   EthHeaderWr_s: Eth_wr_data_valid <= 1'b1;
   EthDataWr_s : Eth_wr_data_valid <= 1'b1;
   default: Eth_wr_data_valid <= 8'h0;
   endcase*/
   
   assign Eth_wr_bad_frame = 1'b0;

endmodule
