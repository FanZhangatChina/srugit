`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:32 10/17/2008 
// Design Name: 
// Module Name:    shiftreg_in 
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
module L_shiftreg_out_16(reset, clk, sset, sload, svalue, shiftout);
    input reset;
    input clk;
    input sset;
    input sload;
    input [15:0] svalue;
    output shiftout;

    wire reset;
    wire clk;
    wire sset;
    wire sload;
    wire [15:0] svalue;
    wire shiftout;
	 
	 
	 wire [1:0] cfg;
	 assign cfg = {sset,sload};

	reg [15:0] q ;
	 
	 assign shiftout = q[15];
	 
	 always @(negedge reset or posedge clk)
	 begin
	 if(~reset)
	 q = 16'h0;
	 else 
	 case(cfg)
	 2'b00 : q = q << 1;
	 2'b01 : q = svalue;
	 2'b10, 2'b11 : q = 16'hffff;
	 default : q = 16'hffff;
	 endcase
	 end
	 

endmodule
