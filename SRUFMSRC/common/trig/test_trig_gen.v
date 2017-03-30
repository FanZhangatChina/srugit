`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module test_trig_gen (
input gclk_40m,

input trigger_select,
input htrig,
input strig_cmd,
input [3:0] strig_config,
input sptrig_en,
input [15:0] sptrig_period,
input [15:0] test_l0_latency,
input [15:0] test_l1_latency,
input [15:0] test_l2a_latency,

output reg test_l0 = 1'b0,
output reg test_l1 = 1'b0,
output reg test_l2a = 1'b0,
output reg test_trig = 1'b0,

input BusyFlag,
input reset
); 

parameter st0 = 0;
parameter st1 = 1;
parameter st2 = 2;
parameter st3 = 3;
parameter st4 = 4;
parameter st5 = 5;
parameter st6 = 6;
parameter st7 = 7;
parameter st5d = 8;

reg [3:0] st = st0;
reg [2:0] sta = st0;
reg [15:0] clkcnt = 16'd0;
reg [15:0] clkcnta = 16'd0;

reg l0_trig = 1'b0;

//l0_trig generation
	always @(posedge gclk_40m)
	if(reset)
	begin
	l0_trig <= 1'b0;
	clkcnta <= 16'd0;
	
	sta <= st0;
	end 
	else case(sta)
	st0 : 
	begin
	l0_trig <= 1'b0;
	clkcnta <= 16'd0;

	if(BusyFlag)
	sta <= st0;
	else if(htrig & trigger_select)
	sta <= st1;
	else if(strig_cmd & (!trigger_select))
	sta <= st1;
	else if(sptrig_en & (!trigger_select))
	sta <= st1;
	else
	sta <= st0;
	end
	
	st1 : 	begin
	l0_trig <= 1'b1;
	clkcnta <= 16'd0;
	
	sta <= st2;
	end 

	st2 : 	begin
	l0_trig <= 1'b0;
	clkcnta <= clkcnta + 16'd1;
	
	if(clkcnta == sptrig_period)
	sta <= st0;
	else
	sta <= st2;
	end 
	
	default: begin
	l0_trig <= 1'b0;
	clkcnta <= 16'd0;
	
	sta <= st0;	
	end
	endcase

//trigger sequence generation
	always @(posedge gclk_40m)
	if(reset)
	begin
	test_l0 <=  1'b0;
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  16'h0;
	
	st <= st0;
	end
	else case(st)
	st0 : 
	begin
	test_l0 <=  1'b0;
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  16'h0;
	
	if(l0_trig)
	st <=  st1;
	else
	st <=  st0;
	end
	
	//assert l0,set clk_cnt_set = 1;
	st1 : 
	begin
	if(strig_config[0])
	begin
	test_l0 <=  1'b1;
	test_trig <= 1'b1;
	end
	else
	begin
	test_l0 <=  1'b0;
	test_trig <= 1'b0;
	end
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	st <=  st2;
	end
	
	st2 : 
	begin
	test_l0 <=  1'b0;
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(clkcnt == test_l0_latency) 
	st <=  st3;
	else
	st <=  st2;
	end
	

	st3 : 
	begin
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(strig_config[1]) //
		begin
		test_l0 <=  1'b1;
		test_trig <= 1'b1;
		end
	else
		begin
		test_l0 <=  1'b0;
		test_trig <= 1'b0;
		end
	
	st <= st4;
	end
	
	st4 : 
	begin
	test_l0 <=  1'b0;
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(clkcnt == test_l1_latency) 
	st <=  st5;
	else
	st <=  st4;
	end
	//assert l1,set clk_cnt_set = 1;
	st5 : 
	begin
	test_l0 <= 1'b0;
	test_l2a <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(strig_config[2]) //
	begin
	test_l1 <=  1'b1;
	test_trig <= 1'b1;
	end
	else
	begin
	test_l1 <=  1'b0;
	test_trig <= 1'b0;
	end
	
	st <= st5d;
	end
//add one clock duration to l1 trigger	
	st5d : 
	begin
	test_l0 <= 1'b0;
	test_l2a <= 1'b0;
	test_l1 <=  1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(strig_config[2]) //
	begin	
	test_trig <= 1'b1;
	end
	else
	begin
	test_trig <= 1'b0;
	end
	
	st <= st6;
	end	
	
	
	st6 : 
	begin
	test_l0 <=  1'b0;
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(clkcnt == test_l2a_latency) 
	st <=  st7;
	else
	st <=  st6;
	end
	//assert l1,set clk_cnt_set = 1;
	st7 : 
	begin
	test_l0 <= 1'b0;
	test_l1 <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  clkcnt + 16'd1;
	
	if(strig_config[3]) //
	test_l2a <=  1'b1;
	else
	test_l2a <=  1'b0;
	
	st <= st0;
	end
	
	default: begin
	test_l0 <=  1'b0;
	test_l1 <= 1'b0;
	test_l2a <= 1'b0;
	test_trig <= 1'b0;
	clkcnt <=  16'h0;
	
	st <= st0;
	end	
	endcase

endmodule
