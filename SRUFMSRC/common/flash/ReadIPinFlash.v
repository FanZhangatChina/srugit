`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module ReadIPinFlash(
    input clk, //100MHz
    input rstn,
	 
	 output reg [31:0] local_ip = 32'h0aa08479,
	 
	 //Global SC interface
    input [15:0] sc_port,
    input [31:0] sc_data,
    input [31:0] sc_addr,
    input [31:0] sc_subaddr,
    input sc_op,
    input sc_frame,
    input sc_wr,
    output sc_ack,
    output [31:0] sc_rply_data,
    output [31:0] sc_rply_error, 
	 
	 //Flash SC interface
    output [15:0] flash_sc_port,
    output [31:0] flash_sc_data,
    output [31:0] flash_sc_addr,
    output [31:0] flash_sc_subaddr,
    output flash_sc_op,
    output flash_sc_frame,
    output flash_sc_wr,
    input flash_sc_ack,
    input [31:0] flash_sc_rply_data,
    input [31:0] flash_sc_rply_error
    );
	 

   // wire [15:0] ip_sc_port;
    wire [31:0] ip_sc_data;
    reg [31:0] ip_sc_addr = 32'h00FFC000;
    wire [31:0] ip_sc_subaddr;
    reg ip_sc_op = 1'b0;
    reg ip_sc_frame = 1'b0;
    wire ip_sc_wr;
    wire ip_sc_ack;
    wire [31:0] ip_sc_rply_data;
    wire [31:0] ip_sc_rply_error;
	 
	 reg ip_sc_en = 1'b0;
	 reg [26:0] ip_sc_cnt = 27'h0; //ca. 1.5s 
	 reg [31:0] local_ip_i = 32'h0;
	 
	 assign ip_sc_subaddr = 32'h000000ff;
	 assign ip_sc_wr = 1'b0;
	 //assign ip_sc_data = 32'h0;
	 
	 assign flash_sc_port = ip_sc_en ? 16'h2777 : sc_port;
	 assign flash_sc_data = sc_data;
	 assign flash_sc_addr = ip_sc_en ? ip_sc_addr : sc_addr;////FFC000(low),//FFC001(high)
	 assign flash_sc_subaddr = ip_sc_en ? ip_sc_subaddr : sc_subaddr;
	 
	 assign flash_sc_op = ip_sc_en ? ip_sc_op : sc_op;
	 assign flash_sc_frame = ip_sc_en ? ip_sc_frame : sc_frame;
	 assign flash_sc_wr = ip_sc_en ? ip_sc_wr : sc_wr;
	 
	 assign sc_ack = flash_sc_ack;
	 assign sc_rply_data = flash_sc_rply_data;
	 assign sc_rply_error = flash_sc_rply_error;
	 
	 assign ip_sc_ack = flash_sc_ack;
	 assign ip_sc_rply_data = flash_sc_rply_data;
	 assign ip_sc_rply_error = flash_sc_rply_error;

//FFC000
//FFC001
parameter st0 = 0;
parameter st1 = 1;
parameter st2 = 2;
parameter st3 = 3;
parameter st4 = 4;
parameter st5 = 5;
parameter st6 = 6;
parameter st7 = 7;
parameter st8 = 8;

reg [3:0] st = st0;

wire reset; 
assign reset = ~rstn;

always @(posedge reset or posedge clk)
if(reset)
begin
ip_sc_en <= 1'b0;
ip_sc_cnt <= 27'h0;

ip_sc_addr <= 32'h00FFC000;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= 32'h0;
local_ip <= 32'h0aa08479;

st <= st0;
end else case(st)
st0 : begin
ip_sc_en <= 1'b0;
ip_sc_cnt <= 27'h0;

ip_sc_addr <= 32'h00FFC000;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= 32'h0;
local_ip <= local_ip;

st <= st1;
end

st1 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= ip_sc_cnt + 27'h1;

ip_sc_addr <= 32'h00FFC000;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= 32'h0;
local_ip <= local_ip;

if(ip_sc_cnt[26])
st <= st2;
else
st <= st1;
end

st2 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= 27'h0;

ip_sc_addr <= 32'h00FFC000;
ip_sc_op <= 1'b1;
ip_sc_frame <= 1'b1;

local_ip_i <= 32'h0;
local_ip <= local_ip;

if(ip_sc_ack)
st <= st3;
else
st <= st2;
end

st3 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= 27'h0;

ip_sc_addr <= 32'h00FFC000;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= ip_sc_rply_data;
local_ip <= local_ip;

if(ip_sc_ack)
st <= st3;
else
st <= st4;
end

st4 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= ip_sc_cnt + 27'd1;

ip_sc_addr <= 32'h00FFC001;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= local_ip_i;
local_ip <= local_ip;

if(ip_sc_cnt == 27'd16)
st <= st5;
else
st <= st4;
end

st5 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= 27'h0;

ip_sc_addr <= 32'h00FFC001;
ip_sc_op <= 1'b1;
ip_sc_frame <= 1'b1;

local_ip_i <= local_ip_i;
local_ip <= local_ip;

if(ip_sc_ack)
st <= st6;
else
st <= st5;
end

st6 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= 27'h0;

ip_sc_addr <= 32'h00FFC001;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= {ip_sc_rply_data[15:0],local_ip_i[15:0]};
local_ip <= local_ip;

if(ip_sc_ack)
st <= st6;
else
st <= st7;
end

st7 : begin
ip_sc_en <= 1'b1;
ip_sc_cnt <= ip_sc_cnt + 27'd1;

ip_sc_addr <= 32'h00FFC001;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= local_ip_i;
local_ip <= local_ip_i;

if(ip_sc_cnt == 27'd16)
st <= st8;
else
st <= st7;
end

st8 : begin
ip_sc_en <= 1'b0;
ip_sc_cnt <= 27'd0;

ip_sc_addr <= 32'h00FFC001;
ip_sc_op <= 1'b0;
ip_sc_frame <= 1'b0;

local_ip_i <= local_ip_i;
local_ip <= local_ip;

st <= st8;
end
endcase

endmodule
