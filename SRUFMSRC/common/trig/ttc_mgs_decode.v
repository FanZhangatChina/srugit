`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

`define DLY #1
module ttc_mgs_decode(
	 input 				gclk_40m,
	 
	 //ttc parallel signals
	 input [7:0] 		ttc_saddr,
	 input [7:0] 		ttc_dout,
	 input 				ttc_doutstr,

	 output reg 		ttc_l2r = 1'b0,
	 output  			ttc_l2a,
	 output reg 		ttc_feereset = 1'b0,
	 
	 input 				trig_mode,
	 input [11:0] 		unttc_event_id2,
	 input [11:0] 		ttc_mini_event_id,
	 input [7:0] 		cdh_blk_att,
	 input [5:0] 		trigerr,

//	 input					CDHVer,
	 input  [7:0]			ParReq,				
	 output [31:0] 		cdh_w0,
	 output reg [31:0] 	cdh_w1 = 32'h0,
	 output reg [31:0] 	cdh_w2 = 32'h0,
	 output reg [31:0] 	cdh_w3 = 32'h0,
	 output reg [31:0] 	cdh_w4 = 32'h0,
	 output reg [31:0] 	cdh_w5 = 32'h0,
	 output reg [31:0] 	cdh_w6 = 32'h0,
	 output reg [31:0] 	cdh_w7 = 32'h0,
	 output reg [31:0] 	cdh_w8 = 32'h0,
	 output reg [31:0] 	cdh_w9 = 32'h0,
	 
	 output reg [31:0]	L2aMes8Cnt = 32'h0,
	 
    input 					reset
    );	 

	 reg [11:4] 	L1_word1 = 8'h0;	
	 reg [11:0] 	L2a_word1 = 12'h0;	
	 reg [11:0] 	L2a_word2 = 12'h0;	
	 reg [11:0] 	L2a_word3 = 12'h0;	
	 reg [1:0] 		L2a_word4 = 2'h0;	
	 reg [11:0] 	L2a_word5 = 12'h0;	
	 reg [11:0] 	L2a_word6 = 12'h0;		 
	 reg [11:0] 	L2a_word7 = 12'h0;	
	 reg [11:0] 	L2a_word8 = 12'h0;
	 
	 reg [11:0] 	L2a_word9 = 12'h0;	
	 reg [11:0] 	L2a_word10 = 12'h0;		 
	 reg [11:0] 	L2a_word11 = 12'h0;	
	 reg [11:0] 	L2a_word12 = 12'h0;
	 reg [11:0] 	L2a_word13 = 12'h0;
	 
	 reg [11:0] 	roi_word2 = 12'h0;	
	 reg [11:0] 	roi_word3 = 12'h0;	
	 reg [11:0] 	roi_word4 = 12'h0;	

	 wire [3:0] 	ttc_mgs_header;
	 wire [11:0] 	ttc_mgs_data;
	 
//********************************************************************//
//L1 message
//Decode L1 message
always @(posedge gclk_40m)
if(ttc_doutstr & (ttc_mgs_header == 4'h1))
L1_word1 <= `DLY ttc_mgs_data[11:4]; 
else
L1_word1 <= `DLY L1_word1;
//L1 message
//********************************************************************//

//********************************************************************//
//L2a message
reg [12:0] L2_mes_strobe = 13'b0;

parameter st1  = 13'b0_0000_0000_0001;
parameter st2  = 13'b0_0000_0000_0010;
parameter st3  = 13'b0_0000_0000_0100;
parameter st4  = 13'b0_0000_0000_1000;
parameter st5  = 13'b0_0000_0001_0000;
parameter st6  = 13'b0_0000_0010_0000;
parameter st7  = 13'b0_0000_0100_0000;
parameter st8  = 13'b0_0000_1000_0000;
parameter st9  = 13'b0_0001_0000_0000;
parameter st10 = 13'b0_0010_0000_0000;
parameter st11 = 13'b0_0100_0000_0000;
parameter st12 = 13'b0_1000_0000_0000;
parameter st13 = 13'b1_0000_0000_0000;


   reg [12:0] st = st1;
   reg [12:0] L2_st = st1;

   (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="13'b0_0000_0000_0001" *) 


   always @(posedge gclk_40m)
	if(reset)
	L2a_word1 <= `DLY 12'h0;
	else if(L2_mes_strobe[0])
	L2a_word1 <= `DLY ttc_mgs_data;
	else
	L2a_word1 <= `DLY L2a_word1;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word2 <= `DLY 12'h0;
	else if(L2_mes_strobe[1])
	L2a_word2 <= `DLY ttc_mgs_data;
	else
	L2a_word2 <= `DLY L2a_word2;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word3 <= `DLY 12'h0;
	else if(L2_mes_strobe[2])
	L2a_word3 <= `DLY ttc_mgs_data;
	else
	L2a_word3 <= `DLY L2a_word3;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word4 <= `DLY 2'h0;
	else if(L2_mes_strobe[3])
	L2a_word4 <= `DLY ttc_mgs_data[1:0];
	else
	L2a_word4 <= `DLY L2a_word4;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word5 <= `DLY 12'h0;
	else if(L2_mes_strobe[4])
	L2a_word5 <= `DLY ttc_mgs_data;
	else
	L2a_word5 <= `DLY L2a_word5;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word6 <= `DLY 12'h0;
	else if(L2_mes_strobe[5])
	L2a_word6 <= `DLY ttc_mgs_data;
	else
	L2a_word6 <= `DLY L2a_word6;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word7 <= `DLY 12'h0;
	else if(L2_mes_strobe[6])
	L2a_word7 <= `DLY ttc_mgs_data;
	else
	L2a_word7 <= `DLY L2a_word7;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word8 <= `DLY 12'h0;
	else if(L2_mes_strobe[7])
	L2a_word8 <= `DLY ttc_mgs_data;
	else
	L2a_word8 <= `DLY L2a_word8;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word9 <= `DLY 12'h0;
	else if(L2_mes_strobe[8])
	L2a_word9 <= `DLY ttc_mgs_data;
	else
	L2a_word9 <= `DLY L2a_word9;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word10 <= `DLY 12'h0;
	else if(L2_mes_strobe[9])
	L2a_word10 <= `DLY ttc_mgs_data;
	else
	L2a_word10 <= `DLY L2a_word10;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word11 <= `DLY 12'h0;
	else if(L2_mes_strobe[10])
	L2a_word11 <= `DLY ttc_mgs_data;
	else
	L2a_word11 <= `DLY L2a_word11;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word12 <= `DLY 12'h0;
	else if(L2_mes_strobe[11])
	L2a_word12 <= `DLY ttc_mgs_data;
	else
	L2a_word12 <= `DLY L2a_word12;

   always @(posedge gclk_40m)
	if(reset)
	L2a_word13 <= `DLY 12'h0;
	else if(L2_mes_strobe[12])
	L2a_word13 <= `DLY ttc_mgs_data;
	else
	L2a_word13 <= `DLY L2a_word13;
	
	always @(posedge gclk_40m)
	if(reset)
	L2aMes8Cnt <=  32'h0;
	else if(L2_mes_strobe[7])
	L2aMes8Cnt <=  L2aMes8Cnt + 32'h1;
	else
	L2aMes8Cnt <=  L2aMes8Cnt;

	reg ttc_l2aMesRdy = 1'b0;
   always @(posedge gclk_40m)
	if(reset)
	ttc_l2aMesRdy <= 1'b0;
//	else if((CDHVer&L2_mes_strobe[12])|((~CDHVer)&L2_mes_strobe[7]))
	else if(L2_mes_strobe[12])
	ttc_l2aMesRdy <= 1'b1;
	else
	ttc_l2aMesRdy <= 1'b0;
	
	assign ttc_l2a = ttc_l2aMesRdy;

   always @(posedge gclk_40m)
	if(reset)
	begin
	st <= `DLY st1;
	L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
	end else
	
	if(ttc_doutstr)
	case(st)
		st1 : 
		if(ttc_mgs_header == 4'h3)
		begin
		st <= `DLY st2;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0001;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st2 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st3;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0010;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st3 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st4;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0100;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end

		st4 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st5;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_1000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end

		st5 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st6;
		L2_mes_strobe <= `DLY 13'b0_0000_0001_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end

		st6 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st7;
		L2_mes_strobe <= `DLY 13'b0_0000_0010_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end

		st7 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st8;
		L2_mes_strobe <= `DLY 13'b0_0000_0100_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st8 : 
		if(ttc_mgs_header == 4'h4)
		begin
//			if(CDHVer)
//			begin st <= `DLY st9; end
//			else
//			begin st <= `DLY st1; end

			begin st <= `DLY st9; end
					
		L2_mes_strobe <= `DLY 13'b0_0000_1000_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end		
		
		st9 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st10;
		L2_mes_strobe <= `DLY 13'b0_0001_0000_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st10 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st11;
		L2_mes_strobe <= `DLY 13'b0_0010_0000_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st11 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st12;
		L2_mes_strobe <= `DLY 13'b0_0100_0000_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st12 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st13;
		L2_mes_strobe <= `DLY 13'b0_1000_0000_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
		
		st13 : 
		if(ttc_mgs_header == 4'h4)
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b1_0000_0000_0000;
		end
		else
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end		
		
	default:
		begin
		st <= `DLY st1;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
		end
	endcase
else
	begin
		st <= st;
		L2_mes_strobe <= `DLY 13'b0_0000_0000_0000;
	end

//L2a message
//********************************************************************//

//********************************************************************//
//L2r message
	reg L2r_st = 1'b0;
   parameter L2r_st1 = 1'b0;
   parameter L2r_st2 = 1'b1;
	
   always @(posedge gclk_40m)
	if(reset)
	begin
	L2r_st <= `DLY L2r_st1;
	end else
	
	case(L2r_st)
		L2r_st1 : 
		if(ttc_doutstr & (ttc_mgs_header == 4'h5))
		begin
		L2r_st <= `DLY L2r_st2;
		end
		else
		begin
		L2r_st <= `DLY L2r_st1;
		end
		
		L2r_st2 : 
		begin
		L2r_st <= `DLY L2r_st1;
		end
	default: begin L2r_st <= `DLY L2r_st1; 
	end
	endcase

always @(posedge gclk_40m)
if(reset)
begin
ttc_l2r <= 1'b0;
L2_st <= st1;
end 
else case(L2_st)
st1 : begin
ttc_l2r <= 1'b0;

if(ttc_doutstr)
L2_st <= st2;
else
L2_st <= st1;
end

st2 : begin
ttc_l2r <= 1'b0;

if(ttc_doutstr)
L2_st <= st2;
else
L2_st <= st3;
end

st3 : begin
ttc_l2r <= 1'b0;

if(ttc_mgs_header == 4'h5)
L2_st <= st4;
else if(ttc_mgs_header == 4'h3)
L2_st <= st5;
else
L2_st <= st1;
end

st4 : begin
ttc_l2r <= 1'b1;

L2_st <= st1;
end

st5 : begin
ttc_l2r <= 1'b0;

L2_st <= st1;
end

default : begin
ttc_l2r <= 1'b0;

L2_st <= st1;
end
endcase

//********************************************************************//
//RoI message
   parameter RoI_st1 = 4'b0001;
   parameter RoI_st2 = 4'b0010;
   parameter RoI_st3 = 4'b0100;
   parameter RoI_st4 = 4'b1000;


   reg [3:0] RoI_st = RoI_st1;
	reg [3:1] RoI_mes_strobe = 3'h0;

   always @(posedge gclk_40m)
	if(reset)
	roi_word2 <= `DLY 12'h0;
	else if(RoI_mes_strobe[1])
	roi_word2 <= `DLY ttc_mgs_data;
	else
	roi_word2 <= `DLY roi_word2;

   always @(posedge gclk_40m)
	if(reset)
	roi_word3 <= `DLY 12'h0;
	else if(RoI_mes_strobe[2])
	roi_word3 <= `DLY ttc_mgs_data;
	else
	roi_word3 <= `DLY roi_word3;

   always @(posedge gclk_40m)
	if(reset)
	roi_word4 <= `DLY 12'h0;
	else if(RoI_mes_strobe[3])
	roi_word4 <= `DLY ttc_mgs_data;
	else
	roi_word4 <= `DLY roi_word4;

   always @(posedge gclk_40m)
	if(reset)
	begin
	RoI_st <= `DLY RoI_st1;
	RoI_mes_strobe <= `DLY 3'b000;
	end else
	
	if(ttc_doutstr)
	case(RoI_st)
		RoI_st1 : 
		begin
		if(ttc_mgs_header == 4'h6)
		RoI_st <= `DLY RoI_st2;
		else
		RoI_st <= `DLY RoI_st1;
		RoI_mes_strobe <= `DLY 3'b000;
		end
		
		RoI_st2 : 
		if(ttc_mgs_header == 4'h7)
		begin
		RoI_st <= `DLY RoI_st3;
		RoI_mes_strobe <= `DLY 3'b001;
		end
		else
		begin
		RoI_st <= `DLY RoI_st1;
		RoI_mes_strobe <= `DLY 3'b000;
		end
		
		RoI_st3 : 
		if(ttc_mgs_header == 4'h7)
		begin
		RoI_st <= `DLY RoI_st4;
		RoI_mes_strobe <= `DLY 3'b010;
		end
		else
		begin
		RoI_st <= `DLY RoI_st1;
		RoI_mes_strobe <= `DLY 3'b000;
		end

		RoI_st4 : 
		if(ttc_mgs_header == 4'h7)
		begin
		RoI_st <= `DLY RoI_st1;
		RoI_mes_strobe <= `DLY 3'b100;
		end
		else
		begin
		RoI_st <= `DLY RoI_st1;
		RoI_mes_strobe <= `DLY 3'b000;
		end

	default:
		begin
		RoI_st <= `DLY RoI_st1;
		RoI_mes_strobe <= `DLY 3'b000;
		end
	endcase
	else begin
		RoI_st <= RoI_st;
		RoI_mes_strobe <= `DLY 3'b000;
		end
//RoI message
//********************************************************************//


//********************************************************************//
//FEE reset command
	reg ttc_feereset_st = 1'b0;
   parameter ttc_feereset_st1 = 1'b0;
   parameter ttc_feereset_st2 = 1'b1;
	
   always @(posedge gclk_40m)
	if(reset)
	begin
	ttc_feereset_st <= `DLY ttc_feereset_st1;
	ttc_feereset <= `DLY 1'b0;
	end else
	
	case(ttc_feereset_st)
		ttc_feereset_st1 : 
		if(ttc_doutstr & (ttc_mgs_header == 4'h8))
		begin
		ttc_feereset_st <= `DLY ttc_feereset_st2;
		ttc_feereset <= `DLY 1'b1;
		end
		else
		begin
		ttc_feereset_st <= `DLY ttc_feereset_st1;
		ttc_feereset <= `DLY 1'b0;
		end
		
		ttc_feereset_st2 : 
		begin
		ttc_feereset_st <= `DLY ttc_feereset_st1;
		ttc_feereset <= `DLY 1'b1;
		end
	default: begin ttc_feereset_st <= `DLY ttc_feereset_st1; ttc_feereset <= `DLY 1'b0; end
	endcase
//FEE reset command
//********************************************************************//


//cdh_w0[31:0]
//An optional field, filled with a fixed value
localparam [31:0] cdh_blk_len = 32'hffffffff; 
//Fixed Data format version identifier
localparam [7:0]  cdhv2_format_ver = 8'h02; //* 20-03-2013 : Change cdh_format_ver
localparam [7:0]  cdhv3_format_ver = 8'h03; //* 20-03-2013 : Change cdh_format_ver
wire [15:0] FEE_st_err;

assign FEE_st_err[0] = trigerr[0];
assign FEE_st_err[1] = trigerr[1];
assign FEE_st_err[9] = trigerr[2];
assign FEE_st_err[10] = trigerr[3];
assign FEE_st_err[12] = trigerr[4];
assign FEE_st_err[13] = trigerr[5];

assign FEE_st_err[3:2] = 2'h0;
assign FEE_st_err[4] = trig_mode ? 1'b0 : 1'b1;//Software trigger: Trigger info unavailable
assign FEE_st_err[8:5] = 4'h0;

assign FEE_st_err[11] = 1'b0;
assign FEE_st_err[15:14] = 2'h0;

assign ttc_mgs_header = ttc_saddr[7:4];
assign ttc_mgs_data = {ttc_saddr[3:0],ttc_dout[7:0]};

assign cdh_w0 = cdh_blk_len;

   always @(posedge gclk_40m)
	if(reset)
	begin
	cdh_w1 <= 32'h0;
	end else
	if(trig_mode)
		begin 	
//			if(CDHVer)
//				cdh_w1 <= {cdhv3_format_ver[7:0],2'b00,L1_word1[11:4],2'b00,L2a_word1[11:0]}; 
//			else
//				cdh_w1 <= {cdhv2_format_ver[7:0],2'b00,L1_word1[11:4],2'b00,L2a_word1[11:0]}; 
//			if(CDHVer)
				cdh_w1 <= {cdhv3_format_ver[7:0],2'b00,L1_word1[11:4],2'b00,L2a_word1[11:0]}; 
//			else
//				cdh_w1 <= {cdhv2_format_ver[7:0],2'b00,L1_word1[11:4],2'b00,L2a_word1[11:0]}; 
				
		end 
	else
		begin
//			if(CDHVer)
//			cdh_w1 <= {cdhv3_format_ver[7:0],2'b00,8'h0,2'b00,12'h0}; 
//			else
//			cdh_w1 <= {cdhv2_format_ver[7:0],2'b00,8'h0,2'b00,12'h0}; 
			
//			if(CDHVer)
			cdh_w1 <= {cdhv3_format_ver[7:0],2'b00,8'h0,2'b00,12'h0}; 
//			else
//			cdh_w1 <= {cdhv2_format_ver[7:0],2'b00,8'h0,2'b00,12'h0}; 
		end//Not in TTC mode
		//if(CDHVer) //CDH V3.0
//cdhv3_format_ver
   always @(posedge gclk_40m)
	if(reset)
	begin
	cdh_w2 <= 32'h0;
	end else
	if(trig_mode)
	begin 	
//		if(CDHVer)
//			cdh_w2 <= {ParReq, L2a_word2[11:0],L2a_word3[11:0]}; 
//		else
//			cdh_w2 <= {8'h0,L2a_word2[11:0],L2a_word3[11:0]};
			
//		if(CDHVer)
			cdh_w2 <= {ParReq, L2a_word2[11:0],L2a_word3[11:0]}; 
//		else
//			cdh_w2 <= {8'h0,L2a_word2[11:0],L2a_word3[11:0]};
	end 
	else
	begin 	cdh_w2 <= {8'h0,12'h0,unttc_event_id2[11:0]}; end//Not in TTC mode

//cdh_w3 = {Block Attributes [31:24], Partipating Sub-Detectors[23:0]};
//When running without the ALICE Trigger system, the "Partipating Sub-Detectors" 
//field can be loaded with any value 
//The block attributes is an optional field that can be used freely by the detectors 
//groups to encode specific information such as the event type. If unused, this field 
//should be set to zero.
   always @(posedge gclk_40m)
	if(reset)
		begin
			cdh_w3<= 32'h0;
		end 
	else
//		if(CDHVer)
//			cdh_w3 <= {cdh_blk_att[7:0],L2a_word9[7:0],L2a_word10[11:0],L2a_word11[11:8]};
//			//cdh_w3 <= {cdh_blk_att[7:0],L2a_word11[11:8],L2a_word10[11:0],L2a_word9[7:0]};
//		else
//			cdh_w3 <= {cdh_blk_att[7:0],L2a_word5[11:0],L2a_word6[11:0]}; 
			
//		if(CDHVer)
			cdh_w3 <= {cdh_blk_att[7:0],L2a_word9[7:0],L2a_word10[11:0],L2a_word11[11:8]};
			//cdh_w3 <= {cdh_blk_att[7:0],L2a_word11[11:8],L2a_word10[11:0],L2a_word9[7:0]};
//		else
//			cdh_w3 <= {cdh_blk_att[7:0],L2a_word5[11:0],L2a_word6[11:0]}; 
			

//The Mini-event ID is a mandatory field. When running without the ALICE Trigger system, the Mini-event ID 
//field must be set to zero	
   always @(posedge gclk_40m)
	if(reset)
		begin
			cdh_w4<= 32'h0;
		end 
	else
		if(trig_mode)
			begin 	
					cdh_w4 <= {4'h0,FEE_st_err[15:0],L2a_word1[11:0]};				
			end 
		else
			begin 	
				cdh_w4 <={4'h0,FEE_st_err[15:0],12'h0};
			end//Not in TTC mode

//Trigger classes low [0-31]
//When running without the ALICE Trigger system, this 
//field can be loaded with any value 
   always @(posedge gclk_40m)
	if(reset)
	begin
	cdh_w5<= 32'h0;
	end else
//		if(CDHVer)
//			cdh_w5 <= {L2a_word10[3:0],L2a_word11[11:0],L2a_word12[11:0],L2a_word13[11:8]};
//		else
//			cdh_w5 <= {L2a_word6[7:0],L2a_word7[11:0],L2a_word8[11:0]};
			
//		if(CDHVer)
			cdh_w5 <= {L2a_word10[3:0],L2a_word11[11:0],L2a_word12[11:0],L2a_word13[11:8]};
//		else
//			cdh_w5 <= {L2a_word6[7:0],L2a_word7[11:0],L2a_word8[11:0]};

   always @(posedge gclk_40m)
	if(reset)
		begin
			cdh_w6<= 32'h0;
		end 
	else
		begin 	
//		if(CDHVer)
			cdh_w6 <= {L2a_word8[11:0],L2a_word9[11:10],L2a_word9[9:0],L2a_word10[11:4]};
//		else
//			cdh_w6 <= {roi_word4[3:0],10'h0,L2a_word4[1:0],L2a_word5[11:0],L2a_word6[11:8]};
//		end 
////		if(CDHVer)
////			cdh_w6 <= {L2a_word8[11:0],L2a_word9[11:10],L2a_word9[9:0],L2a_word10[11:4]};
////		else
////			cdh_w6 <= {roi_word4[3:0],10'h0,L2a_word4[1:0],L2a_word5[11:0],L2a_word6[11:8]};
		end 
		

   always @(posedge gclk_40m)
	if(reset)
		begin
			cdh_w7<= 32'h0;
		end 
	else
		begin 
//			if(CDHVer)
			cdh_w7 <= {L2a_word5[7:0],L2a_word6[11:0],L2a_word7[11:0]}; 
//			else
//		   cdh_w7 <= {roi_word2[11:0],roi_word3[11:0],roi_word4[11:4]};
			
////			if(CDHVer)
////			cdh_w7 <= {L2a_word5[7:0],L2a_word6[11:0],L2a_word7[11:0]}; 
////			else
////		   cdh_w7 <= {roi_word2[11:0],roi_word3[11:0],roi_word4[11:4]};
		end 

   always @(posedge gclk_40m)
	if(reset)
	begin
	cdh_w8<= 32'h0;
	end else
			cdh_w8 <= {roi_word4[3:0],24'h0,L2a_word5[11:8]};

   always @(posedge gclk_40m)
	if(reset)
		begin
			cdh_w9<= 32'h0;
		end 
	else
		begin
		cdh_w9 <= {roi_word2[11:0],roi_word3[11:0],roi_word4[11:4]};
		end
	
endmodule
