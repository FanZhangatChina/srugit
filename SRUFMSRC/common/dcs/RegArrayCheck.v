`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module RegArrayCheck(
input [639:0] 	din,
output [39:0]  dout
);

genvar j;
generate
for (j=0; j < 40; j=j+1)	
begin: Array
RegValCheck u0 ( .din(din[((j+1)*16-1) : ((j+1)*16-16)]), .dout(dout[j]));
end
endgenerate
  
endmodule
