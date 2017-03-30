`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

//module SGclkMux #(
//parameter SRUHDVer = 1'b1  //'0': SRUV2; '1' : SRUV3
//)(
module SGclkMux (
	input 			brdclk_p, //100 MHz differential / 40 MHz single-end clock
	input 			brdclk_n,
		
	input 			pllclkin1_p, //Clock from Jitter cleaner.  TTC clock --> Clock cleaner --> pllclkin1 
	input 			pllclkin1_n, //At present, the jitter cleaner is not used. pllclkin1 =  TTC clock;
	
	input 			RdoClkSel, //Force SRU use board clock when RdoClkSel = 0;
	input				ttc_ready,
	
//	output 			brdclk,
	output			RdoClkSrc,
	output			psclk,
	output			dcsclk,
	output			icap_clk,
	output			dcsclk_locked	
    );

	wire pllclkin;
	wire bclk;
	wire brdclk;
	wire dclk_sel;
	
//	generate 
//	if(SRUHDVer)
//	begin
	   IBUFGDS #( .DIFF_TERM("FALSE"),  .IOSTANDARD("DEFAULT")
	   ) IBUFGDS_brdclk ( .O(brdclk), .I(brdclk_p),  .IB(brdclk_n));
		
	   IBUFGDS #( .DIFF_TERM("FALSE"),  .IOSTANDARD("DEFAULT")
	   ) IBUFGDS_pllclk ( .O(pllclkin), .I(pllclkin1_p),  .IB(pllclkin1_n));

		brdclk_pll u_brdclk_pll	(.CLK_IN1(brdclk), .CLK_OUT1(bclk),	 .CLK_OUT2(icap_clk), .LOCKED(dcsclk_locked));

//	end else begin
//	
//   IBUFG #( .IBUF_LOW_PWR("TRUE"),  .IOSTANDARD("DEFAULT")
//   ) IBUFG_brdclk (  .O(brdclk), .I(brdclk_p));		
//	
//   IBUFG #( .IBUF_LOW_PWR("TRUE"),  .IOSTANDARD("DEFAULT")
//   ) IBUFG_pllclk (  .O(pllclkin), .I(pllclkin1_p));		
//	
//	brdclkSRUV2 u_brdclk_pll(.CLK_IN1(brdclk), .CLK_OUT1(bclk),	 .LOCKED(dcsclk_locked));
//
//	end
//	endgenerate
//
	BUFGMUX BUFGMUX_dclk ( .O(RdoClkSrc), .I0(bclk),  .I1(pllclkin), .S(dclk_sel));
	//assign RdoClkSrc = pllclkin;
		
	assign dclk_sel = RdoClkSel & ttc_ready;	//Force SRU use board clock when RdoClkSel = 0;		
	assign psclk = bclk;	
	assign dcsclk = bclk;
	
endmodule
