//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : dtc_cmd
//* File            : dtc_cmd.v
//* Description     : Multiplexed FPGA commands and ALTRO commands to DTC commands.
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*   18-01-2013 : Initial release
//*	  06-03-2013 : Add fpga_cmd_ack, acmd_ack, optimize FSM
//*******************************************************************************
module dtc_cmd(
input rdoclk,

//dtc_rx
input dtc_cmd_rnw,
input dtc_cmd_exec,//last 100ns
input dtc_cmd_feenal, //0: fpga, 1:altro
input [19:0] dtc_cmd_data,
input [19:0] dtc_cmd_addr,
output dtc_cmd_ack,

//memory interface
output wire dtc_fpga_cmd_exec,
output wire dtc_fpga_cmd_rnw,
output wire [7:0] dtc_fpga_cmd_addr,
output wire [15:0] dtc_fpga_cmd_wdata,
input [15:0] 	 dtc_fpga_cmd_rdata,
input			 fpga_cmd_ack,

//read/write
output wire 	   acmd_exec,
output wire 	   acmd_rw,
output wire [19:0] acmd_addr,
output wire [19:0] acmd_rx,
input 		[19:0] acmd_tx,
input					 acmd_ack,

//dtc_tx
input 				frame_st,
output reg [31:0]   reply_addr = 32'h0,
output reg [31:0]   reply_data = 32'h0,
output reg 			reply_rdy = 1'b0,

input 				reset
);

assign dtc_fpga_cmd_exec = dtc_cmd_exec & (!dtc_cmd_feenal);
assign dtc_fpga_cmd_rnw = dtc_cmd_rnw;
assign dtc_fpga_cmd_addr = dtc_cmd_addr[7:0];
assign dtc_fpga_cmd_wdata = dtc_cmd_data[15:0];

assign acmd_exec = dtc_cmd_exec & dtc_cmd_feenal;
assign acmd_rw = dtc_cmd_rnw;
assign acmd_addr = dtc_cmd_addr[19:0];
assign acmd_rx = dtc_cmd_data[19:0];

assign dtc_cmd_ack = fpga_cmd_ack | acmd_ack;

always @(posedge rdoclk)
if(reset)
	reply_addr <= 32'h0;
else if(dtc_cmd_exec)
	reply_addr <= {1'b1,dtc_cmd_feenal,10'h0,dtc_cmd_addr};
else
	reply_addr <= reply_addr;
	
always @(posedge rdoclk)
if(reset)
	reply_data <= 32'h0;
else if(dtc_cmd_feenal)
	reply_data <= {10'h0,acmd_tx};
	else
	reply_data <= {16'h0,dtc_fpga_cmd_rdata};

parameter st0 = 0; parameter st1 = 1;
parameter st2 = 2; parameter st3 = 3; 

reg [1:0] st = st0;
always @(posedge rdoclk)
if(reset)
begin
//clkcnt <= 6'h0;
reply_rdy <= 1'b0;
st <= st0;
end
	else
case(st)
st0 : begin
//clkcnt <= 6'h0;
reply_rdy <= 1'b0;

if(dtc_cmd_ack)
st <= st1;
else 
st <= st0;
end 

st1 : begin
//clkcnt <= 6'h0;
reply_rdy <= 1'b0;
	
if(dtc_cmd_rnw)
st <= st2;
else
st <= st0;
end

st2 : begin
//	clkcnt <= 6'h0;
	reply_rdy <= 1'b0;
	
	if(frame_st)
	st <= st2;
	else
	st <= st3;
end

st3 : begin
//	clkcnt <= 6'h0;
	reply_rdy <= 1'b1;
	
	if(frame_st)
	st <= st3;
	else
	st <= st0;
end

default : begin
//clkcnt <= 6'h0;
reply_rdy <= 1'b0;
st <= st0;
end
endcase

endmodule
