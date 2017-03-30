`timescale 1ns / 1ps

// ALICE/PHOS SRU
// This is the top module of the DDL link.
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module ddl_mac  #(
parameter Simulation = 1'b0
)(
	input							rdoclk,
	
	output						DtcRamclkb,
	output	[39:0]			DtcRamenb,
	output  	[9:0]	   		DtcRamaddrb,
	input 	[1319:0]	   	DtcRamdoutb,
	output 						DtcRamReadConfirm,
	
//	input		  					CDHVer,
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

	input	   [79:0]   		rdo_cfg,
		
	input 	[1:0]				sclkphasecnt,
	input							STrigErrFlag,
	
	input							EventRdySent,
	output						ddl_tx_start,
	output 	[31:0]			ddl_ecnt,
	output 	[31:0]			ddl_if_debug,
		
	output	[1:0]				rorc_status,
	input	   [7:0]				SIUIP,
	
	input 	 					ddl_rxn,
	input 	 					ddl_rxp,
	output 	 					ddl_txn,
	output 	 					ddl_txp,
	input 						ddl_refclk_p,
	input 						ddl_refclk_n,	
	
	input							BusyClr,
	input							ddlinit,
	input		[1:0]				ddl_xoff,
	input							reset
    );

//-------------------------------------------------------------------------	
//-------------------------------------------------------------------------

wire siu_reset;
wire siu_foCLK;
wire [31:0] siu_fbd;
wire siu_fbten_n;
wire siu_fbctrl_n;
wire siu_fiben_n;
wire siu_fidir;
wire siu_filf_n;
wire siu_fobsy_n;

wire [31:0] siusn;

SIUSNGEN u_SIUSNGEN (
    .clk(siu_foCLK), 
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
	 .ddlinit(ddlinit|reset),
    .gpio_in(reset)
    );
	 
ddl_fee_if u_ddl_fee_if (
    .DtcRamclkb(DtcRamclkb), 
    .DtcRamenb(DtcRamenb), 
    .DtcRamaddrb(DtcRamaddrb), 
    .DtcRamdoutb(DtcRamdoutb), 
    .DtcRamReadConfirm(DtcRamReadConfirm), 
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
    .rdo_cfg(rdo_cfg), 
    .sclkphasecnt(sclkphasecnt), 
    .STrigErrFlag(STrigErrFlag), 
    .EventRdySent(EventRdySent), 
    .ddl_tx_start(ddl_tx_start), 
	 .ddl_ecnt(ddl_ecnt),
	 .ddl_if_debug(ddl_if_debug),

    .siu_reset(BusyClr|siu_reset), 
//  .siu_reset(BusyClr|siu_reset|reset), //For simulation
    .siu_foCLK(siu_foCLK), 
    .siu_fbd(siu_fbd), 
    .siu_fbten_n(siu_fbten_n), 
    .siu_fbctrl_n(siu_fbctrl_n), 
    .siu_fiben_n(siu_fiben_n), 
    .siu_fidir(siu_fidir), 
    .siu_filf_n(siu_filf_n), 
    .siu_fobsy_n(siu_fobsy_n)
    );

	 
endmodule
