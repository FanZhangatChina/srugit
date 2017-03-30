`timescale 1ns / 1ps

// This module generate DDL serial number from DCS IP address for EMCal SRU
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 11 July 2015

module SIUSNGEN(
		input 				clk,
		input 	[7:0]		sruip,
		output	[31:0]	siusn
    );

wire [15:0] sruip_bcd;
Hex2BCD uHex2BCD (
    .sys_clk(clk), 
    .HexIn({8'h0,sruip}), 
    .BCD_out(sruip_bcd), 
    .busy()
    );

assign siusn[7:0]  	= 8'h30 + sruip_bcd[3:0];
assign siusn[15:8]  	= 8'h30 + sruip_bcd[7:4];
assign siusn[23:16]  = 8'h30 + sruip_bcd[11:8];
assign siusn[31:24]  = 8'h30 + sruip_bcd[15:12];

endmodule
