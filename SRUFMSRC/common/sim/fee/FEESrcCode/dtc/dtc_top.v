//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : sru_top
//* File            : sru_top.v
//* Description     : Top module of the DDL links
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*   18-01-2013 : Initial release
//*	  06-03-2013 : Add fpga_cmd_ack, acmd_ack
//*******************************************************************************
//`timescale 1ns / 1ps
module dtc_top(

		//dtc phy
		input         dtc_clk,                     // Differential -ve of clock from Master DTC to Slave DTC.
		input 		  dtc_trig,                    // Differential -ve of trigger from Master DTC to Slave DTC.
		output		  dtc_data,                    // Differential -ve of data from Slave DTC to Master DTC.
		output 		  dtc_return,                  // Differential -ve of return from Slave DTC to Master DTC.

		//Interface to write/read FEE FPGA registers
		output wire dtc_fpga_cmd_exec,//Active high means the following "rnw", "addr", "wdata" are active for a new DCS command
		output wire dtc_fpga_cmd_rnw,
		output wire [7:0] dtc_fpga_cmd_addr,
		output wire [15:0] dtc_fpga_cmd_wdata,
		input [15:0] dtc_fpga_cmd_rdata,
		input			fpga_cmd_ack,
		
		//Interface to write/read ALTRO chips
		output wire 		 acmd_exec,
		output wire 		 acmd_rw,
		output wire [19:0] 	 acmd_addr,
		output wire [19:0]   acmd_rx,
		input 		[19:0]   acmd_tx,	
		input				 acmd_ack,
		
		//Trigger	
		output  	trig_l0n,//low active 
		output  	trig_l1n,
		
		//Special readout commands for EMCal
		output  	altrordo_cmd,
		output  	altroabort_cmd,
		output		sampclksync_cmd,
		output		DtcCmdRst,
		
		//event fifo readout clock
		output 			fifo_rdreq,
		input [31:0] 	fifo_q,
		input 			fifo_empty,	

		//FEE flag 
		input 			fee_flag,

		output [15:0] 	event_rdo_cnt,
		input			CntRst,	
			

		input 		rdoclk,
		input       reset                 // Asynchronous reset for entire core.
	);

wire 		dtc_cmd_rnw;
wire 		dtc_cmd_exec;//last 250ns
wire 		dtc_cmd_feenal;
wire 		[19:0] dtc_cmd_data;
wire 		[19:0] dtc_cmd_addr;

wire 		frame_st;
wire 		reply_rdy;
wire [31:0] reply_addr;
wire [31:0] reply_data;
wire 		dtc_cmd_ack;
wire 		DtcStReq;
wire 		test_mode;

	dtc_tx u_dtc_tx (
		.rdoclk(rdoclk),
		.dtc_data(dtc_data), 
		.dtc_return(dtc_return),	
		
		.fee_flag(fee_flag),
		
		.reply_rdy(reply_rdy),
		.reply_addr(reply_addr),
		.reply_data(reply_data),
		
		.frame_st(frame_st), 
		.fifo_rdreq(fifo_rdreq), 
		.fifo_q(fifo_q), 
		.fifo_empty(fifo_empty),
		.event_rdo_cnt(event_rdo_cnt),
		.CntRst(CntRst),
		.DtcStReq(DtcStReq),
		.test_mode(test_mode),
		
		.reset(reset)
	);	

	dtc_rx u_dtc_rx (
		.clkin(rdoclk), 
		.dtc_trig(dtc_trig), 
		
		.dtc_cmd_rnw(dtc_cmd_rnw), 
		.dtc_cmd_exec(dtc_cmd_exec), 
		.dtc_cmd_feenal(dtc_cmd_feenal), 
		.dtc_cmd_data(dtc_cmd_data), 
		.dtc_cmd_addr(dtc_cmd_addr),
		.dtc_cmd_ack(dtc_cmd_ack),
		
		.trig_l0n(trig_l0n), 
		.trig_l1n(trig_l1n), 
		
		.altrordo_cmd(altrordo_cmd), 
		.altroabort_cmd(altroabort_cmd), 
		.sampclksync_cmd(sampclksync_cmd),
		.DtcCmdRst(DtcCmdRst),
		.DtcStReq(DtcStReq),
		.test_mode(test_mode),
		
		.reset(reset)
	);

/*	edata_stim u_edata_stim (
		.edata_rclk(edata_rclk), 
		.edata_ren(edata_ren), 
		.dtc_tx_busy(dtc_tx_busy), 
		.edata_tx_req(edata_tx_req), 
		
		.edata(edata), 
		.edata_len(edata_len), 
		.altrordo_cmd(altrordo_cmd), 
		
		.reset(reset)
	);*/
	
		dtc_cmd dtc_cmd_uut (
		.rdoclk(rdoclk), 
		
		//dtc_rx
		.dtc_cmd_rnw(dtc_cmd_rnw),
		.dtc_cmd_exec(dtc_cmd_exec), 
		.dtc_cmd_feenal(dtc_cmd_feenal),		
		.dtc_cmd_data(dtc_cmd_data),  
		.dtc_cmd_addr(dtc_cmd_addr),
		.dtc_cmd_ack(dtc_cmd_ack),
		
		//memory interface
		.dtc_fpga_cmd_exec(dtc_fpga_cmd_exec), 
		.dtc_fpga_cmd_rnw(dtc_fpga_cmd_rnw),		
		.dtc_fpga_cmd_addr(dtc_fpga_cmd_addr),		
		.dtc_fpga_cmd_wdata(dtc_fpga_cmd_wdata),
		.dtc_fpga_cmd_rdata(dtc_fpga_cmd_rdata), 
		.fpga_cmd_ack(fpga_cmd_ack),
		
		//altro cmd interface
		.acmd_exec(acmd_exec), 
		.acmd_rw(acmd_rw), 
		.acmd_addr(acmd_addr), 
		.acmd_rx(acmd_rx), 
		.acmd_tx(acmd_tx), 
		.acmd_ack(acmd_ack),
		
		//dtc_tx
		.frame_st(frame_st),		
		.reply_addr(reply_addr),	
		.reply_data(reply_data),
		.reply_rdy(reply_rdy),
		
		.reset(reset)
	);
	

endmodule
