`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module udp_reply_mux( 
		//udp reply transmit interface
		input  				udp_sw_tx_clk,
		output 				udp_sw_tx_sof_n,
		output [7:0] 		udp_sw_tx_data_out,
		output 				udp_sw_tx_eof_n,
		output 				udp_sw_tx_src_rdy_n,
		input  				udp_sw_tx_dst_rdy_n,
		input  [5:0]		udp_sw_tx_fifo_rd_addr,
		output [3:0]  		udp_sw_tx_fifo_status,
		output 				udp_sw_tx_overflow,		
		
		output  				udp_tx_rd_clk,
		input 				udp_tx_rd_sof_n,
		input [7:0] 		udp_tx_rd_data_out,
		input 				udp_tx_rd_eof_n,
		input 				udp_tx_rd_src_rdy_n,
		output reg			udp_tx_rd_dst_rdy_n = 1'b1,
		output reg [5:0]  udp_tx_rd_fifo_addr = 6'd0,
		
		input 				reset
);

parameter UdpFifoAddr = 6'd0;
parameter MaxUdpCh = 6'd20;

wire udp_sw_wr_clk, udp_sw_wr_bad_frame;
reg udp_sw_wr_enable = 1'b0, udp_sw_wr_data_valid = 1'b0;
reg udp_sw_wr_good_frame = 1'b0, udp_sw_wr_ch_sel = 1'b0;
wire [7:0] udp_sw_wr_data;
reg [7:0] ip_tx_rd_data_pipe = 8'h0;
reg [7:0] udp_cnt = 8'd0;

//FSM. states are UdpChSelSwitch_s,UdpChkFifo_s, UdpDataLoad_s, UdpDataWe_s
parameter UdpChSelSwitch_s = 5'b0_0001; 
parameter UdpDataSof_s = 5'b0_0010; 
parameter UdpDataLoad_s = 5'b0_0100;  
parameter UdpDataWe_s = 5'b0_1000; 
parameter UdpChSelSwitch2_s = 5'b1_0000; 

reg [4:0] UdpSt = UdpChSelSwitch_s;
always @(posedge udp_sw_wr_clk)
 if(reset)
 begin
 udp_sw_wr_enable <= 1'b0;
 udp_sw_wr_data_valid <= 1'b0;
 udp_sw_wr_good_frame <= 1'b0;
 udp_tx_rd_dst_rdy_n <= 1'b1;
 udp_cnt <= 8'd0;
 udp_tx_rd_fifo_addr <= 6'd0;
 
 UdpSt <= UdpChSelSwitch_s;
 end else case(UdpSt)
 UdpChSelSwitch_s: begin
 udp_sw_wr_enable <= 1'b0;
 udp_sw_wr_data_valid <= 1'b0;
 udp_sw_wr_good_frame <= 1'b0;
 udp_tx_rd_dst_rdy_n <= 1'b1;
 udp_cnt <= 8'd0;
 
 if(udp_tx_rd_fifo_addr == MaxUdpCh)
udp_tx_rd_fifo_addr <= 6'd0;
else
udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr + 6'd1;
 
 if(udp_sw_tx_fifo_status == 4'hf) 
 UdpSt <= UdpChSelSwitch_s;
 else
 UdpSt <= UdpChSelSwitch2_s;
 end
 
 UdpChSelSwitch2_s: begin
 udp_sw_wr_enable <= 1'b0;
 udp_sw_wr_data_valid <= 1'b0;
 udp_sw_wr_good_frame <= 1'b0;
 udp_tx_rd_dst_rdy_n <= 1'b1;
 udp_cnt <= udp_cnt + 8'd1;
 udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr;
 
 if(udp_cnt == 8'd3)
	if(udp_tx_rd_src_rdy_n|udp_tx_rd_sof_n)
	 UdpSt <= UdpChSelSwitch_s;
	 else
	 UdpSt <= UdpDataSof_s;
 else
	 UdpSt <= UdpChSelSwitch2_s;
 end
 
 UdpDataSof_s: begin
 udp_sw_wr_enable <= 1'b1;
 udp_sw_wr_data_valid <= 1'b0;
 udp_sw_wr_good_frame <= 1'b0; 
 udp_cnt <= 8'd0;
 udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr;
 
 udp_sw_wr_good_frame <= 1'b0;
 udp_tx_rd_dst_rdy_n <= 1'b0;
 UdpSt <= UdpDataLoad_s;
 end
 
 UdpDataLoad_s: begin
 udp_sw_wr_enable <= 1'b1;
 udp_sw_wr_data_valid <= 1'b1; 
 udp_cnt <= 8'd0;
 udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr;
 //udp_sw_wr_data <= udp_tx_rd_data_out ;
 
 if(udp_tx_rd_eof_n)
 begin
 udp_sw_wr_good_frame <= 1'b0;
 udp_tx_rd_dst_rdy_n <= 1'b0;
 UdpSt <= UdpDataLoad_s;
 end
 else
 begin
 udp_sw_wr_good_frame <= 1'b1;
 udp_tx_rd_dst_rdy_n <= 1'b1;
 UdpSt <= UdpDataWe_s;
 end
 end

 UdpDataWe_s: begin
 udp_sw_wr_enable <= 1'b1;
 udp_sw_wr_data_valid <= 1'b0;
 udp_sw_wr_good_frame <= 1'b0; 
 udp_tx_rd_dst_rdy_n <= 1'b1;
  
 udp_cnt <= udp_cnt + 4'd1;
 udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr;
 
 if(udp_cnt == 8'd4)
 UdpSt <= UdpChSelSwitch_s;
else
 UdpSt <= UdpDataWe_s;
 end
  
 default: begin
 udp_sw_wr_enable <= 1'b0;
 udp_sw_wr_data_valid <= 1'b0;
 udp_sw_wr_good_frame <= 1'b0;
 udp_tx_rd_dst_rdy_n <= 1'b1;
 udp_tx_rd_fifo_addr <= 6'd0;

 udp_cnt <= 8'd0;
 
 UdpSt <= UdpChSelSwitch_s;
 end
 endcase

/*always @(posedge udp_sw_wr_clk)
if(UdpSt == UdpChSelSwitch_s)
if(udp_tx_rd_fifo_addr == MaxUdpCh)
udp_tx_rd_fifo_addr <= 6'd0;
else
udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr + 6'd1;
else
udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr;*/

//always @(posedge udp_sw_wr_clk)
//if(UdpSt == UdpChSelSwitch_s)
////if(udp_tx_rd_fifo_addr == MaxUdpCh)
////udp_tx_rd_fifo_addr <= 6'd0;
////else
//udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr + 6'd1;
//else
//udp_tx_rd_fifo_addr <= udp_tx_rd_fifo_addr;

always @(posedge udp_sw_wr_clk)
//ip_tx_rd_data_pipe <= {ip_tx_rd_data_pipe[23:0],udp_tx_rd_data_out} ;
ip_tx_rd_data_pipe <= udp_tx_rd_data_out ;

assign udp_sw_wr_data = ip_tx_rd_data_pipe[7:0];

   rx_client_fifo_8_rdbus #(.FifoInitAddr(UdpFifoAddr)) udp_reply_tx_fifo_8_rdbus (
      .rd_clk          (udp_sw_tx_clk),
      .rd_sreset       (reset),
      .rd_data_out     (udp_sw_tx_data_out),
      .rd_sof_n        (udp_sw_tx_sof_n),
      .rd_eof_n        (udp_sw_tx_eof_n),
      .rd_src_rdy_n    (udp_sw_tx_src_rdy_n),
      .rd_dst_rdy_n    (udp_sw_tx_dst_rdy_n),
      .rx_fifo_status  (udp_sw_tx_fifo_status),
	   .rd_addr		     (udp_sw_tx_fifo_rd_addr),
		
      .wr_sreset       (reset),
      .wr_clk          (udp_sw_wr_clk),
      .wr_enable       (udp_sw_wr_enable),
      .rx_data         (udp_sw_wr_data),
      .rx_data_valid   (udp_sw_wr_data_valid),
      .rx_good_frame   (udp_sw_wr_good_frame),
      .rx_bad_frame    (udp_sw_wr_bad_frame),
      .overflow        (udp_sw_tx_overflow)		
	  
	    );

assign udp_sw_wr_clk = udp_sw_tx_clk;
assign udp_tx_rd_clk = udp_sw_tx_clk;
assign udp_sw_wr_bad_frame = 1'b0;
		
endmodule
		