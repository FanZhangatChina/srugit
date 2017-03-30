//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : memory_interface
//* File            : memory_interface.v
//* Description     : FEE register management module
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*     18-01-2013 : Initial release
//*	  06-03-2013 : Add command WR/RD handle shake mechanism. Output cmd_ack signal, high active. 
//*     It is asserted after 250 ns of @negedge of cmd_exec.
//*     FMVER : 5007
//*	  01-24-04-2013 : Add HGTh, LG Supperssion SW 
//*	  01-10-01-2014 : Parameter  LGSEN_Init,  FEEFMVer  
//Last modified: 2014-02-19-15-11
//*******************************************************************************
`timescale 1ns / 1ps
module memory_interface
#(
parameter LGSEN_Init = 1'b1,
parameter FEEFMVer = 16'h5042
)(
input wire reset,
input wire clk_40m,

input wire cmd_exec,
output reg cmd_ack = 1'b0,
input wire cmd_rw,
input wire [7:0] cmd_addr,
input wire [15:0] cmd_rx,
output reg [15:0] cmd_tx = 16'h0,

output reg [4:0] fee_addr = 5'h0,
input wire [3:0] reg_st,
output reg [2:0] reg_en = 3'h0,

output reg [7:0] Thyst_H = 8'd75,
output reg [7:0] Toti_H = 8'd80,

input wire [2:0] temp_toi,
output [31:0] altrochmask,
//output reg dcsresetaltro = 1'b0,
//output reg dcsresetall = 1'b0,
output reg dcsresetcnt = 1'b0,
output reg Hv_update_cmd = 1'b0,

//For TVI monitoring
input wire adc_read_finish,
input wire [9:0] adc_result,
input wire [3:0] adc_cnt,

//For HV Update
output reg [9:0] ram_data_out0 = 10'h0,
output reg [9:0] ram_data_out1 = 10'h0,
output reg [9:0] ram_data_out2 = 10'h0,
output reg [9:0] ram_data_out3 = 10'h0,
input wire [2:0] dac_cnt,

input wire [15:0] event_rdo_cnt,
input wire [15:0] L0cnt,
input wire [15:0] L1cnt,
input wire [15:0] L2ACNT,
input wire [15:0] L2RCNT,	
input wire [15:0] CmdCnt,
output reg LGSEN = 1'b1,
//output LGSEN,
input wire [31:0] HGOverFlag,
			
input [15:0] GErrSt,
input [15:0] ErrALTROCmd,
input [15:0] ErrALTRORdo,	
output reg [15:0] ErrFpgaCmd = 16'h0,
output 		 ErrClr,

//For Card_SN module
output reg Card_SN_W_cmd = 1'b0,
output reg [9:0] Card_SN_W = 10'h0,
input wire [9:0] Card_SN_R 
);

//FEE Firmware version
parameter bc_ver = FEEFMVer;
//reg LGSEN = LGSEN_Init;
wire [31:0] HGSaSt;
assign HGSaSt = ~HGOverFlag;

reg RCmdErr = 1'b0;
reg WCmdErr = 1'b0;
reg ErrClr_i = 1'b0;
assign ErrClr = ErrClr_i | reset;

always @(posedge clk_40m)
if(ErrClr)
ErrFpgaCmd <= 16'h0;
else if(RCmdErr|WCmdErr)
ErrFpgaCmd <= {cmd_rw,1'b1,6'h0,cmd_addr};
else
ErrFpgaCmd <= ErrFpgaCmd;

always @(posedge clk_40m)
Thyst_H <= Toti_H - 8'h5;

reg [15:0] altrochmask0 = 16'h0, altrochmask1 = 16'h0;
assign altrochmask = {altrochmask1,altrochmask0};

//addr: 0x50~0x5E
reg [9:0] TEMP_IC13 = 10'h0,D4V2 = 10'h0,D4V2C = 10'h0,D3V3 = 10'h0,D3V3C = 10'h0,TEMP_IC14 = 10'h0,
A3V3 = 10'h0,A3V3C = 10'h0,A13V5 = 10'h0,A13V5C = 10'h0,TEMP_IC15 = 10'h0,AM6V = 10'h0,AM6VC = 10'h0,A6V = 10'h0,A6VC = 10'h0;

//addr: 0x60~0x7F
reg [9:0] hv_reg0 = 10'h0,hv_reg1 = 10'h0,hv_reg2 = 10'h0,hv_reg3 = 10'h0,hv_reg4 = 10'h0,hv_reg5 = 10'h0,hv_reg6 = 10'h0,
hv_reg7 = 10'h0,hv_reg8 = 10'h0,hv_reg9 = 10'h0,hv_reg10 = 10'h0,hv_reg11 = 10'h0,hv_reg12 = 10'h0,hv_reg13 = 10'h0,hv_reg14 = 10'h0,hv_reg15 = 10'h0;
reg [9:0] hv_reg16 = 10'h0,hv_reg17 = 10'h0,hv_reg18 = 10'h0,hv_reg19 = 10'h0,hv_reg20 = 10'h0,hv_reg21 = 10'h0,hv_reg22 = 10'h0,
hv_reg23 = 10'h0,hv_reg24 = 10'h0,hv_reg25 = 10'h0,hv_reg26 = 10'h0,hv_reg27 = 10'h0,hv_reg28 = 10'h0,hv_reg29 = 10'h0,hv_reg30 = 10'h0,hv_reg31 = 10'h0;
	
reg [7:0] tcnt = 8'h0;
parameter CmdWait_s = 0;  parameter CmdExe_s = 1; 
parameter CmdRd_s = 2;    parameter CmdWr_s = 3; 
parameter CmdAck_s = 4;
reg [2:0] st = CmdWait_s;

always @(posedge clk_40m)
if(reset)
begin
tcnt <= 8'd0;
cmd_ack <= 1'b0;
st <= CmdWait_s;
end else case(st)
CmdWait_s : begin
tcnt <= 8'd0;
cmd_ack <= 1'b0;

if(cmd_exec)
st <= CmdExe_s;
else
st <= CmdWait_s;
end

CmdExe_s : begin
tcnt <= 8'd0;
cmd_ack <= 1'b0;

if(cmd_rw)
st <= CmdRd_s;
else
st <= CmdWr_s;
end

CmdRd_s : begin
tcnt <= tcnt + 8'd1;
cmd_ack <= 1'b0;

if(tcnt == 8'd10)
st <= CmdAck_s;
else
st <= CmdRd_s;
end

CmdWr_s : begin
tcnt <= tcnt + 8'd1;
cmd_ack <= 1'b0;

if(tcnt == 8'd10)
st <= CmdAck_s;
else
st <= CmdWr_s;
end

CmdAck_s : begin
tcnt <= tcnt + 8'd1;
cmd_ack <= 1'b1;

if(tcnt == 8'd12)
st <= CmdWait_s;
else
st <= CmdAck_s;

//if(tcnt == 8'd12)
//st <= CmdAck_s;
//else
//st <= CmdWait_s;
end

default: begin
tcnt <= 8'd0;
cmd_ack <= 1'b0;

st <= CmdWait_s;
end
endcase

always @(posedge clk_40m)
	 if(reset)
	 begin
	 cmd_tx <=   16'h0;
	 RCmdErr <= 1'b0;
	 end
	 else
	 begin
		//if(cmd_rw && cmd_exec)//read
		if(st == CmdRd_s)
			case(cmd_addr)
			
			8'h01: begin cmd_tx <=   {12'h0,reg_en}; RCmdErr <= 1'b0; end
			8'h02: begin cmd_tx <=   {15'h0,LGSEN}; RCmdErr <= 1'b0; end
			8'h03: begin cmd_tx <=   {11'h0,fee_addr}; RCmdErr <= 1'b0; end
			//8'h04: begin cmd_tx <=   {8'h0,Thyst_H}; RCmdErr <= 1'b0; end
			8'h05: begin cmd_tx <=   {8'b0,Toti_H}; RCmdErr <= 1'b0; end
			
			8'h06: begin cmd_tx <=   altrochmask0; RCmdErr <= 1'b0; end
			8'h07: begin cmd_tx <=   altrochmask1; RCmdErr <= 1'b0; end
			8'h08: begin cmd_tx <=   HGSaSt[15:0]; RCmdErr <= 1'b0; end
			8'h09: begin cmd_tx <=   HGSaSt[31:16]; RCmdErr <= 1'b0; end
			
			8'h0a: begin cmd_tx <=   GErrSt; RCmdErr <= 1'b0; end
			8'h0b: begin cmd_tx <=   ErrFpgaCmd; RCmdErr <= 1'b0; end
			8'h0c: begin cmd_tx <=   ErrALTROCmd; RCmdErr <= 1'b0; end
			8'h0d: begin cmd_tx <=   ErrALTRORdo; RCmdErr <= 1'b0; end						
			
			8'h20 : begin cmd_tx <=   bc_ver;	 RCmdErr <= 1'b0; end
			8'h21: begin cmd_tx <=   L0cnt; RCmdErr <= 1'b0; end
			8'h22: begin cmd_tx <=   L1cnt; RCmdErr <= 1'b0; end
			8'h23: begin cmd_tx <=   L2ACNT; RCmdErr <= 1'b0; end
			8'h24: begin cmd_tx <=   L2RCNT; RCmdErr <= 1'b0; end
			8'h25: begin cmd_tx <=   event_rdo_cnt; RCmdErr <= 1'b0; end
			8'h26: begin cmd_tx <=   CmdCnt; RCmdErr <= 1'b0; end	
			
			8'h50 : begin cmd_tx <=   {6'h0,TEMP_IC13}; RCmdErr <= 1'b0; end
			8'h51 : begin cmd_tx <=   {6'h0,D4V2}; RCmdErr <= 1'b0; end
			8'h52 : begin cmd_tx <=   {6'h0,D4V2C}; RCmdErr <= 1'b0; end
			8'h53 : begin cmd_tx <=   {6'h0,D3V3}; RCmdErr <= 1'b0; end
			8'h54 : begin cmd_tx <=   {6'h0,D3V3C}; RCmdErr <= 1'b0; end
			
			8'h55 : begin cmd_tx <=   {6'h0,TEMP_IC15}; RCmdErr <= 1'b0; end
			8'h56 : begin cmd_tx <=   {6'h0,AM6V}; RCmdErr <= 1'b0; end
			8'h57 : begin cmd_tx <=   {6'h0,AM6VC}; RCmdErr <= 1'b0; end
			8'h58 : begin cmd_tx <=   {6'h0,A6V}; RCmdErr <= 1'b0; end
			8'h59 : begin cmd_tx <=   {6'h0,A6VC}; RCmdErr <= 1'b0; end
			
			8'h5a : begin cmd_tx <=   {6'h0,TEMP_IC14}; RCmdErr <= 1'b0; end
			8'h5b : begin cmd_tx <=   {6'h0,A3V3}; RCmdErr <= 1'b0; end
			8'h5c : begin cmd_tx <=   {6'h0,A3V3C}; RCmdErr <= 1'b0; end
			8'h5d : begin cmd_tx <=   {6'h0,A13V5}; RCmdErr <= 1'b0; end
			8'h5e : begin cmd_tx <=   {6'h0,A13V5C}; RCmdErr <= 1'b0; end
			
			8'h60: begin cmd_tx <=   {6'h0,hv_reg0}; RCmdErr <= 1'b0; end
			8'h61: begin cmd_tx <=   {6'h0,hv_reg1}; RCmdErr <= 1'b0; end
			8'h62: begin cmd_tx <=   {6'h0,hv_reg2}; RCmdErr <= 1'b0; end
			8'h63: begin cmd_tx <=   {6'h0,hv_reg3}; RCmdErr <= 1'b0; end
			8'h64: begin cmd_tx <=   {6'h0,hv_reg4}; RCmdErr <= 1'b0; end
			8'h65: begin cmd_tx <=   {6'h0,hv_reg5}; RCmdErr <= 1'b0; end
			8'h66: begin cmd_tx <=   {6'h0,hv_reg6}; RCmdErr <= 1'b0; end
			8'h67: begin cmd_tx <=   {6'h0,hv_reg7}; RCmdErr <= 1'b0; end

			8'h68: begin cmd_tx <=   {6'h0,hv_reg8}; RCmdErr <= 1'b0; end
			8'h69: begin cmd_tx <=   {6'h0,hv_reg9}; RCmdErr <= 1'b0; end
			8'h6a: begin cmd_tx <=   {6'h0,hv_reg10}; RCmdErr <= 1'b0; end
			8'h6b: begin cmd_tx <=   {6'h0,hv_reg11}; RCmdErr <= 1'b0; end
			8'h6c: begin cmd_tx <=   {6'h0,hv_reg12}; RCmdErr <= 1'b0; end
			8'h6d: begin cmd_tx <=   {6'h0,hv_reg13}; RCmdErr <= 1'b0; end
			8'h6e: begin cmd_tx <=   {6'h0,hv_reg14}; RCmdErr <= 1'b0; end
			8'h6f: begin cmd_tx <=   {6'h0,hv_reg15}; RCmdErr <= 1'b0; end

			8'h70: begin cmd_tx <=   {6'h0,hv_reg16}; RCmdErr <= 1'b0; end
			8'h71: begin cmd_tx <=   {6'h0,hv_reg17}; RCmdErr <= 1'b0; end
			8'h72: begin cmd_tx <=   {6'h0,hv_reg18}; RCmdErr <= 1'b0; end
			8'h73: begin cmd_tx <=   {6'h0,hv_reg19}; RCmdErr <= 1'b0; end
			8'h74: begin cmd_tx <=   {6'h0,hv_reg20}; RCmdErr <= 1'b0; end
			8'h75: begin cmd_tx <=   {6'h0,hv_reg21}; RCmdErr <= 1'b0; end
			8'h76: begin cmd_tx <=   {6'h0,hv_reg22}; RCmdErr <= 1'b0; end
			8'h77: begin cmd_tx <=   {6'h0,hv_reg23}; RCmdErr <= 1'b0; end
			
			8'h78: begin cmd_tx <=   {6'h0,hv_reg24}; RCmdErr <= 1'b0; end
			8'h79: begin cmd_tx <=   {6'h0,hv_reg25}; RCmdErr <= 1'b0; end
			8'h7a: begin cmd_tx <=   {6'h0,hv_reg26}; RCmdErr <= 1'b0; end
			8'h7b: begin cmd_tx <=   {6'h0,hv_reg27}; RCmdErr <= 1'b0; end
		    8'h7c: begin cmd_tx <=   {6'h0,hv_reg28}; RCmdErr <= 1'b0; end
			8'h7d: begin cmd_tx <=   {6'h0,hv_reg29}; RCmdErr <= 1'b0; end
			8'h7e: begin cmd_tx <=   {6'h0,hv_reg30}; RCmdErr <= 1'b0; end
			8'h7f: begin cmd_tx <=   {6'h0,hv_reg31}; RCmdErr <= 1'b0; end
			
			8'h80: begin cmd_tx <=   Card_SN_R; RCmdErr <= 1'b0; end

			default : begin cmd_tx <=   cmd_tx; RCmdErr <= 1'b1; end
			endcase			
		else
			begin
			cmd_tx <=   cmd_tx;
			RCmdErr <= 1'b0;
			end
	 end


//For writing registers or commands
always @(posedge clk_40m)
	 if(reset)
		begin		
		fee_addr <=   5'h00;
		Toti_H <=   8'd80;
		//Thyst_H <=   8'd75;
		reg_en <=   3'h7;	
						
		altrochmask0 <=   16'h0000;
		altrochmask1 <=   16'h0000;
		
//		dcsresetaltro <=   1'b1;
//		dcsresetall <=   1'b0;
		dcsresetcnt <=   1'b1;
		Card_SN_W_cmd <=   1'b0;
		Hv_update_cmd <=   1'b0;		
		Card_SN_W <=   10'h0;
		ErrClr_i <= 1'b0;
		
		LGSEN <= LGSEN_Init;
						
		hv_reg0 <=   10'h0;
		hv_reg1 <=   10'h0;
		hv_reg2 <=   10'h0;
		hv_reg3 <=   10'h0;
		hv_reg4 <=   10'h0;
		hv_reg5 <=   10'h0;
		hv_reg6 <=   10'h0;
		hv_reg7 <=   10'h0;		

		hv_reg8 <=   10'h0;
		hv_reg9 <=   10'h0;
		hv_reg10 <=   10'h0;
		hv_reg11 <=   10'h0;
		hv_reg12 <=   10'h0;
		hv_reg13 <=   10'h0;
		hv_reg14 <=   10'h0;
		hv_reg15 <=   10'h0;

		hv_reg16 <=   10'h0;
		hv_reg17 <=   10'h0;
		hv_reg18 <=   10'h0;
		hv_reg19 <=   10'h0;
		hv_reg20 <=   10'h0;
		hv_reg21 <=   10'h0;
		hv_reg22 <=   10'h0;
		hv_reg23 <=   10'h0;

		hv_reg24 <=   10'h0;
		hv_reg25 <=   10'h0;
		hv_reg26 <=   10'h0;
		hv_reg27 <=   10'h0;
		hv_reg28 <=   10'h0;
		hv_reg29 <=   10'h0;
		hv_reg30 <=   10'h0;
		hv_reg31 <=   10'h0;	
		WCmdErr <= 1'b0;

		end
		
	 else
	 begin
		//if((!cmd_rw) && cmd_exec)//write
		if(st == CmdWr_s)
			case(cmd_addr)
			8'h1 : reg_en <=   cmd_rx[2:0];
			8'h2 : LGSEN <= cmd_rx[0];
			8'h3 : fee_addr <=   cmd_rx[4:0];			
			//8'h4 : Thyst_H <=   cmd_rx[7:0];			
			8'h5 : Toti_H <=   cmd_rx[7:0];
			8'h6 : altrochmask0 <=   cmd_rx;
			8'h7 : altrochmask1 <=   cmd_rx;

			8'h1b: dcsresetcnt <=   1'b1;
			8'h1e: Hv_update_cmd <=   1'b1;
			8'h1f: ErrClr_i <= 1'b1;	
			
			8'h60: hv_reg0 <=   cmd_rx[9:0];
			8'h61: hv_reg1 <=   cmd_rx[9:0];
			8'h62: hv_reg2 <=   cmd_rx[9:0];
			8'h63: hv_reg3 <=   cmd_rx[9:0];
			8'h64: hv_reg4 <=   cmd_rx[9:0];
			8'h65: hv_reg5 <=   cmd_rx[9:0];
			8'h66: hv_reg6 <=   cmd_rx[9:0];
			8'h67: hv_reg7 <=   cmd_rx[9:0];

			8'h68: hv_reg8 <=   cmd_rx[9:0];
			8'h69: hv_reg9 <=   cmd_rx[9:0];
			8'h6a: hv_reg10 <=  cmd_rx[9:0];
			8'h6b: hv_reg11 <=  cmd_rx[9:0];
			8'h6c: hv_reg12 <=  cmd_rx[9:0];
			8'h6d: hv_reg13 <=  cmd_rx[9:0];
			8'h6e: hv_reg14 <=  cmd_rx[9:0];
			8'h6f: hv_reg15 <=  cmd_rx[9:0];

			8'h70: hv_reg16 <=   cmd_rx[9:0];
			8'h71: hv_reg17 <=   cmd_rx[9:0];
			8'h72: hv_reg18 <=   cmd_rx[9:0];
			8'h73: hv_reg19 <=   cmd_rx[9:0];
			8'h74: hv_reg20 <=   cmd_rx[9:0];
			8'h75: hv_reg21 <=   cmd_rx[9:0];
			8'h76: hv_reg22 <=   cmd_rx[9:0];
			8'h77: hv_reg23 <=   cmd_rx[9:0];
			
			8'h78: hv_reg24 <=   cmd_rx[9:0];
			8'h79: hv_reg25 <=   cmd_rx[9:0];
			8'h7a: hv_reg26 <=   cmd_rx[9:0];
			8'h7b: hv_reg27 <=   cmd_rx[9:0];
		    8'h7c: hv_reg28 <=   cmd_rx[9:0];
			8'h7d: hv_reg29 <=   cmd_rx[9:0];
			8'h7e: hv_reg30 <=   cmd_rx[9:0];
			8'h7f: hv_reg31 <=   cmd_rx[9:0];		
			
			8'h80: begin Card_SN_W <=   cmd_rx[9:0]; Card_SN_W_cmd <=   1'b1;end 	
			
			default: begin
			fee_addr <=   fee_addr;
			//Thyst_H <=   Thyst_H;	
			Toti_H <=   Toti_H;	
			reg_en <=   reg_en;	
							
			altrochmask0 <=   altrochmask0;
			altrochmask1 <=   altrochmask1;

			dcsresetcnt <=   1'b0;
			Card_SN_W_cmd <=   Card_SN_W_cmd;
			Hv_update_cmd <=   Hv_update_cmd;		
			Card_SN_W <=   Card_SN_W;
			ErrClr_i <= 1'b0;
			
			LGSEN <= LGSEN;
					
			hv_reg0 <=   hv_reg0;
			hv_reg1 <=   hv_reg1;
			hv_reg2 <=   hv_reg2;
			hv_reg3 <=   hv_reg3;
			hv_reg4 <=   hv_reg4;
			hv_reg5 <=   hv_reg5;
			hv_reg6 <=   hv_reg6;
			hv_reg7 <=   hv_reg7;		

			hv_reg8  <=   hv_reg8;
			hv_reg9  <=   hv_reg9;
			hv_reg10 <=   hv_reg10;
			hv_reg11 <=   hv_reg11;
			hv_reg12 <=   hv_reg12;
			hv_reg13 <=   hv_reg13;
			hv_reg14 <=   hv_reg14;
			hv_reg15 <=   hv_reg15;

			hv_reg16 <=   hv_reg16;
			hv_reg17 <=   hv_reg17;
			hv_reg18 <=   hv_reg18;
			hv_reg19 <=   hv_reg19;
			hv_reg20 <=   hv_reg20;
			hv_reg21 <=   hv_reg21;
			hv_reg22 <=   hv_reg22;
			hv_reg23 <=   hv_reg23;

			hv_reg24 <=   hv_reg24;
			hv_reg25 <=   hv_reg25;
			hv_reg26 <=   hv_reg26;
			hv_reg27 <=   hv_reg27;
			hv_reg28 <=   hv_reg28;
			hv_reg29 <=   hv_reg29;
			hv_reg30 <=   hv_reg30;
			hv_reg31 <=   hv_reg31;
			
			WCmdErr  <=   1'b0;	
		end
		endcase
			
		else
			begin
			fee_addr <=   fee_addr;
			//Thyst_H <=   Thyst_H;	
			Toti_H <=   Toti_H;	
			reg_en <=   reg_en;	
							
			altrochmask0 <=   altrochmask0;
			altrochmask1 <=   altrochmask1;

			dcsresetcnt <=   1'b0;
			Card_SN_W_cmd <=   Card_SN_W_cmd;
			Hv_update_cmd <=   Hv_update_cmd;		
			Card_SN_W <=   Card_SN_W;
			ErrClr_i <= 1'b0;
			
			LGSEN <= LGSEN;
					
			hv_reg0 <=   hv_reg0;
			hv_reg1 <=   hv_reg1;
			hv_reg2 <=   hv_reg2;
			hv_reg3 <=   hv_reg3;
			hv_reg4 <=   hv_reg4;
			hv_reg5 <=   hv_reg5;
			hv_reg6 <=   hv_reg6;
			hv_reg7 <=   hv_reg7;		

			hv_reg8 <=   hv_reg8;
			hv_reg9 <=   hv_reg9;
			hv_reg10 <=   hv_reg10;
			hv_reg11 <=   hv_reg11;
			hv_reg12 <=   hv_reg12;
			hv_reg13 <=   hv_reg13;
			hv_reg14 <=   hv_reg14;
			hv_reg15 <=   hv_reg15;

			hv_reg16 <=   hv_reg16;
			hv_reg17 <=   hv_reg17;
			hv_reg18 <=   hv_reg18;
			hv_reg19 <=   hv_reg19;
			hv_reg20 <=   hv_reg20;
			hv_reg21 <=   hv_reg21;
			hv_reg22 <=   hv_reg22;
			hv_reg23 <=   hv_reg23;

			hv_reg24 <=   hv_reg24;
			hv_reg25 <=   hv_reg25;
			hv_reg26 <=   hv_reg26;
			hv_reg27 <=   hv_reg27;
			hv_reg28 <=   hv_reg28;
			hv_reg29 <=   hv_reg29;
			hv_reg30 <=   hv_reg30;
			hv_reg31 <=   hv_reg31;
			
			WCmdErr <= 1'b0;	
			end

	 end
	 	 
//-------------------------------------------------------------------
always @(posedge clk_40m)
if(reset)	
begin
ram_data_out0 <=   10'h3ff;
ram_data_out1 <=   10'h3ff;
ram_data_out2 <=   10'h3ff;
ram_data_out3 <=   10'h3ff;
end
else
	begin
	case(dac_cnt)
	3'h0 : begin ram_data_out0 <=   hv_reg0; ram_data_out1 <=   hv_reg8; ram_data_out2 <=   hv_reg16; ram_data_out3 <=   hv_reg24;end	
	3'h1 : begin ram_data_out0 <=   hv_reg1; ram_data_out1 <=   hv_reg9; ram_data_out2 <=   hv_reg17; ram_data_out3 <=   hv_reg25;end	
	3'h2 : begin ram_data_out0 <=   hv_reg2; ram_data_out1 <=   hv_reg10; ram_data_out2 <=   hv_reg18; ram_data_out3 <=   hv_reg26;end	
	3'h3 : begin ram_data_out0 <=   hv_reg3; ram_data_out1 <=   hv_reg11; ram_data_out2 <=   hv_reg19; ram_data_out3 <=   hv_reg27;end	
	
	3'h4 : begin ram_data_out0 <=   hv_reg4; ram_data_out1 <=   hv_reg12; ram_data_out2 <=   hv_reg20; ram_data_out3 <=   hv_reg28;end	
	3'h5 : begin ram_data_out0 <=   hv_reg5; ram_data_out1 <=   hv_reg13; ram_data_out2 <=   hv_reg21; ram_data_out3 <=   hv_reg29;end	
	3'h6 : begin ram_data_out0 <=   hv_reg6; ram_data_out1 <=   hv_reg14; ram_data_out2 <=   hv_reg22; ram_data_out3 <=   hv_reg30;end	
	3'h7 : begin ram_data_out0 <=   hv_reg7; ram_data_out1 <=   hv_reg15; ram_data_out2 <=   hv_reg23; ram_data_out3 <=   hv_reg31;end	
	default : begin ram_data_out0 <=   10'h3ff; ram_data_out1 <=   10'h3ff; ram_data_out2 <=   10'h3ff; ram_data_out3 <=   10'h3ff;end	
	endcase
	end

always @(posedge adc_read_finish)
if(reset)
	begin
	TEMP_IC13 <=   10'h0a0;
	D4V2 <=   10'h1D9;
	D4V2C <=   10'h00C;
	D3V3 <=   10'h1C2;
	D3V3C <=   10'h011;
	
	TEMP_IC15 <=   10'h0a0;
	AM6V <=   10'h171;
	AM6VC <=   10'h014;
	A6V <=   10'h1E8;
	A6VC <=   10'h016;
	
	TEMP_IC14 <=   10'h0a0;
	A3V3 <=   10'h1C2;
	A3V3C <=   10'h014;
	A13V5 <=   10'h1D1;
	A13V5C <=   10'h0F;
	
	end
else
	begin
		case(adc_cnt)
		4'h1 : begin TEMP_IC13 <=   adc_result;  end
		4'h2 : begin TEMP_IC14 <=   adc_result;  end
		4'h3 : begin TEMP_IC15 <=   adc_result;  end
		
		
		4'h4 : begin D4V2 <=   adc_result; end
		4'h5 : begin A3V3 <=   adc_result; end
		4'h6 : begin AM6V <=   adc_result;  end
		4'h7 : 	begin 
				if(D4V2 > adc_result)
				D4V2C <=   D4V2 - adc_result;
				else
				D4V2C <=   10'h0;	
				end
		4'h8 : 	begin 
				if(A3V3 > adc_result)
				A3V3C <=   A3V3 - adc_result;
				else
				A3V3C <=   10'h0;
				end
		4'h9 : 	begin 
				if(adc_result > AM6V)
				AM6VC <=   adc_result - AM6V;
				else
				AM6VC <=   10'h0;	
				end		
				
		4'ha : begin D3V3 <=   adc_result; end
		4'hb : begin A13V5 <=   adc_result; end
		4'hc : begin A6V <=   adc_result;  end
		
		4'hd : 	begin 
				if(D4V2 > adc_result)
				D3V3C <=   D3V3 - adc_result;
				else
				D3V3C <=   10'h0;	
				end		
		4'he : 	begin 
				if(A13V5 > adc_result)
				A13V5C <=   A13V5 - adc_result;
				else
				A13V5C <=   10'h0;
				end
		4'hf,4'h0 : 	begin 
				if(A6V > adc_result)
				A6VC <=   A6V - adc_result;
				else
				A6VC <=   10'h0;
				end
		endcase
	end

endmodule
