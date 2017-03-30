`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module FlashToUDP(
		input       			udp_rx_clk,             
		input  [7:0] 			udp_rxd,              
		input       			udp_rx_dv,            
		
		input [15:0]			udp_rx_dst_port,
		input  [31:0] 			udp_rx_src_ip,              
		
		//DCS rx_fifo read interface
		input  					dcs_rd_clk,//40MHz
		output 					dcs_rd_sof_n,
		output [7:0] 			dcs_rd_data_out,
		output 					dcs_rd_eof_n,
		output 					dcs_rd_src_rdy_n,
		input  					dcs_rd_dst_rdy_n,
		input  [5:0]			dcs_rd_addr,
		output [3:0]  			dcs_rx_fifo_status,
		output 					dcs_rx_overflow,	
		
		output [31:0] 		   fpga_ip,
		output [47:0] 			fpga_mac,
		output [31:0]			sru_sn,
		
		input 					FPGAReload,

		output [22:0] 			FLASH_A,
		inout  [15:0] 			FLASH_DQ,
		output 					FLASH_CS_B,
		output 					FLASH_OE_B,
		output 					FLASH_WE_B,
		output 					FLASH_RS0,
		output 					FLASH_RS1,
		
		output 					FPGA_PROG_B,
		
		input						gclk_40m,
		input						SlowClk,
		
		input 					reset
    );

		parameter DcsFifoAddr = 6'd42;
		
		//slow control for Flash
		wire [15:0]	 			sc_port;
		wire [31:0]	 			sc_data, sc_addr, sc_subaddr;
		wire 		 	 			sc_wr, sc_op, sc_frame;
		wire	 		 			sc_ack;
		wire  [31:0]	 		sc_rply_error, sc_rply_data;
		
		//clock for u_scController
		wire 						clk, clk125, clk10M;
		
		//configuration parameters for u_scController
		wire [15:0]	 			cfg_scport, cfg_scmode;
		
		//UDP rx interface
		wire [7:0] 				udprx_data;
		wire [15:0] 			udprx_checksum, udprx_dstport;
		wire [31:0] 			udprx_srcIP;
		wire 						udprx_datavalid;
		wire 						udprx_portAck;	//unused now.

		//tx interface
		wire [15:0] 			sctx_udptxSrcPort, sctx_udptxDstPort, sctx_length;
		wire [31:0] 			sctx_udptxDstIP;
		wire [7:0] 				sctx_data;
		wire 						sctx_start, sctx_stop, sctx_req, sctx_done;
		wire 						sctx_ack, sctx_txdatardy;	


////////////////////////////////////////////////////
reg udp_rx_dv_i = 1'b0, udp_rx_dv_ii = 1'b0, udp_rx_dv_iii = 1'b0, udp_rx_dv_iiii = 1'b0, udp_rx_dv_iiiii = 1'b0;
reg [7:0] udp_rxd_i = 8'h0, udp_rxd_ii = 8'h0, udp_rxd_iii = 8'h0, udp_rxd_iiii = 8'h0, udp_rxd_iiiii = 8'h0;


// Instantiate the module
scController u_scController (
    .clk(clk), 
    .clk125(clk125), 
    .clk10M(clk10M), 
    .rstn(!reset), 
	 .cfg_scport(16'h1777),
    .cfg_scmode(cfg_scmode), 
	 
    .udprx_data(udprx_data), 
    .udprx_checksum(udprx_checksum), 
    .udprx_dstport(udprx_dstport), 
    .udprx_srcIP(udprx_srcIP), 
    .udprx_datavalid(udprx_datavalid), 
    .udprx_portAck(udprx_portAck),
	 
    .sc_port(sc_port), 
    .sc_data(sc_data), 
    .sc_addr(sc_addr), 
    .sc_subaddr(sc_subaddr), 
    .sc_wr(sc_wr), 
    .sc_op(sc_op), 
    .sc_frame(sc_frame), 
    .sc_ack(sc_ack), 
    .sc_rply_error(sc_rply_error), 
    .sc_rply_data(sc_rply_data), 
	 
    .sctx_udptxSrcPort(sctx_udptxSrcPort), 
    .sctx_udptxDstPort(sctx_udptxDstPort), 
    .sctx_length(sctx_length), 
    .sctx_udptxDstIP(sctx_udptxDstIP), 
    .sctx_data(sctx_data), 
    .sctx_start(sctx_start), 
    .sctx_stop(sctx_stop), 
    .sctx_req(sctx_req), 
    .sctx_done(sctx_done), 
    .sctx_ack(sctx_ack), 
    .sctx_txdatardy(sctx_txdatardy)
    );

	 
FlashTop u_FlashTop (
    .clk(SlowClk), 
    .reset(reset), 
    .FPGAReload(FPGAReload), 

    .sc_port(sc_port), 
    .sc_data(sc_data), 
    .sc_addr(sc_addr), 
    .sc_subaddr(sc_subaddr), 
    .sc_wr(sc_wr), 
    .sc_op(sc_op), 
    .sc_frame(sc_frame), 
    .sc_ack(sc_ack), 
    .sc_rply_error(sc_rply_error), 
    .sc_rply_data(sc_rply_data),
	 
    .SRU_ip(fpga_ip), 
    .SRU_SN(sru_sn), 
    .FLASH_A(FLASH_A), 
    .FLASH_DQ(FLASH_DQ), 
    .FLASH_CS_B(FLASH_CS_B), 
    .FLASH_OE_B(FLASH_OE_B), 
    .FLASH_WE_B(FLASH_WE_B), 
    .FLASH_RS0(FLASH_RS0), 
    .FLASH_RS1(FLASH_RS1), 
    .FPGA_PROG_B(FPGA_PROG_B)
    );

UDPSCConv  #(.DcsFifoAddr(DcsFifoAddr)) u_UDPSCConv (
    .clk125m(udp_rx_clk), 
	 
    .sctx_udptxSrcPort(sctx_udptxSrcPort), 
    .sctx_udptxDstPort(sctx_udptxDstPort), 
    .sctx_length(sctx_length), 
    .sctx_udptxDstIP(sctx_udptxDstIP), 
	 
    .sctx_data(sctx_data), 
    .sctx_start(sctx_start), 
    .sctx_stop(sctx_stop), 
    .sctx_req(sctx_req), 
    .sctx_done(sctx_done), 
    .sctx_ack(sctx_ack), 
    .sctx_txdatardy(sctx_txdatardy), 
	 
	 .dcs_wr_clk          (dcs_wr_clk),
    .dcs_rd_clk          (dcs_rd_clk),
    .dcs_rd_data_out     (dcs_rd_data_out),
    .dcs_rd_sof_n        (dcs_rd_sof_n),
    .dcs_rd_eof_n        (dcs_rd_eof_n),
    .dcs_rd_src_rdy_n    (dcs_rd_src_rdy_n),
    .dcs_rd_dst_rdy_n    (dcs_rd_dst_rdy_n),
	 .dcs_rd_addr		 	 (dcs_rd_addr),
    .dcs_rx_fifo_status  (dcs_rx_fifo_status),
	 .dcs_rx_overflow	 	 (dcs_rx_overflow),	
		
    .reset(reset)
    );

	 
	 assign fpga_mac = {16'h0a35, fpga_ip};
	 assign clk10M = SlowClk;
	 assign clk125 = udp_rx_clk;
	 assign clk = gclk_40m;
	 
	 assign cfg_scmode = 16'hffff;
	 assign udprx_checksum = 16'hffff;

	 assign udprx_data = udp_rxd_iiiii;
	 assign udprx_dstport = udp_rx_dst_port;
	 assign udprx_srcIP = udp_rx_src_ip;
	 assign udprx_datavalid = udp_rx_dv_iiiii;


always @(posedge udp_rx_clk)
begin
udp_rx_dv_i <= udp_rx_dv;
udp_rxd_i <= udp_rxd;
end

always @(posedge udp_rx_clk)
begin
udp_rx_dv_ii <= udp_rx_dv_i;
udp_rxd_ii <= udp_rxd_i;
end

always @(posedge udp_rx_clk)
begin
udp_rx_dv_iii <= udp_rx_dv_ii;
udp_rxd_iii <= udp_rxd_ii;
end

always @(posedge udp_rx_clk)
begin
udp_rx_dv_iiii <= udp_rx_dv_iii;
udp_rxd_iiii <= udp_rxd_iii;
end

always @(posedge udp_rx_clk)
begin
if(udp_rx_dst_port == 16'h2777)
udp_rx_dv_iiiii <= udp_rx_dv_iiii;
else
udp_rx_dv_iiiii <= 1'b0;
udp_rxd_iiiii <= udp_rxd_iiii;
end

assign dcs_wr_clk = gclk_40m;

	 
endmodule
