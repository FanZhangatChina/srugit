`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module ip_reply_fsm( 
		//ip reply transmit interface
		input  				ip_tx_clk,
		output 				ip_tx_sof_n,
		output [7:0] 		ip_tx_data_out,
		output 				ip_tx_eof_n,
		output 				ip_tx_src_rdy_n,
		input  				ip_tx_dst_rdy_n,
		input  [5:0]		ip_rx_fifo_rd_addr,
		output [3:0]  		ip_rx_fifo_status,
		output 				ip_rx_overflow,		
		//No flow control
		output  			ip_tx_rd_clk,
		input 				ip_tx_rd_sof_n,
		input [7:0] 		ip_tx_rd_data_out,
		input 				ip_tx_rd_eof_n,
		input 				ip_tx_rd_src_rdy_n,
		output reg			ip_tx_rd_dst_rdy_n = 1'b1,
		output [5:0]        ip_tx_rd_fifo_addr,
		
		//Configuration parameters
		input [63:0]		ip_tx_IP,
		
		input 				reset
);

parameter IpFifoAddr = 6'd1;
parameter IP_ICMP_Pro = 8'h01;
parameter IP_UDP_Pro = 8'h11;
wire ip_wr_clk, ip_tx_bad_frame;
reg ip_wr_enable = 1'b0, ip_tx_data_valid = 1'b0, ip_tx_good_frame = 1'b0, ip_tx_ch_sel = 1'b0;
wire ip_tx_ch_sel_n;
reg [7:0] ip_tx_data = 8'h0;
wire [7:0] ip_tx_pro;
reg [7:0] ip_cnt = 8'd0;
reg [15:0] ip_tx_total_len = 16'h0;
reg [159:0] ip_tx_header_pipe = 160'h0;
reg [7:0] ip_tx_rd_data_pipe = 8'h0;

wire ip_HeaderUpdate;
reg ip_tx_header_req = 1'b0;
wire [159:0] ip_tx_header;

assign ip_tx_ch_sel_n = ~ip_tx_ch_sel;
assign ip_tx_pro = {3'b0,ip_tx_ch_sel_n,4'b0001};

ip_hchksum u_ip_hchksum (
    .ip_tx_clk(ip_tx_clk), 
    .ip_tx_header_req(ip_tx_header_req), 
    .ip_HeaderUpdate(ip_HeaderUpdate), 
    .ip_total_len(ip_tx_total_len), 
    .IpSrcIP(ip_tx_IP[63:32]), 
    .IpDstIP(ip_tx_IP[31:0]), 
    .IpPro(ip_tx_pro), 
    .ip_tx_header(ip_tx_header), 
    .reset(reset)
    );
	
//FSM. states are ipChSelSwitch_s,ipChkFifo_s, ipLengthLoad_s, ipHeaderCal_s, ipHeaderLoad_s, ipHeaderWr_s, ipDataLoad_s,ipDataWe_s.
parameter ipChSelSwitch_s = 3'd0; parameter ipLengthRd1_s = 3'd1;
parameter ipLengthLoad_s = 3'd2; parameter ipHeaderCal_s = 3'd3;
parameter ipHeaderLoad_s = 3'd4; parameter ipHeaderWr_s = 3'd5;
parameter ipDataLoad_s = 3'd6; parameter ipDataWe_s = 3'd7;
parameter ipLengthRd2_s = 4'd8;parameter ipLengthRd3_s = 4'd9;
parameter ipChSelSwitch2_s = 4'd10;
reg [3:0] ipSt = ipChSelSwitch_s;
always @(posedge ip_wr_clk)
 if(reset)
 begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 ip_tx_total_len <= 16'h0;
  
 ipSt <= ipChSelSwitch_s;
 end else case(ipSt)
 ipChSelSwitch_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ip_tx_total_len <= 16'd20;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ~ip_tx_ch_sel;
 
 if(ip_rx_fifo_status > 4'he) 
 ipSt <= ipChSelSwitch_s;
 else
 ipSt <= ipChSelSwitch2_s;
 end
 
  ipChSelSwitch2_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ip_tx_total_len <= ip_tx_total_len;
 //ip_tx_total_len <= ip_tx_total_len + {ip_tx_rd_data_out, 8'h0};
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= ip_cnt + 8'd1;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 if(ip_cnt == 8'd3)
	 if(ip_tx_rd_src_rdy_n|ip_tx_rd_sof_n)
	 ipSt <= ipChSelSwitch_s;
	 else
	 ipSt <= ipLengthRd1_s;
 else
     ipSt <= ipChSelSwitch2_s;
 end
 
 ipLengthRd1_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b0;
ip_tx_total_len <= ip_tx_total_len + {ip_tx_rd_data_out, 8'h0};
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= ip_cnt + 8'd1;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
if(ip_cnt == 8'd5)
 ipSt <= ipLengthLoad_s;
 else
 ipSt <= ipLengthRd1_s;
 end 
 
 ipLengthRd2_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 ipSt <= ipLengthLoad_s;
 end
 
 ipLengthRd3_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 ipSt <= ipLengthLoad_s;
 end 
 
 ipLengthLoad_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ip_tx_total_len <= ip_tx_total_len + ip_tx_rd_data_out;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 ipSt <= ipHeaderCal_s;
 end 
 
 ipHeaderCal_s: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ip_tx_total_len <= ip_tx_total_len;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b1;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 if(ip_HeaderUpdate)
 ipSt <= ipHeaderLoad_s;
 else
 ipSt <= ipHeaderCal_s;
 end 
 
 ipHeaderLoad_s: begin
 ip_wr_enable <= 1'b1;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ip_tx_total_len <= ip_tx_total_len;
 
 ip_tx_header_pipe <= ip_tx_header;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd1;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 ipSt <= ipHeaderWr_s;
 end 
 
 ipHeaderWr_s: begin
 ip_wr_enable <= 1'b1;
 ip_tx_data_valid <= 1'b1;
 ip_tx_data <= ip_tx_header_pipe[159:152];
 ip_tx_good_frame <= 1'b0;
 ip_tx_total_len <= ip_tx_total_len;
 
 ip_tx_header_pipe <= {ip_tx_header_pipe[151:0], 8'h55};
 ip_tx_header_req <= 1'b0;
 ip_cnt <= ip_cnt + 5'd1;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 if(ip_cnt == 8'd20)
 begin
 ip_tx_rd_dst_rdy_n <= 1'b0;
 ipSt <= ipDataLoad_s;
 end
 else
 begin
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ipSt <= ipHeaderWr_s;
 end
 end 
 
 ipDataLoad_s: begin
 ip_wr_enable <= 1'b1;
 ip_tx_data_valid <= 1'b1; 
 ip_tx_data <= ip_tx_rd_data_out;
 ip_tx_total_len <= ip_tx_total_len;
 
 ip_tx_header_pipe <= 160'h0;

 ip_tx_header_req <= 1'b0;
 ip_cnt <= 8'd0;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 if(ip_tx_rd_eof_n)
 begin
  ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b0;
 ipSt <= ipDataLoad_s;
 end
 else
 begin
 ip_tx_good_frame <= 1'b1;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ipSt <= ipDataWe_s;
 end
 end

 ipDataWe_s: begin
 ip_wr_enable <= 1'b1;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0; 
 ip_tx_total_len <= ip_tx_total_len;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_cnt <= ip_cnt + 5'd1;
 ip_tx_ch_sel <= ip_tx_ch_sel;
 
 if(ip_cnt == 8'd4)
 ipSt <= ipChSelSwitch_s;
else
 ipSt <= ipDataWe_s;
 end
 
 
 default: begin
 ip_wr_enable <= 1'b0;
 ip_tx_data_valid <= 1'b0;
 ip_tx_data <= 8'h0;
 ip_tx_good_frame <= 1'b0;
 ip_tx_rd_dst_rdy_n <= 1'b1;
 ip_tx_total_len <= 16'h0;
 
 ip_tx_header_pipe <= 160'h0;
 ip_tx_header_req <= 1'b0;
 ip_tx_ch_sel <= 1'b0;
 ip_cnt <= 8'd0;
 
 ipSt <= ipChSelSwitch_s;
 end
 endcase

/*always @(posedge ip_tx_rd_clk)
if(ipSt == ipLengthLoad_s)
ip_tx_total_len <= {ip_tx_rd_data_pipe[7:0],ip_tx_rd_data_out} + 5'd20;
else
ip_tx_total_len <= ip_tx_total_len;*/

/*always @(posedge ip_tx_rd_clk)
if(ipSt == ipChSelSwitch_s)
ip_tx_ch_sel <= ~ip_tx_ch_sel;
else
ip_tx_ch_sel <= ip_tx_ch_sel;*/

always @(posedge ip_tx_rd_clk)
ip_tx_rd_data_pipe <= ip_tx_rd_data_out ;
		
		
   rx_client_fifo_8_rdbus #(.FifoInitAddr(IpFifoAddr)) ip_reply_tx_fifo_8_rdbus (
      .rd_clk          (ip_tx_clk),
      .rd_sreset       (reset),
      .rd_data_out     (ip_tx_data_out),
      .rd_sof_n        (ip_tx_sof_n),
      .rd_eof_n        (ip_tx_eof_n),
      .rd_src_rdy_n    (ip_tx_src_rdy_n),
      .rd_dst_rdy_n    (ip_tx_dst_rdy_n),
      .rx_fifo_status  (ip_rx_fifo_status),
	  .rd_addr		   (ip_rx_fifo_rd_addr),
		
      .wr_sreset       (reset),
      .wr_clk          (ip_wr_clk),
      .wr_enable       (ip_wr_enable),
      .rx_data         (ip_tx_data),
      .rx_data_valid   (ip_tx_data_valid),
      .rx_good_frame   (ip_tx_good_frame),
      .rx_bad_frame    (ip_tx_bad_frame),
      .overflow        (ip_rx_overflow)		
   ); 		
   
assign ip_wr_clk = ip_tx_clk;
assign ip_tx_rd_clk = ip_tx_clk; 
assign ip_tx_bad_frame = 1'b0;
assign ip_tx_rd_fifo_addr = {5'h0,ip_tx_ch_sel};   
endmodule
