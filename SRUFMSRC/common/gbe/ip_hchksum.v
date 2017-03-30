`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/* IP header: 20 bytes
IpV4Info = 16'h4500;
IpTlength = ?
IpFrag = 32'h00004000;//Don't fragment
IpTlive = 8'h80;//128ms
IpPro = 8'h01(ICMP)? 8'h11(UDP)?
IpHChk = 
IpSrcIP
IpDstIP
*/ 
// http://www.netfor2.com/checksum.html
// Time to live: 128 ms
// No fragment
//////////////////////////////////////////////////////////////////////////////////
module ip_hchksum(
		// Ethernet and IP header signals
		//------------------------------------
		input ip_tx_clk,
		input ip_tx_header_req,
		output reg ip_HeaderUpdate = 1'b0,
		input [15:0] ip_total_len,
		input [31:0] IpSrcIP,
		input [31:0] IpDstIP,
		input [7:0] IpPro,
		
		output [159:0] ip_tx_header,
		
		input reset
    );

parameter IpV4Info = 16'h4500;
parameter IpFrag = 32'h00004000;//Don't fragment
parameter IpTlive = 8'h80;

reg [31:0] chk_sum_i = 32'h0;
reg [15:0] chk_sum = 16'h0;
wire [143:0] ip_header_wire;
reg [143:0] ip_header_reg = 144'h0;
reg [3:0] cnt = 4'h0;

assign 	ip_header_wire = {IpV4Info,ip_total_len,IpFrag,IpTlive,IpPro,
IpSrcIP,IpDstIP};
assign ip_tx_header = {IpV4Info, ip_total_len,IpFrag,IpTlive,
IpPro,chk_sum,IpSrcIP,IpDstIP};


//FSM
//States are Wait_s, LoadHPara_s,ChkSumA_s, ChkSumB_s,
// ChkInv_s, Flag_s
parameter Wait_s = 3'd0;  parameter LoadHPara_s = 3'd1;
parameter ChkSumA_s = 3'd2;  parameter ChkSumB_s = 3'd3;
parameter ChkInv_s = 3'd4;  parameter Flag_s = 3'd5;

reg [2:0] st = Wait_s;
				
	always @(posedge ip_tx_clk)
	if(reset)
	begin
	chk_sum_i <= 32'h0;
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= 16'h0;
	ip_header_reg <= 144'h0;
	cnt <= 4'd0;
	
	st <= Wait_s;
	end
	else case(st)
	Wait_s :
	begin
	chk_sum_i <= 32'h0;
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= chk_sum;
	ip_header_reg <= 144'h0;
	cnt <= 4'd0;
	
	if(ip_tx_header_req)
	st <= LoadHPara_s;	
	else
	st <= Wait_s;
	end
	
	LoadHPara_s :
	begin
	chk_sum_i <= 32'h0;
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= chk_sum;
	ip_header_reg <= ip_header_wire;
	cnt <= 4'd0;
	
	st <= ChkSumA_s;	
	end
	
	ChkSumA_s :
	begin
	chk_sum_i <= chk_sum_i + ip_header_reg[143:128];
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= chk_sum;
	ip_header_reg <= {ip_header_reg[127:0],16'h0};
	cnt <= 4'd1 + cnt;
	
	if(cnt == 5'd9)
	st <= ChkSumB_s;	
	else
	st <= ChkSumA_s;
	end
	
	ChkSumB_s :
	begin
	chk_sum_i <= chk_sum_i ;
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= chk_sum_i[15:0] + chk_sum_i[31:16];
	ip_header_reg <= 144'h0;	
	cnt <= 4'd0;
	
	st <= ChkInv_s;	
	end
	
	ChkInv_s :
	begin
	chk_sum_i <= chk_sum_i ;
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= ~chk_sum;
	ip_header_reg <= 144'h0;	
	cnt <= 4'd0;	
	
	st <= Flag_s;	
	end
	
	Flag_s :
	begin
	chk_sum_i <= chk_sum_i ;
	ip_HeaderUpdate <= 1'b1;
	chk_sum <= ~chk_sum;
	ip_header_reg <= 144'h0;	
	cnt <= 4'd0;	
	
	if(ip_tx_header_req)
	st <= Flag_s;
	else
	st <= Wait_s;	
	end	
	
	default:
	begin
	chk_sum_i <= 32'h0;
	ip_HeaderUpdate <= 1'b0;
	chk_sum <= 16'h0;
	ip_header_reg <= 144'h0;	
	cnt <= 4'd0;	
	
	st <= Wait_s;
	end
	endcase
	

endmodule
