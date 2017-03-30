`timescale 1ns / 1ps
/*
2012-3-19: Optimization
1. remove "altroabort_cmd"
2. add initial value to "reg" variables
3. change "async reset" to "sync reset"
4. change module name from "fed_build3" into "fed_build"
*/
//*	  01-24-04-2013 : Add HGTh, LG Supperssion SW
module fed_build(
input rdoclk,

//altro bus
input [39:0] bd,
input wire trsfn,
input wire dstbn,

//dtc edata interface
input fifo_rdreq,
output [31:0] fifo_q,
output fifo_empty,
output fifo_almost_full,

input wire altro_chrdo_en,
input wire ram_addrclr,
output reg con_busy = 1'b0, //@neg rdoclk

output reg  FlagClear = 1'b0,
output reg fifo_wren = 1'b0, 
output Dflag,
output [1:0] DHeader,
output [6:0] ChAddr,

input reset
);

parameter ch_setup_cnt = 5'd20;

reg [39:0] pdata = 40'h0;
reg [9:0] numer = 10'h0;

wire rdoclk_n;
assign rdoclk_n = ~rdoclk;

wire trsf, dstb;
assign trsf = ~trsfn;
assign dstb = ~dstbn;

reg [3:0] st = 4'h0;
parameter st0 = 0;
parameter st1 = 1;
parameter st2 = 2;
parameter st3 = 3;
parameter st4 = 4;
parameter st5a = 5;
parameter st5b = 6;
parameter st_end = 7;

//reg fifo_wren = 1'b0;
reg [31:0] fifo_din = 32'h0; 
reg [5:0] ram_wraddr = 6'h0;
reg [5:0] ram_rdaddr = 6'h0;
wire [39:0] ram_dout;

always @(posedge reset or posedge ram_addrclr or posedge dstbn)
if(reset || ram_addrclr)
ram_wraddr <= 6'h0;
else
ram_wraddr <= ram_wraddr + 6'h1;

ch_ram u_ch_ram (
  .clka(dstb), // input clka
  .wea(trsf), // input [0 : 0] wea
  .addra(ram_wraddr), // input [5 : 0] addra
  .dina(bd), // input [39 : 0] dina
  .clkb(rdoclk_n), // input clkb
  .enb(1'b1), // input enb
  .addrb(ram_rdaddr), // input [5 : 0] addrb
  .doutb(ram_dout) // output [39 : 0] doutb
);

//Quartus
/*ch_ram u_ch_ram(
	.data(bd),
	.rdaddress(ram_rdaddr),
	.rdclock(rdoclk_n),
	.wraddress(ram_wraddr),
	.wrclock(dstb),
	.wren(trsf),
	.q(ram_dout));*/
	
//Quartus
/*event_fifo u_event_fifo(
	.clock(rdoclk_n),
	.data(fifo_din),
	.rdreq(fifo_rdreq),
	.sclr(reset),
	.wrreq(fifo_wren),
	.almost_full(fifo_almost_full),
	.empty(fifo_empty),
	.q(fifo_q));*/

//Xilinx	
event_fifo u_event_fifo (
  .clk(rdoclk_n), // input clk
  .srst(reset), // input srst
  .din(fifo_din), // input [31 : 0] din
  .wr_en(fifo_wren), // input wr_en
  .rd_en(fifo_rdreq), // input rd_en
  .dout(fifo_q), // output [31 : 0] dout
  .full(), // output full
  .almost_full(fifo_almost_full), // output almost_full
  .empty(fifo_empty) // output empty
);

	
reg [4:0] clkcnt = 5'h0;	

always @(posedge rdoclk)
if(reset)
begin
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b0;
	fifo_din <= 32'h0;
	numer <= 10'h0;
	pdata <= 40'h0;

	st <= st0;
end else case(st)
st0 : begin
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b0;
	fifo_din <= 32'h0;
	numer <= 10'h0;
	pdata <= 40'h0;
	
	if(altro_chrdo_en)
	st <= st1;
	else
	st <= st0;	
end

st_end : begin
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b1;
	fifo_din <= 32'hc5d5c5d5;
	numer <= 10'h0;
	pdata <= 40'h0;
	
	st <= st0;	
end

st1 : begin
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b0;
	fifo_din <= 32'h0;
	ram_rdaddr <= 6'h0;
	numer <= 10'h0;
	pdata <= 40'h0;

	if(trsf)
	st <= st2;
	else if(altro_chrdo_en)
	st <= st1;
	else
	st <= st_end;
end

st2 : begin
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b0;
	fifo_din <= 32'h0;
	ram_rdaddr <= ram_wraddr - 6'd1;	//read one	ram_rdaddr = 2
	numer <= 10'h0;
	pdata <= 40'h0;

	if(trsf)
	st <= st2;
	else if(ram_wraddr == 6'h0)//empty channel
	st <= st1;
	else
	st <= st3;
end

st3 : begin//ram_dout = trailer
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b0;
	fifo_din <= 32'h0;
	ram_rdaddr <= ram_rdaddr - 6'd1;	//read two ram_rdaddr = 1
	numer <= ram_dout[25:16];
	pdata <= ram_dout;

	if(ram_dout[25:16] < 10'd5)
	st <= st1;
	else
	st <= st4;
end


st4 : begin//ram_dout = first word
	if(clkcnt == ch_setup_cnt)
		begin
		con_busy <= 1'b1;
		clkcnt <= clkcnt;	
		end
	else
		begin
		con_busy <= 1'b0;
		clkcnt <= clkcnt + 5'h1;	
		end	

		fifo_wren <= 1'b1;		
		ram_rdaddr <= ram_rdaddr - 6'd1;	//read three
		
		fifo_din <= {2'b01,4'h0,pdata[25:16],4'h0,pdata[11:0]};
		numer <= numer;
		pdata <= ram_dout; //first word 
		
		
		if(numer < 10'd4)
			st <= st5a;
		else
			st <= st5b;	

end

st5a : begin//ram_dout = second word
	if(clkcnt == ch_setup_cnt)
		begin
		con_busy <= 1'b1;
		clkcnt <= clkcnt;	
		end
	else
		begin
		con_busy <= 1'b0;
		clkcnt <= clkcnt + 5'h1;	
		end

		case(numer)
		3'h1 : fifo_din <= {2'h0,pdata[9:0],20'h0};
		3'h2 : fifo_din <= {2'h0,pdata[19:0],10'h0};		
		3'h3 : fifo_din <= {2'h0,pdata[29:0]};
		default : fifo_din <= 32'h0;
		endcase		
		
		fifo_wren <= 1'b1;
		st <= st1;

	ram_rdaddr <= 6'd0;	
	numer <= numer;
	pdata <= pdata;

end

st5b : begin//ram_dout = second word
	if(clkcnt == ch_setup_cnt)
		begin
		con_busy <= 1'b1;
		clkcnt <= clkcnt;	
		end
	else
		begin
		con_busy <= 1'b0;
		clkcnt <= clkcnt + 5'h1;	
		end


			case(numer[1:0])
			3'h1 : 
				begin 
				fifo_din <= {2'h0,pdata[9:0],ram_dout[39:20]};
				ram_rdaddr <= ram_rdaddr - 6'd1;
				pdata <= ram_dout;		
				end
			
			3'h2 : 
				begin
				fifo_din <= {2'h0,pdata[19:0],ram_dout[39:30]};
				ram_rdaddr <= ram_rdaddr - 6'd1;
				pdata <= ram_dout;		
				end		
				
			3'h3 : 
				begin
				fifo_din <= {2'h0,pdata[29:0]};
				ram_rdaddr <= ram_rdaddr - 6'd1;
				pdata <= ram_dout;	
				end		
				
			3'h0 : 
				begin
				fifo_din <= {2'h0,pdata[39:10]};
				ram_rdaddr <= ram_rdaddr;
				pdata <= pdata;
				end		
			default :
				begin
				fifo_din <= 32'h0;
				ram_rdaddr <= ram_rdaddr;
				pdata <= pdata;
				end
			endcase
			
			numer <= numer - 10'd3;	

			if(numer < 10'd7)
				st <= st5a;
			else
				st <= st5b;

	
end

default:
begin
	clkcnt <= 5'h0;
	con_busy <= 1'b0;
	fifo_wren <= 1'b0;
	fifo_din <= 32'h0;
	numer <= 10'h0;
	pdata <= 40'h0;

	st <= st0;
end
endcase

always @(posedge rdoclk)
if(reset)
begin
FlagClear <= 1'b1;
end else if(st == st0)
	if(altro_chrdo_en)
	FlagClear <= 1'b1;
	else
	FlagClear <= 1'b0;
else
FlagClear <= 1'b0;

assign DHeader = fifo_din[31:30];
assign ChAddr = fifo_din[6:0];
assign Dflag = (fifo_din[29]&fifo_din[28]&fifo_din[27])|(fifo_din[19]&fifo_din[18]&
fifo_din[17])|(fifo_din[9]&fifo_din[8]&fifo_din[7]);

endmodule
