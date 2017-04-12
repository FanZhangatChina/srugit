`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:38:24 04/08/2017
// Design Name:   dac_ctrl_fsm
// Module Name:   Y:/Desktop/SRUFM2016091502/SRUFM2016091502/SRUFM2016090301_PHOS/New folder/dcs_ctrl_fsm_tb.v
// Project Name:  SRUFM2016090301_PHOS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dac_ctrl_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dcs_ctrl_fsm_tb;

	// Inputs
	reg reset;
	reg clkin;
	reg clkin2;
	reg hv_update;
	reg [319:0] hv_reg_din;
	reg [3:0] dac_dout;

	// Outputs
	wire [3:0] dac_sclk;
	wire [3:0] dac_din;
	wire [3:0] dac_cs;
	wire dac_load;

	// Instantiate the Unit Under Test (UUT)
	dac_ctrl_fsm uut (
		.reset(reset), 
		.clkin(clkin), 
		.hv_update(hv_update), 
		.hv_reg_din(hv_reg_din), 
		.dac_dout(dac_dout), 
		.dac_sclk(dac_sclk), 
		.dac_din(dac_din), 
		.dac_cs(dac_cs), 
		.dac_load(dac_load)
	);


hv_top_module instance_name (
    .reset(reset), 
    .clk(clkin2), 
    .hv_update(hv_update), 
    .dac_sclk(), 
    .dac_ldac(), 
    .dac_sel(), 
    .dac_din(), 
    .dac_dout(1'b0), 
    .dac_end1(), 
    .dac_err_reg0(), 
    .dac_err_reg1(), 
    .dac_err_reg2(), 
    .dac_err_reg3(), 
    .ram_data_out0(10'hff), 
    .ram_data_out1(10'h1ff), 
    .ram_data_out2(10'h2ff), 
    .ram_data_out3(10'h3ff), 
    .f_cnt()
    );

	initial begin
		// Initialize Inputs
		reset = 0;
		hv_update = 0;
		hv_reg_din = 0;
		dac_dout = 0;

		// Wait 100 ns for global reset to finish
		#1000;
		reset = 1;
		#5000 hv_update = 1'b1;
		#5000 hv_update = 1'b0;
		hv_reg_din = {10'd32,10'd31,10'd30,10'd29,10'd28,10'd27,10'd26,10'd25,10'd24,10'd23,10'd22,10'd21,10'd20,
		10'd19,10'd18,10'd17,10'd16,10'd15,10'd14,10'd13,10'd12,10'd11,10'd10,10'd9,10'd8,10'd7,10'd6,10'd5,
		10'd4,10'd3,10'd2,10'd1};
        
		// Add stimulus here

	end
	
	always begin
	clkin = 1'b0;
	#500 clkin = 1'b1;
	#500;	
	end
	
	always begin
	clkin2 = 1'b0;
	#125 clkin2 = 1'b1;
	#125;	
	end
	
endmodule

