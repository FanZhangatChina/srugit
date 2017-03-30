`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 19 July 2015

`timescale 1ns / 1ps
module sru_trigger(
	 input 				gclk_40m,
		
	 input 				ttc_l1accept_p,
	 input 				ttc_l1accept_n,
	 input [7:0] 		ttc_saddr,
	 input [7:0] 		ttc_dout,
	 input 				ttc_doutstr,
	 input 				evcntres,
	 input 				bcntres,
		
	// input				CDHVer,
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

	 input 				DtcRamFlag,
	 input				ddl_tx_start,
	 output 				EventRdySent,
	 output				STrigErrFlag,
	 output				DtcRamClr,

//	 output 				sru_l0, 
	 output				FeeTrig,
//	 output 				l1out,
	 output 				abortcmd,
	 output 				rdocmd,

	 input 				trigcnt_clr,	
    output [255:0] 	trigcnt,
	 input 				trigerr_clr,
	 output [5:0]  	trigerr,
	 input 				htrig,
	 input 				strig_cmd,
	 input  [144:0]	trig_config,
	 input  [1:0] 	   trig_mode,

	 output [31:0] 	DebugReg,
	 output  			trig_busy,
	 input 				BusyFlag,
	 output				ttc_feereset,
	 input				rdocmd_opt,

	 input 				reset
	 );

	 wire 				sru_l0; 
	 wire 				l1out;

	 
	wire ttc_l0, ttc_l1, ttc_l2a, ttc_l2r;
	wire test_l0, test_l1, test_l2a; 
	wire l0,l1,l2a,l2r;
	
	wire l1out_c;
	wire rdocmd_c;
	wire abortcmd_c;
	
	wire [11:0] 		unttc_event_id2;
	reg  [11:0] 		ttc_mini_event_id = 12'h0;
	
	wire [31:0] 		l0_cnt;
	wire [31:0] 		l1_cnt;
	wire [31:0] 		l2a_cnt;
	wire [31:0] 		l2r_cnt;	 
	wire [31:0] 		l1out_cnt;
	wire [31:0] 		rdocmd_cnt;
	wire [31:0] 		abortcmd_cnt;	
	wire  [11:0] 		trigerr_cnt;
	
	wire  [11:0] 		bunch_cnt;
	wire  [23:0] 		event_cnt;
	
	 wire [3:0] 		strig_config;
	 wire 				sptrig_en;
	 wire [15:0] 		sptrig_period;
	 wire [15:0] 		test_l0_latency;
	 wire [15:0] 		test_l1_latency;
	 wire [15:0] 		test_l2a_latency;
	 
	 wire [15:0] 		l1tw_low;
	 wire [15:0] 		l1tw_high;
	 wire [15:0] 		l2tw_low;
	 wire [15:0] 		l2tw_high;

	 wire 				ttc_l1accept;
	 wire					test_trig;
	
	parameter cdh_blk_att = 8'h02;
	assign unttc_event_id2 = l2a_cnt[11:0];
	assign trigcnt = {trigerr_cnt, abortcmd_cnt,rdocmd_cnt,l1out_cnt,l2r_cnt,l2a_cnt,l1_cnt,l0_cnt};

	assign l1tw_low = trig_config[15:0];						
	assign l1tw_high = trig_config[31:16];
	assign l2tw_low = trig_config[47:32];
	assign l2tw_high = trig_config[63:48];	

	assign test_l0_latency = trig_config[79:64];						
	assign test_l1_latency = trig_config[95:80];
	assign test_l2a_latency = trig_config[111:96];
	assign strig_config = trig_config[115:112];//127
	
	assign sptrig_period = trig_config[143:128];	
	assign sptrig_en = trig_config[144];
	
ttc_decoder u_ttc_decoder (
    .gclk_40m(gclk_40m),
	 
    .ttc_l1accept_p(ttc_l1accept_p), 
    .ttc_l1accept_n(ttc_l1accept_n),
    .ttc_l1accept(ttc_l1accept),	 
    .ttc_l0(ttc_l0), 
    .ttc_l1(ttc_l1), 
    .ttc_saddr(ttc_saddr), 
    .ttc_dout(ttc_dout), 
    .ttc_doutstr(ttc_doutstr), 
    .ttc_l2r(ttc_l2r), 
    .ttc_l2a(ttc_l2a),
    .ttc_feereset(ttc_feereset),	 
	 
    .trig_mode(trig_mode[1]), 
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
	
	trig_cnt u_trig_cnt (
		.gclk_40m(gclk_40m),
		
		.l0(l0), 
		.l1(l1),
		.l2a(l2a),
		.l2r(l2r),
		
		.l1out_c(l1out_c),		
		.rdocmd_c(rdocmd_c),
		.abortcmd_c(abortcmd_c),
		
		.trigcnt_clr(trigcnt_clr),
		
		.l1out(l1out),		
		.rdocmd(rdocmd),
		.abortcmd(abortcmd),
		
		.evcntres(evcntres), 
		.bcntres(bcntres), 
		
		.l0_cnt(l0_cnt), 
		.l1_cnt(l1_cnt),
		.l2a_cnt(l2a_cnt),
		.l2r_cnt(l2r_cnt),

		.l1out_cnt(l1out_cnt),
		.rdocmd_cnt(rdocmd_cnt),
		.abortcmd_cnt(abortcmd_cnt),		

		.bunch_cnt(bunch_cnt),
		.event_cnt(event_cnt),		
		
		.reset(reset)
	);

	
	test_trig_gen u_test_trig_gen (
		.gclk_40m(gclk_40m),
		
		.trigger_select(trig_mode[0]), 
		.htrig(htrig),
		.strig_cmd(strig_cmd),
		.strig_config(strig_config),	
		
		.sptrig_en(sptrig_en),
		.sptrig_period(sptrig_period),	
		
		.test_l0_latency(test_l0_latency),
		.test_l1_latency(test_l1_latency),		
		.test_l2a_latency(test_l2a_latency),
		
		.test_l0(test_l0),		
		.test_l1(test_l1),
		.test_l2a(test_l2a),
		.test_trig(test_trig),		
		
		.BusyFlag(BusyFlag), 		
		.reset(reset)
	);


trig_err_detect u_trig_err_detect (
    .gclk_40m(gclk_40m), 
	
    .l0(l0), 
    .l1(l1), 
    .l2a(l2a), 
    .l2r(l2r), 
	
    .l1tw_low(l1tw_low), 
    .l1tw_high(l1tw_high), 
    .l2tw_low(l2tw_low), 
    .l2tw_high(l2tw_high), 
	
	 .trigerr_clr(trigerr_clr), 
    .trigerr(trigerr), 
    .trigerr_cnt(trigerr_cnt), 
    .trig_busy(trig_busy), 
	 
    .DtcRamFlag(DtcRamFlag), 
    .ddl_tx_start(ddl_tx_start), 
	 .EventRdySent(EventRdySent),
	 .STrigErrFlag(STrigErrFlag),
	
    .rdocmd_c(rdocmd_c), 
    .abortcmd_c(abortcmd_c), 
    .rdocmd_f(rdocmd_f), 
	 .DebugReg(DebugReg),
	 .DtcRamClr(DtcRamClr),
	 .rdocmd_opt(rdocmd_opt),
	
    .reset(reset)
    );

assign l0 = trig_mode[1] ? ttc_l0 : test_l0;
assign l1 = trig_mode[1] ? ttc_l1 : test_l1;
assign l2a = trig_mode[1] ? ttc_l2a : test_l2a;
assign l2r = ttc_l2r;
assign sru_l0 = l0;
assign l1out_c = l1;

assign FeeTrig = trig_mode[1] ? ttc_l1accept : test_trig;

	always @(posedge gclk_40m)
	if(reset)
	ttc_mini_event_id <=  12'h0;
	else if(l1)
	ttc_mini_event_id <=  bunch_cnt;
	else
	ttc_mini_event_id <=  ttc_mini_event_id;	

endmodule
