`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

//module main_clk_gen #(
//parameter SRUHDVer = 1'b0  //'0': SRUV2; '1' : SRUV3
//)
module main_clk_gen 
(
	input				BusyClr,
	input				RegFsmRst,
	
	input 			brdclk_p, //100 MHz differential clock
	input 			brdclk_n,		
	input 			pllclkin1_p, //Clock from Jitter cleaner.  TTC clock --> Clock cleaner --> pllclkin1 
	input 			pllclkin1_n,
	input				ttc_ready,
	input				RdoClkSel,
	//Phase control interface for Deser
	input 			pscmd,
	input [16:0]	psscancfg,
	input [15:0] 	deser_dout,
	
//	output 			brdclk,	
	output 			dcsclk,//Clocks for slow control
	output 			rdoclk,
	output			icap_clk,
	
	input  [39:0] 	dtc_clk_en,	
	output [39:0] 	dtc_clk,

	//DTC_RETURN, DTC_DATA. Deser
	output [39:0] 	DeserBitclk, //Phase tunable
	output [39:0] 	DeserBitclkDiv, //Phase tunable
	//DTC_TRIG, Ser
	output [39:0] 	SerBitclk, //Phase untunable
	output [39:0] 	SerBitclkDiv, //Phase untunable
	
	output			psscan_flag,
	output	 [15:0]	dtcref_phase,

	output			DcsClkLockSt,
	output			SerClkLockSt
	);

wire psclk;
wire RdoClkSrc;
wire DtcClkSrc;

SGclkMux USGclkMux (
    .brdclk_p(brdclk_p), 
    .brdclk_n(brdclk_n), 
    .pllclkin1_p(pllclkin1_p), 
    .pllclkin1_n(pllclkin1_n), 
    .RdoClkSel(RdoClkSel), 
    .ttc_ready(ttc_ready),	 
	 
//    .brdclk(brdclk), 
    .RdoClkSrc(RdoClkSrc), 
    .psclk(psclk), 
    .dcsclk(dcsclk), 
	 .icap_clk(icap_clk),
    .dcsclk_locked(DcsClkLockSt)
    );
	 
SerClkSrc USerClkSrc (
	 .BusyClr(BusyClr),
    .RegFsmRst(RegFsmRst),
	 .ClkReset(~DcsClkLockSt),
    .RdoClkSrc(RdoClkSrc), 
    .psclk(psclk), 
    .pscmd(pscmd), 
    .psmode(psscancfg[16]), 
    .psstep(psscancfg[15:0]), 
	 .dtcref_phase(dtcref_phase),
	 
    .deser_dout(deser_dout), 
    .rdoclk(rdoclk), 
    .DtcClkSrc(DtcClkSrc),
    .DeserBitclk(DeserBitclk), 
    .DeserBitclkDiv(DeserBitclkDiv), 
    .SerBitclk(SerBitclk), 
	 .psscan_flag(psscan_flag),
    .SerBitclkDiv(SerBitclkDiv), 
    .SerClkLockSt(SerClkLockSt)
    );

   genvar j;
   generate
   for (j=0; j < 40; j=j+1) 
   begin: dtc_clkgen
	assign dtc_clk[j] = dtc_clk_en[j] ? DtcClkSrc : 1'b1;
	end
   endgenerate

endmodule
