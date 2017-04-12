`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:32:28 11/03/2008 
// Design Name: 
// Module Name:    hv_top_module 
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
module hv_top_module(
input wire reset,
input wire clk,
input wire hv_update,

output wire dac_sclk,
output wire dac_ldac,
output wire [3:0] dac_sel,
output wire [3:0] dac_din,
input  wire [3:0] dac_dout,

output wire dac_end1,
output wire [7:0] dac_err_reg0,
output wire [7:0] dac_err_reg1,
output wire [7:0] dac_err_reg2,
output wire [7:0] dac_err_reg3,
	
input wire [9:0] ram_data_out0,
input wire [9:0] ram_data_out1,
input wire [9:0] ram_data_out2,
input wire [9:0] ram_data_out3,	 
output wire [2:0] f_cnt
);		 
	
wire dac_end2, dac_end3, dac_end4;

assign dac_ldac = dac_end1 || dac_end2 || dac_end3 || dac_end4;

dac_driver_module DAC0(.reset(reset), .clk(clk), .hv_start(hv_update), .dac_dout(dac_dout[0]), .ram_data_out(ram_data_out0), 
.dac_sel(dac_sel[0]), .dac_sclk(dac_sclk), .dac_din(dac_din[0]), .dac_err_reg(dac_err_reg0), .f_cnt(f_cnt), .dac_end(dac_end1));

dac_driver_module DAC1(.reset(reset), .clk(clk), .hv_start(hv_update), .dac_dout(dac_dout[1]), .ram_data_out(ram_data_out1), 
.dac_sel(dac_sel[1]), .dac_sclk(), .dac_din(dac_din[1]), .dac_err_reg(dac_err_reg1), .f_cnt(), .dac_end(dac_end2));

dac_driver_module DAC2(.reset(reset), .clk(clk), .hv_start(hv_update), .dac_dout(dac_dout[2]), .ram_data_out(ram_data_out2), 
.dac_sel(dac_sel[2]), .dac_sclk(), .dac_din(dac_din[2]), .dac_err_reg(dac_err_reg2), .f_cnt(), .dac_end(dac_end3));

dac_driver_module DAC3(.reset(reset), .clk(clk), .hv_start(hv_update), .dac_dout(dac_dout[3]), .ram_data_out(ram_data_out3), 
.dac_sel(dac_sel[3]), .dac_sclk(), .dac_din(dac_din[3]), .dac_err_reg(dac_err_reg3), .f_cnt(), .dac_end(dac_end4));

endmodule
