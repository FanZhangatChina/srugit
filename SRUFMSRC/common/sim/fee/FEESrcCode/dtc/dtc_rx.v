//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : dtc_rx
//* File            : dtc_rx.v
//* Description     : Multiplexed FPGA commands and ALTRO commands to DTC commands.
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*   18-01-2013 : Initial release
//*	  06-03-2013 : Add dtc command hand-shaking protocol
//*	  Modify the decoding of L0,L1 (posedge) and commands (negedge).
//*	  02-22-04-2013 : DtcCmdRst
//*******************************************************************************
`timescale 1ns / 1ps
module dtc_rx(
input clkin,
input dtc_trig,

output reg dtc_cmd_rnw = 1'b0,
output reg dtc_cmd_exec = 1'b0,//last 250ns
output reg dtc_cmd_feenal = 1'b0,
output reg [19:0] dtc_cmd_data = 20'h0,
output reg [19:0] dtc_cmd_addr = 20'h0,
input 	  dtc_cmd_ack,

output 	  trig_l0n,
output     trig_l1n,
output reg altrordo_cmd = 1'b0,
output reg altroabort_cmd = 1'b0,
output reg sampclksync_cmd = 1'b0,
output reg DtcCmdRst = 1'b0,
output reg DtcStReq = 1'b0,

output reg test_mode = 1'b0,

input reset
);

parameter rwcmd_code = 16'h00E1;
parameter altrordo_code = 16'h00E2;
parameter abort_code = 16'h00EA;
parameter sampclksycn_code = 16'h00E4;
parameter Rst_code = 16'h00E8;
parameter StReq = 16'h00E9;
parameter TestModeOn = 16'h00E6;
parameter TestModeOff = 16'h00E7;

reg [7:0] clkcnt = 8'h0;
wire clkin_n;
assign clkin_n = ~clkin;

parameter shift = 80;   
reg [shift-1:0] sdc_din_reg = 80'h0;   
always @(posedge clkin_n)
sdc_din_reg  <= {sdc_din_reg[shift-2:0], dtc_trig}; 

  
parameter st0 = 0;  parameter st_rdo_1=1;
parameter st_abort_1 = 2; parameter st_sampsync_1 = 3;
parameter stcmd1 = 4; parameter stcmd2 = 5;
parameter stcmd3 = 6; parameter st_rst_1 = 7;
parameter ErrReq_s = 4'h8; parameter TestModeOn_s = 4'h9;
parameter TestModeOff_s = 4'd10;
reg [3:0] st = 0;

always @(posedge clkin_n)
case(st)
st0:begin
clkcnt <= 8'h0;

dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b0;

case(sdc_din_reg[15:0])
rwcmd_code : st <= stcmd1;
altrordo_code : st <= st_rdo_1;//
abort_code : st <= st_abort_1;//
sampclksycn_code : st <= st_sampsync_1;//
Rst_code : st <= st_rst_1;//
StReq : st <= ErrReq_s;//
TestModeOn : st <= TestModeOn_s;//
TestModeOff : st <= TestModeOff_s;//

default: st <= st0;
endcase
end

st_rdo_1: begin
clkcnt <= clkcnt + 8'h1;//
dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b1;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b0;

if(clkcnt==8'd11)
st <= st0;
else
st <= st_rdo_1;
end

st_abort_1: begin
clkcnt <= clkcnt + 8'h1;//
dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b1;
sampclksync_cmd <= 1'b0;

if(clkcnt==8'd19)
st <= st0;
else
st <= st_abort_1;
end

st_sampsync_1: begin
clkcnt <= clkcnt + 8'h1;//
dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b1;

if(clkcnt==8'd11)
st <= st0;
else
st <= st_sampsync_1;
end

st_rst_1: begin
clkcnt <= clkcnt + 8'h1;//
dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b1;

if(clkcnt==8'd11)
st <= st0;
else
st <= st_rst_1;
end

ErrReq_s: begin
clkcnt <= clkcnt + 8'h1;//
dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b1;

if(clkcnt==8'd11)
st <= st0;
else
st <= ErrReq_s;
end

stcmd1 : begin
clkcnt <= clkcnt + 8'h1;

dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b0;

if(clkcnt==8'd62)
//if(clkcnt==8'd63)
st <= stcmd2;
else
st <= stcmd1;
end

stcmd2 : begin
clkcnt <= 8'd0;

dtc_cmd_rnw <= sdc_din_reg[63];
dtc_cmd_feenal <= sdc_din_reg[62];
dtc_cmd_exec <= 1'b1;
dtc_cmd_addr <= sdc_din_reg[51:32];
dtc_cmd_data <= sdc_din_reg[19:0];

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b0;

st <= stcmd3;
end

stcmd3 : begin
clkcnt <= clkcnt + 8'h1;

dtc_cmd_rnw <= dtc_cmd_rnw;
dtc_cmd_feenal <= dtc_cmd_feenal;
dtc_cmd_exec <= 1'b1;
dtc_cmd_addr <= dtc_cmd_addr;
dtc_cmd_data <= dtc_cmd_data;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b0;

if(dtc_cmd_ack)
st <= st0;
else if(clkcnt == 8'd255)
st <= st0;
else
st <= stcmd3;
end

default : begin
clkcnt <= 8'h0;//

dtc_cmd_rnw <= 1'b0;
dtc_cmd_feenal <= 1'b0;
dtc_cmd_exec <= 1'b0;
dtc_cmd_addr <= 20'b0;
dtc_cmd_data <= 20'b0;

altrordo_cmd <= 1'b0;
altroabort_cmd <= 1'b0;
sampclksync_cmd <= 1'b0;

st <= st0;
end
endcase

dtcTrigDecode u_dtcTrigDecode (
    .clkin(clkin), 
    .dtc_trig(dtc_trig), 
    .trig_l0n(trig_l0n), 
    .trig_l1n(trig_l1n), 
    .reset(reset)
    );


always @(posedge clkin_n)
if(st == st_rst_1)
DtcCmdRst <= 1'b1;
else
DtcCmdRst <= 1'b0;

always @(posedge clkin_n)
if(st == ErrReq_s)
DtcStReq <= 1'b1;
else
DtcStReq <= 1'b0;

always @(posedge clkin_n)
if(reset)
test_mode <= 1'b0;
else if(st == TestModeOn_s)
test_mode <= 1'b1;
else if(st == TestModeOff_s)
test_mode <= 1'b0;
else
test_mode <= test_mode;

endmodule
