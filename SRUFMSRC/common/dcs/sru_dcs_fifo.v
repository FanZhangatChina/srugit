`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module sru_dcs_fifo(
		input 				gclk_40m,
		input       		dcs_rx_clk,                 
		input [7:0] 		dcs_rxd,              
		input 				dcs_rx_dv,            
	
		//DCS rx_fifo read interface
		input  				dcs_rd_clk,//40MHz
		output 				dcs_rd_sof_n,
		output [7:0] 		dcs_rd_data_out,
		output 				dcs_rd_eof_n,
		output 				dcs_rd_src_rdy_n,
		input  				dcs_rd_dst_rdy_n,
		input  [5:0]		dcs_rd_addr,
		output [3:0]  		dcs_rx_fifo_status,
		output 				dcs_rx_overflow,
		input  [15:0]		dcs_udp_dst_port,
		input  [15:0]		dcs_udp_src_port,		
		
		input [63:0]		dcs_cmd_reply,
		input 				dcs_cmd_update,
		
		output  				udp_cmd_dv,
		output  [31:0]		udp_cmd_addr,
		output  [31:0]		udp_cmd_data,
		
		input  reset		
    );

		wire dcs_wr_clk, udp_reply_stored;
		parameter SruFifoAddr = 6'd41;
		dcs_client_fifo_wr_fsm #(.DcsNode(6'd41), .DcsFifoAddr(SruFifoAddr)) u_dcs_client_fifo_wr_fsm (
	
		//Fifo RD interface
        .dcs_rd_clk          (dcs_rd_clk),
        .dcs_rd_data_out     (dcs_rd_data_out),
        .dcs_rd_sof_n        (dcs_rd_sof_n),
        .dcs_rd_eof_n        (dcs_rd_eof_n),
        .dcs_rd_src_rdy_n    (dcs_rd_src_rdy_n),
        .dcs_rd_dst_rdy_n    (dcs_rd_dst_rdy_n),
		  .dcs_rd_addr		 	  (dcs_rd_addr),
        .dcs_rx_fifo_status  (dcs_rx_fifo_status),
	     .dcs_rx_overflow	  (dcs_rx_overflow),	
		  .dcs_udp_dst_port	  (dcs_udp_dst_port),
		  .dcs_udp_src_port	  (dcs_udp_src_port),
		
	    //command reply		
	    .dcs_wr_clk			 (dcs_wr_clk),
		 .dcs_cmd_reply		 (dcs_cmd_reply),
	    .dcs_cmd_update	 	 (dcs_cmd_update),
		 .udp_reply_stored    (udp_reply_stored),
		
	    .reset(reset)
	);
	
		sru_dcscmd_par u_sru_dcscmd_par (
		.dcs_rx_clk(dcs_rx_clk), 
		.dcs_rxd(dcs_rxd), 
		.dcs_rx_dv(dcs_rx_dv), 
		
		.gclk_40m(gclk_40m),
		
		.udp_cmd_dv(udp_cmd_dv), 		
		.udp_cmd_addr(udp_cmd_addr), 
		.udp_cmd_data(udp_cmd_data),
		.udp_reply_stored(udp_reply_stored),
		
		.reset(reset)		
	);
	
	assign dcs_wr_clk = gclk_40m;
	

endmodule
