`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module DtcRamMgt(
		input reset,
		input clk,
		input WrConfirm,
		input ReadConfirm,
		input RamClr,
		output reg RamFlag = 1'b0
    );

reg ReadConfirm_i = 1'b0;

always @(posedge clk)
ReadConfirm_i <= ReadConfirm | RamClr;

parameter WriteWait_st 	= 6'b00_0001;
parameter Write_st 		= 6'b00_0010;
parameter WriteCfm_st 	= 6'b00_0100;
parameter ReadWait_st 	= 6'b00_1000;
parameter Read_st 		= 6'b01_0000;
parameter ReadCfm_st 	= 6'b10_0000;

reg [5:0] st = WriteWait_st;
   (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="6'b00_0001" *) 

always @(posedge clk)
if(reset)
begin
RamFlag <= 1'b0;
st <= WriteWait_st;
end else case(st)
WriteWait_st : begin
RamFlag <= 1'b0;

if(WrConfirm)
st <= Write_st;
else
st <= WriteWait_st;
end

Write_st : begin
RamFlag <= 1'b1;

if(WrConfirm)
st <= Write_st;
else
st <= WriteCfm_st;
end

WriteCfm_st : begin
RamFlag <= 1'b1;
st <= ReadWait_st;
end

ReadWait_st : begin
RamFlag <= 1'b1;
if(ReadConfirm_i)
st <= Read_st;
else
st <= ReadWait_st;
end

Read_st : begin
RamFlag <= 1'b1;
if(ReadConfirm_i)
st <= Read_st;
else
st <= ReadCfm_st;
end

ReadCfm_st : begin
RamFlag <= 1'b0;
st <= WriteWait_st;
end

default : begin
RamFlag <= 1'b0;
st <= WriteWait_st;
end
endcase

endmodule
