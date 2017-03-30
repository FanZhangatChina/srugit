`timescale 1ns / 1ps
`define DLY #1
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:23:43 11/04/2011 
// Design Name: 
// Module Name:    altro_emulator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module altro_emulator(
		input rdoclk,
		input cstbn,
		input writen,
		
		output reg ackn,
		output reg trsfn,
		output dstbn,
		
		inout [39:0] bd,
		
		input reset
    );



reg [11:0] ch_addr;
reg [9:0] trcfg;
reg [19:0] altro_reg0;
reg [19:0] altro_reg1;
reg [39:0] bdout;
reg bdout_en;
reg dstbn_en;
reg [3:0] clkcnt = 4'h0;

assign dstbn = dstbn_en ? rdoclk : 1'b1;
assign bd = bdout_en ? bdout : 40'hZ;

parameter st0 = 0;
parameter st1 = 1;
parameter stc2 = 2;
parameter stcw3 = 3;
parameter stcw4 = 4;

parameter stcr3 = 5;
parameter stcr4 = 6;
parameter stcr5 = 7;

parameter strdo2 = 8;
parameter strdo3 = 9;
parameter strdo4 = 10;
parameter strdo5 = 11;
parameter strdo6 = 12;
parameter strdo7 = 13;
parameter strdo8 = 14;
parameter strdo9 = 15;
parameter strdo10 = 16;
parameter strdo11 = 17;
parameter strdo12 = 18;
parameter strdo12a = 19;
parameter strdo12b = 20;
parameter strdo12c = 21;


reg [4:0] st;

always @(posedge reset or posedge rdoclk)
if(reset)
begin
trcfg <= `DLY 10'h0;
altro_reg0 <= `DLY 20'h0;
altro_reg1 <= `DLY 20'h0;
clkcnt <= `DLY 4'h0;

bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;
st <= `DLY st0;
end

else

case(st)
st0 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;
if(cstbn)
st <= `DLY st0;
else
st <= `DLY st1;
end

st1 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;

if(bd[24:20]==5'h1A)
st <= `DLY strdo2;
else 
st <= `DLY stc2;
end

stc2 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;

if(writen)
st <= `DLY stcr3;
else
st <= `DLY stcw3;
end

stcw3 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;

case(bd[24:20])
5'h0a : trcfg <= `DLY bd[9:0];
5'h01 : altro_reg0 <= `DLY bd[19:0];
5'h02 : altro_reg1 <= `DLY bd[19:0];
default : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
end
endcase

st <= `DLY stcw4;
end

stcw4 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;

if(cstbn)
st <= `DLY st0;
else
st <= `DLY stcw4;
end

stcr3 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;

case(bd[24:20])
5'h0a : bdout <= `DLY {30'h0,trcfg};
5'h01 : bdout <= `DLY {20'h0, altro_reg0};
5'h02 : bdout <= `DLY {20'h0, altro_reg1};
default : begin
bdout <= `DLY 40'h55005500;
end
endcase

st <= `DLY stcr4;
end

stcr4 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY bdout;
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;
st <= `DLY stcr5;
end

stcr5 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY bdout;
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;
st <= `DLY st0;
end

strdo2 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY bd[36:25];
st <= `DLY strdo3;
end

strdo3 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b0;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY ch_addr;

if(cstbn)
st <= `DLY strdo4;
else
st <= `DLY strdo3;
end

strdo4 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY clkcnt + 4'h1;


bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY ch_addr;

if(clkcnt == 4'd4)
st <= `DLY strdo5;
else
st <= `DLY strdo4;
end

strdo5 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo6;
end

strdo6 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo7;
end

strdo7 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY 40'h0;
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo8;
end

strdo8 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'h3ff,10'h3f2,10'h02,10'h01}; //word1
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

//st <= `DLY strdo12;

st <= `DLY strdo9;
end

strdo9 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'h08,10'h07,10'h06,10'h05}; //word2
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo12a;
//st <= `DLY strdo10;
end

strdo10 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'h0c,10'h0b,10'h0a,10'h09};//word3
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo11;
end

strdo11 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'h10,10'h0f,10'h0e,10'h0d}; //word4
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo12a;
end

strdo12a : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'h14,10'h13,10'h12,10'h11}; //word5
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo12b;
end

strdo12b : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'd24,10'h17,10'h16,10'd21}; //word6
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo12c;
end

strdo12c : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY {10'd28,10'd27,10'd26,10'd25}; //word6
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY strdo12;
end

strdo12 : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

//bdout <= `DLY {14'h2aaa,10'h11,4'ha,ch_addr}; //trailer
bdout <= `DLY {14'h2aaa,10'h011,4'ha,ch_addr}; //trailer
//bdout <= `DLY {14'h2aaa,10'h05,4'ha,ch_addr}; //trailer
bdout_en <= `DLY 1'b1;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b0;
dstbn_en <= `DLY 1'b1;
ch_addr <= `DLY ch_addr;

st <= `DLY st0;
end

default : begin
trcfg <= `DLY trcfg;
altro_reg0 <= `DLY altro_reg0;
altro_reg1 <= `DLY altro_reg1;
clkcnt <= `DLY 4'h0;

bdout <= `DLY 40'h0; //trailer
bdout_en <= `DLY 1'b0;
ackn <= `DLY 1'b1;
trsfn <= `DLY 1'b1;
dstbn_en <= `DLY 1'b0;
ch_addr <= `DLY 12'h0;

st <= `DLY st0;
end
endcase

endmodule
