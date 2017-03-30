`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module fee_40dtc_top

#(
parameter LGSEN_Init = 1'b1,
parameter FEEFMVer = 16'h5043
)
(
		 input 	[39:0] dtc_clk_p,//output
		 input 	[39:0] dtc_clk_n,//output
		 input 	[39:0] dtc_trig_p,//output
		 input 	[39:0] dtc_trig_n,//output
		 output  [39:0] dtc_data_p,
		 output  [39:0] dtc_data_n,
		 output  [39:0] dtc_return_p,
		 output  [39:0] dtc_return_n
    );
	 
wire [39:0] trig_l0n;
wire [39:0] trig_l1n;
parameter fee_flag = 40'h0;

wire rdoclk;
reg reset;

	  genvar k;
	  generate
     for (k=0; k < 40; k=k+1) 
	  begin: fee_40dtc
		dtc_slave_top 
		#(.LGSEN_Init(LGSEN_Init),
		.FEEFMVer(FEEFMVer)
		)
		u_dtc_slave_top (
		.rdoclk(rdoclk), 
		
		// dtc phy 
		.dtc_clk(dtc_clk_p[k]),  
		.dtc_trig(dtc_trig_p[k]),
		.dtc_data(dtc_data_p[k]), 
		.dtc_return(dtc_return_p[k]),
		
		//dtc trig
		.trig_l0n(trig_l0n[k]),
		.trig_l1n(trig_l1n[k]),
		.fee_flag(fee_flag[k]),
		
		.reset(reset)
	 );
	 assign dtc_data_n[k] = ~dtc_data_p[k];
	 assign dtc_return_n[k] = ~dtc_return_p[k];
	 end
	 endgenerate

//   initial begin
//      rdoclk = 1'b1;
//      #12.5;
//		#6.25;
//      forever
//         #12.5 rdoclk = ~rdoclk;
//   end
reg rdoclk_i;
always @(dtc_clk_p)	
#6.25 rdoclk_i <= dtc_clk_p;

initial begin
reset = 1'b1;
#500 reset = 1'b0;
end

assign rdoclk = ~ rdoclk_i;
endmodule
