//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : altro_if
//* File            : altro_if.v
//* Description     : Top module of the DDL links
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//CSP num: 0,     1,     2,     3,     4,     5,     6,     7
//HG addr: 7'h2a, 7'h2e, 7'h25, 7'h21, 7'h31, 7'h35, 7'h3e, 7'h3a
//LG addr: 7'h2b, 7'h2f, 7'h24, 7'h20, 7'h30, 7'h34, 7'h3f, 7'h3b
//
//
//CSP num: 8,     9,     10,    11,    12,    13,    14,    15
//HG addr: 7'h0a, 7'h0e, 7'h05, 7'h01, 7'h41, 7'h45, 7'h4e, 7'h4a
//LG addr: 7'h0b, 7'h0f, 7'h04, 7'h00, 7'h40, 7'h44, 7'h4f, 7'h4b
//
//
//CSP num: 16,    17,    18,    19,    20,    21,    22,    23
//HG addr: 7'h28, 7'h2c, 7'h27, 7'h23, 7'h33, 7'h37, 7'h3c, 7'h38
//LG addr: 7'h29, 7'h2d, 7'h26, 7'h22, 7'h32, 7'h36, 7'h3d, 7'h39
//
//
//CSP num: 24,    25,    26,    27,    28,    29,    30,    31
//HG addr: 7'h08, 7'h0c, 7'h07, 7'h03, 7'h43, 7'h47, 7'h4c, 7'h48
//LG addr: 7'h09, 7'h0d, 7'h06, 7'h02, 7'h42, 7'h46, 7'h4d, 7'h49
//*
//*  Revision history:
//*	  06-03-2013 : Add ALTRO command handshaking (acmd_ack)
//*	  02-22-04-2013 : acmd_ack when broadcasting
//*	  01-23-04-2013 : HG,LG readout procedure
//*	  01-25-04-2013 : LG suppression 
//*	  02-25-04-2013 : CSP, HG, LG mapping modification
//*******************************************************************************
`timescale 1ns / 1ps

module altro_if(
	input wire rdoclk,	
	inout wire [39:0] bd,
	output reg writen = 1'b1,
	output reg cstbn = 1'b1,	
	input wire ackn,
	input wire trsfn,
	
	//read/writen
	input wire acmd_exec,
	input wire acmd_rw,
	input wire [19:0] acmd_addr,
	input wire [19:0] acmd_rx,
	output reg [19:0] acmd_tx = 20'h0,
    output reg acmd_ack = 1'b0,	
	
	input [31:0] altrochmask,
	input [4:0] fee_addr,

	input altrordo_cmd,
	input altroabort_cmd,// suppose  L2r is comming after 50us of level-1, if yes, upgrade firmware later. we test it first.
	
	input wire fifo_almost_full,
	output reg altro_chrdo_en = 1'b0,
	input con_busy,
	output reg ram_addrclr = 1'b0,
	
	input [31:0] altrochmask_LG,
	output reg [15:0] ErrALTROCmd = 16'h0,
	output reg [15:0] ErrALTRORdo = 16'h0,
	input  ErrClr,
		
	input reset
    );

wire rdoclk_n;

reg [38:0] bdout = 39'h0;
wire bdout_par;
wire [19:0] bdh, bdl;

reg InvalidInst = 1'b0;
reg CmdACKnErr1 = 1'b0;
reg CmdACKnErr2 = 1'b0;
reg CmdACKnErr3 = 1'b0;
reg CmdTRSFnErr1 = 1'b0;
reg CmdTRSFnErr2 = 1'b0;

//reg [63:0] altrochmask_i = 64'h0;
reg [31:0] altrochmask_i = 32'h0;
reg [6:0] ch_addr = 7'h0;
wire [38:0] chrdo_cmd;
//reg [2:0] altro_addr = 3'h0;
reg [6:0] rdo_addr = 7'h0;
wire LGFlag;
wire [31:0] LF;
assign LF = altrochmask_LG;
assign LGFlag = LF[31]&LF[30]&LF[29]&LF[28]&LF[27]&LF[26]&LF[25]&LF[24]
&LF[23]&LF[22]&LF[21]&LF[20]&LF[19]&LF[18]&LF[17]&LF[16]&LF[15]&LF[14]&LF[13]&LF[12]
&LF[11]&LF[10]&LF[9]&LF[8]&LF[7]&LF[6]&LF[5]&LF[4]&&LF[3]&LF[2]&&LF[1]&LF[0];

assign bd[39:20] = cstbn ? 20'bzzzzz_zzzzz_zzzzz_zzzzz : {bdout_par,bdout[38:20]};
assign bd[19:0] = (cstbn | writen)? 20'bzzzzz_zzzzz_zzzzz_zzzzz : bdout[19:0];

assign rdoclk_n = ~rdoclk;

assign bdout_par = bdout[38]^bdout[37]^bdout[36]^bdout[35]^bdout[34]^bdout[33]^bdout[32]^bdout[31]^bdout[30]^bdout[29]
^bdout[28]^bdout[27]^bdout[26]^bdout[25]^bdout[24]^bdout[23]^bdout[22]^bdout[21]^bdout[20];

//assign chrdo_cmd = {2'h0,fee_addr,altro_addr[2:0],ch_addr[3:0],5'h1A,20'h0};
assign chrdo_cmd = {2'h0,fee_addr,rdo_addr,5'h1A,20'h0};
parameter rpinc = {1'b1,13'h0,5'h19,20'h0};

always @(posedge rdoclk_n)
if(reset)
rdo_addr <= 7'h0;
else case(ch_addr[5:0])
6'h0 : rdo_addr <= {3'h2, 4'ha};
6'h1 : rdo_addr <= {3'h2, 4'he};
6'h2 : rdo_addr <= {3'h2, 4'h5};
6'h3 : rdo_addr <= {3'h2, 4'h1};
6'h4 : rdo_addr <= {3'h3, 4'h1};
6'h5 : rdo_addr <= {3'h3, 4'h5};
6'h6 : rdo_addr <= {3'h3, 4'he};
6'h7 : rdo_addr <= {3'h3, 4'ha};

6'd8 : rdo_addr <= {3'h0, 4'ha};
6'd9 : rdo_addr <= {3'h0, 4'he};
6'd10 : rdo_addr <= {3'h0, 4'h5};
6'd11 : rdo_addr <= {3'h0, 4'h1};
6'd12 : rdo_addr <= {3'h4, 4'h1};
6'd13 : rdo_addr <= {3'h4, 4'h5};
6'd14 : rdo_addr <= {3'h4, 4'he};
6'd15 : rdo_addr <= {3'h4, 4'ha};

6'd16 : rdo_addr <= {3'h2, 4'h8};
6'd17 : rdo_addr <= {3'h2, 4'hc};
6'd18 : rdo_addr <= {3'h2, 4'h7};
6'd19 : rdo_addr <= {3'h2, 4'h3};
6'd20 : rdo_addr <= {3'h3, 4'h3};
6'd21 : rdo_addr <= {3'h3, 4'h7};
6'd22 : rdo_addr <= {3'h3, 4'hc};
6'd23 : rdo_addr <= {3'h3, 4'h8};

6'd24 : rdo_addr <= {3'h0, 4'h8};
6'd25 : rdo_addr <= {3'h0, 4'hc};
6'd26 : rdo_addr <= {3'h0, 4'h7};
6'd27 : rdo_addr <= {3'h0, 4'h3};
6'd28 : rdo_addr <= {3'h4, 4'h3};
6'd29 : rdo_addr <= {3'h4, 4'h7};
6'd30 : rdo_addr <= {3'h4, 4'hc};
6'd31 : rdo_addr <= {3'h4, 4'h8};
//Low gain
//0,2,4,6 & 9,11,13,15
6'd32 : rdo_addr <= {3'h2, 4'hb};
6'd33 : rdo_addr <= {3'h2, 4'hf};
6'd34 : rdo_addr <= {3'h2, 4'h4};
6'd35 : rdo_addr <= {3'h2, 4'h0};
6'd36 : rdo_addr <= {3'h3, 4'h0};
6'd37 : rdo_addr <= {3'h3, 4'h4};
6'd38 : rdo_addr <= {3'h3, 4'hf};
6'd39 : rdo_addr <= {3'h3, 4'hb};

6'd40 : rdo_addr <= {3'h0, 4'hb};
6'd41 : rdo_addr <= {3'h0, 4'hf};
6'd42 : rdo_addr <= {3'h0, 4'h4};
6'd43 : rdo_addr <= {3'h0, 4'h0};
6'd44 : rdo_addr <= {3'h4, 4'h0};
6'd45 : rdo_addr <= {3'h4, 4'h4};
6'd46 : rdo_addr <= {3'h4, 4'hf};
6'd47 : rdo_addr <= {3'h4, 4'hb};

6'd48 : rdo_addr <= {3'h2, 4'h9};
6'd49 : rdo_addr <= {3'h2, 4'hd};
6'd50 : rdo_addr <= {3'h2, 4'h6};
6'd51 : rdo_addr <= {3'h2, 4'h2};
6'd52 : rdo_addr <= {3'h3, 4'h2};
6'd53 : rdo_addr <= {3'h3, 4'h6};
6'd54 : rdo_addr <= {3'h3, 4'hd};
6'd55 : rdo_addr <= {3'h3, 4'h9};

6'd56 : rdo_addr <= {3'h0, 4'h9};
6'd57 : rdo_addr <= {3'h0, 4'hd};
6'd58 : rdo_addr <= {3'h0, 4'h6};
6'd59 : rdo_addr <= {3'h0, 4'h2};
6'd60 : rdo_addr <= {3'h4, 4'h2};
6'd61 : rdo_addr <= {3'h4, 4'h6};
6'd62 : rdo_addr <= {3'h4, 4'hd};
6'd63 : rdo_addr <= {3'h4, 4'h9};

default: begin
rdo_addr <= 7'h0;
end
endcase
always @(posedge rdoclk)
if(reset)
acmd_tx <= 20'h0;
else if(ackn)
acmd_tx <= acmd_tx;
else
acmd_tx <= bd[19:0];

reg [15:0] TimeOutCnt = 16'h0;

parameter st0 = 0;
parameter stc1 = 1;
parameter stc2 = 2;
parameter stt1 = 3;
parameter stt2 = 4;
parameter stt3 = 5;
parameter stt4 = 6;
parameter stt5 = 7;
parameter stt6 = 8;
parameter stt7 = 9;
parameter stt8 = 10;
parameter stt9 = 11;
parameter stt10 = 12;
parameter stc3 = 13;
parameter stc4 = 15;
parameter stt4a = 14;
parameter stLG1 = 16;
parameter stLG2 = 17;

reg [4:0] st = st0;

always @(posedge rdoclk)
if(reset)
acmd_ack <= 1'b0;
else if(st == stc4)
acmd_ack <= 1'b1;
else
acmd_ack <= 1'b0;

always @(posedge rdoclk)
if(reset)
begin
ram_addrclr <= 1'b0;
bdout <= 39'h0;
writen <= 1'b0;
cstbn <= 1'b1;
TimeOutCnt <= 16'd0;
altro_chrdo_en <= 1'b0;
ch_addr <= 7'h0;
altrochmask_i <= 32'h0;

st <= st0;
end else

case(st)
st0 : begin
ram_addrclr <= 1'b0;
bdout <= 39'h0;
writen <= 1'b0;
cstbn <= 1'b1;
TimeOutCnt <= 16'd0;
altro_chrdo_en <= 1'b0;
ch_addr <= 7'h0;
altrochmask_i <= altrochmask[31:0];

if(acmd_exec)
st <= stc1;
else if(altrordo_cmd)
st <= stt2;
else if(altroabort_cmd)
st <= stt9;
else
st <= st0;

end

stc1 : begin
ram_addrclr <= 1'b0;
//bdout <= {acmd_addr[18:0],acmd_rx};
bdout <= {acmd_addr[18:17],fee_addr,acmd_addr[11:0],acmd_rx};
cstbn <= 1'b1;
TimeOutCnt <= 16'd0;

altro_chrdo_en <= 1'b0;
ch_addr <= 7'h0;
altrochmask_i <= altrochmask_i;

if(acmd_rw)
	begin
	writen <= 1'b1;
	end
else
	begin
	writen <= 1'b0;
	end
if(InvalidInst)
st <= st0; 
else
st <= stc2;
end

stc2 : begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b0; //Command start
writen <= writen;

altro_chrdo_en <= 1'b0;
ch_addr <= 7'h0;
altrochmask_i <= altrochmask_i;

if((TimeOutCnt == 6'd63)&acmd_addr[18])
begin
TimeOutCnt <= 16'd0;
st <= stc4;
end else if(TimeOutCnt[15])
	begin
	TimeOutCnt <= 16'd0;
	st <= st0;
	end
else if(ackn)
	begin
	TimeOutCnt <= 16'd1 + TimeOutCnt;
	st <= stc2;
	end
	else
	begin
	TimeOutCnt <= 16'd0;
	st <= stc3;
	end
end

stc3 : begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b1;
writen <= writen;

altro_chrdo_en <= 1'b0;
ch_addr <= 7'h0;
altrochmask_i <= altrochmask_i;

//if(TimeOutCnt == 6'd63)
if(TimeOutCnt[15])
begin
TimeOutCnt <= 16'd0;
st <= stc4;
end
else if(ackn)
		begin
		TimeOutCnt <= 16'd0;
		st <= stc4;
		end
		else
		begin
		TimeOutCnt <= TimeOutCnt + 16'd1;
		st <= stc3;
		end
end

stc4 : begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b1;
writen <= writen;

altro_chrdo_en <= 1'b0;
ch_addr <= 7'h0;
altrochmask_i <= altrochmask_i;

if(TimeOutCnt == 16'd4)
	begin
	TimeOutCnt <= 16'd0;
	st <= st0;
	end
else 
	begin
	TimeOutCnt <= TimeOutCnt + 16'd1;
	st <= stc4;
	end
end

stt2: begin
ram_addrclr <= 1'b0;
bdout <= 39'h0;
cstbn <= 1'b1;
writen <= 1'b0;
TimeOutCnt <= 6'd0;

altro_chrdo_en <= 1'b1;

altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if((ch_addr == 7'd32))
st <= stLG1;
else if((ch_addr == 7'd64))
st <= stt9;  //go to rpinc cmd
else if(altrochmask_i[0])
st <= stt3;
else
st <= stt4a;
end

stLG1 : begin
ram_addrclr <= 1'b0;
bdout <= 39'h0;
cstbn <= 1'b1;
writen <= 1'b0;
TimeOutCnt <= TimeOutCnt + 16'd1;

altro_chrdo_en <= 1'b1;

altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if(TimeOutCnt == 16'd40)
   if(LGFlag)
	st <= stt9;
	else
	st <= stLG2;
else
st <= stLG1;
end

stLG2 : begin
ram_addrclr <= 1'b0;
bdout <= 39'h0;
cstbn <= 1'b1;
writen <= 1'b0;
TimeOutCnt <= TimeOutCnt + 16'd1;

altro_chrdo_en <= 1'b1;

altrochmask_i <= altrochmask_LG;
ch_addr <= ch_addr;

if(altrochmask_LG[0])
st <= stt3;
else
st <= stt4a;
end

stt3: begin
ram_addrclr <= 1'b0;
bdout <= 39'h0;
cstbn <= 1'b1;
writen <= 1'b0;
TimeOutCnt <= 16'd0;

altro_chrdo_en <= 1'b1;

altrochmask_i <= {1'b0,altrochmask_i[31:1]};
ch_addr <= ch_addr + 7'h1;
st <= stt2;
end

stt4a : begin
bdout <= chrdo_cmd;
writen <= 1'b0;
TimeOutCnt <= 16'd0;

altro_chrdo_en <= 1'b1;

altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if(con_busy|fifo_almost_full)
begin
ram_addrclr <= 1'b0;
cstbn <= 1'b1;
st <= stt4a;
end
else
begin
ram_addrclr <= 1'b1;
cstbn <= 1'b0;
st <= stt4;
end
end

stt4 : begin
bdout <= bdout;
ram_addrclr <= 1'b1;
cstbn <= 1'b0;
writen <= 1'b0;
TimeOutCnt <= 16'd0;

altro_chrdo_en <= 1'b1;

altrochmask_i <= {1'b0,altrochmask_i[31:1]};
ch_addr <= ch_addr + 7'h1;

st <= stt5;
end

stt5:begin
bdout <= bdout;
ram_addrclr <= 1'b0;
cstbn <= 1'b0;
writen <= 1'b0;

altro_chrdo_en <= 1'b1;

altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if(~ackn)
begin
TimeOutCnt <= 16'd0;
st <= stt6;
end
//else if(TimeOutCnt == 6'd63)
else if(TimeOutCnt[15])
begin
TimeOutCnt <= 16'd0;
st <= stt2;
end
else
begin
TimeOutCnt <= TimeOutCnt + 16'd1;
st <= stt5;
end

end


stt6: begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b1;
writen <= 1'b0;

altro_chrdo_en <= 1'b1;
altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if(~trsfn)
begin
TimeOutCnt <= 16'd0;
st <= stt7;
end
//else if(TimeOutCnt == 6'd63)
else if(TimeOutCnt[15])
begin
TimeOutCnt <= 16'd0;
st <= stt2;
end
else
begin
TimeOutCnt <= TimeOutCnt + 16'd1;
st <= stt6;
end

end

stt7: begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b1;
writen <= 1'b0;

altro_chrdo_en <= 1'b1;
altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if(trsfn)
begin
TimeOutCnt <= 16'd0;
st <= stt2;
end
//else if(TimeOutCnt == 6'd63)
else if(TimeOutCnt[15])
begin
TimeOutCnt <= 16'd0;
st <= stt2;
end
else
begin
TimeOutCnt <= TimeOutCnt + 16'd1;
st <= stt7;
end

end

stt9 : begin
ram_addrclr <= 1'b0;
bdout <= rpinc;
cstbn <= 1'b1;
writen <= 1'b0;
TimeOutCnt <= 16'd0;

altro_chrdo_en <= 1'b1;
altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

st <= stt10;
end

stt10 : begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b0;
writen <= 1'b0;
TimeOutCnt <= TimeOutCnt + 16'd1;

altro_chrdo_en <= 1'b1;
altrochmask_i <= altrochmask_i;
ch_addr <= ch_addr;

if(TimeOutCnt == 16'd19)
st <= st0;
else
st <= stt10;
end

default: begin
ram_addrclr <= 1'b0;
bdout <= bdout;
cstbn <= 1'b1;
writen <= 1'b0;
TimeOutCnt <= 16'd0;

altro_chrdo_en <= 1'b0;
altrochmask_i <= 32'h0;
ch_addr <= 7'h0;
st <= st0;
end
endcase


always @(posedge rdoclk)
if(reset)
begin
InvalidInst <= 1'b0;
end else
if(acmd_exec)
	if(acmd_rw)//Read
		case(acmd_addr[4:0])
		5'h0, 5'h1, 5'h2, 5'h3, 5'h4, 5'h5, 5'h6, 5'h7, 5'h8, 5'h9, 5'ha,
		5'hb, 5'hc, 5'hd, 5'h10, 5'h11, 5'h12 : InvalidInst <= 1'b0;
		default : InvalidInst <= 1'b1;
		endcase
	else
		case(acmd_addr[4:0])
		5'h0, 5'h1, 5'h2, 5'h3, 5'h4, 5'h5, 5'h6, 5'h7, 5'h8, 5'h9, 5'ha,
		5'hb, 5'hc, 5'hd, 5'h18, 5'h19, 5'h1a, 5'h1b, 5'h1c, 5'h1d : InvalidInst <= 1'b0;
		default : InvalidInst <= 1'b1;
		endcase
else
	InvalidInst <= 1'b0;

	
always @(posedge rdoclk)
if(reset)
begin
CmdACKnErr1 <= 1'b0;
end else if((st == stc2)&TimeOutCnt[15])
CmdACKnErr1 <= 1'b1;
else
CmdACKnErr1 <= 1'b0;

always @(posedge rdoclk)
if(reset)
begin
CmdACKnErr2 <= 1'b0;
end else if((st == stc3)&TimeOutCnt[15])
CmdACKnErr2 <= 1'b1;
else
CmdACKnErr2 <= 1'b0;


always @(posedge rdoclk)
if(reset)
begin
CmdACKnErr3 <= 1'b0;
end else if((st == stt5)&TimeOutCnt[15])
CmdACKnErr3 <= 1'b1;
else
CmdACKnErr3 <= 1'b0;

always @(posedge rdoclk)
if(reset)
begin
CmdTRSFnErr1 <= 1'b0;
end else if((st == stt6)&TimeOutCnt[15])
CmdTRSFnErr1 <= 1'b1;
else
CmdTRSFnErr1 <= 1'b0;

always @(posedge rdoclk)
if(reset)
begin
CmdTRSFnErr2 <= 1'b0;
end else if((st == stt7)&TimeOutCnt[15])
CmdTRSFnErr2 <= 1'b1;
else
CmdTRSFnErr2 <= 1'b0;



always @(posedge rdoclk)
if(ErrClr)
begin
ErrALTRORdo <= 16'h0;
end else if(CmdACKnErr3)
ErrALTRORdo <= {1'b1, 3'h0, 5'h0, rdo_addr};
else if(CmdTRSFnErr1)
ErrALTRORdo <= {1'b0, 1'b1,2'h0, 5'h0, rdo_addr};
else if(CmdTRSFnErr2)
ErrALTRORdo <= {1'b0, 1'b0,1'b1,1'b0, 5'h0, rdo_addr};
else
ErrALTRORdo <= ErrALTRORdo;
//fee_addr,rdo_addr
always @(posedge rdoclk)
if(ErrClr)
begin
ErrALTROCmd <= 16'h0;
end else if(InvalidInst)
ErrALTROCmd <= {acmd_rw, 1'b1, 2'b00, acmd_addr[11:0]};
else if(CmdACKnErr1)
ErrALTROCmd <= {acmd_rw, 1'b0, 1'b1, 1'b0, acmd_addr[11:0]};
else if(CmdACKnErr2)
ErrALTROCmd <= {acmd_rw, 1'b0, 1'b0, 1'b1, acmd_addr[11:0]};
else
ErrALTROCmd <= ErrALTROCmd;


endmodule
