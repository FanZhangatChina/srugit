`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:34 10/17/2008 
// Design Name: 
// Module Name:    data_coding 
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
module dac_data_coding(reset, reg_addr, clk, data_out);
    input reset;
    input [2:0] reg_addr;
    input clk;
    //input [9:0] data_in;
    output [3:0] data_out;

    wire reset;
    wire [2:0] reg_addr;
    wire clk;
    //wire [9:0] data_in;
    reg [3:0] data_out;

	 always @(negedge reset or posedge clk)
	 begin
	 if(~reset)
	 data_out <= 4'h0;
	 else
	 case(reg_addr)
	 3'h0 : data_out <= 4'b0010;
	 3'h1 : data_out <= 4'b0011;
	 3'h2 : data_out <= 4'b0100;
	 3'h3 : data_out <= 4'b0101;
	 3'h4 : data_out <= 4'b0110;
	 3'h5 : data_out <= 4'b0111;
	 3'h6 : data_out <= 4'b1000;
	 3'h7 : data_out <= 4'b1001;
	 endcase
	 end

endmodule
