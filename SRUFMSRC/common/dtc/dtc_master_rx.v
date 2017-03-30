`timescale 1ns / 1ps

// ALICE/EMCal SRU
// This module process event data and dcs reply from DTC ports
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 13 July 2015

module dtc_master_rx(
		input  					dtc_data_p,
		input  					dtc_data_n,
		input  					dtc_return_p,
		input  					dtc_return_n,

		output 					fee_flag,
		
		input 					WordAlignStart,
		input 					errtest,
		output [15:0] 			errcnt,

		input						DtcRamclkb,
		input						DtcRamenb,
		input  [9:0]			DtcRamaddrb,
		output [32:0]			DtcRamdoutb,
		
		input 					DtcRamReadConfirm,
		input 					DtcRamClr,
		output 					DtcRamFlag,

		input 					dcs_wr_clk,//40MHz
		input  					dcs_rd_clk,//40MHz
		output 					dcs_rd_sof_n,
		output [7:0] 			dcs_rd_data_out,
		output 					dcs_rd_eof_n,
		output 					dcs_rd_src_rdy_n,
		input  					dcs_rd_dst_rdy_n,
		input  [5:0] 			dcs_rd_addr,
		output [3:0]  			dcs_rx_fifo_status,
		output 					dcs_rx_overflow,
		
		output					udp_reply_stored,

		
		input  [15:0]			dcs_udp_dst_port,
		input  [15:0]			dcs_udp_src_port,		

		input 					bitclk, //for sampling clock phase tuning
		input 					bitclkdiv,
		output [15:0] 			dtc_deser_dout,

		input 					reset
		);
		 
		parameter 			DcsFifoAddr = 6'd1;
		parameter 			DcsNode = 6'd1;
		 
		wire  [63:0]		dcs_cmd_reply;
		wire					dcs_cmd_update;
		
	dtc_rx_deser u_dtc_rx_deser (
		.bitclk(bitclk), 
		.bitclkdiv(bitclkdiv), 
		.dtc_data_p(dtc_data_p), 
		.dtc_data_n(dtc_data_n), 
		.dtc_return_p(dtc_return_p), 
		.dtc_return_n(dtc_return_n), 
		.dtc_deser_dout(dtc_deser_dout), 
		.WordAlignStart(WordAlignStart), 

		.errtest(errtest), 
		.errcnt(errcnt),
		
		.reset(reset)
	);

		dtc_rx_decoder u_dtc_rx_decoder (
		  .bitclkdiv		 	(bitclkdiv),
		  .dtc_deser_align 	(1'b1),
		  .dtc_deser_dout	 	(dtc_deser_dout),
		
		  .fee_flag		 	   (fee_flag), 
		
        .clkb          		(DtcRamclkb),
        .enb     				(DtcRamenb),
        .addrb        		(DtcRamaddrb),
        .doutb        		(DtcRamdoutb),
        .ReadConfirm    	(DtcRamReadConfirm),
        .RamClr    			(DtcRamClr),
        .RamFlag  			(DtcRamFlag),
		  
	     .dcs_cmd_reply		(dcs_cmd_reply),
	     .dcs_cmd_update	 	(dcs_cmd_update),
		
	     .reset(reset)
	);


		dcs_client_fifo_wr_fsm #(.DcsNode(DcsNode),
		.DcsFifoAddr(DcsFifoAddr)) u_dcs_client_fifo_wr_fsm (
	
        .dcs_rd_clk          (dcs_rd_clk),
        .dcs_rd_data_out     (dcs_rd_data_out),
        .dcs_rd_sof_n        (dcs_rd_sof_n),
        .dcs_rd_eof_n        (dcs_rd_eof_n),
        .dcs_rd_src_rdy_n    (dcs_rd_src_rdy_n),
        .dcs_rd_dst_rdy_n    (dcs_rd_dst_rdy_n),
		  .dcs_rd_addr		 	  (dcs_rd_addr),
        .dcs_rx_fifo_status  (dcs_rx_fifo_status),
	     .dcs_rx_overflow	  (dcs_rx_overflow),	
		  .udp_reply_stored		(udp_reply_stored),
		
	    .dcs_wr_clk			  (bitclkdiv),
		 .dcs_cmd_reply		  (dcs_cmd_reply),
	    .dcs_cmd_update	 	  (dcs_cmd_update),
		 .dcs_udp_dst_port	   (dcs_udp_dst_port),
	    .dcs_udp_src_port	 	(dcs_udp_src_port),
		 
	    .reset(reset)
	);

endmodule
