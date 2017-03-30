`timescale 1ns / 1ps

// EMCal SRU
// Equivalent SRU = SRUV3FM20150701601_PHOS
// Fan Zhang. 16 July 2015

module rx_ip_fsm_fifo_8(
		//EMAC LocalLink receiver interface
		input       	rx_ll_clock,    
    	input [7:0] 	rx_ll_data,  
		input   		rx_ll_sof_n,      
		input   		rx_ll_eof_n,      
		input   		rx_ll_src_rdy_n,
		output  		rx_ll_dst_rdy_n,  
	    
		//EMAC IP receiver interface 
 		input   		ip_rd_clk,
		input  			ip_rd_enable,		
		output  [7:0] 	ip_rd_data,
		output  		ip_rd_data_valid,
		input  			ip_rd_ack,		
		output  		ip_rd_overflow, 
		output	[3:0]	ip_rd_fifo_status, 
		
		input	[47:0]	local_mac,
		input   [31:0]  local_ip,
		output  [95:0]  Eth_reply_MAC,
		output  [63:0]  ip_tx_IP,				
		
		input			arp_reply,
		output	reg		arp_req = 1'b0,
		output  [223:0] arp_tx_reply_frame,
		
		output	reg		udp_frame = 1'b0,
		output 	reg		icmp_frame = 1'b0,
		//output 	reg		drop_frame = 1'b0, 	
        input			rx_frame_processed,
		
		output  [15:0]	IcmpCheckSum,  
		output reg [15:0]  IPFrameLen = 16'd0,
		
		input			reset		
		);
		
		parameter ETH_ARP = 16'h0806;
		parameter ETH_IP = 16'h0800;
		parameter ARP_REQ_CODE = 16'h0001;
		parameter IP_ICMP = 8'h01;
		parameter IP_UDP = 8'h11;
		parameter BROADCAST_MAC = 48'hffff_ffff_ffff;
		parameter ICMP_PING_REQ = 16'h0800;
		parameter ICMP_PING_REPLY = 16'h0000;
		
		parameter ArpHardType = 16'h0001;
		parameter ArpProType = 16'h0800;
		parameter ArpHAPA = 16'h0604;
		parameter ArpOper = 16'h0002;
		
		//ARP reply format:
		//Hardware type: 16'h0001
		//Protocol type: 16'h0800
		//Length of hardware address/protocol address: 16'h0604
		//Operator: 16'h0002
		//Sender MAC
		//Sender IP
		//Receiver MAC
		//Receiver IP
		

		
		//ICMP checksum
		reg CheckSumReset = 1'b0, RxllNewByte = 1'b0, IcmpDataDv = 1'b0;
		reg [7:0] IcmpData = 8'h0;
					
		calculateChecksum IcmpChkSumCalUnit(
		.clk(rx_ll_clock), 
		.rst(reset), 
		.iniChecksum(16'h0), 
		.newChecksum(CheckSumReset), 
		.newByte(IcmpDataDv), 
		.inByte(IcmpData), 
		.checksum(IcmpCheckSum)
	);

		reg [47:0]  local_mac_i = 48'h0,remote_mac = 48'h0,arp_sender_mac = 48'h0;
		reg [31:0]  local_ip_i = 32'h0, remote_ip = 32'h0,arp_sender_ip = 32'h0,arp_receiver_ip = 32'h0;
		reg [7:0]   ip_protocol = 8'h0;
//		reg [15:0]  ip_len = 16'h0, 
		reg [15:0]  eth_type = 16'h0, rx_ll_data_cnt = 16'h0, icmp_type = 16'h0, arp_op_code = 16'h0;		
		reg [47:0]  rx_ll_data_pipe = 48'b0;
		
//		assign IPFrameLen = rx_ll_data_cnt;
//		assign IPFrameLen = rx_ll_data_cnt;
		assign Eth_reply_MAC = {remote_mac,local_mac};
		assign ip_tx_IP = {local_ip,remote_ip};
		assign arp_tx_reply_frame = {ArpHardType, ArpProType, ArpHAPA, ArpOper,local_mac, local_ip,
		arp_sender_mac,arp_sender_ip};		
		   
		reg rx_ll_dst_rdy_n_i = 1'b0;
		
		wire 		wr_clk, wr_sof_n, wr_eof_n, wr_src_rdy_n, wr_dst_rdy_n;
		wire [7:0]  wr_data;   
		wire 		ip_rd_collision, ip_rd_retransmit;
		
		parameter rx_data_WAIT_s = 2'b00; parameter rx_data_SOF_s = 2'b01;
		parameter rx_data_DATA_s = 2'b10; parameter rx_data_EOF_s = 2'b11;
		
		reg [1:0] rx_data_pipe_st = rx_data_WAIT_s;
		
		reg [3:0]	RxllNewByte_pipe = 3'h0;
		always @(posedge rx_ll_clock)
		begin
		RxllNewByte_pipe[0] <= RxllNewByte;
		RxllNewByte_pipe[1] <= RxllNewByte_pipe[0];
		RxllNewByte_pipe[2] <= RxllNewByte_pipe[1];
		RxllNewByte_pipe[3] <= RxllNewByte_pipe[2];
		end				

  //---------------------------------------------------------------------------
  // EMAC LocalLink read state machines and control
  // states are rx_data_WAIT_s, rx_data_SOF_s, rx_data_DATA_s, rx_data_EOF_s
  // data counter is incremented when an new byte of data has been received.
  // data inputs has been registered into a 8-byte pipeline.
  //---------------------------------------------------------------------------
		always @(posedge rx_ll_clock)
		if(reset)
			begin
			rx_ll_data_pipe <= 48'h0;
			rx_ll_data_cnt <= 16'h0;
			RxllNewByte <= 1'b0;
			rx_data_pipe_st <= rx_data_WAIT_s;
			end
		else
			case(rx_data_pipe_st)
			rx_data_WAIT_s : begin
				if(rx_ll_sof_n)
					begin
					rx_ll_data_pipe <= rx_ll_data_pipe;
					rx_ll_data_cnt <= rx_ll_data_cnt;
					RxllNewByte <= 1'b0;
					rx_data_pipe_st <= rx_data_WAIT_s;
					end
				else
					begin
					rx_ll_data_pipe <= {rx_ll_data_pipe[39:0],rx_ll_data};
					rx_ll_data_cnt <= 16'h1;
					RxllNewByte <= 1'b1;
					rx_data_pipe_st <= rx_data_SOF_s;
					end
			end
			
			rx_data_SOF_s : begin
				if(rx_ll_sof_n)
					begin
						if(rx_ll_src_rdy_n)
						begin
						rx_ll_data_pipe <= rx_ll_data_pipe;
						rx_ll_data_cnt <= rx_ll_data_cnt;
						RxllNewByte <= 1'b0;
						rx_data_pipe_st <= rx_data_DATA_s;
						end
							else
						begin
						rx_ll_data_pipe <= {rx_ll_data_pipe[39:0],rx_ll_data};
						rx_ll_data_cnt <= rx_ll_data_cnt + 16'h1;
						RxllNewByte <= 1'b1;
						rx_data_pipe_st <= rx_data_DATA_s;
						end						
					end
				else
					begin
						rx_ll_data_pipe <= rx_ll_data_pipe;
						rx_ll_data_cnt <= rx_ll_data_cnt;
						RxllNewByte <= 1'b0;
						rx_data_pipe_st <= rx_data_SOF_s;
					end
			end	
			
			rx_data_DATA_s : begin
				if(rx_ll_src_rdy_n)
					begin
					rx_ll_data_pipe <= rx_ll_data_pipe;
					rx_ll_data_cnt <= rx_ll_data_cnt;
					RxllNewByte <= 1'b0;
					rx_data_pipe_st <= rx_data_DATA_s;
					end
				else
					begin
					rx_ll_data_pipe <= {rx_ll_data_pipe[39:0],rx_ll_data};
					rx_ll_data_cnt <= rx_ll_data_cnt + 16'h1;
					RxllNewByte <= 1'b1;
					
					if(rx_ll_eof_n)
					rx_data_pipe_st <= rx_data_DATA_s;
					else
					rx_data_pipe_st <= rx_data_EOF_s;
					end
			end
			
			rx_data_EOF_s : begin
				rx_ll_data_pipe <= rx_ll_data_pipe;
				rx_ll_data_cnt <= rx_ll_data_cnt;
				RxllNewByte <= 1'b0;
				
				if(rx_ll_eof_n)
					rx_data_pipe_st <= rx_data_WAIT_s;
					else
					rx_data_pipe_st <= rx_data_EOF_s;
			end
			
			default: begin
				rx_ll_data_pipe <= 48'h0;
				rx_ll_data_cnt <= 16'h0;
				RxllNewByte <= 1'b0;
				rx_data_pipe_st <= rx_data_WAIT_s;			
			end
			endcase

  //---------------------------------------------------------------------------
  // Register ethernet parameters
  // Parameters are local_mac_i, remote_mac, eth_type, ip_len, ip_protocol,
  // remote_ip, local_ip_i, icmp_type
  //----------------------------------------------------------------------------
			
			//load local_mac_i
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd6)
			local_mac_i <= rx_ll_data_pipe[47:0];
			else
			local_mac_i <= local_mac_i;
			
			//load remote_mac
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd12)
			remote_mac <= rx_ll_data_pipe[47:0];
			else
			remote_mac <= remote_mac;
			
			//load eth_type
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd14) 
			eth_type <= rx_ll_data_pipe[15:0];
			else
			eth_type <= eth_type;
			
			//load ip_len
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd18) 
			//ip_len <= rx_ll_data_pipe[15:0];
			IPFrameLen <= 4'd14 + rx_ll_data_pipe[15:0];
			else
			IPFrameLen <= IPFrameLen;

			//load ip_protocol
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd24)
			ip_protocol <= rx_ll_data_pipe[7:0];
			else
			ip_protocol <= ip_protocol;			
			
			//load remote_ip
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd30)
			remote_ip <= rx_ll_data_pipe[31:0];
			else
			remote_ip <= remote_ip;	
			
			//load local_ip_i
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd34)
			local_ip_i <= rx_ll_data_pipe[31:0];
			else
			local_ip_i <= local_ip_i;			
			
			//load icmp_type
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd36)
			icmp_type <= rx_ll_data_pipe[15:0];
			else
			icmp_type <= icmp_type;
			
			
  //---------------------------------------------------------------------------
  // Finite state machine
  // states are IcmpChkWait_s, IcmpChkResetA_s, IcmpChkResetR_s, IcmpChkPro_s,
  // IcmpChkCode_s, IcmpChkH_s, IcmpChkL_s, IcmpRemainData_s
  // decode the output signals depending on the current state
  // rx_ll_dst_rdy_n_i is asserted "0" in default.
  // arp_req 
  // udp_frame
  // icmp_frame
  // rx_frame_processed (input)
  //----------------------------------------------------------------------------
    parameter IcmpChkWait_s = 4'd0; parameter IcmpChkResetA_s = 4'd1;
	parameter IcmpChkResetR_s = 4'd2; parameter IcmpChkPro_s = 4'd3;
	parameter IcmpChkCode_s = 4'd4; parameter IcmpChkH_s = 4'd5;
	parameter IcmpChkL_s = 4'd6; parameter IcmpRemainDataS_s = 4'd7;
	parameter IcmpRemainDataF_s = 4'd8;
    reg [3:0]	IcmpChkSt = IcmpChkWait_s;
			
			always @(posedge rx_ll_clock)
			if(reset)
			begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b0;
			IcmpData <= 8'h0;
			
			IcmpChkSt <= IcmpChkWait_s;
			end else case(IcmpChkSt)
			IcmpChkWait_s : begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b0;
			IcmpData <= 8'h0;
			
			if(rx_ll_data_cnt == 16'd24)
			IcmpChkSt <= IcmpChkResetA_s;		
			else
			IcmpChkSt <= IcmpChkWait_s;			
			end
			
			IcmpChkResetA_s : begin
			CheckSumReset <= 1'b1;
			IcmpDataDv <= 1'b0;
			IcmpData <= 8'h0;
			
			IcmpChkSt <= IcmpChkResetR_s;			
			end	

			IcmpChkResetR_s : begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b0;
			IcmpData <= 8'h0;
			
			IcmpChkSt <= IcmpChkPro_s;			
			end				
			
			IcmpChkPro_s : begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b1;
			IcmpData <= ICMP_PING_REPLY[15:8];
			
			IcmpChkSt <= IcmpChkCode_s;			
			end				

			IcmpChkCode_s : begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b1;
			IcmpData <= ICMP_PING_REPLY[7:0];
			
			IcmpChkSt <= IcmpChkH_s;			
			end	
			
			IcmpChkH_s : begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b1;
			IcmpData <= 8'h0;
			
			IcmpChkSt <= IcmpChkL_s;			
			end	

			IcmpChkL_s : begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b1;
			IcmpData <= 8'h0;
			
			IcmpChkSt <= IcmpRemainDataS_s;			
			end	
			
			IcmpRemainDataS_s : begin
			CheckSumReset <= 1'b0;
						
			IcmpDataDv <= 1'b0;
			IcmpData <= rx_ll_data_pipe[7:0];
			
			if(rx_ll_data_cnt == 16'd38)
			IcmpChkSt <= IcmpRemainDataF_s;				
			else
			IcmpChkSt <= IcmpRemainDataS_s;
			end	
			
			IcmpRemainDataF_s : begin
			CheckSumReset <= 1'b0;
						
			IcmpDataDv <= icmp_frame & RxllNewByte;
			IcmpData <= rx_ll_data_pipe[7:0];
			
			if(rx_ll_data_cnt == 16'd1)
			IcmpChkSt <= IcmpChkWait_s;				
			else
			IcmpChkSt <= IcmpRemainDataF_s;
			end
			
			default: begin
			CheckSumReset <= 1'b0;
			IcmpDataDv <= 1'b0;
			IcmpData <= 8'h0;
			
			IcmpChkSt <= IcmpChkWait_s;				
			end
			endcase
		
  //---------------------------------------------------------------------------
  // Register ARP parameters
  // arp_op_code, arp_receiver_ip 
  // arp_sender_mac, and arp_sender_ip
  //----------------------------------------------------------------------------
 			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd22)
			arp_op_code <= rx_ll_data_pipe[15:0];
			else
			arp_op_code <= arp_op_code; 

			//load arp_sender_mac
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd28)
			arp_sender_mac <= rx_ll_data_pipe[47:0];
			else
			arp_sender_mac <= arp_sender_mac;	
			
			//load arp_sender_ip
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd32)
			arp_sender_ip <= rx_ll_data_pipe[31:0];
			else
			arp_sender_ip <= arp_sender_ip;				

			//load arp_receiver_ip
			always @(posedge rx_ll_clock)
			if(rx_ll_data_cnt == 16'd42)
			arp_receiver_ip <= rx_ll_data_pipe[31:0];
			else
			arp_receiver_ip <= arp_receiver_ip;	

			
  //---------------------------------------------------------------------------
  // Finite state machine
  // states are EthSt_WAIT_s, EthSt_MAC_s, EthSt_EthType_s, EthSt_ARPReq_s,EthSt_ARPPly_s,
  // EthSt_IP_s, EthSt_ICMP_s, EthSt_UDP_s, EthSt_DROP_s, EthSt_EOF_s, 
  // EthSt_FramePro_s
  // decode the output signals depending on the current state
  // rx_ll_dst_rdy_n_i is asserted "0" in default.
  // arp_req 
  // udp_frame
  // icmp_frame
  // drop_frame
  // rx_frame_processed (input)
  //----------------------------------------------------------------------------
    parameter EthSt_WAIT_s = 4'd0; parameter EthSt_MAC_s = 4'd1;
	parameter EthSt_EthType_s = 4'd2; parameter EthSt_ARPReq_s = 4'd3;	
	parameter EthSt_ARPRly_s = 4'd4; parameter EthSt_IP_s = 4'd5; 
	parameter EthSt_ICMP_s = 4'd6; 	parameter EthSt_UDP_s = 4'd7; 
	parameter EthSt_DROP_s = 4'd8; 	parameter EthSt_EOF_s = 4'd9; 
	parameter EthSt_FramePro_s = 4'd10;	parameter EthSt_ARPChk_s = 4'd11; 
	
	reg [3:0] EthSt = EthSt_WAIT_s;
	
			always @(posedge rx_ll_clock)
			if(reset)
			begin	
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;
			arp_req <= 1'b0;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			EthSt <= EthSt_WAIT_s;
			end else case(EthSt)
			
			EthSt_WAIT_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;
			arp_req <= 1'b0;
			
			if(ip_rd_fifo_status > 4'he)
			rx_ll_dst_rdy_n_i <= 1'b1;
			else
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_sof_n)
			EthSt <= EthSt_WAIT_s;
			else
			EthSt <= EthSt_MAC_s;
			end
			
			EthSt_MAC_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;	
			arp_req <= 1'b0;			
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_data_cnt == 16'd7)
				if((local_mac_i == BROADCAST_MAC)||(local_mac_i == local_mac))
				EthSt <= EthSt_EthType_s;
				else
				EthSt <= EthSt_DROP_s;
			else
			EthSt <= EthSt_MAC_s;			
			end		

			EthSt_EthType_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;	
            arp_req <= 1'b0;				
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_data_cnt == 16'd23)
				if(eth_type == ETH_IP)
				EthSt <= EthSt_IP_s;
				else if((eth_type == ETH_ARP)&&(arp_op_code == ARP_REQ_CODE))
				EthSt <= EthSt_ARPReq_s;
				else
				EthSt <= EthSt_DROP_s;
			else
			EthSt <= EthSt_EthType_s;			
			end	

			EthSt_ARPReq_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;	
			arp_req <= 1'b0;			
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_eof_n)
			EthSt <= EthSt_ARPReq_s;
			else
			EthSt <= EthSt_ARPChk_s;			
			end			

			EthSt_ARPChk_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;	
			arp_req <= 1'b0;			
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(arp_receiver_ip == local_ip)
			EthSt <= EthSt_ARPRly_s;
			else
			EthSt <= EthSt_WAIT_s;			
			end
			
			EthSt_ARPRly_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;	
			arp_req <= 1'b1;			
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(arp_reply)
			EthSt <= EthSt_WAIT_s;
			else
			EthSt <= EthSt_ARPRly_s;			
			end				
			
			EthSt_IP_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;	
			arp_req <= 1'b0;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_data_cnt == 16'd37)
				if((ip_protocol == IP_ICMP)&&(local_ip_i == local_ip)&&(icmp_type == ICMP_PING_REQ))
				EthSt <= EthSt_ICMP_s; //ICMP request
				else if((ip_protocol == IP_UDP)&&(local_ip_i == local_ip))
				EthSt <= EthSt_UDP_s; //UDP packet
				else
				EthSt <= EthSt_DROP_s; //Other packet
			else
			EthSt <= EthSt_IP_s;			
			end	

			EthSt_ICMP_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b1;
			//drop_frame <= 1'b0;				
			arp_req <= 1'b0;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_eof_n)
			EthSt <= EthSt_ICMP_s;
			else
			EthSt <= EthSt_EOF_s;			
			end
			
			EthSt_UDP_s : begin
			udp_frame <= 1'b1;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;				
			arp_req <= 1'b0;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_eof_n)
			EthSt <= EthSt_UDP_s;
			else
			EthSt <= EthSt_EOF_s;			
			end			
			
			EthSt_DROP_s : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b1;				
			arp_req <= 1'b0;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_eof_n)
			EthSt <= EthSt_DROP_s;
			else
			EthSt <= EthSt_EOF_s;			
			end

			EthSt_EOF_s : begin
			udp_frame <= udp_frame;
			icmp_frame <= icmp_frame;
			//drop_frame <= drop_frame;				
			arp_req <= arp_req;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			if(rx_ll_eof_n)
			EthSt <= EthSt_FramePro_s;
			else
			EthSt <= EthSt_EOF_s;			
			end	

			EthSt_FramePro_s : begin
			udp_frame <= udp_frame;
			icmp_frame <= icmp_frame;
			//drop_frame <= drop_frame;				
			arp_req <= arp_req;
			
			rx_ll_dst_rdy_n_i <= 1'b1;
			
			if(rx_frame_processed)
			EthSt <= EthSt_WAIT_s;
			else
			EthSt <= EthSt_FramePro_s;			
			end				

			default : begin
			udp_frame <= 1'b0;
			icmp_frame <= 1'b0;
			//drop_frame <= 1'b0;				
			arp_req <= 1'b0;
			
			rx_ll_dst_rdy_n_i <= 1'b0;
			
			EthSt <= EthSt_WAIT_s;			
			end		
			endcase
	
   parameter FULL_DUPLEX_ONLY = 0;

   // Transmitter FIFO
   tx_client_fifo_8 #(
      .FULL_DUPLEX_ONLY (FULL_DUPLEX_ONLY)
   )
   tx_fifo_i (
      .rd_clk          (ip_rd_clk),
      .rd_sreset       (reset),
      .rd_enable       (ip_rd_enable),
      .tx_data         (ip_rd_data),
      .tx_data_valid   (ip_rd_data_valid),
      .tx_ack          (ip_rd_ack),
      .tx_collision    (ip_rd_collision),
      .tx_retransmit   (ip_rd_retransmit),
	  
      .overflow        (ip_rd_overflow),
	  
      .wr_clk          (wr_clk),
      .wr_sreset       (reset),
      .wr_data         (wr_data),
      .wr_sof_n        (wr_sof_n),
      .wr_eof_n        (wr_eof_n),
      .wr_src_rdy_n    (wr_src_rdy_n),
      .wr_dst_rdy_n    (wr_dst_rdy_n),
	  
      .wr_fifo_status  (ip_rd_fifo_status)
   );

	
   assign wr_clk = rx_ll_clock;
   assign wr_sof_n = rx_ll_sof_n;
   assign wr_data = rx_ll_data;
   assign wr_eof_n = rx_ll_eof_n;
   assign wr_src_rdy_n = rx_ll_src_rdy_n;
   assign rx_ll_dst_rdy_n = wr_dst_rdy_n | rx_ll_dst_rdy_n_i; 
   assign ip_rd_collision = 1'b0;
   assign ip_rd_retransmit = 1'b0;
   
   endmodule			