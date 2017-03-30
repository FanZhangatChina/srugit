//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : dtc_rx
//* File            : dtc_rx.v
//* Description     : Top module of the DDL links
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*     18-01-2013 : Initial release
//*	  05-03-2013 : Split L0,L1 (posedge) and commands (negedge).
//*******************************************************************************
`timescale 1ns / 1ps
module dtcTrigDecode(
input clkin,
input dtc_trig,

output reg trig_l0n = 1'b1,//low active 
output reg trig_l1n = 1'b1,

input reset
);

parameter shift = 4;
reg [7:0] clkcnt = 8'h0;
reg [shift-1:0] sdc_din_reg = 4'h0;
   
always @(posedge clkin)
  sdc_din_reg  <= {sdc_din_reg[shift-2:0], dtc_trig}; 

parameter Wait_s0 = 0; parameter TrigL1_s = 1;
parameter Wait_s1 = 2; parameter TrigL2_s = 3; parameter Wait_s2 = 4;
reg [2:0] st = Wait_s0;
always @(posedge clkin)
if(reset)
begin
clkcnt <= 8'h0;
trig_l0n <= 1'b1;
trig_l1n <= 1'b1;
st <= Wait_s0;
end else case(st)
Wait_s0 : begin
clkcnt <= 8'h0;
trig_l1n <= 1'b1;

if(sdc_din_reg==4'b0010) //clkcnt=2
	begin
	trig_l0n <= 1'b0;
	st <= TrigL1_s; //trig_l0n =0; for 250ns = 10clks;
	end
else if(sdc_din_reg==4'b0011)
	begin
	trig_l0n <= 1'b1;
	st <= Wait_s1; 
	end
else
	begin
	trig_l0n <= 1'b1;
	st <= Wait_s0;
	end
end

//assert level0 trigger, 250ns
TrigL1_s: begin //clkcnt ++
clkcnt <= clkcnt + 8'h1;//
trig_l0n <= 1'b0;
trig_l1n <= 1'b1;

if(clkcnt==8'd9)
st <= Wait_s0;
else
st <= TrigL1_s;
end

//0110,0111,
Wait_s1: begin
clkcnt <= 8'h0;//
trig_l0n <= 1'b1;
trig_l1n <= 1'b1;

if(sdc_din_reg==4'b0110)
st <= TrigL2_s; //trig_l1n=0; for 250ns = 10clks
else 
st <= Wait_s2; 
end

TrigL2_s: begin //clkcnt ++ 50ns 
clkcnt <= clkcnt + 8'h1;//
trig_l0n <= 1'b1;
trig_l1n <= 1'b0;

if(clkcnt==8'd1)
st <= Wait_s0;
else
st <= TrigL2_s;
end

Wait_s2 : begin
clkcnt <= clkcnt + 8'h1;
trig_l0n <= 1'b1;
trig_l1n <= 1'b1;

if(clkcnt==8'd5)
st <= Wait_s0;
else
st <= Wait_s2;
end

default : begin//clkcnt ++
clkcnt <= 8'd0;//
trig_l0n <= 1'b1;
trig_l1n <= 1'b1;

st <= Wait_s0;
end
endcase

endmodule
