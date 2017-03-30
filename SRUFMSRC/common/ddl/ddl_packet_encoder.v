	//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : ddl_packet_encoder
//* File            : ddl_packet_encoder.v
//* Description     : DDL packet encoder
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*     05-02-2015 : Last modified
//*******************************************************************************
module ddl_packet_encoder(
	input 					rd_clk, 

//	input 		[15:0] 	tx_data,
//	input 					tx_data_valid,
//	output 					tx_rd_enable,
//	output reg 				tx_ack = 1'b0,

	output reg				rd_en = 1'b0,
	input			[16:0]	dout,
	input						empty,
	input						prog_empty,

	output reg				ddl_ReplyAck = 1'b0,
	input 					ddl_ReplyReq,
	input 		[31:0]  	ddl_Reply,
	
	output reg				ddl_DtstwAck = 1'b0,
//	input 					ddl_DtstwReq,
//	input 		[31:0]  	DTSTW,
	
	output  		[1:0] 	txchardispmode,
	output  		[1:0] 	txchardispval,
	output reg 	[1:0]  	tx_charisk = 2'b01,
	output reg 	[15:0] 	txd = 16'h50bc,
	
	input      	[15:0] 	diag_payload,
	input						ddl_xoff,
	
	input reset	
);

parameter s_delimiter = 16'h5555;  //D21.2,D21.2

	reg 					ddl_DtstwReq = 1'b0;
	reg 	[31:0]  		DTSTW = 32'h0;

reg rd = 1'b0;
wire rd_clk_n;
wire code_disp;				
reg txchardispmode_0 = 1'b0;
reg code_disp0=1'b0, code_disp1=1'b0, code_disp2=1'b0, code_disp3=1'b0;

assign rd_clk_n = ~rd_clk;
assign txchardispmode[1] = 1'b0;
assign txchardispmode[0] = txchardispmode_0;
assign txchardispval[1] = 1'b0;
assign txchardispval[0] = 1'b0;
assign code_disp = (code_disp0^code_disp1)^(code_disp2^code_disp3);

//---------------------------------------------------
wire [79:0] DtstwWire, ReplyWire;
reg [79:0] DdlCmdReg = 80'h0;

assign DtstwWire = {s_delimiter,DTSTW[15:0],DTSTW[15:0],DTSTW[31:16],DTSTW[31:16]};
assign ReplyWire = {s_delimiter,ddl_Reply[15:0],ddl_Reply[15:0],ddl_Reply[31:16],ddl_Reply[31:16]};
//----------------------------------------------------------------------------------

		
	always @(posedge rd_clk_n)
	if(reset)
		begin
		code_disp0 <= 1'b0;
		end 
		else if(tx_charisk == 2'b01)
				code_disp0 <= 1'b1;
			else
				begin
				case(txd[4:0])
				5'd0,5'd1, 5'd2, 5'd4, 5'd8, 5'd15, 5'd16, 5'd23, 5'd24, 5'd27, 5'd29,5'd30,5'd31 : code_disp0 <= 1'b1;
				default: code_disp0 <= 1'b0;
				endcase		
				end

	always @(posedge rd_clk_n)
	if(reset)
		begin
		code_disp1 <= 1'b0;
		end 
		else if(tx_charisk == 2'b01)
				code_disp1 <= 1'b0;
			else
				begin
				case(txd[7:5])
				3'h0,3'h4, 3'h7 : code_disp1 <= 1'b1;
				default: code_disp1 <= 1'b0;
				endcase
				end
		
	always @(posedge rd_clk_n)
	if(reset)
		begin
		code_disp2 <= 1'b0;
		end 
			else
				begin
				case(txd[12:8])
				5'd0,5'd1, 5'd2, 5'd4, 5'd8, 5'd15, 5'd16, 5'd23, 5'd24, 5'd27, 5'd29,5'd30,5'd31 : code_disp2 <= 1'b1;
				default: code_disp2 <= 1'b0;
				endcase		
				end
	always @( posedge rd_clk_n)
	if(reset)
		begin
		code_disp3 <= 1'b0;
		end
			else
				begin
				case(txd[15:13]) 
				3'h0,3'h4, 3'h7 : code_disp3 <= 1'b1;
				default: code_disp3 <= 1'b0;
				endcase
				end
				
reg crc_rst = 1'b0;
reg crc_ena = 1'b0;
wire [15:0] ddl_crc16b;
reg [15:0] dout_i = 16'h0, dout_ii = 16'h0;
reg [7:0] count = 8'h0;
reg [3:0] diagcnt = 4'h0;
//----------------------------------------------------------------------------------
//States are Wait_s, DiagFrame_s1, DiagFrame_s2, DiagFrame_s3, 
//DiagFrame_s4,FifoAck_s, FrameLoad_s, FrameEof_s,DtstwLoad_s,
//ReplyLoad_s, CmdLoad_s, CmdAck_s

parameter Wait_s = 4'd0; parameter DiagFrame_s1 = 4'd1;
parameter DiagFrame_s2 = 4'd2; parameter DiagFrame_s3 = 4'd3;
parameter DiagFrame_s4 = 4'd4; parameter FifoAck_s = 4'd5;
parameter FrameLoad_s = 4'd6; parameter FrameEof_s = 4'd7;
parameter DtstwLoad_s = 4'd8; parameter ReplyLoad_s = 4'd9;
parameter CmdLoad_s = 4'd10; parameter DtstwAck_s = 4'd11;
parameter ReplyAck_s = 4'd12;  parameter FifoCrc1_s = 4'd13;
parameter FifoHeader_s = 4'd14; parameter FifoCrc2_s = 4'd15;
parameter FifoCrc3_s = 5'd16;  parameter FifoCrc4_s = 5'd19;
parameter FifoRead2_s = 5'd17;  parameter FifoRead1_s = 5'd18;
parameter FifoEnd1_s = 5'd20;   parameter FifoEnd2_s = 5'd21;
parameter DtstwRdenH_s = 5'd22; parameter DtstwRdenL_s = 5'd23;
parameter DtstwRdataH_s = 5'd24; parameter DtstwRdataL_s = 5'd25;


reg [4:0] st = Wait_s;
reg [7:0] cnt = 8'd0;

	always @(posedge rd_clk)
	if(reset)
	begin
	rd <= 1'b0;
	txchardispmode_0 = 1'b1;
		
	tx_charisk <= 2'b01;
	txd <= 16'h50bc;

	st <= Wait_s;		
	end
	else case(st)
	Wait_s :
	begin
	rd <= 1'b0;
	txchardispmode_0 = 1'b1;
	
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
//	$display("hello %t", $realtime);

	if(ddl_DtstwReq)
//	st <= DtstwLoad_s;
	st <= DtstwRdenH_s;
	else 
	if(ddl_ReplyReq)
	st <= ReplyLoad_s;
	else if(ddl_xoff)
	st <= DiagFrame_s1;
	else if((!empty)&& diagcnt[3])
	st <= FifoAck_s;
	else
	st <= DiagFrame_s1;	
	end
	
//------------------------------------------------
	DiagFrame_s1 : begin
	rd <= code_disp^ rd;
	
	txchardispmode_0 = 1'b0;

	tx_charisk <= 2'b01;
   txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;	

	st <= DiagFrame_s2;
	end	

	//F7F7
	DiagFrame_s2 :begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;

	tx_charisk <= 2'b11;
	txd <= 16'hF7F7;
	
	st <= DiagFrame_s3;	
	end 
	
	DiagFrame_s3 :begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'h0;
	txd <= diag_payload;
	
	st <= DiagFrame_s4;	
	end 
	
	DiagFrame_s4 : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
	
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= Wait_s;	
	end	
	
//------------------------------------------------	
	FifoAck_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
//	$display("hello  fifoACK %t", $realtime);

	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
//	st <= FrameLoad_s;	
	st <= FifoRead1_s;	
	end
	
	FifoRead1_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
//	$display("hello  fifoACK %t", $realtime);

	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
//	st <= FrameLoad_s;	
	st <= FifoRead2_s;	
	end

	FifoRead2_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
//	$display("hello  fifoACK %t", $realtime);

	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
//	txd <= 16'h4A4A;
	
//	st <= FrameLoad_s;	
//	if(dout[16])
//	st <= DtstwLoad_s;
//	else
	st <= FifoHeader_s;	
	end
	
	FifoHeader_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
//	$display("hello  fifoheader %t", $realtime);

		tx_charisk <= 2'b00;
		txd <= 16'h4A4A; //e_delimiter = 16'h4A4A;  //D10.2,D10.2
//		txd <= dout_i; //e_delimiter = 16'h4A4A;  //D10.2,D10.2

//	tx_charisk <= 2'b01;
//	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= FrameLoad_s;	
	end
	
	FrameLoad_s :begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		tx_charisk <= 2'b00;
		txd <= dout_ii;
	
	
	if((count < 8'd252) &&(!ddl_xoff)&&(!prog_empty)&&(!dout[16]))
		begin
		st <= FrameLoad_s;
		end
	else 
		begin 
				if((ddl_xoff)&& count[0])
					begin
					st <= FrameLoad_s;
					end
				else
					begin
					st <= FifoCrc1_s;
					end
		end
	end

	FifoCrc1_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
	tx_charisk <= 2'b00;
	txd <= dout_ii[15:0];
	
	st <= FifoCrc2_s;	
	end
		
	FifoEnd1_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		tx_charisk <= 2'b00;
		txd <= dout_ii[15:0];

	
	st <= FifoEnd2_s;	
	end
	
	FifoEnd2_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		tx_charisk <= 2'b00;
		txd <= dout_ii[15:0];

	
	st <= FifoCrc2_s;	
	end
	
	FifoCrc2_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		tx_charisk <= 2'b00;
		txd <= dout_ii[15:0];

	
	st <= FifoCrc3_s;	
	end

	FifoCrc3_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		tx_charisk <= 2'b00;
		txd <= dout_ii[15:0]; //e_delimiter = 16'h4A4A;  //D10.2,D10.2

	
	st <= FifoCrc4_s;	
	end
	
	FifoCrc4_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		tx_charisk <= 2'b00;
		txd <= ddl_crc16b; //e_delimiter = 16'h4A4A;  //D10.2,D10.2

	
	st <= FrameEof_s;	
	end

	
	FrameEof_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
	
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= DiagFrame_s1;	
	end	

	DtstwRdenH_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	if(empty)
	st <= DtstwRdenH_s;	
	else
	st <= DtstwRdenL_s;	
	end	

	DtstwRdenL_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= DtstwRdataH_s;	
	end	

	DtstwRdataH_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= DtstwRdataL_s;	
	end	

	DtstwRdataL_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= DtstwLoad_s;	
	end	


	DtstwLoad_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
		$display("send dtstw status %t", $realtime);

	st <= CmdLoad_s;	
	end	

	ReplyLoad_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= CmdLoad_s;	
	end	

	CmdLoad_s :begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b00;
	txd <= DdlCmdReg[79:64];
	
	if(cnt == 8'd4)
		if(ddl_DtstwReq)
		st <=DtstwAck_s;
		else
		st <= ReplyAck_s;
	else
	st <= CmdLoad_s;	
	end

	DtstwAck_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	if(cnt == 8'd15)
	st <= DiagFrame_s1;	
	else
	st <= DtstwAck_s;
	end
	
	ReplyAck_s : begin
	rd <= code_disp^ rd;
	txchardispmode_0 = 1'b0;
		
	tx_charisk <= 2'b01;
	txd <= (code_disp^ rd) ? 16'hc5bc : 16'h50bc;
	
	st <= DiagFrame_s1;	
	end
	
	
	default :begin
	rd <= 1'b0;
	txchardispmode_0 = 1'b1;
		
	tx_charisk <= 2'b01;
	txd <= 16'h50bc;

	st <= Wait_s;
	end	
	endcase

//-----------------------------------------------	
	always @(posedge rd_clk)
	if(st == DtstwAck_s)
		ddl_DtstwAck <= 1'b1;
	else
		ddl_DtstwAck <= 1'b0;
		
	always @(posedge rd_clk)
	//if((st == FrameLoad_s)&&(dout[16]))
	if(reset)
	ddl_DtstwReq <= 1'b0;
	else if(dout[16])
		ddl_DtstwReq <= 1'b1;
	else if (st == DtstwAck_s)
		ddl_DtstwReq <= 1'b0;
	else
		ddl_DtstwReq <= ddl_DtstwReq;
						
	always @(posedge rd_clk)
	if(st == ReplyAck_s)
		ddl_ReplyAck <= 1'b1;
	else
		ddl_ReplyAck <= 1'b0;
			
	always @(posedge rd_clk)
	case(st)
	DtstwLoad_s : DdlCmdReg <= DtstwWire;
	ReplyLoad_s : DdlCmdReg <= ReplyWire;
	CmdLoad_s	: DdlCmdReg <= {DdlCmdReg[63:0],16'h0};
	default		: DdlCmdReg <= DdlCmdReg;
	endcase
	
	always @(posedge rd_clk)
	if((st == CmdLoad_s)||(st == DtstwAck_s))
			cnt <= cnt + 8'd1;
		else
			cnt <= 8'd0;	

//	always @(posedge rd_clk)
//	if(st == FifoAck_s)
//			tx_ack <= 1'b1;
//		else
//			tx_ack <= 1'b0;	
//
//assign tx_rd_enable = 1'b1;
//

	always @(posedge rd_clk)
	case(st)
	FifoAck_s : begin
	crc_ena <= 1'b0;
	rd_en <= 1'b1;
	count <= count + 8'd1;
	end
	FifoRead1_s : begin
	crc_ena <= 1'b1;
	rd_en <= 1'b1;
	count <= count + 8'd1;
	end
	FifoRead2_s : begin
	crc_ena <= 1'b1;
	rd_en <= 1'b1;
	count <= count + 8'd1;
	end
	FifoHeader_s : begin
	crc_ena <= 1'b1;
	rd_en <= 1'b1;
	count <= count + 8'd1;
	end
	FrameLoad_s : begin
	crc_ena <= 1'b1;
	if((count < 8'd252) && (!ddl_xoff)&& (!prog_empty) && (!dout[16]))
		begin
		rd_en <= 1'b1;
		count <= count + 8'd1;
		end
	else 
		if((ddl_xoff)&& count[0])
		begin
		rd_en <= 1'b1;
		count <= count + 8'd1;
		end
		else
		begin
		rd_en <= 1'b0;
		count <= count;
		end
	end
				
	
	DtstwRdenH_s : begin
	crc_ena <= 1'b0;
	if(empty)
	rd_en <= 1'b0;
	else
	rd_en <= 1'b1;
	
	count <= count;
	end
	
	DtstwRdenL_s : begin
	crc_ena <= 1'b0;
	rd_en <= 1'b1;
	
	count <= count;
	end
	
	default : begin
	crc_ena <= 1'b0;
	rd_en <= 1'b0;
	count <= 8'd0;
	end
	endcase


always @(posedge rd_clk)
if(st == FifoAck_s)
crc_rst <= 1'b1;
else
crc_rst <= 1'b0;

always @(posedge rd_clk)
begin
dout_i <= dout[15:0]; //
dout_ii <= dout_i;
end

	always @(posedge rd_clk)
	if(reset)
	DTSTW <= 32'h0;
	else
	case(st)
	DtstwRdataH_s : 
				DTSTW <= {dout[15:0], 16'h0};
	DtstwRdataL_s : 
				DTSTW <= {DTSTW[31:16],dout[15:0]};
	default : DTSTW <= DTSTW;
	endcase

	always @(posedge rd_clk)
	if(reset)
	diagcnt <= 4'h0;
	else case(st)
	DiagFrame_s3 : begin
	if(empty)
	diagcnt <= diagcnt;
	else
	diagcnt <= diagcnt + 4'h1;
	end
	
	FifoAck_s : begin
	diagcnt <= 4'h0;
	end
	
	default : begin
	diagcnt <= diagcnt;
	end
	endcase
	

crc16 ddl_crc16(
	.clock(rd_clk),
	.srst(crc_rst),
	.ena(crc_ena),
	.d(dout[15:0]),
	.q(ddl_crc16b)
	);		

	
endmodule
	