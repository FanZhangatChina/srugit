`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module SCLKPhaseDetect(
	input reset,
	input clk,
	input ttc_bcntres,
	input FastCmd,
	input [7:0] FastCmdCode,
	input FastCmdAck,
	
	output reg [1:0] sclkphasecnt = 2'h0
    );

reg [31:0] cnt_i = 32'h0;

parameter SCLKCMDCODE = 32'h0000_00E4;

always @(posedge clk)
if(reset||ttc_bcntres)
begin
cnt_i <= 32'h0;
end else begin
cnt_i <= cnt_i + 32'h1;
end

parameter IDLE_st = 2'h0; parameter FastCmd_st = 2'h1;
parameter SCLKCMD_st = 2'h2; parameter SCLKWAIT_st = 2'h3;
reg [1:0] st = IDLE_st;

always @(posedge clk)
if(reset)
begin
sclkphasecnt <= 2'h0;
st <= IDLE_st;
end else case(st)
IDLE_st : begin
sclkphasecnt <= sclkphasecnt;

if(FastCmd)
st <= FastCmd_st;
else
st <= IDLE_st;
end

FastCmd_st : begin
sclkphasecnt <= sclkphasecnt;

if(FastCmdCode == SCLKCMDCODE)
st <= SCLKCMD_st;
else
st <= IDLE_st;
end

SCLKCMD_st : begin
if(FastCmdAck)
	begin
	st <= SCLKWAIT_st;
	sclkphasecnt <= cnt_i[1:0];
	end 
else
	begin
	st <= SCLKCMD_st;
	sclkphasecnt <= sclkphasecnt;
	end
end

SCLKWAIT_st : begin
	sclkphasecnt <= sclkphasecnt;
	
if(FastCmdAck || FastCmd)
	st <= SCLKWAIT_st;
else
	st <= IDLE_st;
end

default: begin
			sclkphasecnt <= 2'h0;
			st <= IDLE_st;
			end
endcase

endmodule
