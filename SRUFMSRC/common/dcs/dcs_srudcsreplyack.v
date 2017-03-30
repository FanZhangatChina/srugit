`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module srudcsreplyack(
		input 				reset,
		input 				dcsclk,
		
		input 				rcmd_reply_dv,
		input [31:0] 		udp_cmd_addr,
		input [31:0] 		rcmd_reply_data,
		
		output reg 			dcs_cmd_update = 1'b0,
		output reg [63:0] dcs_cmd_reply = 64'h0
    );

parameter st0 = 0; parameter st1 = 1; 
parameter st2 = 2; parameter st3 = 3; 
reg [1:0] st = st0;

always @(posedge dcsclk)
if(reset)
begin
dcs_cmd_update <= 1'b0;
dcs_cmd_reply <= 64'h0;
st <= st0;
end else case(st)
st0 : begin
dcs_cmd_update <= 1'b0;
dcs_cmd_reply <= dcs_cmd_reply;

if(rcmd_reply_dv)
st <= st1;
else
st <= st0;
end

st1 : begin
dcs_cmd_update <= 1'b0;
dcs_cmd_reply <= {udp_cmd_addr,rcmd_reply_data};

st <= st2;
end

st2 : begin
dcs_cmd_update <= 1'b1;
dcs_cmd_reply <= dcs_cmd_reply;

st <= st3;
end

st3 : begin
dcs_cmd_update <= 1'b0;
dcs_cmd_reply <= dcs_cmd_reply;

if(rcmd_reply_dv)
st <= st3;
else
st <= st0;
end

default : begin
dcs_cmd_update <= 1'b0;
dcs_cmd_reply <= 64'h0;

st <= st0;
end
endcase
//-------------------------------------------------------

endmodule
