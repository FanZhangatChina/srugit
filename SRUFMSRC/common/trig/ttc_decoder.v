`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module ttc_decoder(
	 input 				gclk_40m,
		//ttc trigger
	 input 				ttc_l1accept_p,
	 input 				ttc_l1accept_n,
	 output reg 		ttc_l0 = 1'b0,
	 output reg 		ttc_l1 = 1'b0,

	 input [7:0] 		ttc_saddr,
	 input [7:0] 		ttc_dout,
	 input 				ttc_doutstr,
	 output 				ttc_l2r,
	 output 				ttc_l2a,
	 output 				ttc_feereset,
	 output 				ttc_l1accept,
	 
	 input 				trig_mode,
	 input [11:0] 		unttc_event_id2,
	 input [11:0] 		ttc_mini_event_id,
	 input [7:0] 		cdh_blk_att,
	 input [5:0] 		trigerr,

//	 input				CDHVer,
	 input  [7:0]		ParReq,
	 output [31:0] 	cdh_w0,
	 output [31:0] 	cdh_w1,
	 output [31:0] 	cdh_w2,
	 output [31:0] 	cdh_w3,
	 output [31:0] 	cdh_w4,
	 output [31:0] 	cdh_w5,
	 output [31:0] 	cdh_w6,
	 output [31:0] 	cdh_w7,
	 output [31:0] 	cdh_w8,
	 output [31:0] 	cdh_w9,
	 output [31:0] 	L2aMes8Cnt,
	 
	 input 				reset	 
    );

	parameter st0 = 4'b0001;
	parameter st1 = 4'b0010;
	parameter st2 = 4'b0100;
	parameter st3 = 4'b1000;
	
	reg [3:0] st = st0;

   IBUFDS #(
      .DIFF_TERM("FALSE"),    
      .IOSTANDARD("DEFAULT") 
   ) IBUFDS_ttc_l1accept (
      .O(ttc_l1accept), 
      .I(ttc_l1accept_p), 
      .IB(ttc_l1accept_n) 
   );

ttc_mgs_decode u_ttc_mgs_decode (
    .gclk_40m(gclk_40m), 
    .ttc_saddr(ttc_saddr), 
    .ttc_dout(ttc_dout), 
    .ttc_doutstr(ttc_doutstr), 
    .ttc_l2r(ttc_l2r), 
    .ttc_l2a(ttc_l2a), 
    .ttc_feereset(ttc_feereset), 
	 
    .trig_mode(trig_mode), 
    .unttc_event_id2(unttc_event_id2), 
    .ttc_mini_event_id(ttc_mini_event_id), 
    .cdh_blk_att(cdh_blk_att), 
    .trigerr(trigerr),
	 
//    .CDHVer(CDHVer), 
    .ParReq(ParReq), 
    .cdh_w0(cdh_w0), 
    .cdh_w1(cdh_w1), 
    .cdh_w2(cdh_w2), 
    .cdh_w3(cdh_w3), 
    .cdh_w4(cdh_w4), 
    .cdh_w5(cdh_w5), 
    .cdh_w6(cdh_w6), 
    .cdh_w7(cdh_w7),
    .cdh_w8(cdh_w8),
    .cdh_w9(cdh_w9),
    .L2aMes8Cnt(L2aMes8Cnt),
	 
    .reset(reset)
    );

	always @(posedge gclk_40m)
	if(reset)
	begin
	ttc_l0 <= 1'b0;
	ttc_l1 <= 1'b0;
	st <= st0;
	end else case(st)
	st0 : begin
	ttc_l0 <= 1'b0;
	ttc_l1 <= 1'b0;

	if(ttc_l1accept)
	st <= st1;
	else
	st <= st0;
	end

	st1 : begin
	ttc_l0 <= 1'b0;
	ttc_l1 <= 1'b0;

	if(ttc_l1accept)
	st <= st3; //l1
	else
	st <= st2; //l0
	end

	st2 : begin
	ttc_l0 <= 1'b1;
	ttc_l1 <= 1'b0;
	st <= st0;
	end

	st3 : begin
	ttc_l0 <= 1'b0;
	ttc_l1 <= 1'b1;
	st <= st0;
	end

	default : begin
	ttc_l0 <= 1'b0;
	ttc_l1 <= 1'b0;
	st <= st0;
	end
	endcase
	
endmodule
