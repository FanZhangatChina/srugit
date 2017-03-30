//*******************************************************************************
//* Module          : dtc_tx
//* File            : dtc_tx.v
//* Description     : Top module of the FEE board controller
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*	  06-03-2013 : Add ALTRO command handshaking (acmd_ack)
//*				   Modify the decoding of the L0,L1 (posedge) and commands (negedge) on the DTC_TRIG 
//*	  01-19-04-2013 : Add event_rdo_cnt
//*	  01-23-04-2013 : Modify width of the event_rdo_cnt
//*******************************************************************************
module dtc_tx
(
	input rdoclk,
	output dtc_data,
	output dtc_return,

	input fee_flag,

	input reply_rdy,
	input [31:0] reply_addr,
	input [31:0] reply_data,

	output reg frame_st = 1'b0,
	output reg fifo_rdreq = 1'b0,
	input [31:0] fifo_q,
	input fifo_empty,
	
	input test_mode,

	output reg [15:0] event_rdo_cnt = 16'h0,
	input CntRst,
	input DtcStReq,

	input reset
);

parameter reply_header = 16'hf7f7;
parameter status_header = 16'hdcdc;
parameter event_header = 16'h5c5c;
parameter end_word = 16'hC5D5;

wire [15:0] status;
assign status = {15'h0,fee_flag};

reg [1:0] bitcnt = 2'h0;

wire txword_load, bitcnt_flag;
reg [15:0] txword = 16'hbc50;
reg [11:0] txword_i = 12'h0;
wire [15:0] txword_temp;
reg [3:0] data_bit4 = 4'h0;

wire [15:0] prbs_out;

   parameter POLY_LENGHT = 9;
   parameter POLY_TAP = 5;
   parameter INV_PATTERN = 1;


  PRBS_ANY #(
    .CHK_MODE(0),
    .INV_PATTERN(INV_PATTERN),
    .POLY_LENGHT(POLY_LENGHT),
    .POLY_TAP(POLY_TAP),
    .NBITS(16))
  I_PRBS_ANY_GEN(
 //   .RST(1'b0),
    .RST(reset),    
    .CLK(bitcnt_flag),
    .DATA_IN(16'b0),
    //.EN(1'b 1),
    .EN(test_mode),    
    .DATA_OUT(prbs_out));


always @(negedge rdoclk)
bitcnt <= bitcnt + 2'h1;

assign txword_load = bitcnt[1] & bitcnt[0];
assign bitcnt_flag = ~ (bitcnt[1] | bitcnt[0]);

always @(posedge rdoclk)
    if (txword_load) 
      begin
//         txword_i <= txword[15:4];
//         data_bit4    <= txword[3:0];
         if(test_mode)
			begin
			txword_i <= prbs_out[15:4];
			data_bit4    <= prbs_out[3:0];     
			end
		else 
			begin
			txword_i <= txword[15:4];
			data_bit4    <= txword[3:0];
			end
      end
      else 
      begin
         txword_i <= {4'b00,txword_i[11:4]};
         data_bit4   <= txword_i[3:0];
      end

//assign txword_temp = test_mode ? prbs_out : txword;

BitDdr Udata (.reset(reset), .clkin(rdoclk), .din_p(data_bit4[0]), .din_n(data_bit4[2]),.dout(dtc_data));
BitDdr Ureturn (.reset(reset), .clkin(rdoclk), .din_p(data_bit4[1]), .din_n(data_bit4[3]),.dout(dtc_return));

parameter st0 = 5'd0;
parameter stc1 = 5'd1;
parameter stc2 = 5'd2;
parameter stc3 = 5'd3;
parameter stc4 = 5'd4;
parameter stc5 = 5'd5;
parameter stc6 = 5'd6;
parameter stc7 = 5'd7;
parameter sts1 = 5'd8;
parameter sts2 = 5'd9;
parameter sts3 = 5'd10;
parameter sts4 = 5'd11;
parameter ste1 = 5'd12;
parameter ste2 = 5'd13;
parameter ste3 = 5'd14;
parameter ste4a = 5'd15;  
parameter ste4b = 5'd16;  
parameter ste5b = 5'd17;  
parameter ste6b = 5'd18;  
parameter ste7b = 5'd19;  
parameter stef = 5'd20;
parameter sts5 = 5'd21;
parameter ste3a = 5'd22;
parameter stef2 = 5'd23;
  
parameter sync_word = 16'hbc50;

reg [4:0] st = st0;
reg [15:0] timer = 16'h0;

always @(posedge rdoclk)
if(reset)
begin
st <= st0;
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;
txword <= sync_word;
end

else 
begin
case(st)
st0:  
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;
txword <= sync_word;

if(reply_rdy)
st <= stc1;
else if(DtcStReq)
st <= sts1;
else if(~fifo_empty)
st <= ste1;
else
st <= st0;
end

stc1: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= sync_word;
	st <= stc2;
	end
else
	begin
	txword <= txword;
	st <= stc1;
	end
end
//header
stc2: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= reply_header;
	st <= stc3;
	end
else
	begin
	txword <= txword;
	st <= stc2;
	end
end
//address
stc3: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= reply_addr[31:16];
	st <= stc4;
	end
else
	begin
	txword <= txword;
	st <= stc3;
	end
end

stc4: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= reply_addr[15:0];
	st <= stc5;
	end
else
	begin
	txword <= txword;
	st <= stc4;
	end
end

//data
stc5: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= reply_data[31:16];
	st <= stc6;
	end
else
	begin
	txword <= txword;
	st <= stc5;
	end
end

stc6: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= reply_data[15:0];
	st <= stc7;
	end
else
	begin
	txword <= txword;
	st <= stc6;
	end
end
//bc50
stc7: 
begin
frame_st <= 1'b1;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= sync_word;
	st <= sts1;
	end
else
	begin
	txword <= txword;
	st <= stc7;
	end
end

/////////////Status frame////////////////
sts1: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= sync_word;
	st <= sts2;
	end
else
	begin
	txword <= txword;
	st <= sts1;
	end
end
//header
sts2: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= status_header;
	st <= sts3;
	end
else
	begin
	txword <= txword;
	st <= sts2;
	end
end
//status
sts3: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= status;
	st <= sts4;
	end
else
	begin
	txword <= txword;
	st <= sts3;
	end
end

sts4: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= sync_word;
	st <= st0;
	end
else
	begin
	txword <= txword;
	st <= sts4;
	end
end

/////////////Event frame////////////////
ste1: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <=sync_word;
	st <= ste2;
	end
else
	begin
	txword <= txword;
	st <= ste1;
	end
end
//header
ste2: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= event_header;
	st <= ste3;
	end
else
	begin
	txword <= txword;
	st <= ste2;
	end
end
//address
ste3: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;
txword <= txword;

if(fifo_empty)
	st <= ste4a;
else if(timer[15])
			st <= stef;
			else
			st <= ste4b;
end

ste4a: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= 16'h8012;
	st <= ste3a;
	end
else
	begin
	txword <= txword;
	st <= ste4a;
	end
end

ste3a: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= 16'h8012;
	st <= ste3;
	end
else
	begin
	txword <= txword;
	st <= ste3a;
	end
end


//data
ste4b: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b1;

	txword <= txword;
	st <= ste5b;
end

ste5b: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

	txword <= txword;
	st <= ste6b;

end

ste6b: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= fifo_q[15:0];
	st <= ste7b;
	end
else
	begin
	txword <= txword;
	st <= ste6b;
	end
end

ste7b: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	txword <= fifo_q[31:16];
	if(fifo_q[31:30] == 2'b11)
	st <= stef;
	else
	st <= ste3;
	end
else
	begin
	txword <= txword;
	st <= ste7b;
	end
end

//bc50
stef: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	//txword <=sync_word;
	txword <=end_word;
	st <= stef2;
	end
else
	begin
	txword <= txword;
	st <= stef;
	end
end

stef2: 
begin
frame_st <= 1'b0;
fifo_rdreq <= 1'b0;

if(bitcnt_flag)
	begin
	//txword <=sync_word;
	txword <=end_word;
	st <= sts1;
	end
else
	begin
	txword <= txword;
	st <= stef2;
	end
end

default:
begin
frame_st <= 1'b0;
st <= st0;
fifo_rdreq <= 1'b0;
txword <=sync_word;
end

endcase
end

always @(posedge rdoclk)
if(CntRst)
begin
event_rdo_cnt <= 16'h0;
end else if(st == stef2)
	if(bitcnt_flag)
	event_rdo_cnt <= event_rdo_cnt + 16'h1;
	else
	event_rdo_cnt <= event_rdo_cnt;
else
event_rdo_cnt <= event_rdo_cnt;

always @(posedge rdoclk)
if(reset)
timer <= 16'h0;
else case(st)
ste3, ste3a, ste4a: timer <= timer + 16'h1;
default: timer <= 16'h0;
endcase

endmodule
