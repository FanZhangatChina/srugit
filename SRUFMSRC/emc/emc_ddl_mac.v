`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module ddl_mac  #(
parameter Simulation = 1'b0
)(
	input							rdoclk,
	
	output	[1:0]				DtcRamclkb,
	output	[39:0]			DtcRamenb,
	output  	[19:0]	   	DtcRamaddrb,
	input 	[1319:0]	   	DtcRamdoutb,
	output 	[1:0]				DtcRamReadConfirm,
	
	//input		  					CDHVer,
	input 	[31:0] 			cdh_w0,
	input 	[31:0] 			cdh_w1,
	input 	[31:0] 			cdh_w2,
	input 	[31:0] 			cdh_w3,
	input 	[31:0] 			cdh_w4,
	input 	[31:0] 			cdh_w5,
	input 	[31:0] 			cdh_w6,
	input 	[31:0] 			cdh_w7,
	input 	[31:0] 			cdh_w8,
	input 	[31:0] 			cdh_w9,	

	input	   [119:0]   		rdo_cfg,
	input 	[1:0]				sclkphasecnt,
	input							STrigErrFlag,
	
	input							EventRdySent,
	output						ddl_tx_start,
	output 	[63:0]			ddl_ecnt,
	output 	[63:0]			ddl_if_debug,
		
	output	[3:0]				rorc_status,
	input	  	[7:0]				SIUIP,
	
	input 	[1:0]				ddl_rxn,
	input 	[1:0]				ddl_rxp,
	output 	[1:0]				ddl_txn,
	output 	[1:0]				ddl_txp,
	input 						ddl_refclk_p,
	input 						ddl_refclk_n,	
	
	input		[1:0]				ddl_xoff,
	input							BusyClr,
	input							ddlinit,
	input							reset
    );

		//-------------------------------------------------------------------------	
		//-------------------------------------------------------------------------

wire [1:0]  ddl_event_sent_i;
wire [1:0]  siu_reset;
wire [1:0]  siu_foCLK;
wire [63:0] siu_fbd;
wire [1:0]  siu_fbten_n;
wire [1:0]  siu_fbctrl_n;
wire [1:0]  siu_fiben_n;
wire [1:0]  siu_fidir;
wire [1:0]  siu_fobsy_n;
wire [1:0]  siu_first_n;
wire [1:0]  siu_filf_n;

wire [31:0] siusn;
wire [1:0]	ddl_tx_start_i;

SIUSNGEN u_SIUSNGEN (
    .clk(siu_foCLK[0]), 
    .sruip({SIUIP}), 
    .siusn(siusn)
    );

siu_emulator u_siu_emulator (
    .dclk(rdoclk), 
    .refclk_p(ddl_refclk_p), 
    .refclk_n(ddl_refclk_n), 
    .sfp_rx_p(ddl_rxp), 
    .sfp_rx_n(ddl_rxn), 
    .sfp_tx_p(ddl_txp), 
    .sfp_tx_n(ddl_txn), 
	 
    .siu_reset(siu_reset), 
    .siu_foCLK(siu_foCLK), 
    .siu_fbd(siu_fbd), 
    .siu_fbten_n(siu_fbten_n), 
    .siu_fbctrl_n(siu_fbctrl_n), 
    .siu_fiben_n(siu_fiben_n), 
    .siu_fidir(siu_fidir), 
    .siu_filf_n(siu_filf_n), 
    .siu_fobsy_n(siu_fobsy_n), 
    .siu_first_n(siu_first_n), 
    
	 .siusn(siusn),
	 .ddl_mode(rorc_status),
	 .ddlinit(ddlinit), 
    .gpio_in(reset)
    );


genvar i;
generate
for (i=0; i < 2; i=i+1)	
begin: SIU_INST

ddl_fee_if u_ddl_fee_if (
    .DtcRamclkb(DtcRamclkb[i]), 
    .DtcRamenb(DtcRamenb[((i+1)*20-1) : ((i+1)*20-20)]), 
    .DtcRamaddrb(DtcRamaddrb[((i+1)*10-1) : ((i+1)*10-10)]), 
    .DtcRamdoutb(DtcRamdoutb[((i+1)*660-1) : ((i+1)*660-660)]), 
    .DtcRamReadConfirm(DtcRamReadConfirm[i]), 
//    .CDHVer(CDHVer), 
    .cdh_w0(cdh_w0), 
    .cdh_w1(cdh_w1), 
    .cdh_w2(cdh_w2), 
    .cdh_w3(cdh_w3), 
    .cdh_w4(cdh_w4), 
    .cdh_w5(cdh_w5), 
    .cdh_w6(cdh_w6), 
    .cdh_w7(cdh_w7), 
    .cdh_w8(cdh_w8), 
    .cdh_w9(cdh_w9), 
    .rdo_cfg(rdo_cfg[((i+1)*60-1) : ((i+1)*60-60)]), 
    .sclkphasecnt(sclkphasecnt), 
    .STrigErrFlag(STrigErrFlag), 
    .EventRdySent(EventRdySent), 
    .ddl_tx_start(ddl_tx_start_i[i]), 
    .ddl_ecnt(ddl_ecnt[((i+1)*32-1) : ((i+1)*32-32)]), 
    .ddl_if_debug(ddl_if_debug[((i+1)*32-1) : ((i+1)*32-32)]), 
	 
    .siu_reset(BusyClr|siu_reset[i]), 
//	 .siu_reset(BusyClr|siu_reset[i]|reset), //For simulation
    .siu_foCLK(siu_foCLK[i]), 
    .siu_fbd(siu_fbd[((i+1)*32-1) : ((i+1)*32-32)]),
    .siu_fbten_n(siu_fbten_n[i]), 
    .siu_fbctrl_n(siu_fbctrl_n[i]), 
    .siu_fiben_n(siu_fiben_n[i]), 
    .siu_fidir(siu_fidir[i]), 
    .siu_filf_n(siu_filf_n[i]), 
    .siu_fobsy_n(siu_fobsy_n[i]) 
	 
    );

end
endgenerate

event_sent_fsm u_event_sent_fsm (
    .reset(reset), 
    .clk(siu_foCLK[0]), 
    .ddl_event_send_i(ddl_tx_start_i), 
    .ddl_xoff(ddl_xoff), 
    .ddl_event_send(ddl_tx_start)
    );

 
endmodule
