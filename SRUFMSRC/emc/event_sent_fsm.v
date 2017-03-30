`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module event_sent_fsm(
		input reset,
		input clk,
		input [1:0] ddl_event_send_i,
		input [1:0] ddl_xoff,
		output reg	ddl_event_send = 1'b0
    );


reg ddl_event_send_ii = 1'b0;

parameter IDLE_st = 5'b00001;
parameter Check_st = 5'b00010;
parameter AllSent_st = 5'b00100;
parameter LowSent_st = 5'b01000;
parameter HighSent_st = 5'b10000;
reg [4:0] st = IDLE_st;

always @(posedge clk)
if(reset)
begin
ddl_event_send_ii <= 1'b0;
st <= IDLE_st;
end else case(st)
IDLE_st : begin
ddl_event_send_ii <= 1'b0;
if(ddl_event_send_i == 2'b00)
st <= IDLE_st;
else
st <= Check_st;
end

Check_st : begin
ddl_event_send_ii <= 1'b0;
case(ddl_event_send_i)
2'b11 : st <= AllSent_st;
2'b01 : st <= LowSent_st;
2'b10 : st <= HighSent_st;
default: st <= IDLE_st;
endcase
end

AllSent_st : begin
ddl_event_send_ii <= 1'b1;

if(ddl_event_send_i == 2'b00)
st <= IDLE_st;
else
st <= AllSent_st;
end

LowSent_st : begin
ddl_event_send_ii <= 1'b0;
if(ddl_event_send_i[1])
st <= AllSent_st;
else
st <= LowSent_st;
end

HighSent_st : begin
ddl_event_send_ii <= 1'b0;
if(ddl_event_send_i[0])
st <= AllSent_st;
else
st <= HighSent_st;
end

default: begin
ddl_event_send_ii <= 1'b0;
st <= IDLE_st;
end
endcase

always @(posedge clk)
if(reset)
ddl_event_send <= 1'b0;
else case(ddl_xoff)
2'b00 : ddl_event_send <= ddl_event_send_ii;
2'b01 : ddl_event_send <= ddl_event_send_i[1];
2'b10 : ddl_event_send <= ddl_event_send_i[0];
default : ddl_event_send <= 1'b0;
endcase

endmodule
