
// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

`timescale 1ns / 1ps

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
		 
		 //trigger pulse input
		input 					FeeTrig,
		input 					rdocmd,
		input 					abortcmd,
		input            		FastCmd,
		input	  	[7:0]    	FastCmdCode,
		output			  		FastCmdAck,
		//DDL interface
		input		[79:0]		rdo_cfg,
		output   [39:0]		DTCEventRdy,
		input 					DtcRamClr,
		output 					DtcRamFlag,
		
	   input						DtcRamclkb,
		input		[39:0]		DtcRamenb,
		input  	[9:0]	   	DtcRamaddrb,
		output 	[1319:0]	   DtcRamdoutb,
		input 					DtcRamReadConfirm,
		 
		 //DCS rx_fifo read interface
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
		input		[1:0]			ddl_xoff,
		//-------------------------------------------------------
		
		input 					reset		 
		);


	parameter 			DcsFifoAddr = 6'h0;
	
	wire 	[39:0] 		DtcRamFlag_i;
	reg  	[39:0]		DtcRamFlag_ii = 40'h0;
	reg					DTCRamAllFlag_i = 1'b0;
	
	wire 	[39:0] 		FastCmdAck_i;	
	reg 	[39:0] 		FeeTrig_i = 40'h0;
	reg 	[39:0]  		rdocmd_i = 40'h0;
	reg 	[39:0]  		abortcmd_i = 40'h0;
	reg 	[39:0]  		DTCEventRdy_i = 40'h0;
	wire 	[39:0] 		dtc_mask;
	
	assign   			dtc_mask = rdo_cfg[39:0];
	assign 				FastCmdAck = FastCmdAck_i[0];
	assign 				DtcRamFlag = DTCRamAllFlag_i;
	assign   			DTCEventRdy = DTCEventRdy_i;

	wire  				dcs_rd_clk;
	wire 					dcs_rd_sof_n;
	wire 	[7:0] 		dcs_rd_data_out;
	wire 					dcs_rd_eof_n;
	wire 					dcs_rd_src_rdy_n;
	wire      			dcs_rd_dst_rdy_n;
	wire  [5:0]			dcs_rd_addr;

////////////////////////////////////////////////////////////////////////////////
	genvar j;
	generate
    for (j=0; j < 40; j=j+1) 
	
    begin: ddl0_dtc_partition
	dtc_master_top  #(
	.DcsNode(j),
	.DcsFifoAddr(j)) u_dtc_master_top(
	.dtc_clk_p				(dtc_clk_p[j]),
	.dtc_clk_n				(dtc_clk_n[j]),
	.dtc_trig_p				(dtc_trig_p[j]),
	.dtc_trig_n				(dtc_trig_n[j]),
	.dtc_data_p				(dtc_data_p[j]),
	.dtc_data_n				(dtc_data_n[j]),
	.dtc_return_p			(dtc_return_p[j]),
	.dtc_return_n			(dtc_return_n[j]),

	.gclk_40m				(dcsclk),
	.fee_flag				(fee_flag[j]),

   .WordAlignStart		(WordAlignStart), 
   .errtest					(errtest), 
   .errcnt					(errcnt[((j+1)*16-1) : ((j+1)*16-16)]), 

	.FeeTrig					(FeeTrig_i[j]),
	.rdocmd					(rdocmd_i[j]),
	.abortcmd				(abortcmd_i[j]),

	.dcs_rx_clk				(dcs_rx_clk), 
	.dcs_rxd					(dcs_rxd), 
	.dcs_rx_dv				(dcs_rx_dv[j]),

	.DtcRamclkb          (DtcRamclkb),
	.DtcRamenb     		(DtcRamenb[j]),//bus
   .DtcRamaddrb        	(DtcRamaddrb),//bus
   .DtcRamdoutb        	(DtcRamdoutb[((j+1)*33-1) : ((j+1)*33-33)]),//bus

	.DtcRamReadConfirm  	(DtcRamReadConfirm),
	.DtcRamClr          	(DtcRamClr),
	.DtcRamFlag          (DtcRamFlag_i[j]),

	.dcs_rd_clk          (dcs_rd_clk),
	.dcs_rd_data_out     (dcs_rd_data_out),//bus
   .dcs_rd_sof_n        (dcs_rd_sof_n),//bus
   .dcs_rd_eof_n        (dcs_rd_eof_n),//bus
   .dcs_rd_src_rdy_n    (dcs_rd_src_rdy_n),//bus
   .dcs_rd_dst_rdy_n    (dcs_rd_dst_rdy_n),
	.dcs_rd_addr		 	(dcs_rd_addr),
   .dcs_rx_fifo_status  (), 
	.dcs_rx_overflow	 	(),
	.dcs_udp_dst_port	 	(dcs_udp_dst_port),
	.dcs_udp_src_port	 	(dcs_udp_src_port),
		
	//clock interface
	.dtc_clk					(dtc_clk[j]), 
	.DeserBitclk			(DeserBitclk[j]),
	.DeserBitclkDiv		(DeserBitclkDiv[j]),
	.SerBitclk				(SerBitclk[j]),
	.SerBitclkDiv			(SerBitclkDiv[j]),

	.dtc_deser_dout		(dtc_dout[((j+1)*16-1) : ((j+1)*16-16)]),
	
	.FastCmd					(FastCmd),
	.FastCmdCode			(FastCmdCode),
   .FastCmdAck				(FastCmdAck_i[j]), 
	 
	.reset					(reset)
	);
	end
  endgenerate

  always @(posedge dcsclk)
  if(dtc_mask == 40'hfffff_fffff)
  DTCRamAllFlag_i <= 1'b0;
  else if(DtcRamFlag_ii == 40'hfffff_fffff)
  DTCRamAllFlag_i <= 1'b1;
  else
  DTCRamAllFlag_i <= 1'b0;
  
//-----------------------------------------------------------
  always @(posedge dcsclk)
  DTCEventRdy_i <= DtcRamFlag_ii;

  genvar m;
  generate
  for (m=0; m < 40; m=m+1) 
  begin: trigger_mask
  
  always @(posedge dcsclk)
	  begin
	  FeeTrig_i[m] <= (!dtc_mask[m]) & FeeTrig;
	  rdocmd_i[m] <= (!dtc_mask[m]) & rdocmd;
	  abortcmd_i[m] <= (!dtc_mask[m]) & abortcmd; 
	  DtcRamFlag_ii[m] <= DtcRamFlag_i[m] | dtc_mask[m];
	  end
  end
  endgenerate

//udp_reply_mux: Select one of multiple UDP reply fifos (support 64 fifos) and forwards
//one frame in one of the fifo into a single fifo.
udp_reply_mux #(.MaxUdpCh(39), .UdpFifoAddr(DcsFifoAddr)) u_udp_reply_mux (
    .udp_sw_tx_clk(udp_tx_clk), 
    .udp_sw_tx_sof_n(udp_tx_sof_n), 
    .udp_sw_tx_data_out(udp_tx_data_out), 
    .udp_sw_tx_eof_n(udp_tx_eof_n), 
    .udp_sw_tx_src_rdy_n(udp_tx_src_rdy_n), 
    .udp_sw_tx_dst_rdy_n(udp_tx_dst_rdy_n), 
    .udp_sw_tx_fifo_rd_addr(udp_tx_fifo_addr), 
    .udp_sw_tx_fifo_status(), 
    .udp_sw_tx_overflow(), 
	
    .udp_tx_rd_clk(dcs_rd_clk), 
    .udp_tx_rd_sof_n(dcs_rd_sof_n), 
    .udp_tx_rd_data_out(dcs_rd_data_out), 
    .udp_tx_rd_eof_n(dcs_rd_eof_n), 
    .udp_tx_rd_src_rdy_n(dcs_rd_src_rdy_n), 
    .udp_tx_rd_dst_rdy_n(dcs_rd_dst_rdy_n), 
    .udp_tx_rd_fifo_addr(dcs_rd_addr), 
	
    .reset(reset)
    );
	

endmodule

