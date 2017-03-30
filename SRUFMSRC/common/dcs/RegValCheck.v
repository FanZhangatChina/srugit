`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module RegValCheck(
	input [15:0] din,
	output dout
    );

assign dout = din[15]|din[14]|din[13]|din[12]|din[11]|din[10]|din[9]|din[8]
|din[7]|din[6]|din[5]|din[4]|din[3]|din[2]|din[1]|din[0];

endmodule
