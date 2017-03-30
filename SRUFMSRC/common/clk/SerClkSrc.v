`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module SerClkSrc(
	input				BusyClr,
	input				RegFsmRst,
	input				ClkReset,
	input				RdoClkSrc,
	input				psclk,
	input				pscmd,
	input				psmode,
	input	 [15:0]	psstep,
	input	 [15:0]	deser_dout,
	
   output 			rdoclk,
	output			DtcClkSrc,

	//DTC_RETURN, DTC_DATA. Deser
	output [39:0] 	DeserBitclk, //Phase tunable
	output [39:0] 	DeserBitclkDiv, //Phase tunable
	
	output [39:0] 	SerBitclk, //Phase untunable
	output [39:0] 	SerBitclkDiv, //Phase untunable
	
	output			psscan_flag,
	output [15:0]	dtcref_phase,
	
	output			SerClkLockSt
    );

	wire GDeserBitclk;
	wire GDeserBitclkDiv;
	wire GSerBitclk;
	wire GSerBitclkDiv;
	
	wire psen; 
	wire psdone;

//VCO = 750 MHz	
	dtc_40clk USerClkGen
   (// Clock in ports
    .CLK_IN1(RdoClkSrc),      // IN
    // Clock out ports
    .CLK_OUT1(DtcClkSrc),     // OUT
    .CLK_OUT2(GDeserBitclkDiv),     // OUT
    .CLK_OUT3(GSerBitclkDiv),     // OUT
    .CLK_OUT4(rdoclk),     // OUT
	 .CLK_OUT5(GDeserBitclk),
	 
    // Dynamic phase shift ports
    .PSCLK(psclk),// IN
    .PSEN(psen), // IN
    .PSINCDEC(1'b1),     // IN
    .PSDONE(psdone),       // OUT	 
    .RESET(ClkReset|RegFsmRst),// IN
    .LOCKED(SerClkLockSt));      // OUT
	 
	psctrl u_psctrl (
	.psclk(psclk),
	.pscmd(pscmd),
	.psmode(psmode),
	.deser_dout(deser_dout),
	.psstep(psstep),
	.psen(psen),
	.psdone(psdone),
	.psscan_flag(psscan_flag),
	//.dtcref_phase(dtcref_phase),
	.reset(RegFsmRst|BusyClr)	
	);

	assign GSerBitclk = rdoclk;

   genvar j;
   generate
   for (j=0; j < 40; j=j+1) 
   begin: ClkAssign
	assign DeserBitclk[j] = GDeserBitclk; 
	assign DeserBitclkDiv[j] = GDeserBitclkDiv; 
	assign SerBitclk[j] = GSerBitclk;
	assign SerBitclkDiv[j] = GSerBitclkDiv;
	end
   endgenerate

endmodule
