`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module rx_client_fifo_8_rdbus
#(parameter FifoInitAddr = 6'h3f)
(
  // LocalLink Interface
  input        	rd_clk,
  input        	rd_sreset,
  output [7:0]	rd_data_out,
  output       	rd_sof_n,
  output       	rd_eof_n,
  output       	rd_src_rdy_n,
  input        	rd_dst_rdy_n,
  input	 [5:0]	rd_addr,
  output [3:0] 	rx_fifo_status,

  // Client Interface
  input        wr_sreset,
  input        wr_clk,
  input        wr_enable,
  input [7:0] rx_data,
  input        rx_data_valid,
  input        rx_good_frame,
  input        rx_bad_frame,
  output       overflow
    );

  // LocalLink Interface
  wire [7:0] 	rd_data_out_i;
  wire       	rd_sof_n_i;
  wire       	rd_eof_n_i;
  wire       	rd_src_rdy_n_i;
  wire			rd_dst_rdy_n_i;
  
  reg			fifo_cs = 1'b1, fifo_cs_i = 1'b1;
  
  always @(posedge rd_clk)
  if(rd_addr == FifoInitAddr)
  fifo_cs <= 1'b0;
  else
  fifo_cs <= 1'b1;
  
  always @(posedge rd_clk)
  fifo_cs_i <= fifo_cs;
  
  assign rd_dst_rdy_n_i = fifo_cs_i | rd_dst_rdy_n;

   // Receiver FIFO
   rx_client_fifo_8_f1 u_rx_client_fifo_8_f1 (
      .rd_clk          (rd_clk),
      .rd_sreset       (rd_sreset),
      .rd_data_out     (rd_data_out_i),
      .rd_sof_n        (rd_sof_n_i),
      .rd_eof_n        (rd_eof_n_i),
      .rd_src_rdy_n    (rd_src_rdy_n_i),
      .rd_dst_rdy_n    (rd_dst_rdy_n_i),
      .rx_fifo_status  (rx_fifo_status),
	
      .wr_sreset       (wr_sreset),
      .wr_clk          (wr_clk),
      .wr_enable       (wr_enable),
      .rx_data         (rx_data),
      .rx_data_valid   (rx_data_valid),
      .rx_good_frame   (rx_good_frame),
      .rx_bad_frame    (rx_bad_frame),
      .overflow        (overflow)		
   );  
	
	assign rd_data_out = fifo_cs ? 8'hZ : rd_data_out_i;
	assign rd_sof_n = fifo_cs ? 1'bz : rd_sof_n_i;
	assign rd_eof_n = fifo_cs ? 1'bz : rd_eof_n_i;
	assign rd_src_rdy_n = fifo_cs ? 1'bz : rd_src_rdy_n_i;	
	

endmodule
