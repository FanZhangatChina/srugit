`timescale 1ns / 1ps

// This module decode data from DTC link for EMCal SRU
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 11 July 2015

module dtc_rx_decoder(
		input 					bitclkdiv,
		input 					dtc_deser_align,
		input [15:0] 			dtc_deser_dout,

		output reg 				fee_flag = 1'b0,
		
		input						clkb,
		input						enb,
		input  [9:0]			addrb,
		output [32:0]			doutb,
		
		input 					ReadConfirm,
		input 					RamClr,
		output 					RamFlag,
		
		output reg  [63:0]   dcs_cmd_reply = 64'h0,
		output reg				dcs_cmd_update = 1'b0,
		 
		input 					reset
		);

		// Reg for DCS readout interface
		reg 				dcs_rpy_load = 1'b0;
		reg 				WrConfirm = 1'b0;
		
		wire 				clka;
		reg 				ena = 1'b0;
		reg 				wea = 1'b0;
		reg 	[9:0] 	addra = 10'h0;
		reg 	[32:0] 	dina = 33'h0; 

parameter reply_header 		= 16'hF7F7;		
parameter status_header 	= 16'hDCDC;
parameter event_header 		= 16'h5C5C;
//parameter sync_word 		= 16'hBC50;
parameter event_end_flag 	= 32'hC5D5C5D5; //
parameter event_dummy 		= 32'h80128012;

parameter ALIGN_st 		= 10'b00_0000_0001;
parameter Wait_st 		= 10'b00_0000_0010;
parameter Status_st 		= 10'b00_0000_0100;
parameter ReplyS1_st 	= 10'b00_0000_1000;
parameter ReplyS2_st 	= 10'b00_0001_0000;
parameter ReplyS3_st 	= 10'b00_0010_0000;
parameter ReplyS4_st 	= 10'b00_0100_0000;
parameter EventLow_st 	= 10'b00_1000_0000;
parameter EventHigh_st 	= 10'b01_0000_0000;
parameter EventEnd_st 	= 10'b10_0000_0000;

reg [9:0] st = ALIGN_st;

 (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="10'b00_0000_0001" *) 
		
always @(posedge bitclkdiv)
if(reset)
begin
fee_flag <= 1'b0;

ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;

st <= ALIGN_st;
end	else case(st)
ALIGN_st : begin
fee_flag <= 1'b0;

ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;

if(dtc_deser_align)
st <= Wait_st;
else
st <= ALIGN_st;
end

Wait_st: begin
fee_flag <= fee_flag;

ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h3_ff;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_cmd_update <= 1'b0;

if(dtc_deser_dout == reply_header)
dcs_rpy_load <= 1'b1;
else
dcs_rpy_load <= 1'b0;

if(dtc_deser_dout == status_header)
	st <= Status_st;
else if(dtc_deser_dout == reply_header)
	st <= ReplyS1_st;
else if(dtc_deser_dout == event_header)
	st <= EventLow_st;
else if(dtc_deser_align)
	st <= Wait_st;
else
	st <= ALIGN_st;
end

//status frame
Status_st : begin
fee_flag <= dtc_deser_dout[0];

ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;

st <= Wait_st;
end

// reply frame
ReplyS1_st : begin
fee_flag <= fee_flag;

ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b1;
dcs_cmd_update <= 1'b0;

st <= ReplyS2_st;
end

ReplyS2_st : begin
fee_flag <= fee_flag;
ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b1;
dcs_cmd_update <= 1'b0;

st <= ReplyS3_st;
end

ReplyS3_st : begin
fee_flag <= fee_flag;
ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b1;
dcs_cmd_update <= 1'b0;

st <= ReplyS4_st;
end

ReplyS4_st : begin
fee_flag <= fee_flag;
ena <= 1'b0;
wea <= 1'b0;
addra <= 10'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b1;

st <= Wait_st;
end

//event frame
EventLow_st : begin
fee_flag <= fee_flag;
ena <= 1'b1;
wea <= 1'b0;
addra <= addra;
dina <= {17'h0,dtc_deser_dout};
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;

st <= EventHigh_st;
end

EventHigh_st : begin
fee_flag <= fee_flag;
ena <= 1'b1;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;
WrConfirm <= 1'b0;

if({dtc_deser_dout,dina[15:0]} == event_dummy)
begin
wea <= 1'b0;
dina <= 33'h0;
addra <= addra;
st <= EventLow_st;
end else
	begin
		addra <= addra + 1'b1;
		wea <= 1'b1;
		if({dtc_deser_dout,dina[15:0]} == event_end_flag)
		begin
		dina <= {1'b1,dtc_deser_dout,dina[15:0]};
		st <= EventEnd_st;
		end
		else
		begin
		dina <= {1'b0,dtc_deser_dout,dina[15:0]};
		st <= EventLow_st;
		end
	end
end

//
EventEnd_st : begin
fee_flag <= fee_flag;

ena <= 1'b0;
wea <= 1'b0;
addra <= 11'h0;
dina <= 33'h0;
WrConfirm <= 1'b1;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;

st <= Wait_st;
end

default : begin
fee_flag <= 1'b0;

ena <= 1'b0;
wea <= 1'b0;
addra <= 11'h0;
dina <= 33'h0;
WrConfirm <= 1'b0;

dcs_rpy_load <= 1'b0;
dcs_cmd_update <= 1'b0;

st <= Wait_st;
end
endcase


assign clka = bitclkdiv;

DtcRam u_DtcRam (
  .clka(clka), // input clka
  .ena(ena), // input ena
  .wea(wea), // input [0 : 0] wea  port A write enable
  .addra(addra), // input [9 : 0] addra
  .dina(dina), // input [32 : 0] dina
  
  .clkb(clkb), // input clkb
  .enb(enb), // input enb
  .addrb(addrb), // input [9 : 0] addrb
  .doutb(doutb) // output [32 : 0] doutb
);

  
DtcRamMgt u_DtcRamMgt (
    .reset(reset), 
    .clk(bitclkdiv), 
    .WrConfirm(WrConfirm), 
    .ReadConfirm(ReadConfirm), 
    .RamClr(RamClr), 
    .RamFlag(RamFlag)
    );
  
//DCS inteface
always @(posedge bitclkdiv)
if(dcs_rpy_load)
dcs_cmd_reply <= {dcs_cmd_reply[47:0],dtc_deser_dout};
else
dcs_cmd_reply <= dcs_cmd_reply;

endmodule
