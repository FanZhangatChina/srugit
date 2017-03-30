`timescale 1ns / 1ps

// ALICE/PHOS SRU
// This module read data from DTC buffers, build raw data and send it to siu_emulator.
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module ddl_fee_if(
	output						DtcRamclkb,
	output	[39:0]			DtcRamenb,
	output  	[9:0]	   		DtcRamaddrb,
	input 	[1319:0]	   	DtcRamdoutb,
	output 						DtcRamReadConfirm,
	
//	input		  					CDHVer,
	input 	[31:0] 			cdh_w0,
	input 	[31:0] 			cdh_w1,
	input 	[31:0] 			cdh_w2,
	input 	[31:0] 			cdh_w3,
	input 	[31:0] 			cdh_w4,
	input 	[31:0] 			cdh_w5,
	input 	[31:0] 			cdh_w6,
	input 	[31:0] 			cdh_w7,
	input 	[31:0] 			cdh_w8,
	input 	[31:0] 			cdh_w9,	

	input	   [79:0]   		rdo_cfg,
		
	input 	[1:0]				sclkphasecnt,
	input							STrigErrFlag,
	
	input							EventRdySent,
	output						ddl_tx_start,

	output [31:0]				ddl_ecnt,
	output [31:0]				ddl_if_debug,
	
	input 						siu_reset,
	input 						siu_foCLK,
	inout  [31:0] 				siu_fbd,
	inout 						siu_fbten_n,
	inout 						siu_fbctrl_n,
	input 						siu_fiben_n,
	input 						siu_fidir,
	input 						siu_filf_n,
	output 						siu_fobsy_n
    );

wire    [39:0]			DtcMask;
reg						EventRdySent_i = 1'b0;

assign   DtcMask = rdo_cfg[39:0];
assign 	DtcRamclkb = siu_foCLK;

wire [31:0] rcu_trailer0;
wire [31:0] rcu_trailer1;
wire [31:0] rcu_trailer2;
wire [31:0] rcu_trailer3;
wire [31:0] rcu_trailer4;
wire [31:0] rcu_trailer5;
wire [31:0] rcu_trailer6;
wire [31:0] rcu_trailer7;
wire [31:0] rcu_trailer8;

reg [5:0] 	cnt = 6'd0;
reg [18:0] 	Payloadcnt = 19'h0;
reg [39:0] 	DtcMask_i = 40'hfffff_fffff;
reg  			ddl_tx_start_i = 1'b0;
reg  			DtcRamReadConfirm_i = 1'b0;
reg [39:0]	DtcRamenb_i = 40'h0;
reg [9:0]	DtcRamaddrb_i = 10'h0;

wire [32:0] DtcRamD_i [39:0] ;
wire [39:0] DtcRamFlag_i;
wire 			DtcRamEndFlag;

assign 		ddl_tx_start 			= ddl_tx_start_i;
assign      DtcRamReadConfirm 	= DtcRamReadConfirm_i;
assign 		DtcRamenb 				= DtcRamenb_i;
assign		DtcRamaddrb 			= DtcRamaddrb_i;

genvar i;
generate 
for(i=0; i<40; i=i+1)
begin: DtcRamDataLoad
assign DtcRamD_i[i] = DtcRamdoutb[((i+1)*33-1) : ((i+1)*33-33)];
assign DtcRamFlag_i[i] = DtcRamdoutb[((i+1)*33-1)] & DtcRamenb_i[i];
end
endgenerate

assign DtcRamEndFlag = (DtcRamFlag_i == 40'h0) ? 1'b0 : 1'b1;

wire [31:0] siu_fbd_i;
wire siu_fbten_n_i;
wire siu_fbctrl_n_i;
reg [31:0] siu_fbd_o = 32'h0;
reg siu_fbten_n_o = 1'b1;
reg siu_fbctrl_n_o = 1'b1;
reg [31:0] ddl_ecnt_i = 32'h0;
wire siu_tx_en;

assign siu_fbd = (siu_fidir & (~ siu_fiben_n)) ? siu_fbd_o : 32'hZ;
assign siu_fbctrl_n =  (siu_fidir & (~ siu_fiben_n)) ? siu_fbctrl_n_o : 1'bZ;
assign siu_fbten_n =  (siu_fidir & (~ siu_fiben_n)) ? siu_fbten_n_o : 1'bZ;

assign siu_fbten_n_i = siu_fidir ? 1'b1 : siu_fbten_n;
assign siu_fbctrl_n_i = siu_fidir ? 1'b1 : siu_fbctrl_n;
assign siu_fbd_i = siu_fidir ? 32'h0 : siu_fbd;
assign ddl_ecnt = ddl_ecnt_i;

assign siu_fobsy_n = 1'b1;
assign ddl_tx_rd_clk = siu_foCLK;

wire [31:0] ReplyPayload = 32'h0;
wire 			ReplyReq = 1'b0;
reg 			ReplyAck = 1'b0;
assign 		siu_tx_en = siu_fidir & (~siu_fiben_n) & siu_filf_n;

reg [31:0]	ddl_if_debug_i = 32'h0;
assign 		ddl_if_debug = ddl_if_debug_i;

parameter 	TX_IDLE 				= 15'b000_0000_0000_0001; 
parameter 	ReplyTxSend_st 	= 15'b000_0000_0000_0010; 
parameter 	ReplyTxAck_st 		= 15'b000_0000_0000_0100; 
parameter 	EventTxSend_st 	= 15'b000_0000_0000_1000; 
parameter 	EventTxEnd_st 		= 15'b000_0000_0001_0000; 
parameter 	TX_EVENT_GAP 		= 15'b000_0000_0010_0000; 
parameter 	CDHSend_st 			= 15'b000_0000_0100_0000;
parameter 	RamChk_st 			= 15'b000_0000_1000_0000;
parameter 	RamRdStart_st 		= 15'b000_0001_0000_0000;
parameter 	RamRd_st 			= 15'b000_0010_0000_0000;
parameter 	RamSwitch_st 		= 15'b000_0100_0000_0000;
parameter	TrailerStart_st 	= 15'b000_1000_0000_0000;
parameter 	TrailerSend_st 	= 15'b001_0000_0000_0000;
parameter 	RamAllStart_st		= 15'b010_0000_0000_0000;
parameter 	RamRdWait_st		= 15'b100_0000_0000_0000;

reg [14:0] st = TX_IDLE;
reg [4:0] gap_timer = 5'h0;

always @(posedge siu_foCLK)
ddl_if_debug_i <= {3'h0,siu_fbten_n, siu_fbctrl_n, siu_fiben_n, siu_fidir, siu_filf_n, 9'h0,st};

always @(posedge siu_foCLK)
EventRdySent_i <= EventRdySent;

(* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="15'b000_0000_0000_0001"*) 

always @(posedge siu_foCLK)
if(siu_reset)
begin
siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;
//ReplyAck <= 1'b0;
gap_timer <= 5'h0;
ddl_ecnt_i <= 32'h0;

cnt <= 6'h0;
DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= 19'h0;
ddl_tx_start_i <= 1'b0;
DtcMask_i <= 40'hfffff_fffff;
DtcRamReadConfirm_i <= 1'b0;

st <= TX_IDLE;
end else case(st)
TX_IDLE : begin
siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;
gap_timer <= 5'h0;
ddl_ecnt_i <= ddl_ecnt_i;

cnt <= 6'h0;
DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= 19'h0;
ddl_tx_start_i <= 1'b0;
DtcMask_i <= 40'hfffff_fffff;
DtcRamReadConfirm_i <= 1'b0;

if(EventRdySent_i)
st <= CDHSend_st;
else
st <= TX_IDLE;
end

CDHSend_st : begin
gap_timer <= 5'h0;
ddl_ecnt_i <= ddl_ecnt_i;

DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= 19'h0;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= 40'hfffff_fffff;
DtcRamReadConfirm_i <= 1'b0;

if(siu_tx_en)
	begin	
		siu_fbctrl_n_o <= 1'b1;//
		siu_fbten_n_o <= 1'b0;
		case(cnt)
		6'd0 : siu_fbd_o <= cdh_w0;
		6'd1 : siu_fbd_o <= cdh_w1;
		6'd2 : siu_fbd_o <= cdh_w2;
		6'd3 : siu_fbd_o <= cdh_w3;
		6'd4 : siu_fbd_o <= cdh_w4;
		6'd5 : siu_fbd_o <= cdh_w5;
		6'd6 : siu_fbd_o <= cdh_w6;
		6'd7 : siu_fbd_o <= cdh_w7;
		6'd8 : siu_fbd_o <= cdh_w8;
		6'd9 : siu_fbd_o <= cdh_w9;
		default : siu_fbd_o <= 32'h0;
		endcase
		
//	if(((cnt == 6'd7) && (~CDHVer)) || ((cnt == 6'd9) && CDHVer))
	if(cnt == 6'd9)
		if(STrigErrFlag)
		st <= TrailerStart_st;
		else
		st	<= RamAllStart_st;
	else
		st <= CDHSend_st;
		
		cnt <= cnt + 1'b1;
	end
else
	begin
	siu_fbctrl_n_o <= 1'b1;
	siu_fbten_n_o <= 1'b1;
	st <= CDHSend_st;
	cnt <= cnt;
	end
end

//Ram////////////////////////////////////////////////////
RamAllStart_st : begin
DtcRamenb_i <= 40'h1;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= 19'h0;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask;
cnt <= 6'd10;
DtcRamReadConfirm_i <= 1'b1;

siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;//For simulation
siu_fbten_n_o <= 1'b1;
st <= RamChk_st;
end

RamChk_st : begin
DtcRamenb_i <= DtcRamenb_i;
DtcRamaddrb_i <= 10'h0;

siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;//For simulation
siu_fbten_n_o <= 1'b1;

cnt <= cnt;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;
DtcRamReadConfirm_i <= 1'b1;

if(DtcMask_i[0])
st <= RamSwitch_st;
else
st <= RamRdStart_st;
end

RamRdStart_st : begin
DtcRamenb_i <= DtcRamenb_i;
DtcRamaddrb_i <= DtcRamaddrb_i;

siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;//For simulation
siu_fbten_n_o <= 1'b1;

cnt <= cnt;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;
DtcRamReadConfirm_i <= 1'b1;

st <= RamRd_st;
end

RamRd_st : begin
DtcRamenb_i <= DtcRamenb_i;
cnt <= cnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;
DtcRamReadConfirm_i <= 1'b1;

if(siu_tx_en)
begin
		if(DtcRamEndFlag)
		begin
		siu_fbd_o <= 32'h0;
		siu_fbctrl_n_o <= 1'b1;
		siu_fbten_n_o <= 1'b1;
		
		Payloadcnt <= Payloadcnt;
		DtcRamaddrb_i <= DtcRamaddrb_i;
		st <= RamSwitch_st;
		end
	else
		begin
		case(cnt)
		6'd10 : siu_fbd_o <= DtcRamD_i[0][31:0];
		6'd11 : siu_fbd_o <= DtcRamD_i[1][31:0];
		6'd12 : siu_fbd_o <= DtcRamD_i[2][31:0];
		6'd13 : siu_fbd_o <= DtcRamD_i[3][31:0];
		6'd14 : siu_fbd_o <= DtcRamD_i[4][31:0];
		////////////////////////////////////
		6'd15 : siu_fbd_o <= DtcRamD_i[5][31:0];
		6'd16 : siu_fbd_o <= DtcRamD_i[6][31:0];
		6'd17 : siu_fbd_o <= DtcRamD_i[7][31:0];
		6'd18 : siu_fbd_o <= DtcRamD_i[8][31:0];
		6'd19 : siu_fbd_o <= DtcRamD_i[9][31:0];
		//DTC10//////////////////////////////
		6'd20 : siu_fbd_o <= DtcRamD_i[10][31:0];
		6'd21 : siu_fbd_o <= DtcRamD_i[11][31:0];
		6'd22 : siu_fbd_o <= DtcRamD_i[12][31:0];
		6'd23 : siu_fbd_o <= DtcRamD_i[13][31:0];
		6'd24 : siu_fbd_o <= DtcRamD_i[14][31:0];
		//DTC15//////////////////////////////
		6'd25 : siu_fbd_o <= DtcRamD_i[15][31:0];
		6'd26 : siu_fbd_o <= DtcRamD_i[16][31:0];
		6'd27 : siu_fbd_o <= DtcRamD_i[17][31:0];
		6'd28 : siu_fbd_o <= DtcRamD_i[18][31:0];
		6'd29 : siu_fbd_o <= DtcRamD_i[19][31:0];
		//DTC20//////////////////////////////

		6'd30 : siu_fbd_o <= DtcRamD_i[20][31:0];
		6'd31 : siu_fbd_o <= DtcRamD_i[21][31:0];
		6'd32 : siu_fbd_o <= DtcRamD_i[22][31:0];
		6'd33 : siu_fbd_o <= DtcRamD_i[23][31:0];
		6'd34 : siu_fbd_o <= DtcRamD_i[24][31:0];
		//DTC25//////////////////////////////
		6'd35 : siu_fbd_o <= DtcRamD_i[25][31:0];
		6'd36 : siu_fbd_o <= DtcRamD_i[26][31:0];
		6'd37 : siu_fbd_o <= DtcRamD_i[27][31:0];
		6'd38 : siu_fbd_o <= DtcRamD_i[28][31:0];
		6'd39 : siu_fbd_o <= DtcRamD_i[29][31:0];
		//DTC30//////////////////////////////
		6'd40 : siu_fbd_o <= DtcRamD_i[30][31:0];
		6'd41 : siu_fbd_o <= DtcRamD_i[31][31:0];
		6'd42 : siu_fbd_o <= DtcRamD_i[32][31:0];
		6'd43 : siu_fbd_o <= DtcRamD_i[33][31:0];
		6'd44 : siu_fbd_o <= DtcRamD_i[34][31:0];
		//DTC35//////////////////////////////
		6'd45 : siu_fbd_o <= DtcRamD_i[35][31:0];
		6'd46 : siu_fbd_o <= DtcRamD_i[36][31:0];
		6'd47 : siu_fbd_o <= DtcRamD_i[37][31:0];
		6'd48 : siu_fbd_o <= DtcRamD_i[38][31:0];
		6'd49 : siu_fbd_o <= DtcRamD_i[39][31:0];

		default : siu_fbd_o <= 32'h0;
		endcase
		siu_fbctrl_n_o <= 1'b1;
		//siu_fbctrl_n_o <= 1'b0;//For simulation
		siu_fbten_n_o <= 1'b0;
		
		Payloadcnt <= Payloadcnt + 19'h1;
		DtcRamaddrb_i <= DtcRamaddrb_i + 10'd1;
		st <= RamRdWait_st;
		end

	end
else
	begin
	Payloadcnt <= Payloadcnt;
	DtcRamaddrb_i <= DtcRamaddrb_i;
	st <= RamRd_st;
	end
end

RamRdWait_st : begin
DtcRamenb_i <= DtcRamenb_i;
DtcRamaddrb_i <= DtcRamaddrb_i;
DtcRamReadConfirm_i <= 1'b1;

siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;

cnt <= cnt;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;

st <= RamRd_st;
end


RamSwitch_st : begin
DtcRamenb_i <= {DtcRamenb_i[38:0],1'b0};
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
cnt <= cnt + 6'd1;
DtcMask_i <= {1'b1,DtcMask_i[39:1]};
DtcRamReadConfirm_i <= 1'b1;


siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;

if(cnt == 6'd50)
st <= TrailerStart_st;
else
st <= RamChk_st;
end

TrailerStart_st : begin
cnt <= 6'd50;
DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;
DtcRamReadConfirm_i <= 1'b1;


siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;

st <= TrailerSend_st;
end

TrailerSend_st : begin
DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;
DtcRamReadConfirm_i <= 1'b0;

if(siu_tx_en)
	begin
	cnt <= cnt + 6'h1;
	siu_fbctrl_n_o <= 1'b1;
	//siu_fbctrl_n_o <= 1'b0;//For simulation
	siu_fbten_n_o <= 1'b0;

	//Trailer////////////////////////////
	case(cnt)
	6'd50 : siu_fbd_o <= rcu_trailer0;
	6'd51 : siu_fbd_o <= rcu_trailer1;
	6'd52 : siu_fbd_o <= rcu_trailer2;
	6'd53 : siu_fbd_o <= rcu_trailer3;
	6'd54 : siu_fbd_o <= rcu_trailer4;
	6'd55 : siu_fbd_o <= rcu_trailer5;
	6'd56 : siu_fbd_o <= rcu_trailer6;
	6'd57 : siu_fbd_o <= rcu_trailer7;
	6'd58 : siu_fbd_o <= rcu_trailer8;
	default: siu_fbd_o <= 32'h0;
	endcase

	end
else
	begin
	siu_fbd_o <= 32'h0;
	siu_fbctrl_n_o <= 1'b1;
	siu_fbten_n_o <= 1'b1;

	cnt <= cnt;
	end

	if(cnt == 6'd58)
	st <= EventTxEnd_st;
	else
	st <= TrailerSend_st;
end

EventTxEnd_st : begin
siu_fbd_o <= 32'h64;
siu_fbctrl_n_o <= 1'b0;
siu_fbten_n_o <= 1'b0;
ReplyAck <= 1'b0;
gap_timer <= 5'h0;
ddl_ecnt_i <= ddl_ecnt_i + 1'b1;
DtcRamReadConfirm_i <= 1'b0;
cnt <= 6'd0;


DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;


st <= TX_EVENT_GAP;
end

TX_EVENT_GAP : begin
siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;
ReplyAck <= 1'b0;
ddl_ecnt_i <= ddl_ecnt_i;
cnt <= 6'd0;

DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= Payloadcnt;
ddl_tx_start_i <= 1'b1;
DtcMask_i <= DtcMask_i;
DtcRamReadConfirm_i <= 1'b0;

if(gap_timer == 5'd20)
	begin
	gap_timer <= 5'h0;
	st <= TX_IDLE;
	end 
else
	begin
	gap_timer <= gap_timer + 5'd1;
	st <= TX_EVENT_GAP;
	end
end

default: begin
siu_fbd_o <= 32'h0;
siu_fbctrl_n_o <= 1'b1;
siu_fbten_n_o <= 1'b1;
gap_timer <= 5'h0;
ddl_ecnt_i <= ddl_ecnt_i;
DtcRamReadConfirm_i <= 1'b0;
cnt <= 6'h0;

DtcRamenb_i <= 40'h0;
DtcRamaddrb_i <= 10'h0;
Payloadcnt <= 19'h0;
ddl_tx_start_i <= 1'b0;
DtcMask_i <= 40'h0;

st <= TX_IDLE;
end
endcase  

parameter rcu_ver = 10'h2;
parameter rcu_addr = 9'h0;
parameter rcu_trailer_num= 7'h9;

assign rcu_trailer0 = {2'b10,4'd0,7'h0,Payloadcnt};
assign rcu_trailer1 = {2'b10,4'd1,26'h0};
assign rcu_trailer2 = {2'b10,4'd2,26'h0};
assign rcu_trailer3 = {2'b10,4'd3,26'h0};
assign rcu_trailer4 = {2'b10,4'd4,6'h0,rdo_cfg[19:0]};
assign rcu_trailer5 = {2'b10,4'd5,6'h0,rdo_cfg[39:20]};
assign rcu_trailer6 = {2'b10,4'd6,6'h0,rdo_cfg[59:40]};
assign rcu_trailer7 = {2'b10,4'd7,1'h0,rdo_cfg[79:60],3'h0,sclkphasecnt};
assign rcu_trailer8 = {2'b11,4'd8,rcu_ver,rcu_addr,rcu_trailer_num};

endmodule
