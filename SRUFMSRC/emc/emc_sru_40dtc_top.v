`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module sru_40dtc_top(
		output 	[39:0] 		dtc_clk_p,
		output 	[39:0] 		dtc_clk_n,
		output 	[39:0] 		dtc_trig_p,
		output 	[39:0] 		dtc_trig_n,
		input  	[39:0] 		dtc_data_p,
		input  	[39:0] 		dtc_data_n,
		input  	[39:0] 		dtc_return_p,
		input  	[39:0] 		dtc_return_n,		 

		input  					dcsclk,
		output 	[39:0] 		fee_flag,
		input   					WordAlignStart,
		input  					errtest,
		output 	[639:0] 		errcnt,
		 
		input 					FeeTrig,
		input 					rdocmd,
		input 					abortcmd,
		input            		FastCmd,
		input	   [7:0]    	FastCmdCode,
		output			  		FastCmdAck,
		 
		input		[119:0]		rdo_cfg,
		output  	[39:0]		DTCEventRdy,
		input 					DtcRamClr,
		output 					DtcRamFlag,
		
	   input		[1:0]			DtcRamclkb,
		input		[39:0]		DtcRamenb,
		input  	[19:0]	   DtcRamaddrb,
		output 	[1319:0]	   DtcRamdoutb,
		input 	[1:0]			DtcRamReadConfirm,
		input		[1:0]			ddl_xoff,

		input       			dcs_rx_clk,           
		input 	[7:0] 		dcs_rxd,              
		input 	[39:0]		dcs_rx_dv,            
		input  					udp_tx_clk,
		output 					udp_tx_sof_n,
		output 	[7:0] 		udp_tx_data_out,
		output 					udp_tx_eof_n,
		output 					udp_tx_src_rdy_n,
		input  					udp_tx_dst_rdy_n,
		input  	[5:0] 		udp_tx_fifo_addr,			
		input  	[15:0]		dcs_udp_dst_port,
		input  	[15:0]		dcs_udp_src_port,	
		
		input 	[39:0] 		dtc_clk,
		input 	[39:0] 		DeserBitclk,
		input 	[39:0] 		DeserBitclkDiv,	
		input 	[39:0] 		SerBitclk,
		input 	[39:0] 		SerBitclkDiv,
		output 	[639:0] 		dtc_dout,
		
		input 					reset		 
		);
	
	
	wire  [1:0]		FastCmdAck_i;
	wire	[1:0]		DtcRamFlag_i;
	assign FastCmdAck = FastCmdAck_i[0];

genvar j;
generate
for (j=0; j < 2; j=j+1) 
  begin: dtc_partition
dtc_partition_top #(	.DcsNode(j), .DcsFifoAddr(j)) u_dtc_partition_top (
    .dtc_clk_p(dtc_clk_p[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_clk_n(dtc_clk_n[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_trig_p(dtc_trig_p[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_trig_n(dtc_trig_n[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_data_p(dtc_data_p[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_data_n(dtc_data_n[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_return_p(dtc_return_p[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_return_n(dtc_return_n[((j+1)*20-1):((j+1)*20-20)]), 
	 
    .dcsclk(dcsclk), 
    .fee_flag(fee_flag[((j+1)*20-1):((j+1)*20-20)]), 
    .WordAlignStart(WordAlignStart), 
    .errtest(errtest), 
    .errcnt(errcnt[((j+1)*320-1):((j+1)*320-320)]), 
	 
    .FeeTrig(FeeTrig),  
    .rdocmd(rdocmd), 
    .abortcmd(abortcmd), 
	 .FastCmd(FastCmd),
	 .FastCmdCode(FastCmdCode),
	 .FastCmdAck(FastCmdAck_i[j]),
	 
    .rdo_cfg(rdo_cfg[((j+1)*60-1):((j+1)*60-60)]), 
    .DTCEventRdy(DTCEventRdy[((j+1)*20-1):((j+1)*20-20)]), 
    .DtcRamClr(DtcRamClr), 
    .DtcRamFlag(DtcRamFlag_i[j]), 
    .DtcRamclkb(DtcRamclkb[j]), 
    .DtcRamenb(DtcRamenb[((j+1)*20-1):((j+1)*20-20)]), 
    .DtcRamaddrb(DtcRamaddrb[((j+1)*10-1):((j+1)*10-10)]), 
    .DtcRamdoutb(DtcRamdoutb[((j+1)*660-1):((j+1)*660-660)]), 
    .DtcRamReadConfirm(DtcRamReadConfirm[j]),
   	 
	 .dcs_rx_clk(dcs_rx_clk), 
    .dcs_rxd(dcs_rxd), 
    .dcs_rx_dv(dcs_rx_dv[((j+1)*20-1):((j+1)*20-20)]), 
	 .udp_tx_clk(udp_tx_clk), 
    .udp_tx_sof_n(udp_tx_sof_n), 
    .udp_tx_data_out(udp_tx_data_out[7:0]), 
    .udp_tx_eof_n(udp_tx_eof_n), 
    .udp_tx_src_rdy_n(udp_tx_src_rdy_n), 
    .udp_tx_dst_rdy_n(udp_tx_dst_rdy_n), 
    .udp_tx_fifo_addr(udp_tx_fifo_addr[5:0]), 	 
	 .dcs_udp_dst_port(dcs_udp_dst_port), 
    .dcs_udp_src_port(dcs_udp_src_port), 
	 
    .dtc_clk(dtc_clk[((j+1)*20-1):((j+1)*20-20)]), 
    .DeserBitclk(DeserBitclk[((j+1)*20-1):((j+1)*20-20)]), 
    .DeserBitclkDiv(DeserBitclkDiv[((j+1)*20-1):((j+1)*20-20)]), 
    .SerBitclk(SerBitclk[((j+1)*20-1):((j+1)*20-20)]), 
    .SerBitclkDiv(SerBitclkDiv[((j+1)*20-1):((j+1)*20-20)]), 
    .dtc_dout(dtc_dout[((j+1)*320-1):((j+1)*320-320)]), 

	 .reset(reset)
    );
	end
  endgenerate

event_sent_fsm u_DtcRamFlag (
    .reset(reset), 
    .clk(dcsclk), 
    .ddl_event_send_i(DtcRamFlag_i), 
    .ddl_xoff(ddl_xoff), 
    .ddl_event_send(DtcRamFlag)
    );


endmodule

