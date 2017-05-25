//  F:\BC4_MODULE\HV_UPDATE_MODULE\HV_UPDATE_SOURCE\HV_DAC_FSM.v
//  Verilog created by Xilinx's StateCAD 10.1
//  Mon Jan 25 15:14:30 2010

//  This Verilog code (for use with Xilinx XST) was generated using: 
//  one-hot state assignment with boolean code format.
//  Minimization is enabled,  implied else is enabled, 
//  and outputs are speed optimized.

`timescale 1s/1s

module shell_hv_dac_fsm(CLK,dac_err,hv_start,reset,ctr_word0,ctr_word1,
	ctr_word2,ctr_word3,dac_err_reg0,dac_err_reg1,dac_err_reg2,dac_err_reg3,
	dac_err_reg4,dac_err_reg5,dac_err_reg6,dac_err_reg7,f_cnt0,f_cnt1,f_cnt2);

	input CLK;
	input dac_err,hv_start,reset;
	output ctr_word0,ctr_word1,ctr_word2,ctr_word3,dac_err_reg0,dac_err_reg1,
		dac_err_reg2,dac_err_reg3,dac_err_reg4,dac_err_reg5,dac_err_reg6,dac_err_reg7
		,f_cnt0,f_cnt1,f_cnt2;

	reg [3:0] bit_cnt;
	reg [7:0] BP_dac_err_reg;
	reg [2:0] BP_f_cnt;
	reg [3:0] ctr_word;
	reg [7:0] dac_err_reg;
	reg [2:0] f_cnt;
	reg bit_cnt0,next_bit_cnt0,bit_cnt1,next_bit_cnt1,bit_cnt2,next_bit_cnt2,
		bit_cnt3,next_bit_cnt3,BP_dac_err_reg0,next_BP_dac_err_reg0,BP_dac_err_reg1,
		next_BP_dac_err_reg1,BP_dac_err_reg2,next_BP_dac_err_reg2,BP_dac_err_reg3,
		next_BP_dac_err_reg3,BP_dac_err_reg4,next_BP_dac_err_reg4,BP_dac_err_reg5,
		next_BP_dac_err_reg5,BP_dac_err_reg6,next_BP_dac_err_reg6,BP_dac_err_reg7,
		next_BP_dac_err_reg7,BP_f_cnt0,next_BP_f_cnt0,BP_f_cnt1,next_BP_f_cnt1,
		BP_f_cnt2,next_BP_f_cnt2,ctr_word0,next_ctr_word0,ctr_word1,next_ctr_word1,
		ctr_word2,next_ctr_word2,ctr_word3,next_ctr_word3;
	reg dac_err_reg0,dac_err_reg1,dac_err_reg2,dac_err_reg3,dac_err_reg4,
		dac_err_reg5,dac_err_reg6,dac_err_reg7,f_cnt0,f_cnt1,f_cnt2;
	reg idle,next_idle,st1,next_st1,st2,next_st2,st3,next_st3,st4,next_st4,st5,
		next_st5,st6,next_st6,st7,next_st7,st8,next_st8,st9,next_st9,STATE0,
		next_STATE0,STATE1,next_STATE1,STATE2,next_STATE2,STATE3,next_STATE3;

	always @(posedge CLK or negedge reset)
	begin
		if ( ~reset ) begin
			idle = 1;
			st1 = 0;
			st2 = 0;
			st3 = 0;
			st4 = 0;
			st5 = 0;
			st6 = 0;
			st7 = 0;
			st8 = 0;
			st9 = 0;
			STATE0 = 0;
			STATE1 = 0;
			STATE2 = 0;
			STATE3 = 0;
			BP_dac_err_reg7 = 0;
			BP_dac_err_reg6 = 0;
			BP_dac_err_reg5 = 0;
			BP_dac_err_reg4 = 0;
			BP_dac_err_reg3 = 0;
			BP_dac_err_reg2 = 0;
			BP_dac_err_reg1 = 0;
			BP_dac_err_reg0 = 0;
			bit_cnt3 = 0;
			bit_cnt2 = 0;
			bit_cnt1 = 0;
			bit_cnt0 = 0;
			BP_f_cnt2 = 0;
			BP_f_cnt1 = 0;
			BP_f_cnt0 = 0;
			ctr_word3 = 1;
			ctr_word2 = 1;
			ctr_word1 = 0;
			ctr_word0 = 1;
		end else
		begin
			idle = next_idle;
			st1 = next_st1;
			st2 = next_st2;
			st3 = next_st3;
			st4 = next_st4;
			st5 = next_st5;
			st6 = next_st6;
			st7 = next_st7;
			st8 = next_st8;
			st9 = next_st9;
			STATE0 = next_STATE0;
			STATE1 = next_STATE1;
			STATE2 = next_STATE2;
			STATE3 = next_STATE3;
			bit_cnt3 = next_bit_cnt3;
			bit_cnt2 = next_bit_cnt2;
			bit_cnt1 = next_bit_cnt1;
			bit_cnt0 = next_bit_cnt0;
			BP_dac_err_reg7 = next_BP_dac_err_reg7;
			BP_dac_err_reg6 = next_BP_dac_err_reg6;
			BP_dac_err_reg5 = next_BP_dac_err_reg5;
			BP_dac_err_reg4 = next_BP_dac_err_reg4;
			BP_dac_err_reg3 = next_BP_dac_err_reg3;
			BP_dac_err_reg2 = next_BP_dac_err_reg2;
			BP_dac_err_reg1 = next_BP_dac_err_reg1;
			BP_dac_err_reg0 = next_BP_dac_err_reg0;
			BP_f_cnt2 = next_BP_f_cnt2;
			BP_f_cnt1 = next_BP_f_cnt1;
			BP_f_cnt0 = next_BP_f_cnt0;
			ctr_word3 = next_ctr_word3;
			ctr_word2 = next_ctr_word2;
			ctr_word1 = next_ctr_word1;
			ctr_word0 = next_ctr_word0;
		end
	end

	always @ (bit_cnt0 or bit_cnt1 or bit_cnt2 or bit_cnt3 or BP_dac_err_reg0 or
		 BP_dac_err_reg1 or BP_dac_err_reg2 or BP_dac_err_reg3 or BP_dac_err_reg4 or 
		BP_dac_err_reg5 or BP_dac_err_reg6 or BP_dac_err_reg7 or BP_f_cnt0 or 
		BP_f_cnt1 or BP_f_cnt2 or dac_err or hv_start or idle or st1 or st2 or st3 or
		 st4 or st5 or st6 or st7 or st8 or st9 or STATE0 or STATE1 or STATE2 or 
		STATE3 or bit_cnt or BP_dac_err_reg or BP_f_cnt or ctr_word)
	begin

		if ( ~hv_start & idle | STATE3 ) next_idle=1;
		else next_idle=0;

		if ( hv_start & idle ) next_st1=1;
		else next_st1=0;

		if ( st1 | ~bit_cnt0 & st2 | ~bit_cnt1 & st2 | ~bit_cnt2 & st2 | ~bit_cnt3 
			& st2 ) next_st2=1;
		else next_st2=0;

		if ( bit_cnt0 & bit_cnt1 & bit_cnt2 & bit_cnt3 & st2 ) next_st3=1;
		else next_st3=0;

		if ( st3 ) next_st4=1;
		else next_st4=0;

		if ( st4 | BP_f_cnt0 & st8 | BP_f_cnt1 & st8 | BP_f_cnt2 & st8 ) 
			next_st5=1;
		else next_st5=0;

		if ( st5 | ~bit_cnt0 & st6 | ~bit_cnt1 & st6 | ~bit_cnt2 & st6 | ~bit_cnt3 
			& st6 ) next_st6=1;
		else next_st6=0;

		if ( bit_cnt0 & bit_cnt1 & bit_cnt2 & bit_cnt3 & st6 ) next_st7=1;
		else next_st7=0;

		if ( st7 ) next_st8=1;
		else next_st8=0;

		if ( ~BP_f_cnt0 & ~BP_f_cnt1 & ~BP_f_cnt2 & st8 ) next_st9=1;
		else next_st9=0;

		if ( st9 ) next_STATE0=1;
		else next_STATE0=0;

		if ( STATE0 ) next_STATE1=1;
		else next_STATE1=0;

		if ( STATE1 ) next_STATE2=1;
		else next_STATE2=0;

		if ( STATE2 ) next_STATE3=1;
		else next_STATE3=0;


		bit_cnt= ( {4{idle}}  & ( {4{~hv_start}}  ) & ( 'h0 ) ) | ( {4{STATE3}}  & 
			( 4'hf ) & ( 'h0 ) ) | ( {4{idle}}  & ( {4{hv_start}}  ) & ( 'h0 ) ) | ( {4{
			st1}}  & ( 4'hf ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  + 'h1 ) ) | ( 
			{4{st2}}  & ( {4{~bit_cnt3}} | {4{~bit_cnt2}} | {4{~bit_cnt1}} | {4{~bit_cnt0
			}}  ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  + 'h1 ) ) | ( {4{st2}}  & ( 
			{4{bit_cnt0}} & {4{bit_cnt1}} & {4{bit_cnt2}} & {4{bit_cnt3}}  ) & ( {
			bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  ) ) | ( {4{st3}}  & ( 4'hf ) & ( {
			bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  ) ) | ( {4{st4}}  & ( 4'hf ) & ( 'h0 ) 
			) | ( {4{st8}}  & ( {4{BP_f_cnt2}} | {4{BP_f_cnt1}} | {4{BP_f_cnt0}}  ) & ( 
			'h0 ) ) | ( {4{st5}}  & ( 4'hf ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  +
			 'h1 ) ) | ( {4{st6}}  & ( {4{~bit_cnt3}} | {4{~bit_cnt2}} | {4{~bit_cnt1}} |
			 {4{~bit_cnt0}}  ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  + 'h1 ) ) | ( 
			{4{st6}}  & ( {4{bit_cnt0}} & {4{bit_cnt1}} & {4{bit_cnt2}} & {4{bit_cnt3}}  
			) & ( {bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  ) ) | ( {4{st7}}  & ( 4'hf ) & (
			 {bit_cnt3,bit_cnt2,bit_cnt1,bit_cnt0}  ) ) | ( {4{st8}}  & ( {4{~BP_f_cnt0}}
			 & {4{~BP_f_cnt1}} & {4{~BP_f_cnt2}}  ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,
			bit_cnt0}  ) ) | ( {4{st9}}  & ( 4'hf ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,
			bit_cnt0}  ) ) | ( {4{STATE0}}  & ( 4'hf ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,
			bit_cnt0}  ) ) | ( {4{STATE1}}  & ( 4'hf ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,
			bit_cnt0}  ) ) | ( {4{STATE2}}  & ( 4'hf ) & ( {bit_cnt3,bit_cnt2,bit_cnt1,
			bit_cnt0}  ) );

		BP_dac_err_reg= ( {8{idle}}  & ( {8{~hv_start}}  ) & ( {BP_dac_err_reg7,
			BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,BP_dac_err_reg3,
			BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{idle}}  & ( {8{
			hv_start}}  ) & ( 'h0 ) ) | ( {8{st1}}  & ( 8'hff ) & ( {BP_dac_err_reg7,
			BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,BP_dac_err_reg3,
			BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{st2}}  & ( {8{
			bit_cnt0}} & {8{bit_cnt1}} & {8{bit_cnt2}} & {8{bit_cnt3}}  ) & ( {
			BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{
			st2}}  & ( {8{~bit_cnt3}} | {8{~bit_cnt2}} | {8{~bit_cnt1}} | {8{~bit_cnt0}} 
			 ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{
			st3}}  & ( 8'hff ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,
			BP_dac_err_reg4,BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,
			BP_dac_err_reg0}  ) ) | ( {8{st4}}  & ( 8'hff ) & ( {BP_dac_err_reg7,
			BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,BP_dac_err_reg3,
			BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{st5}}  & ( 8'hff
			 ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{
			st6}}  & ( {8{bit_cnt0}} & {8{bit_cnt1}} & {8{bit_cnt2}} & {8{bit_cnt3}}  ) &
			 ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{
			st6}}  & ( {8{~bit_cnt3}} | {8{~bit_cnt2}} | {8{~bit_cnt1}} | {8{~bit_cnt0}} 
			 ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{
			st7}}  & ( 8'hff ) & ( {dac_err,BP_dac_err_reg7,BP_dac_err_reg6,
			BP_dac_err_reg5,BP_dac_err_reg4,BP_dac_err_reg3,BP_dac_err_reg2,
			BP_dac_err_reg1}  ) ) | ( {8{st8}}  & ( {8{~BP_f_cnt0}} & {8{~BP_f_cnt1}} & 
			{8{~BP_f_cnt2}}  ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,
			BP_dac_err_reg4,BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,
			BP_dac_err_reg0}  ) ) | ( {8{st8}}  & ( {8{BP_f_cnt2}} | {8{BP_f_cnt1}} | {8{
			BP_f_cnt0}}  ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,
			BP_dac_err_reg4,BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,
			BP_dac_err_reg0}  ) ) | ( {8{st9}}  & ( 8'hff ) & ( {BP_dac_err_reg7,
			BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,BP_dac_err_reg3,
			BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{STATE0}}  & ( 
			8'hff ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{
			STATE1}}  & ( 8'hff ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,
			BP_dac_err_reg4,BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,
			BP_dac_err_reg0}  ) ) | ( {8{STATE2}}  & ( 8'hff ) & ( {BP_dac_err_reg7,
			BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,BP_dac_err_reg3,
			BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) ) | ( {8{STATE3}}  & ( 
			8'hff ) & ( {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,BP_dac_err_reg4,
			BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,BP_dac_err_reg0}  ) );

		BP_f_cnt= ( {3{idle}}  & ( {3{~hv_start}}  ) & ( 'h0 ) ) | ( {3{STATE3}}  &
			 ( 3'h7 ) & ( 'h0 ) ) | ( {3{idle}}  & ( {3{hv_start}}  ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st1}}  & ( 3'h7 ) & ( {BP_f_cnt2,BP_f_cnt1,
			BP_f_cnt0}  ) ) | ( {3{st2}}  & ( {3{bit_cnt0}} & {3{bit_cnt1}} & {3{bit_cnt2
			}} & {3{bit_cnt3}}  ) & ( {BP_f_cnt2,BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st2}}  
			& ( {3{~bit_cnt3}} | {3{~bit_cnt2}} | {3{~bit_cnt1}} | {3{~bit_cnt0}}  ) & ( 
			{BP_f_cnt2,BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st3}}  & ( 3'h7 ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st4}}  & ( 3'h7 ) & ( {BP_f_cnt2,BP_f_cnt1,
			BP_f_cnt0}  ) ) | ( {3{st5}}  & ( 3'h7 ) & ( {BP_f_cnt2,BP_f_cnt1,BP_f_cnt0} 
			 ) ) | ( {3{st6}}  & ( {3{bit_cnt0}} & {3{bit_cnt1}} & {3{bit_cnt2}} & {3{
			bit_cnt3}}  ) & ( {BP_f_cnt2,BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st6}}  & ( {3{~
			bit_cnt3}} | {3{~bit_cnt2}} | {3{~bit_cnt1}} | {3{~bit_cnt0}}  ) & ( {
			BP_f_cnt2,BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st7}}  & ( 3'h7 ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  + 'h1 ) ) | ( {3{st8}}  & ( {3{~BP_f_cnt0}} & {3{~
			BP_f_cnt1}} & {3{~BP_f_cnt2}}  ) & ( {BP_f_cnt2,BP_f_cnt1,BP_f_cnt0}  ) ) | (
			 {3{st8}}  & ( {3{BP_f_cnt2}} | {3{BP_f_cnt1}} | {3{BP_f_cnt0}}  ) & ( {
			BP_f_cnt2,BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{st9}}  & ( 3'h7 ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{STATE0}}  & ( 3'h7 ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{STATE1}}  & ( 3'h7 ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  ) ) | ( {3{STATE2}}  & ( 3'h7 ) & ( {BP_f_cnt2,
			BP_f_cnt1,BP_f_cnt0}  ) );

		ctr_word= ( {4{idle}}  & ( {4{~hv_start}}  ) & ( 'hd ) ) | ( {4{STATE3}}  &
			 ( 4'hf ) & ( 'hd ) ) | ( {4{idle}}  & ( {4{hv_start}}  ) & ( 'hb ) ) | ( {4{
			st1}}  & ( 4'hf ) & ( 'h9 ) ) | ( {4{st2}}  & ( {4{~bit_cnt3}} | {4{~bit_cnt2
			}} | {4{~bit_cnt1}} | {4{~bit_cnt0}}  ) & ( 'h9 ) ) | ( {4{st2}}  & ( {4{
			bit_cnt0}} & {4{bit_cnt1}} & {4{bit_cnt2}} & {4{bit_cnt3}}  ) & ( 'hd ) ) | (
			 {4{st3}}  & ( 4'hf ) & ( 'hd ) ) | ( {4{st4}}  & ( 4'hf ) & ( 'h3 ) ) | ( 
			{4{st8}}  & ( {4{BP_f_cnt2}} | {4{BP_f_cnt1}} | {4{BP_f_cnt0}}  ) & ( 'h3 ) )
			 | ( {4{st5}}  & ( 4'hf ) & ( 'h1 ) ) | ( {4{st6}}  & ( {4{~bit_cnt3}} | {4{~
			bit_cnt2}} | {4{~bit_cnt1}} | {4{~bit_cnt0}}  ) & ( 'h1 ) ) | ( {4{st6}}  & (
			 {4{bit_cnt0}} & {4{bit_cnt1}} & {4{bit_cnt2}} & {4{bit_cnt3}}  ) & ( 'hd ) )
			 | ( {4{st7}}  & ( 4'hf ) & ( 'hd ) ) | ( {4{st8}}  & ( {4{~BP_f_cnt0}} & {4{
			~BP_f_cnt1}} & {4{~BP_f_cnt2}}  ) & ( 'hc ) ) | ( {4{st9}}  & ( 4'hf ) & ( 
			'hc ) ) | ( {4{STATE0}}  & ( 4'hf ) & ( 'hc ) ) | ( {4{STATE1}}  & ( 4'hf ) &
			 ( 'hc ) ) | ( {4{STATE2}}  & ( 4'hf ) & ( 'hc ) );

		next_bit_cnt3 = bit_cnt[3];
		next_bit_cnt2 = bit_cnt[2];
		next_bit_cnt1 = bit_cnt[1];
		next_bit_cnt0 = bit_cnt[0];
		next_BP_dac_err_reg7 = BP_dac_err_reg[7];
		next_BP_dac_err_reg6 = BP_dac_err_reg[6];
		next_BP_dac_err_reg5 = BP_dac_err_reg[5];
		next_BP_dac_err_reg4 = BP_dac_err_reg[4];
		next_BP_dac_err_reg3 = BP_dac_err_reg[3];
		next_BP_dac_err_reg2 = BP_dac_err_reg[2];
		next_BP_dac_err_reg1 = BP_dac_err_reg[1];
		next_BP_dac_err_reg0 = BP_dac_err_reg[0];
		next_BP_f_cnt2 = BP_f_cnt[2];
		next_BP_f_cnt1 = BP_f_cnt[1];
		next_BP_f_cnt0 = BP_f_cnt[0];
		next_ctr_word3 = ctr_word[3];
		next_ctr_word2 = ctr_word[2];
		next_ctr_word1 = ctr_word[1];
		next_ctr_word0 = ctr_word[0];
	end

	always @(BP_dac_err_reg0 or BP_dac_err_reg1 or BP_dac_err_reg2 or 
		BP_dac_err_reg3 or BP_dac_err_reg4 or BP_dac_err_reg5 or BP_dac_err_reg6 or 
		BP_dac_err_reg7 or dac_err_reg)
	begin
		dac_err_reg= {BP_dac_err_reg7,BP_dac_err_reg6,BP_dac_err_reg5,
			BP_dac_err_reg4,BP_dac_err_reg3,BP_dac_err_reg2,BP_dac_err_reg1,
			BP_dac_err_reg0} ;
		dac_err_reg0 = dac_err_reg[0];
		dac_err_reg1 = dac_err_reg[1];
		dac_err_reg2 = dac_err_reg[2];
		dac_err_reg3 = dac_err_reg[3];
		dac_err_reg4 = dac_err_reg[4];
		dac_err_reg5 = dac_err_reg[5];
		dac_err_reg6 = dac_err_reg[6];
		dac_err_reg7 = dac_err_reg[7];
	end

	always @(BP_f_cnt0 or BP_f_cnt1 or BP_f_cnt2 or f_cnt)
	begin
		f_cnt= {BP_f_cnt2,BP_f_cnt1,BP_f_cnt0} ;
		f_cnt0 = f_cnt[0];
		f_cnt1 = f_cnt[1];
		f_cnt2 = f_cnt[2];
	end
endmodule

module hv_dac_fsm(ctr_word,dac_err_reg,f_cnt,CLK,dac_err,hv_start,reset);

	output [3:0] ctr_word;
	output [7:0] dac_err_reg;
	output [2:0] f_cnt;
	input CLK;
	input dac_err,hv_start,reset;

	wire [3:0] ctr_word;
	wire [7:0] dac_err_reg;
	wire [2:0] f_cnt;
	wire CLK;
	wire dac_err,hv_start,reset;

	shell_hv_dac_fsm part1(.CLK(CLK),.dac_err(dac_err),.hv_start(hv_start),
		.reset(reset),.ctr_word0(ctr_word[0]),.ctr_word1(ctr_word[1]),.ctr_word2(
		ctr_word[2]),.ctr_word3(ctr_word[3]),.dac_err_reg0(dac_err_reg[0]),
		.dac_err_reg1(dac_err_reg[1]),.dac_err_reg2(dac_err_reg[2]),.dac_err_reg3(
		dac_err_reg[3]),.dac_err_reg4(dac_err_reg[4]),.dac_err_reg5(dac_err_reg[5]),
		.dac_err_reg6(dac_err_reg[6]),.dac_err_reg7(dac_err_reg[7]),.f_cnt0(f_cnt[0])
		,.f_cnt1(f_cnt[1]),.f_cnt2(f_cnt[2]));


endmodule
