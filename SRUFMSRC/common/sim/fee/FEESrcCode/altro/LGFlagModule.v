//*	  01-24-04-2013 : Add HGTh, LG Supperssion SW
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
//Last modified: 2014-02-19-14-55
module LGFlagModule(
input rdoclk,
input FlagClear,
input fifo_wren,
input Dflag,
input [1:0] DHeader,
input [6:0] ChAddr,
output reg [31:0] OverflowFlag = 32'h0,
input	LGSEN,

input reset
);

reg OverTh = 1'b0;
reg [6:0] addr_temp = 7'h0;

parameter Wait_s = 2'b00; parameter Chk_s = 2'b01;
parameter Flag_s = 2'b10; 
reg [1:0] st = Wait_s;

always @(posedge rdoclk)
if(reset)
begin
//OverTh <= 1'b0;
//addr_temp <= 7'h0;
st <= Wait_s;
end else case(st)
Wait_s : begin
//OverTh <= 1'b0;
if(fifo_wren)
	if(DHeader == 2'b01)
	begin
	//addr_temp <= fifo_din[6:0];
	//addr_temp <= ChAddr;
	st <= Chk_s;
	end
	else
	begin
	//addr_temp <= addr_temp;
	st <= Wait_s;
	end
else
	begin
	//addr_temp <= addr_temp;
	st <= Wait_s;
	end
end

Chk_s : begin
//addr_temp <= addr_temp;
if(fifo_wren)
	begin
	//OverTh <= Dflag;
	st <= Chk_s;
	end
else
	begin
    //OverTh <= OverTh;
	 st <= Flag_s;
	end
end

Flag_s: begin
//addr_temp <= addr_temp;
//OverTh <= OverTh;
st <= Wait_s;
end
default: begin
//addr_temp <= 7'h0;
//OverTh <= 1'b0;
st <= Wait_s;
end
endcase

//Load channel address
always @(posedge rdoclk)
if(reset)
	begin
	addr_temp <= 7'h0;
	end 
else if(fifo_wren)
		if(DHeader == 2'b01)
		addr_temp <= ChAddr;
		else
		addr_temp <= addr_temp;
	 else
		addr_temp <= addr_temp;

//Load OverTh
always @(posedge rdoclk)
if(reset)
	begin
	OverTh <= 1'b0;
	end 
else case(st)
Wait_s : OverTh <= 1'b0;
Chk_s : if(fifo_wren)
		OverTh <= Dflag;
		else
		OverTh <= OverTh;
Flag_s : OverTh <= OverTh;
default: OverTh <= 1'b0;
endcase		

always @(posedge rdoclk)
if(FlagClear)
begin
OverflowFlag <= 32'hffffffff;
//end else if((st == Flag_s) && OverTh && LGSEN)//0x5034
//end else if((st == Flag_s) && OverTh || (~LGSEN))//0x5040
end else if(OverTh || (~LGSEN))//0x5042
case(addr_temp)
7'h2a: OverflowFlag <= OverflowFlag & 32'hFFFF_FFFE;
7'h2e: OverflowFlag <= OverflowFlag & 32'hFFFF_FFFD;
7'h25: OverflowFlag <= OverflowFlag & 32'hFFFF_FFFB;
7'h21: OverflowFlag <= OverflowFlag & 32'hFFFF_FFF7;
7'h31: OverflowFlag <= OverflowFlag & 32'hFFFF_FFEF;
7'h35: OverflowFlag <= OverflowFlag & 32'hFFFF_FFDF;
7'h3e: OverflowFlag <= OverflowFlag & 32'hFFFF_FFBF;
7'h3a: OverflowFlag <= OverflowFlag & 32'hFFFF_FF7F;

7'h0a: OverflowFlag <= OverflowFlag & 32'hFFFF_FEFF;
7'h0e: OverflowFlag <= OverflowFlag & 32'hFFFF_FDFF;
7'h05: OverflowFlag <= OverflowFlag & 32'hFFFF_FBFF;
7'h01: OverflowFlag <= OverflowFlag & 32'hFFFF_F7FF;
7'h41: OverflowFlag <= OverflowFlag & 32'hFFFF_EFFF;
7'h45: OverflowFlag <= OverflowFlag & 32'hFFFF_DFFF;
7'h4e: OverflowFlag <= OverflowFlag & 32'hFFFF_BFFF;
7'h4a: OverflowFlag <= OverflowFlag & 32'hFFFF_7FFF;

7'h28: OverflowFlag <= OverflowFlag & 32'hFFFE_FFFF;
7'h2c: OverflowFlag <= OverflowFlag & 32'hFFFD_FFFF;
7'h27: OverflowFlag <= OverflowFlag & 32'hFFFB_FFFF;
7'h23: OverflowFlag <= OverflowFlag & 32'hFFF7_FFFF;
7'h33: OverflowFlag <= OverflowFlag & 32'hFFEF_FFFF;
7'h37: OverflowFlag <= OverflowFlag & 32'hFFDF_FFFF;
7'h3c: OverflowFlag <= OverflowFlag & 32'hFFBF_FFFF;
7'h38: OverflowFlag <= OverflowFlag & 32'hFF7F_FFFF;

7'h08: OverflowFlag <= OverflowFlag & 32'hFEFF_FFFF;
7'h0c: OverflowFlag <= OverflowFlag & 32'hFDFF_FFFF;
7'h07: OverflowFlag <= OverflowFlag & 32'hFBFF_FFFF;
7'h03: OverflowFlag <= OverflowFlag & 32'hF7FF_FFFF;
7'h43: OverflowFlag <= OverflowFlag & 32'hEFFF_FFFF;
7'h47: OverflowFlag <= OverflowFlag & 32'hDFFF_FFFF;
7'h4c: OverflowFlag <= OverflowFlag & 32'hBFFF_FFFF;
7'h48: OverflowFlag <= OverflowFlag & 32'h7FFF_FFFF;

default: begin
OverflowFlag <= OverflowFlag;
end
endcase
else
OverflowFlag <= OverflowFlag;

//wire dinflag;
//assign dinflag = fifo_din[29]&fifo_din[28]&fifo_din[27]&fifo_din[19]&fifo_din[18]&
//fifo_din[17]&fifo_din[9]&fifo_din[8]&fifo_din[7];
endmodule
