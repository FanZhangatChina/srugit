`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:17 11/04/2008 
// Design Name: 
// Module Name:    dac_driver_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dac_driver_module(reset, clk, hv_start, dac_dout, ram_data_out, dac_sel, dac_sclk, dac_din, dac_err_reg, f_cnt, dac_end);
    input reset;
    input clk;
	 input hv_start;
    input dac_dout;
    input [9:0] ram_data_out;
    output dac_sel;
    output dac_sclk;
    output dac_din;
    output [7:0] dac_err_reg;
    output [2:0] f_cnt;
	 output dac_end;
	 
    wire reset;
    wire clk;
	 wire hv_start;
    wire dac_dout;
    wire [9:0] ram_data_out;
    reg dac_sel= 1'b1;
    wire dac_sclk;
    wire dac_din;
    wire [7:0] dac_err_reg;
    wire [2:0] f_cnt;
	 
	 //internal variables
	 wire [3:0] ctr_word;
	 
	 wire dac_cs_t;
	 wire dac_end;
	 
	 reg dac_sset;
	 reg dac_sload;
	 wire dac_sclr;
	 
	 wire dac_sclk_p;
	 wire dac_sclk_n;
	 reg [1:0] clk_cnt;
	 
	 wire [3:0] svalue_h;
	 wire [15:0] svalue;
	 assign svalue = {svalue_h,ram_data_out,2'b00};
	 
	 wire dac_err;
	 
	wire dac_set_t;
	assign dac_set_t = ctr_word[3]; 
	assign dac_cs_t = ctr_word[2];
	 assign dac_sclr = ctr_word[1];
	 assign dac_end = ctr_word[0];
	 
	 always @(negedge reset or posedge clk)
	 begin
	 if(~reset)
	 clk_cnt <= 2'b00;
	 else
	 clk_cnt <= clk_cnt + 2'b01;
	 end

	 assign dac_sclk_p = clk_cnt[1];
	 assign dac_sclk_n = ~dac_sclk_p;
	 assign dac_sclk = dac_sel ? 1'b1 : dac_sclk_p;
	 
	 always @(negedge reset or posedge dac_sclk_p)
	 begin
	 if(~reset)
	 begin
	 dac_sel <= 1'b1;
	 end
	 else
	 begin
	 dac_sel <= dac_cs_t;
	 end
	 end
	 
	 always @(negedge reset or posedge dac_sclk_n)
	 begin
	 if(~reset)
	 begin
	 dac_sload <= 1'b0;
	 dac_sset <= 1'b0;
	 end
	 else
	 begin
	 dac_sload <= dac_sclr;
	 dac_sset <= dac_set_t;
	 end
	 end

	 dac_data_coding U1(.reset(reset), .reg_addr(f_cnt), .clk(clk), .data_out(svalue_h));
	 L_shiftreg_out_16 U2(.reset(reset), .clk(dac_sclk_p), .sset(dac_sset), .sload(dac_sload), .svalue(svalue), .shiftout(dac_din));
	 hv_dac_fsm U3(.ctr_word(ctr_word),.dac_err_reg(dac_err_reg),.f_cnt(f_cnt),.CLK(dac_sclk_p),.dac_err(dac_err),.hv_start(hv_start),.reset(reset));
	 error_detect U4(.reset(reset), .dac_din(dac_din), .dac_dout(dac_dout), .enable(~dac_sel), .sclr(dac_sclr), .clk(dac_sclk_n), .error(dac_err));


endmodule
