`timescale 1ns / 1ps

// ALICE/EMCal SRU
// This module checks trigger sequence, broadcasts valid triggers to DTC ports and reports invalid triggers to DAQ.
// Equivalent SRU = SRUV3FM2015071901_PHOS
// Fan Zhang. 19 July 2015

module trig_err_detect (
input 				gclk_40m,

input 				l0,
input 				l1,
input 				l2a,
input 				l2r,

input [15:0] 		l1tw_low,
input [15:0] 		l1tw_high,
input [15:0] 		l2tw_low,
input [15:0] 		l2tw_high,

input 				trigerr_clr,
output  [5:0]  	trigerr,
output  [11:0] 	trigerr_cnt,
output reg 			trig_busy = 1'b0,

input 				DtcRamFlag,
input					ddl_tx_start,
output reg			EventRdySent = 1'b0,
output reg 			STrigErrFlag = 1'b0,

output reg 			rdocmd_c = 1'b0,
output reg 			abortcmd_c = 1'b0,
output	 			rdocmd_f,

output reg [31:0]	DebugReg = 32'h0,
output reg			DtcRamClr = 1'b0,
input					rdocmd_opt,

input 				reset
);

reg [15:0] clkcnt = 16'd0; // 500us = 200 000

reg ddl_tx_start_i = 1'b0;

   parameter st0  		 			=  21'b0_0000_0000_0000_0000_0001;
   parameter sta0  					= 	21'b0_0000_0000_0000_0000_0010;
   parameter sta1  					= 	21'b0_0000_0000_0000_0000_0100;
   parameter sta2  					= 	21'b0_0000_0000_0000_0000_1000;
   parameter stb0  					= 	21'b0_0000_0000_0000_0001_0000;
   parameter stc0  					= 	21'b0_0000_0000_0000_0010_0000;
   parameter FeeDataReject_st  	= 	21'b0_0000_0000_0000_0100_0000;
   parameter ste0  				 	= 	21'b0_0000_0000_0000_1000_0000;
   parameter stf0  					=  21'b0_0000_0000_0001_0000_0000;
   parameter DTCBufWait_st  	 	=  21'b0_0000_0000_0010_0000_0000;
   parameter L2Reject_st 			=  21'b0_0000_0000_0100_0000_0000;
   parameter L2Accept_st 			=  21'b0_0000_0000_1000_0000_0000;
   parameter L2Soft_st   			=  21'b0_0000_0001_0000_0000_0000;
   parameter L2Err_st    			=  21'b0_0000_0010_0000_0000_0000;
   parameter DdlWait_st  			=  21'b0_0000_0100_0000_0000_0000;
	parameter TrgWait_st  			=  21'b0_0000_1000_0000_0000_0000;
	parameter L0L1Err_st  			=  21'b0_0001_0000_0000_0000_0000;
	parameter DdlStart_st 			=  21'b0_0010_0000_0000_0000_0000;
	parameter DtcWait_st  			=  21'b0_0100_0000_0000_0000_0000;
	parameter sta2a 					=  21'b0_1000_0000_0000_0000_0000;
	parameter FeeBufClr_st 			=  21'b1_0000_0000_0000_0000_0000;
	
	reg [20:0] st = st0;
   (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="21'b0_0000_0000_0000_0000_0001" *) 

reg [5:0] trigerr_i = 6'h0;
reg [11:0] trigerr_cnt_i = 12'h0;

assign trigerr =  trigerr_i;
assign trigerr_cnt =  trigerr_cnt_i;

always @(posedge gclk_40m)
DebugReg <= {11'h0,st};

always @(posedge gclk_40m)
ddl_tx_start_i <= ddl_tx_start;

always @(posedge gclk_40m)
if(reset)
begin
	trig_busy <= 1'b0;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	trigerr_i <= 6'b0;

	clkcnt <= 16'b0;
	st <= st0;
end else case(st)
st0:
begin
	trig_busy <= 1'b0;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	trigerr_i <= 6'b0;

	clkcnt <= 16'b0;
	if(l0)
		st <= sta0;
	else if(l1)
		st <= stb0;
	else if(l2a | l2r)
		st <= stc0;
	else
		st <= st0;	
end

sta0:
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	trigerr_i <= 6'b0;

	if(clkcnt > l1tw_high) //time window
	begin
	clkcnt <= 16'b0;	
	st <= st0; //timeout = l1r
	end
	else if(l0)
	begin
	clkcnt <= 16'h0;
	st <= sta0;
	end
	else if(l1)
	begin
	clkcnt <= clkcnt + 16'b1;	
	st <= sta1;
	end
	else if(l2a | l2r)
	begin
	clkcnt <= clkcnt + 16'b1;	
	st <= ste0;
	end
	else
	begin
	clkcnt <= clkcnt + 16'b1;	
	st <= sta0;
	end
end

sta1:
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	trigerr_i <= 6'b0;

	clkcnt <= clkcnt + 16'b1;

	if(clkcnt < l1tw_low)
	st <= stf0; //l1 trigger arrives too early
	else 
	st <= sta2a; //valid l1 trigger
end

sta2a: begin
	trig_busy <= 1'b1;
	
	if(rdocmd_opt)
	begin rdocmd_c <= 1'b0; end
	else
	begin rdocmd_c <= 1'b1; end
	
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	trigerr_i <= 6'b0;
	
	clkcnt <= clkcnt + 16'b1;
   st <= sta2;
end

sta2:
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	clkcnt <= clkcnt + 16'b1;
	trigerr_i <= 6'b0;

	if(clkcnt > l2tw_high)
	begin
	st <= FeeDataReject_st;
	end
	else if(l2r)
	begin
	st <= FeeDataReject_st;
	end
	else if(l2a)
			begin
			st <= L2Accept_st;
			end
	else
	begin
	st <= sta2;
	end
end

FeeDataReject_st : begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	
	if(rdocmd_opt)
	begin abortcmd_c <= 1'b1; end
	else
	begin abortcmd_c <= 1'b0; end
	
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	clkcnt <= 16'b0;
	trigerr_i <= trigerr_i;

	if(DtcRamFlag)
	st <= FeeBufClr_st;
	else
	st <= FeeDataReject_st;
end

FeeBufClr_st : begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b1;
	STrigErrFlag <= 1'b0;
	clkcnt <= 16'b0;
	trigerr_i <= trigerr_i;

	if(trigerr_i[2])
	st <= L2Err_st;
	else
	st <= DTCBufWait_st;
end

L2Accept_st:
begin
	trig_busy <= 1'b1;
		
	if(rdocmd_opt)
	begin rdocmd_c <= 1'b1; end
	else
	begin rdocmd_c <= 1'b0; end
	
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= 1'b0;
	trigerr_i <= trigerr_i;

	st <= DtcWait_st;
end

DtcWait_st:
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= STrigErrFlag;
	trigerr_i <= trigerr_i;

	if(DtcRamFlag)
	st <= DdlStart_st;
	else
	st <= DtcWait_st;
end

DdlStart_st : 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b1;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= STrigErrFlag;
	clkcnt <= 16'b0;
	trigerr_i <= trigerr_i;
	
	if(ddl_tx_start_i)
	st <= DTCBufWait_st;
	else
	st <= DdlStart_st;
end

DTCBufWait_st: 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	DtcRamClr <= 1'b0;
	STrigErrFlag <= STrigErrFlag;
	clkcnt <= clkcnt + 16'b1;
	trigerr_i <= trigerr_i;
	
	if(ddl_tx_start_i)
	st <= DTCBufWait_st;
	else
	st <= st0;
end
/////////////////////////////////////////////////////////////////////////////

L2Err_st:
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	abortcmd_c <= 1'b0;
	STrigErrFlag <= 1'b1;
	DtcRamClr <= 1'b0;
	trigerr_i <= trigerr_i;

	st <= DdlStart_st;
end

L0L1Err_st:
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	abortcmd_c <= 1'b0;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;
	trigerr_i <= trigerr_i;

	st <= TrgWait_st;
end

TrgWait_st: 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	abortcmd_c <= 1'b0;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;
	trigerr_i <= trigerr_i;

	clkcnt <= clkcnt + 16'b1;
	if(clkcnt[3])
	st <= st0;
	else
	st <= TrgWait_st;
end

///////////////////////////////////////////
//L1 received without L0
stb0 : 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= clkcnt + 16'b1;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;

if(l2a | l2r) //Waiting for L2 trigger
begin
abortcmd_c <= 1'b1;
trigerr_i <= 6'b000_010;  	//L1 received without L0
st <= L2Err_st; 
end
else if(clkcnt > l2tw_high)
begin
abortcmd_c <= 1'b1;
trigerr_i <= 6'h0;
st <= L0L1Err_st; 
end
else
begin
trigerr_i <= 6'h0;
abortcmd_c <= 1'b0;
st <= stb0;
end
end

//L2 received without L0 and L1
stc0 : 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	abortcmd_c <= 1'b0;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;
	trigerr_i <= 6'b100_000;		//L2 received without L0 and L1
	
	st <= L2Err_st; 
end

//L2 received without L1
ste0 : 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	abortcmd_c <= 1'b0;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;
	trigerr_i <= 6'b100_000;		//L2 received without L1

	st <= L2Err_st;//Sent data
end
//L1 arrived eariler than expected
stf0 : 
begin
	trig_busy <= 1'b1;
	rdocmd_c <= 1'b0;
	abortcmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= clkcnt + 16'b1;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;
	

if(l2a | l2r) //Waiting for L2 trigger
	begin
	trigerr_i <= 6'b000_100;		//L1 arrived eariler than expected
	st <= FeeDataReject_st;
	end
else if(clkcnt > l2tw_high) //timeout
	begin
	trigerr_i <= 6'b0;		
	st <= FeeDataReject_st;
	end
else
	begin
	trigerr_i <= 6'b0;
	st <= stf0;
	end
end

default: begin
	trig_busy <= 1'b0;
	rdocmd_c <= 1'b0;
	EventRdySent <= 1'b0;
	clkcnt <= 16'b0;
	abortcmd_c <= 1'b0;
	STrigErrFlag <= 1'b0;
	DtcRamClr <= 1'b0;
	trigerr_i <= 6'b0;

	st <= st0;
end
endcase

always @(posedge gclk_40m)
if(reset||trigerr_clr)
begin
trigerr_cnt_i <= 12'h0;
end else if(st == L2Err_st)
trigerr_cnt_i <= trigerr_cnt_i + 1'b1;
else
trigerr_cnt_i <= trigerr_cnt_i;

assign rdocmd_f = rdocmd_c || abortcmd_c;

endmodule
