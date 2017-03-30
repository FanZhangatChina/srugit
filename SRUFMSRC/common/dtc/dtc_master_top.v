`timescale 1ns / 1ps

// ALICE/EMCal SRU
// This module sends triggers and commands to DTC ports
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 13 July 2015

	module dtc_master_top(
		//dtc phy
		 output 					dtc_clk_p,//output
		 output 					dtc_clk_n,//output
		 
		 output 					dtc_trig_p,//output
		 output 					dtc_trig_n,//output
		 
		 input  					dtc_data_p,
		 input  					dtc_data_n,
		 
		 input  					dtc_return_p,
		 input  					dtc_return_n,

		 input  					gclk_40m,

		 output 					fee_flag,
		 
		 input  					WordAlignStart,
		 input 					errtest,
		 output [15:0] 		errcnt,
		 
		 input 					FeeTrig,
		 input 					rdocmd, 
		 input 					abortcmd,
		 
		 //command reply
		 input       			dcs_rx_clk,            
		 input [7:0] 			dcs_rxd,              
		 input 					dcs_rx_dv,            
		 
		 input					DtcRamclkb,
		 input					DtcRamenb,
		 input  [9:0]	   	DtcRamaddrb,
		 output [32:0]	   	DtcRamdoutb,
		
		 input 					DtcRamReadConfirm,
		 input 					DtcRamClr,
		 output 					DtcRamFlag,

		 input  					dcs_rd_clk,//40MHz
		 output 					dcs_rd_sof_n,
		 output [7:0] 			dcs_rd_data_out,
		 output 					dcs_rd_eof_n,
		 output 					dcs_rd_src_rdy_n,
		 input  					dcs_rd_dst_rdy_n,
		 input  [5:0] 			dcs_rd_addr,
		 output [3:0]  		dcs_rx_fifo_status,
		 output 					dcs_rx_overflow,
		 input  [15:0]			dcs_udp_dst_port,
		 input  [15:0]			dcs_udp_src_port,
		
		 //clock phase shift interface
		 input 					dtc_clk,
		 input 					DeserBitclk,	
		 input 					DeserBitclkDiv,
		 input 					SerBitclk,
		 input 					SerBitclkDiv,
		 
		 output [15:0] 		dtc_deser_dout,
		 
		 input             	FastCmd,
		 input	  [7:0]     FastCmdCode,
		 output			   	FastCmdAck,
		
		 input					reset		 
		 );

		 parameter 			DcsFifoAddr = 6'd1;
		 parameter 			DcsNode = 6'd1;
		 wire 				udp_cmd_dv_ack;
		 wire 				udp_cmd_dv;
		 wire [31:0]		udp_cmd_addr;
		 wire [31:0]		udp_cmd_data;
		 wire 				dcs_wr_clk;	
		 wire 				udp_reply_stored;		 


// Instantiate the module
dtc_master_rx #(
.DcsNode(DcsNode),
.DcsFifoAddr(DcsFifoAddr)
) u_dtc_master_rx (
    .dtc_data_p(dtc_data_p), 
    .dtc_data_n(dtc_data_n), 
    .dtc_return_p(dtc_return_p), 
    .dtc_return_n(dtc_return_n), 
	
    .fee_flag(fee_flag), 
	
    .WordAlignStart(WordAlignStart), 
    .errtest(errtest), 
    .errcnt(errcnt), 
	 
    .DtcRamclkb(DtcRamclkb), 
    .DtcRamenb(DtcRamenb), 
    .DtcRamaddrb(DtcRamaddrb), 
    .DtcRamdoutb(DtcRamdoutb), 
    .DtcRamReadConfirm(DtcRamReadConfirm), 
    .DtcRamClr(DtcRamClr), 
    .DtcRamFlag(DtcRamFlag), 
	
    .dcs_wr_clk(dcs_wr_clk), 
    .dcs_rd_clk(dcs_rd_clk), 
    .dcs_rd_sof_n(dcs_rd_sof_n), 
    .dcs_rd_data_out(dcs_rd_data_out), 
    .dcs_rd_eof_n(dcs_rd_eof_n), 
    .dcs_rd_src_rdy_n(dcs_rd_src_rdy_n), 
    .dcs_rd_dst_rdy_n(dcs_rd_dst_rdy_n),
    .dcs_rd_addr(dcs_rd_addr),	
    .dcs_rx_fifo_status(dcs_rx_fifo_status), 
    .dcs_rx_overflow(dcs_rx_overflow), 
	 .dcs_udp_dst_port(dcs_udp_dst_port),
	 .dcs_udp_src_port(dcs_udp_src_port),
	 .udp_reply_stored(udp_reply_stored),
	
    .bitclk(DeserBitclk), 
    .bitclkdiv(DeserBitclkDiv), 
    .dtc_deser_dout(dtc_deser_dout), 
    .reset(reset)
    );

		dtc_master_tx u_dtc_trig (
		//dtc phy
		.dtc_trig_p(dtc_trig_p), 
		.dtc_trig_n(dtc_trig_n), 
		
		.FeeTrig(FeeTrig),
		.rdocmd(rdocmd),
		.abortcmd(abortcmd),

		.cmd_addr(udp_cmd_addr), 
		.cmd_data(udp_cmd_data), 
		.cmd_dv(udp_cmd_dv),
		.cmd_dv_ack(udp_cmd_dv_ack),

		.bitclk(SerBitclk),
		.bitclkdiv(SerBitclkDiv), 
		
		.FastCmdAck(FastCmdAck),
		.FastCmd(FastCmd),
		.FastCmdCode(FastCmdCode),
		
		.reset(reset)
	);

	dtc_dcscmd_par u_dtc_dcscmd_par(
		.dcs_rx_clk(dcs_rx_clk), 
		.dcs_rxd(dcs_rxd), 
		.dcs_rx_dv(dcs_rx_dv),
		
		.gclk_40m(gclk_40m),
		.udp_cmd_dv_ack(udp_cmd_dv_ack), 
		.udp_cmd_dv(udp_cmd_dv), 
		.udp_cmd_addr(udp_cmd_addr), 
		.udp_cmd_data(udp_cmd_data), 
		
		.reset(reset)
	);

	OBUFDS #( .IOSTANDARD("DEFAULT")) OBUFDS_dtc_clk (.O(dtc_clk_p), .OB(dtc_clk_n), .I(dtc_clk));	
	assign dcs_wr_clk = gclk_40m;	

endmodule
