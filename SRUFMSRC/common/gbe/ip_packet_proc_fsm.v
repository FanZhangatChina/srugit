`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module ip_packet_proc_fsm( 
		//EMAC packet read interface 
 		input   			ip_rd_clk,
		output reg 		ip_rd_enable = 1'b0,		
		input  [7:0] 	ip_rd_data,
		input  			ip_rd_data_valid,
		output reg 		ip_rd_ack = 1'b0,		//Handshake signal. Asserted when one accepts the first byte of data.
		
		//Frame type info
		input				udp_frame,
		input 			icmp_frame,
      output	reg	rx_frame_processed = 1'b0,	
		input [15:0]   IcmpCheckSum,
		input [15:0]	IPFrameLen,

		//ICMP tx_fifo read interface
		input  				icmp_tx_clk,//40MHz
		output 				icmp_tx_sof_n,
		output [7:0] 		icmp_tx_data_out,
		output 				icmp_tx_eof_n,
		output 				icmp_tx_src_rdy_n,
		input  				icmp_tx_dst_rdy_n,
		input  [5:0]		icmp_tx_tx_fifo_rd_addr,
		output [3:0]  		icmp_rx_fifo_status,
		output 				icmp_rx_overflow,
		
		//UDP interface
		output				udp_rx_clk,
		output	reg	[7:0]	udp_rxd = 8'h0, //include UDP ports info
		output 	reg			udp_rx_dv = 1'b0, 
	
		input				reset		
		);
		
		parameter ICMP_PING_REPLY = 16'h0000;
		parameter IcmpFrameSofCnt = 16'd38;		
		parameter IcmpFrameEofCnt = 16'd80;
		parameter UdpFrameSofCnt = 16'd34;		
		parameter UdpFrameEofCnt = 16'd80;
		
		parameter IcmpFifoAddr = 6'd1;
		
		//Variables for ICMP FSM
		reg icmp_wr_enable = 1'b0;
		reg [7:0] icmp_tx_data = 8'h0;
		reg icmp_tx_data_valid = 1'b0;
		reg icmp_tx_good_frame = 1'b0;
		reg IcmpReplySent = 1'b0;
		wire icmp_wr_clk;
		wire [47:0] icmp_header_wire;
		reg [47:0] icmp_header_reg = 48'h0;
		reg [3:0] icmp_cnt = 4'd0;
		reg [15:0] icmp_length = 16'h0;	
				
		assign icmp_wr_clk = ip_rd_clk;
		assign icmp_tx_bad_frame = 1'b0;
		assign icmp_header_wire = {icmp_length,ICMP_PING_REPLY,IcmpCheckSum};
		
		//Reg for UDP FSM
		reg UdpProcessed = 1'b0;
		
		reg [15:0] data_cnt = 16'h0;

		//IP FSM
		//States are Wait_s, RdFifoAck_s1, RdFifoAck_s2, RDataRx_s,
		//Ack_s, Icmp_s, Udp_s
		parameter Wait_s = 3'd0; parameter RdFifoAck_s1 = 3'd1;
		parameter RdFifoAck_s2 = 3'd2; parameter RDataRx_s = 3'd3;
		parameter Ack_s = 3'd4; parameter Icmp_s = 3'd5;
		parameter Udp_s = 3'd6; 		
		reg [2:0] IpSt = Wait_s;		
		
		always @(posedge ip_rd_clk)
		if(reset)
		begin
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b0;
		ip_rd_ack <= 1'b0;
		
		data_cnt <= 16'h0;
		
		IpSt <= Wait_s;
		end else case(IpSt)
		Wait_s : begin
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b0;
		data_cnt <= 16'h0;		
		
		if(ip_rd_data_valid) //First byte of data is detected.
		IpSt <= RdFifoAck_s1;
		else
		IpSt <= Wait_s;
		end
		
		RdFifoAck_s1 : begin
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b1;
		data_cnt <= data_cnt + 16'd1;		
		
		IpSt <= RdFifoAck_s2;
		end		

		RdFifoAck_s2 : begin
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b0;		
		data_cnt <= data_cnt + 16'd1;	

		if(icmp_frame)
		IpSt <= Icmp_s; 
		else if(udp_frame)
		IpSt <= Udp_s;
		else
		IpSt <= RDataRx_s;
		end
		
		RDataRx_s: begin
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b0;		
		data_cnt <= data_cnt + 16'd1;			
		
		if(ip_rd_data_valid)
		IpSt <= RDataRx_s;
		else
		IpSt <= Ack_s;
		end
		
		//Assert rx_frame_processed
		Ack_s: begin 
		rx_frame_processed <= 1'b1;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b0;		
		data_cnt <= 16'd0;					
		
		IpSt <= Wait_s;
		end			
		
		Icmp_s: begin 
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b0;		
		data_cnt <= data_cnt + 16'd1;				
		
		if(IcmpReplySent)
		IpSt <= RDataRx_s;
		else
		IpSt <= Icmp_s;
		end

		Udp_s: begin 
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b1;
		ip_rd_ack <= 1'b0;		
		data_cnt <= data_cnt + 16'd1;					
		
		if(UdpProcessed)
		IpSt <= RDataRx_s;
		else
		IpSt <= Udp_s;
		end			
		
		default: begin
		rx_frame_processed <= 1'b0;
		ip_rd_enable <= 1'b0;
		ip_rd_ack <= 1'b0;		
		data_cnt <= 16'd0;			
		
		IpSt <= Wait_s;
		end
		endcase

				
		//UDP FSM
		//udp_rx_dv : include UDP ports info
		//States are UdpWait_s, UdpSof_s, UdpDvAssert, UdpDvRelease,
    parameter UdpWait_s = 2'd0; parameter UdpSof_s = 2'd1;
	parameter UdpDvAssert = 2'd2; parameter UdpDvRelease = 2'd3;	
	reg [1:0] UdpSt = UdpWait_s;		
		
		always @(posedge udp_rx_clk)
		if(reset)
		begin
		udp_rx_dv <= 1'b0;
		UdpProcessed <= 1'b0;
				
		UdpSt <= UdpWait_s;
		end else case(UdpSt)
		UdpWait_s : begin
		udp_rx_dv <= 1'b0;
		UdpProcessed <= 1'b0;
				
		if(udp_frame)
		UdpSt <= UdpSof_s;
		else
		UdpSt <= UdpWait_s;
		end		
		
		UdpSof_s : begin
		udp_rx_dv <= 1'b0;
		UdpProcessed <= 1'b0;
				
		if(data_cnt == UdpFrameSofCnt)
		UdpSt <= UdpDvAssert;
		else
		UdpSt <= UdpSof_s;
		end
		
		UdpDvAssert : begin
		udp_rx_dv <= ip_rd_data_valid;
		UdpProcessed <= 1'b0;
				
		if(data_cnt == IPFrameLen)
		UdpSt <= UdpDvRelease;
		else
		UdpSt <= UdpDvAssert;
		end
		
		UdpDvRelease : begin
		udp_rx_dv <= 1'b0;
		UdpProcessed <= 1'b1;
		
		if(udp_frame)
		UdpSt <= UdpDvRelease;
		else		
		UdpSt <= UdpWait_s;
		end
		
		default: begin
		udp_rx_dv <= 1'b0;
		UdpProcessed <= 1'b0;
				
		UdpSt <= UdpWait_s;		
		end
		endcase
		
		always @(posedge udp_rx_clk)
        udp_rxd <= ip_rd_data;		
		
		assign udp_rx_clk = ip_rd_clk;
		
		always @(posedge icmp_wr_clk)
		if(icmp_frame)
		icmp_length <= IPFrameLen - 6'd34;
		else
		icmp_length <= icmp_length;

		
		//ICMP FSM
		//States are IcmpWait_s, IcmpHeaderLoad_s, IcmpHeaderWr_s, IcmpReplyDataWait_s,
		//IcmpReplyDataSof_s, IcmpFifoWr_s, IcmpAck_s
    parameter IcmpWait_s = 3'd0; parameter IcmpHeaderLoad_s = 3'd1;
	parameter IcmpHeaderWr_s = 3'd2; parameter IcmpReplyDataWait_s = 3'd3;
	parameter IcmpReplyDataSof_s = 3'd4; parameter IcmpFifoWr_s = 3'd5;
	parameter IcmpAck_s = 3'd6; 
	reg [2:0] IcmpSt = IcmpWait_s;
		assign icmp_wr_clk = ip_rd_clk;			
		always @(posedge icmp_wr_clk)
		if(reset)
		begin
		icmp_wr_enable <= 1'b0;
		icmp_tx_data <= 8'h0;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= 4'd0;
		
		IcmpSt <= IcmpWait_s;
		end else case(IcmpSt)
		IcmpWait_s : begin
		icmp_wr_enable <= 1'b0;
		icmp_tx_data <= 8'h0;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= 4'd0;
		
		if(icmp_frame&ip_rd_data_valid)
		IcmpSt <= IcmpHeaderLoad_s;
		else
		IcmpSt <= IcmpWait_s;		
		end
		
		IcmpHeaderLoad_s : begin
		icmp_wr_enable <= 1'b1;
		icmp_tx_data <= 8'h0;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= icmp_header_wire;
		icmp_cnt <= 4'd0;
		
		IcmpSt <= IcmpHeaderWr_s;
		end		
		
		IcmpHeaderWr_s : begin
		icmp_wr_enable <= 1'b1;
		icmp_tx_data <= icmp_header_reg[47:40];
		icmp_tx_data_valid <= 1'b1;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= {icmp_header_reg[39:0],8'h0};
		icmp_cnt <= icmp_cnt + 4'd1;				
		
		if(icmp_cnt == 4'd5)
		IcmpSt <= IcmpReplyDataWait_s;
		else
		IcmpSt <= IcmpHeaderWr_s;
		end
		
		IcmpReplyDataWait_s : begin
		icmp_wr_enable <= 1'b1;
		icmp_tx_data <= 8'h0;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= 4'd0;	
		
		if(data_cnt == IcmpFrameSofCnt)
		IcmpSt <= IcmpReplyDataSof_s;
		else
		IcmpSt <= IcmpReplyDataWait_s;
		end		
		
		IcmpReplyDataSof_s : begin
		icmp_wr_enable <= 1'b1;
		icmp_tx_data <= ip_rd_data;
		icmp_tx_data_valid <= 1'b1;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= 4'd0;	
		
		if(data_cnt == IPFrameLen)
		begin
		icmp_tx_good_frame <= 1'b1;
		IcmpSt <= IcmpFifoWr_s;
		end
		else
		begin
		icmp_tx_good_frame <= 1'b0;
		IcmpSt <= IcmpReplyDataSof_s;
		end
		end			

		IcmpFifoWr_s : begin
		icmp_wr_enable <= 1'b1;
		icmp_tx_data <= ip_rd_data;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= icmp_cnt + 4'd1;			
		
		if(icmp_cnt == 4'd4)
		IcmpSt <= IcmpAck_s;
		else
		IcmpSt <= IcmpFifoWr_s;
		end
		//wr_enable should be asserted at least 3 clock cycles
		//after the deassertion of data_valid

		IcmpAck_s : begin
		icmp_wr_enable <= 1'b1;
		icmp_tx_data <= 8'h0;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b1;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= 4'd0;
		
		if(icmp_frame)
		IcmpSt <= IcmpAck_s;
		else
		IcmpSt <= IcmpWait_s;
		end	

		default : begin
		icmp_wr_enable <= 1'b0;
		icmp_tx_data <= 8'h0;
		icmp_tx_data_valid <= 1'b0;
		icmp_tx_good_frame <= 1'b0;
		IcmpReplySent <= 1'b0;
		icmp_header_reg <= 48'h0;
		icmp_cnt <= 4'd0;		
		
		IcmpSt <= IcmpWait_s;
		end				
		endcase
		
			
   rx_client_fifo_8_rdbus #(.FifoInitAddr(IcmpFifoAddr)) icmp_tx_client_fifo_8_rdbus (
      .rd_clk          (icmp_tx_clk),
      .rd_sreset       (reset),
      .rd_data_out     (icmp_tx_data_out),
      .rd_sof_n        (icmp_tx_sof_n),
      .rd_eof_n        (icmp_tx_eof_n),
      .rd_src_rdy_n    (icmp_tx_src_rdy_n),
      .rd_dst_rdy_n    (icmp_tx_dst_rdy_n),
      .rx_fifo_status  (icmp_rx_fifo_status),
		.rd_addr		     (icmp_tx_tx_fifo_rd_addr),
		
      .wr_sreset       (reset),
      .wr_clk          (icmp_wr_clk),
      .wr_enable       (icmp_wr_enable),
      .rx_data         (icmp_tx_data),
      .rx_data_valid   (icmp_tx_data_valid),
      .rx_good_frame   (icmp_tx_good_frame),
      .rx_bad_frame    (icmp_tx_bad_frame),
      .overflow        (icmp_rx_overflow)		
   ); 		
endmodule
