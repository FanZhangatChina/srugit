
// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

`timescale 1ns / 1ps

module trig_cnt (
input gclk_40m,
input l0,
input l1,
input l2a,
input l2r,

input l1out_c,
input rdocmd_c,
input abortcmd_c,

input evcntres,
input bcntres,

input trigcnt_clr,

output reg l1out = 1'b0,
output reg rdocmd = 1'b0,
output reg abortcmd = 1'b0, //width: 12 clocks

output reg [31:0] l0_cnt = 32'h0,
output reg [31:0] l1_cnt = 32'h0,
output reg [31:0] l2a_cnt = 32'h0,
output reg [31:0] l2r_cnt = 32'h0,

output reg [31:0] l1out_cnt = 32'h0,
output reg [31:0] rdocmd_cnt = 32'h0,
output reg [31:0] abortcmd_cnt = 32'h0,

output reg [11:0] bunch_cnt = 12'h0,
output reg [23:0] event_cnt = 24'h0,

input reset
);

parameter st0 = 0;
parameter st1 = 1;

reg sta = st0, stb = st0, stc = st0;
reg [3:0] clkcnta = 4'b0, clkcntb = 4'b0, clkcntc = 4'b0; 

	always @(posedge gclk_40m)
	if(reset)
	begin
	l1out <= 1'b0;
	clkcnta <= 4'd0;
	sta <= st0;
	end else case(sta)
	st0 : begin
	l1out <= 1'b0;
	clkcnta <= 4'd0;
	if(l1out_c)
	sta <= st1;
	else
	sta <= st0;
	end
	
	st1 : begin
	l1out <= 1'b1;
	clkcnta <= clkcnta + 4'd1;
	if(clkcnta == 4'd12)
	sta <= st0;
	else
	sta <= st1;
	end	
	
	default:	
	begin
	l1out <= 1'b0;
	clkcnta <= 4'd0;
	sta <= st0;
	end 
	endcase
	
//rdocmd
	always @(posedge gclk_40m)
	if(reset)
	begin
	rdocmd <= 1'b0;
	clkcntb <= 4'd0;
	stb <= st0;
	end else case(stb)
	st0 : begin
	rdocmd <= 1'b0;
	clkcntb <= 4'd0;
	if(rdocmd_c)
	stb <= st1;
	else
	stb <= st0;
	end
	
	st1 : begin
	rdocmd <= 1'b1;
	clkcntb <= clkcntb + 4'd1;
	if(clkcntb == 4'd12)
	stb <= st0;
	else
	stb <= st1;
	end	
	
	default:	
	begin
	rdocmd <= 1'b0;
	clkcntb <= 4'd0;
	stb <= st0;
	end 
	endcase	
	
//abortcmd
	always @(posedge gclk_40m)
	if(reset)
	begin
	abortcmd <= 1'b0;
	clkcntc <= 4'd0;
	stc <= st0;
	end else case(stc)
	st0 : begin
	abortcmd <= 1'b0;
	clkcntc <= 4'd0;
	if(abortcmd_c)
	stc <= st1;
	else
	stc <= st0;
	end
	
	st1 : begin
	abortcmd <= 1'b1;
	clkcntc <= clkcntc + 4'd1;
	if(clkcntb == 4'd12)
	stc <= st0;
	else
	stc <= st1;
	end	
	
	default:	
	begin
	abortcmd <= 1'b0;
	clkcntc <= 4'd0;
	stc <= st0;
	end 
	endcase	

//	l0_cnt
	always @(posedge gclk_40m)
	if(reset)
	l0_cnt <=  32'h0;
	else if(trigcnt_clr)
	l0_cnt <=  32'h0;
	else if(l0)
	l0_cnt <=  l0_cnt + 32'h1;
	else
	l0_cnt <=  l0_cnt;

	always @(posedge gclk_40m)
	if(reset)
	l1_cnt <=  32'h0;
	else if(trigcnt_clr)
	l1_cnt <=  32'h0;
	else if(l1)
	l1_cnt <=  l1_cnt + 32'h1;
	else
	l1_cnt <=  l1_cnt;
	
	always @(posedge gclk_40m)
	if(reset)
	l2a_cnt <=  32'h0;
	else if(trigcnt_clr)
	l2a_cnt <=  32'h0;
	else if(l2a)
	l2a_cnt <=  l2a_cnt + 32'h1;
	else
	l2a_cnt <=  l2a_cnt;

	always @(posedge gclk_40m)
	if(reset)
	l2r_cnt <=  32'h0;
	else if(trigcnt_clr)
	l2r_cnt <=  32'h0;
	else if(l2r)
	l2r_cnt <=  l2r_cnt + 32'h1;
	else
	l2r_cnt <=  l2r_cnt;	

	always @(posedge gclk_40m)
	if(reset)
	l1out_cnt <=  32'h0;
	else if(trigcnt_clr)
	l1out_cnt <=  32'h0;
	else if(l1out_c)
	l1out_cnt <=  l1out_cnt + 32'h1;
	else
	l1out_cnt <=  l1out_cnt;
	
	always @(posedge gclk_40m)
	if(reset)
	rdocmd_cnt <=  32'h0;
	else if(trigcnt_clr)
	rdocmd_cnt <=  32'h0;
	else if(rdocmd_c)
	rdocmd_cnt <=  rdocmd_cnt + 32'h1;
	else
	rdocmd_cnt <=  rdocmd_cnt;

	always @(posedge gclk_40m)
	if(reset)
	abortcmd_cnt <=  32'h0;
	else if(trigcnt_clr)
	abortcmd_cnt <=  32'h0;
	else if(abortcmd_c)
	abortcmd_cnt <=  abortcmd_cnt + 32'h1;
	else
	abortcmd_cnt <=  abortcmd_cnt;	
	
	always @(posedge gclk_40m)
	if(reset)
	bunch_cnt <=  12'h0;
	else if(trigcnt_clr||bcntres)
	bunch_cnt <=  12'h0;
	else
	bunch_cnt <=  bunch_cnt + 12'h1;
	
	always @(posedge gclk_40m)
	if(reset)
	event_cnt <=  24'h0;
	else if(trigcnt_clr||evcntres)
	event_cnt <=  24'h0;
	else if(l1)
	event_cnt <=  event_cnt + 24'h1;
	else
	event_cnt <=  event_cnt;	

endmodule
