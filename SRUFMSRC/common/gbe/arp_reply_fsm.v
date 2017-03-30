`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module arp_reply_fsm( 
		//ARP reply transmit interface
		input  				arp_tx_clk,//40MHz
		output 				arp_tx_sof_n,
		output [7:0] 		arp_tx_data_out,
		output 				arp_tx_eof_n,
		output 				arp_tx_src_rdy_n,
		input  				arp_tx_dst_rdy_n,
		input  [5:0]		arp_tx_fifo_rd_addr,
		output [3:0]  		arp_tx_fifo_status,
		output 				arp_tx_overflow,		
		
		//ArpFrame
		input	[223:0]		arp_tx_reply_frame,
		
		input 				arp_req,
		output reg			arp_reply,
		
		input 				reset
);

wire arp_wr_clk, arp_tx_bad_frame;
reg arp_wr_enable = 1'b0, arp_tx_data_valid = 1'b0, arp_tx_good_frame = 1'b0;
wire [7:0] arp_tx_data;
reg [4:0] arp_cnt = 5'd0;
reg [223:0] arp_tx_data_pipe = 224'h0;
assign arp_wr_clk = arp_tx_clk;
assign arp_tx_bad_frame = 1'b0;
assign  arp_tx_data = arp_tx_data_pipe[223:216];

parameter ArpLength = 5'd26;
parameter ArpFifoAddr = 6'h3f;

//FSM. states are ArpWait_s,ArpRlySof_s, ArpRlyData_s, ArpRlyEof_s, ArpRlyWe1_s, ArpRlyWe2_s, ArpRlyWe3_s.
parameter ArpWait_s = 3'd0; parameter ArpRlySof_s = 3'd1;
parameter ArpRlyData_s = 3'd2; parameter ArpRlyEof_s = 3'd3;
parameter ArpRlyWe1_s = 3'd4; parameter ArpRlyWe2_s = 3'd5;
parameter ArpRlyWe3_s = 3'd6;

reg [2:0] ArpSt = ArpWait_s;
always @(posedge arp_wr_clk)
 if(reset)
 begin
 arp_wr_enable <= 1'b0;
 arp_tx_data_valid <= 1'b0;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= 224'h0;
 arp_reply <= 1'b0;
 arp_cnt <= 5'd0;
 
 ArpSt <= ArpWait_s;
 end else case(ArpSt)
 ArpWait_s: begin
 arp_wr_enable <= 1'b0;
 arp_tx_data_valid <= 1'b0;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= 224'h0;
 arp_reply <= 1'b0;
 arp_cnt <= 5'd0;
  
 if(arp_req)
 ArpSt <= ArpRlySof_s;
 else
 ArpSt <= ArpWait_s;
 end
 
 ArpRlySof_s: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b1;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= arp_tx_reply_frame;
 arp_reply <= 1'b0;
 arp_cnt <= 5'd1;
 
 ArpSt <= ArpRlyData_s;
 end
 
 ArpRlyData_s: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b1;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= {arp_tx_data_pipe[215:0],8'h55};

 arp_reply <= 1'b0;
 arp_cnt <= arp_cnt + 5'd1;
 
 if(arp_cnt == ArpLength)
 ArpSt <= ArpRlyEof_s;
 else
 ArpSt <= ArpRlyData_s;
 end
 
 ArpRlyEof_s: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b1;
 arp_tx_good_frame <= 1'b1;
 arp_tx_data_pipe <= {arp_tx_data_pipe[215:0],8'h55};
 arp_reply <= 1'b0;
 arp_cnt <= 5'd0;
 
 ArpSt <= ArpRlyWe1_s;
 end
 
 ArpRlyWe1_s: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b0;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= arp_tx_data_pipe;
 arp_reply <= 1'b1;
 arp_cnt <= 5'd0;
 
 ArpSt <= ArpRlyWe2_s;
 end
 
 ArpRlyWe2_s: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b0;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= arp_tx_data_pipe;
 arp_reply <= 1'b1;
 arp_cnt <= 5'd0;
 
 ArpSt <= ArpRlyWe3_s;
 end
 
 ArpRlyWe3_s: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b0;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= arp_tx_data_pipe;
 arp_reply <= 1'b1;
 arp_cnt <= 5'd0;
 
 ArpSt <= ArpWait_s;
 end
 
 default: begin
 arp_wr_enable <= 1'b1;
 arp_tx_data_valid <= 1'b0;
 arp_tx_good_frame <= 1'b0;
 arp_tx_data_pipe <= 224'h0;
 arp_reply <= 1'b0;
 arp_cnt <= 5'd0;
 
 ArpSt <= ArpWait_s;
 end
 endcase		
			
   rx_client_fifo_8_rdbus #(.FifoInitAddr(ArpFifoAddr)) arp_reply_tx_fifo_8_rdbus (
      .rd_clk          (arp_tx_clk),
      .rd_sreset       (reset),
      .rd_data_out     (arp_tx_data_out),
      .rd_sof_n        (arp_tx_sof_n),
      .rd_eof_n        (arp_tx_eof_n),
      .rd_src_rdy_n    (arp_tx_src_rdy_n),
      .rd_dst_rdy_n    (arp_tx_dst_rdy_n),
		.rd_addr			  (arp_tx_fifo_rd_addr),
      .rx_fifo_status  (arp_tx_fifo_status),
		
      .wr_sreset       (reset),
      .wr_clk          (arp_wr_clk),
      .wr_enable       (arp_wr_enable),
      .rx_data         (arp_tx_data),
      .rx_data_valid   (arp_tx_data_valid),
      .rx_good_frame   (arp_tx_good_frame),
      .rx_bad_frame    (arp_tx_bad_frame),
      .overflow        (arp_tx_overflow)		
   ); 		
endmodule
