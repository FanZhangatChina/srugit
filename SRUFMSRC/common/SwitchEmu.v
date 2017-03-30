`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    SwitchEmu 
// Designer: Fan.Zhang (zhangfan@mail.hbut.edu.cn)
// Function: Emulate the output of a switch, provide a pulse with a high duty of 24-bit @ clk
//////////////////////////////////////////////////////////////////////////////////
module SwitchEmu(
	input 	clk,
	input		pulse_in,
	output	pulse_out
    );

reg pulse_out_i = 1'b0;
reg [23:0] cnt_i = 24'h0;
assign pulse_out = pulse_out_i;
parameter Idle_st = 3'b001;
parameter Start_st = 3'b010;
parameter SwitchOn_st = 3'b100;
reg [2:0] st = Idle_st;
	 
always @(posedge clk)
case(st)
Idle_st : begin
cnt_i <= 24'h0;
pulse_out_i <= 1'b0;
if(pulse_in)
st <= Start_st;
else
st <= Idle_st;
end

Start_st : begin
cnt_i <= 24'h0;
pulse_out_i <= 1'b0;
if(pulse_in)
st <= Start_st;
else
st <= SwitchOn_st;
end

SwitchOn_st : begin
cnt_i <= cnt_i + 24'h1;
pulse_out_i <= 1'b1;
if(cnt_i[23])
//if(cnt_i[8])  //For simulation
st <= Idle_st;
else
st <= SwitchOn_st;
end

default : begin
cnt_i <= 24'h0;
pulse_out_i <= 1'b0;
st <= Idle_st;
end
endcase

endmodule
