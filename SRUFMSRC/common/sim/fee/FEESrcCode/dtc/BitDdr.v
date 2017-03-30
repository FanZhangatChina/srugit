`timescale 1ns / 1ps

module BitDdr(
		input reset,

		input clkin,
		input din_p,
		input din_n,
		output dout
    );
	 
reg reset_i = 1'b0;
reg pflag = 1'b0;
reg nflag = 1'b0;
reg din_p_reg = 1'b0;
reg din_n_reg_i = 1'b0;
reg din_n_reg = 1'b0;
wire dout_p, dout_n;

always @(posedge clkin)
reset_i <= reset;

always @(posedge clkin)
if(reset_i)
begin
din_p_reg <= din_p;
din_n_reg_i <= 1'b0;
pflag <= 1'b0;
end else
begin
din_p_reg <= din_p;
din_n_reg_i <= din_n;
pflag <= ~pflag;
end

always @(negedge clkin)
if(reset_i)
begin
din_n_reg <= 1'b0;
nflag <= 1'b0;
end else
begin
din_n_reg <= din_n_reg_i;
nflag <= ~nflag;
end



assign dout_p = din_p_reg & (~(pflag ^ nflag));
assign dout_n = din_n_reg & ((pflag ^ nflag));

assign dout = dout_p | dout_n;

endmodule
