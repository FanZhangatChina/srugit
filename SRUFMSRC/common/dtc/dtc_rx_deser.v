`timescale 1ns / 1ps

// This module does DTC data deserialization and word alignment for EMCal SRU
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 11 July 2015

`define DLY #1

module dtc_rx_deser(
input bitclk,
input bitclkdiv,
input dtc_data_p,
input dtc_data_n,
input dtc_return_p,
input dtc_return_n,
output [15:0] dtc_deser_dout,
input WordAlignStart,

input errtest,
output reg [15:0] errcnt = 16'h0,

input reset
    );

//bitslip module
/*
To invoke a Bitslip operation, the BITSLIP port must be asserted High for one CLKDIV cycle. 
In SDR mode, Bitslip cannot be asserted for two consecutive CLKDIV cycles; Bitslip must be 
deasserted for at least one CLKDIV cycle between two Bitslip assertions. 
In both SDR and DDR mode, the total latency from when the ISERDES captures the asserted Bitslip 
input to when the "bit-slipped" ISERDES outputs Q1-Q6 are sampled into the FPGA logic by CLKDIV
is two CLKDIV cycles.
*/
reg bitslip = 1'b0;
wire WordAlignStart_i;
reg [7:0] slipcnt = 8'h0; 
reg [3:0] bitcnt = 4'h0;

parameter st0 = 5'b0_0001;
parameter st1 = 5'b0_0010;
parameter st2 = 5'b0_0100;
parameter st3 = 5'b0_1000;
parameter st4 = 5'b1_0000;

reg [4:0] st = st0;

(* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="5'b0_0001" *) 

assign WordAlignStart_i = WordAlignStart;

always @(posedge bitclkdiv)
if(reset)
begin
bitslip <=  1'b0;
slipcnt <= 8'h0;
bitcnt <= 4'h0;
st <=  st0;
end
else case(st)
st0 : 
begin
bitslip <= 1'b0;
slipcnt <= 8'h0;
bitcnt <= 4'h0;

if(WordAlignStart_i)
st <= st1;
else
st <= st0;
end

st1 : begin
bitslip <= 1'b0;
slipcnt <= slipcnt;
bitcnt <= bitcnt + 4'd1;

if(dtc_deser_dout == 16'hbc50)
	begin
	if(bitcnt == 4'd12)
	st <= st0;
	else
	st <= st1;
	end
else
	st <= st2;
end

st2 : begin
bitslip <= 1'b1;
slipcnt <= slipcnt + 8'd1;

bitcnt <= 4'd0;

st <= st3;
end

st3 : begin
bitslip <= 1'b0;
slipcnt <= slipcnt;
bitcnt <= bitcnt + 4'd1;

if(bitcnt == 4'd8)
st <= st4;
else
st <= st3;
end

st4 : begin
bitslip <= 1'b0;
slipcnt <= slipcnt;
bitcnt <= 4'd0;

if(slipcnt == 8'd250)
st <= st0;
else
st <= st1;
end

default: begin
bitslip <=  1'b0;
slipcnt <= 8'h0;
bitcnt <= 4'd0;

st <= st0;
end
endcase

reg [16:0] detcnt = 16'h0;
reg [4:0] Est = st0;

always @(posedge bitclkdiv)
if(reset)
begin
errcnt <= 16'h0;
detcnt <= 16'h0;
Est <= st0;
end else case(Est)
st0 : begin
errcnt <= errcnt;
detcnt <= 16'h0;

if(errtest)
Est <= st1;
else
Est <= st0;
end

st1 : begin
errcnt <= 16'h0;
detcnt <= 16'h0;

Est <= st2;
end

st2 : begin
detcnt <= detcnt + 16'h1;

if(detcnt == 16'd50000)
Est <= st0;
else 
Est <= st2;

if(dtc_deser_dout == 16'hbc50)
errcnt <= errcnt;
else
errcnt <= errcnt + 16'd1;
end

default: begin
errcnt <= 16'h0;
detcnt <= 16'h0;
Est <= st0;
end
endcase


  dtc_deser_f u_dtc_deser_f
   (
  // From the system into the device
    .DATA_IN_FROM_PINS_P({dtc_return_p, dtc_data_p}),
    .DATA_IN_FROM_PINS_N({dtc_return_n, dtc_data_n}),
    .DATA_IN_TO_DEVICE(dtc_deser_dout),

    .BITSLIP(bitslip),       // Bitslip module is enabled in NETWORKING mode
 
    .CLK_IN(bitclk),        // Fast clock input from PLL/MMCM
    .CLK_DIV_IN(bitclkdiv),    // Slow clock input from PLL/MMCM
    .CLK_RESET(reset),
    .IO_RESET(reset)
);

endmodule

