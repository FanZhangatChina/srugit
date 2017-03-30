`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module UDPSCConv(
		// tx interface
		input 					clk125m,
		input [15:0] 			sctx_udptxSrcPort, sctx_udptxDstPort, sctx_length,
		input [31:0] 			sctx_udptxDstIP,
		input [7:0] 			sctx_data,
		input 					sctx_start, sctx_stop, sctx_req, sctx_done,
		output reg				sctx_ack = 1'b0, 
		output reg				sctx_txdatardy = 1'b0,	
		
		//DCS rx_fifo read interface
		input 				dcs_wr_clk,
		input  				dcs_rd_clk,//40MHz
		output 				dcs_rd_sof_n,
		output [7:0] 		dcs_rd_data_out,
		output 				dcs_rd_eof_n,
		output 				dcs_rd_src_rdy_n,
		input  				dcs_rd_dst_rdy_n,
		input  [5:0]		dcs_rd_addr,
		output [3:0]  		dcs_rx_fifo_status,
		output 				dcs_rx_overflow,		
		
		input 					reset
    );
		parameter DcsFifoAddr = 6'h3f;
		parameter dcs_udp_tx_chksum = 16'h0;
        // Signals for DCS rx_fifo
		//wire 				dcs_wr_clk;
		reg 				dcs_wr_enable = 1'b0;
		reg [7:0] 			dcs_rx_data = 8'h0;
		reg 				dcs_rx_data_valid = 1'b0; 
		reg 				dcs_rx_good_frame = 1'b0;
		wire 				dcs_rx_bad_frame;	
	
		reg [15:0] clkcnt = 16'h0;
		wire [79:0]	udp_header_wire;
		reg [79:0] udp_header_reg = 80'h0;
				
		assign udp_header_wire = {sctx_length, sctx_udptxSrcPort, sctx_udptxDstPort,
		sctx_length,dcs_udp_tx_chksum};

parameter st0 = 0;
parameter st1 = 1;
parameter st2 = 2;
parameter st3 = 3;
parameter st4 = 4;
parameter st5 = 5;
parameter st6 = 6;
parameter st7 = 7;

reg [2:0] st = st0;

always @(posedge clk125m)
if(reset)
begin
	sctx_ack <= 1'b0;
	sctx_txdatardy <= 1'b0;
	st <= st0;
end else case(st)
st0 : begin	
	sctx_txdatardy <= 1'b0;
	
	if(sctx_req)
		begin
		sctx_ack <= 1'b1;
		st <= st1;
		end
	else
		begin
		sctx_ack <= 1'b0;
		st <= st0;
		end
end

st1 : begin
	sctx_ack <= 1'b0;
	sctx_txdatardy <= 1'b0;
	st <= st2;
end

st2 : begin
	sctx_ack <= 1'b1;
	sctx_txdatardy <= 1'b0;
	
	if(sctx_req)
	st <= st2;
	else
	st <= st3;
end

st3 : begin
	sctx_ack <= 1'b1;
	sctx_txdatardy <= 1'b1;
	
	if(sctx_done)
	st <= st0;
	else
	st <= st3;
end

default: begin
	sctx_ack <= 1'b0;
	sctx_txdatardy <= 1'b0;
	
	st <= st0;
end
endcase

//States are FifoWrWait_s,FifoWrLoadHeader_s,FifoWrHeader_s,FifoWrData_s,FifoWrWe_s	
parameter FifoWrWait_s = 3'd0; parameter FifoWrLoadHeader_s = 3'd1;
parameter FifoWrHeader_s = 3'd2; parameter FifoWrData_s = 3'd3;
parameter FifoWrWe_s = 3'd4; 
reg [2:0] FifoWrSt = FifoWrWait_s;

always @(posedge clk125m)
if(reset)
begin
	dcs_wr_enable <= 1'b0;
	dcs_rx_data_valid <= 1'b0;
	dcs_rx_good_frame <= 1'b0;	
	udp_header_reg <= 80'h0;
	dcs_rx_data <= 8'h0;
	
	clkcnt <= 16'h0;
	FifoWrSt <= FifoWrWait_s;
end else case(FifoWrSt)

FifoWrWait_s : begin
	dcs_wr_enable <= 1'b0;
	dcs_rx_data_valid <= 1'b0;
	dcs_rx_good_frame <= 1'b0;
	udp_header_reg <= 80'h0;
	dcs_rx_data <= 8'h0;    
	
	clkcnt <= 16'h0;//6
	if(sctx_start)
	FifoWrSt <= FifoWrLoadHeader_s;
	else
	FifoWrSt <= FifoWrWait_s;
end

FifoWrLoadHeader_s : begin
	dcs_wr_enable <= 1'b1;
	dcs_rx_data_valid <= 1'b0;
	dcs_rx_good_frame <= 1'b0;	
	udp_header_reg <= udp_header_wire;
	dcs_rx_data <= 8'h0;	
	
	clkcnt <= 16'h0;
	FifoWrSt <= FifoWrHeader_s;
end

FifoWrHeader_s : begin
	dcs_wr_enable <= 1'b1;
	dcs_rx_data_valid <= 1'b1;
	dcs_rx_good_frame <= 1'b0;	
	udp_header_reg <= {udp_header_reg[63:0],8'h55};
	dcs_rx_data <= udp_header_reg[79:72];	
	
	clkcnt <= clkcnt + 16'h1;
	if(clkcnt == 16'd8)
	FifoWrSt <= FifoWrData_s;
	else
	FifoWrSt <= FifoWrHeader_s;
end

FifoWrData_s : begin
	dcs_wr_enable <= 1'b0;
	dcs_rx_data_valid <= 1'b1;	
	udp_header_reg <= 80'h0;
	dcs_rx_data <= sctx_data;
	
	if(clkcnt == sctx_length)
	begin
	dcs_rx_good_frame <= 1'b1;
	clkcnt <= 16'h0;
	FifoWrSt <= FifoWrWe_s;
	end
	else
	begin
	dcs_rx_good_frame <= 1'b0;
	clkcnt <= clkcnt + 16'h1;
	FifoWrSt <= FifoWrData_s;
	end
end

FifoWrWe_s : begin
	dcs_wr_enable <= 1'b1;
	dcs_rx_data_valid <= 1'b0;
	dcs_rx_good_frame <= 1'b0;	
	udp_header_reg <= 80'h0;
	dcs_rx_data <= 8'h0;
	clkcnt <= clkcnt + 16'h1;
	
	if(clkcnt == 16'd3)	
	FifoWrSt <= FifoWrWait_s;
	else
	FifoWrSt <= FifoWrWe_s;
end

default: begin
	dcs_wr_enable <= 1'b0;
	dcs_rx_data_valid <= 1'b0;
	dcs_rx_good_frame <= 1'b0;
	udp_header_reg <= 80'h0;
	dcs_rx_data <= 8'h0;	
	clkcnt <= 16'h0;
	FifoWrSt <= FifoWrWait_s;
end
endcase

	   // DCS Reply Receiver FIFO
   rx_client_fifo_8_rdbus #(.FifoInitAddr(DcsFifoAddr)) u_rx_client_fifo_8_rdbus (
      .rd_clk          (dcs_rd_clk),
      .rd_sreset       (reset),
      .rd_data_out     (dcs_rd_data_out),
      .rd_sof_n        (dcs_rd_sof_n),
      .rd_eof_n        (dcs_rd_eof_n),
      .rd_src_rdy_n    (dcs_rd_src_rdy_n),
      .rd_dst_rdy_n    (dcs_rd_dst_rdy_n),
      .rx_fifo_status  (dcs_rx_fifo_status),
	   .rd_addr		   (dcs_rd_addr),
		
      .wr_sreset       (reset),
      .wr_clk          (dcs_wr_clk),
      .wr_enable       (dcs_wr_enable),
      .rx_data         (dcs_rx_data),
      .rx_data_valid   (dcs_rx_data_valid),
      .rx_good_frame   (dcs_rx_good_frame),
      .rx_bad_frame    (dcs_rx_bad_frame),
      .overflow        (dcs_rx_overflow)		
   );  
   
   assign dcs_rx_bad_frame = 1'b0;

endmodule
