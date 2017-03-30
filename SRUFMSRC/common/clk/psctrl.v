`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module psctrl (
input psclk,
input pscmd,
input psmode,
input [15:0] psstep,
output reg psen = 1'b0,
input psdone,
input [15:0] deser_dout,

//output reg [15:0] dtcref_phase = 16'h0,
//output [15:0] dtcref_phase,

output reg psscan_flag = 1'b0,
input reset
);

reg [15:0] psstepcnt = 16'd0;
//reg [15:0] dtcref_phase_i = 16'h0;
//assign dtcref_phase = dtcref_phase_i;

parameter st0  = 11'b000_0000_0001;
parameter st1  = 11'b000_0000_0010;
parameter st2  = 11'b000_0000_0100;
parameter st3  = 11'b000_0000_1000;
parameter st4  = 11'b000_0001_0000;
parameter st5  = 11'b000_0010_0000;
parameter st6  = 11'b000_0100_0000;
parameter st7  = 11'b000_1000_0000;
parameter st8  = 11'b001_0000_0000;
parameter st9  = 11'b010_0000_0000;
parameter st10 = 11'b100_0000_0000;

reg [10:0] st = st0;

always @(posedge psclk)
if(reset)
begin
psen <= 1'b0;
psstepcnt <= 16'd0;
//dtcref_phase_i <= 16'd0;
st <= st0;
end else
case(st)
st0 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
if(pscmd)
st <= st1;
else
st <= st0;
end

st1 : begin
psen <= 1'b0;
psstepcnt <= 16'd0;
//dtcref_phase_i <= dtcref_phase_i;
if(pscmd)
st <= st1;
else if(psmode)
begin
st <= st2;
//dtcref_phase_i <= dtcref_phase_i;
end
else
begin
st <= st5;
//dtcref_phase_i <= 16'd0;
end
end

st2 : begin
psen <= 1'b1;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= psstepcnt + 16'd1;
st <= st3;
end

st3 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= psstepcnt;
if(psdone)
st <= st4;
else
st <= st3;
end

st4 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= psstepcnt;
if(psstepcnt == psstep)
st <= st0;
else
st <= st2;
end
//////////////////////////////////
st5 : begin
psen <= 1'b1;
//dtcref_phase_i <= dtcref_phase_i + 16'd1;
psstepcnt <= 16'd0;
st <= st6;
end

st6 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= 16'd0;
if(psdone)
st <= st7;
else
st <= st6;
end

st7 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= 16'd0;
if(deser_dout == 16'hbc50)
st <= st5;
else
st <= st8;
end


st8 : begin
psen <= 1'b1;
//dtcref_phase_i <= dtcref_phase_i;
if(deser_dout == 16'hbc50)
psstepcnt <= psstepcnt + 16'd1;
else
psstepcnt <= 16'd0;
st <= st9;
end

st9 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= psstepcnt;
if(psdone)
st <= st10;
else
st <= st9;
end

st10 : begin
psen <= 1'b0;
//dtcref_phase_i <= dtcref_phase_i;
psstepcnt <= psstepcnt;
//if(psstepcnt == 16'd112)//5.125ns
if(psstepcnt == psstep)//5.125ns
st <= st0;
else
st <= st8;
end

default: begin
//dtcref_phase_i <= 16'd0;
psstepcnt <= 16'd0;
psen <= 1'b0;
st <= st0;
end
endcase

always @(posedge psclk)
if(reset)
begin
psscan_flag <= 1'b0;
end else if(st == st0)
begin
psscan_flag <= 1'b0;
end else
begin
psscan_flag <= 1'b1;
end

endmodule
