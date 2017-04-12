`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:55 10/17/2008 
// Design Name: 
// Module Name:    error_detect 
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
module error_detect(reset, dac_din, dac_dout, enable, sclr, clk, error);
    input reset;
    input dac_din;
    input dac_dout;
    input enable;
    input sclr;
    input clk;
    output error;

    wire reset;
    wire dac_din;
    wire dac_dout;
    wire enable;
    wire sclr;
    wire clk;
    reg error;

	 wire [1:0] ctr_line;
	 assign ctr_line = {sclr,enable};
	 
	 always @(negedge reset or posedge clk)
	 begin
		 if(~reset)
			 error <= 1'b0;
		 else
			 begin
			 case(ctr_line)
			 2'b00 : error <= error || 1'b0;
			 2'b01 : error <= error || (dac_din ^ dac_dout);
			 2'b10 : error <= 1'b0;
			 2'b11 : error <= 1'b0;
			 default : error <= 1'b0;
			 endcase
			 end
	 end

endmodule
