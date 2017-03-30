`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module dcs_eth_top
#(parameter Simulation = 1'b0,
parameter EMAC_PHYINITAUTONEG_ENABLE = "TRUE")
(
		//Incoming UDP stream interface
		output				udp_rx_clk,
		output  	[7:0]		udp_rxd,
		output  		   	udp_rx_dv,
		
		output  				udp_tx_rd_clk,
		input 				udp_tx_rd_sof_n,
		input 	[7:0] 	udp_tx_rd_data_out,
		input 				udp_tx_rd_eof_n,
		input 				udp_tx_rd_src_rdy_n,
		output 				udp_tx_rd_dst_rdy_n,
		output  [5:0]  	udp_tx_rd_fifo_addr,		
		
		//local MAC and IP addresses
		input 	[47:0]	local_mac,
		input 	[31:0] 	local_ip,
		output 	[31:0] 	udp_rx_src_ip,
		output				dcs_eth_sync,
		
 	   input        		mgtrefclk_p,           
	   input       		mgtrefclk_n,           
      output       		txp,                   
      output       		txn,                   
      input        		rxp,                   
      input        		rxn,
		
		input        		reset           
	);		
	
parameter ArpFifoAddr = 6'd1;	
parameter IpFifoAddr = 6'd0;
parameter IcmpFifoAddr = 6'd1;
parameter UdpFifoAddr = 6'd0;
//Connected to three modules: arp_reply_fsm, ip_reply_fsm, Eth_tx_fsm.
wire Eth_reply_rd_clk;
wire Eth_reply_rd_sof_n;
wire [7:0] Eth_reply_rd_data_out;
wire Eth_reply_rd_eof_n;
wire Eth_reply_rd_src_rdy_n;
wire Eth_reply_rd_dst_rdy_n;
wire [5:0] Eth_reply_rd_fifo_addr;

//Connected to module: u_rx_ip_fsm_fifo_8, u_ip_packet_proc_fsm
wire ip_rd_clk;
wire ip_rd_enable;
wire [7:0] ip_rd_data;
wire ip_rd_data_valid;
wire ip_rd_ack;
wire [15:0] IPFrameLen;

//Connected to module: u_rx_ip_fsm_fifo_8, u_arp_reply_fsm
wire arp_reply;
wire arp_req;
wire [223:0] arp_tx_reply_frame;

//Connected to module: u_rx_ip_fsm_fifo_8, u_ip_packet_proc_fsm
wire udp_frame;
wire icmp_frame;
//wire drop_frame;
wire rx_frame_processed;
wire [15:0] IcmpCheckSum;	

//Connected to module: u_ip_packet_proc_fsm, u_udp_reply_mux, u_ip_reply_fsm
wire ip_tx_rd_clk;
wire ip_tx_rd_sof_n;
wire [7:0] ip_tx_rd_data_out;
wire ip_tx_rd_eof_n;
wire ip_tx_rd_src_rdy_n;
wire ip_tx_rd_dst_rdy_n;
wire [5:0] ip_tx_rd_fifo_addr;

		// local link interface
		wire rx_ll_clock;
		wire rx_ll_reset;
		wire [7:0] rx_ll_data;
		wire rx_ll_sof_n;
		wire rx_ll_eof_n;
		wire rx_ll_src_rdy_n;
		wire rx_ll_dst_rdy_n;
		
		wire tx_ll_clock;
		wire tx_ll_reset;
		wire [7:0] tx_ll_data;
		wire tx_ll_sof_n;
		wire tx_ll_eof_n;
		wire tx_ll_src_rdy_n;
		wire tx_ll_dst_rdy_n;
		wire eth_reset;
		
wire [95:0] Eth_reply_MAC;
wire [63:0] ip_tx_IP;

//There are 6 submodules instainiated in this module: rx_ip_fsm_fifo_8, ip_reply_fsm, arp_reply_fsm, Eth_tx_fsm, ip_packet_proc_fsm, udp_reply_mux.
 
//rx_ip_fsm_fifo_8: buffer the incoming Ethernet frame, check the MAC/IP address and frame protocol types.
//In the meantime, calculate the checksum of the ICMP reply frame.	
rx_ip_fsm_fifo_8 u_rx_ip_fsm_fifo_8 (
	//EMAC core local link interface
    .rx_ll_clock(rx_ll_clock), 
    .rx_ll_data(rx_ll_data), 
    .rx_ll_sof_n(rx_ll_sof_n), 
    .rx_ll_eof_n(rx_ll_eof_n), 
    .rx_ll_src_rdy_n(rx_ll_src_rdy_n), 
    .rx_ll_dst_rdy_n(rx_ll_dst_rdy_n), 
	
	//IP receiver fifo interface
	//Include a complete Ethernet frame: Eth header, ARP/IP header, ARP data/ UDP/ICMP header and data
	//Frame length is the number of the bytes of the frame.
    .ip_rd_clk(ip_rd_clk), 
    .ip_rd_enable(ip_rd_enable), 
    .ip_rd_data(ip_rd_data), 
    .ip_rd_data_valid(ip_rd_data_valid), 
    .ip_rd_ack(ip_rd_ack), 
    .ip_rd_overflow(), 
    .ip_rd_fifo_status(), 
	.IPFrameLen(IPFrameLen),
    
	//Ethernet physical and logical addresses
	.local_mac(local_mac), 
    .local_ip(local_ip), 
	.Eth_reply_MAC(Eth_reply_MAC), 
	.ip_tx_IP(ip_tx_IP),
    
	//ARP require and reply control signals and ARP frame.
	.arp_reply(arp_reply), 
    .arp_req(arp_req), 
    .arp_tx_reply_frame(arp_tx_reply_frame), 
    
	//UDP/ICMP and discard frame control signals.
	.udp_frame(udp_frame), 
    .icmp_frame(icmp_frame), 
    //.drop_frame(drop_frame), 
    .rx_frame_processed(rx_frame_processed), 
    
	//Checksum of the ICMP reply frame
	.IcmpCheckSum(IcmpCheckSum), 
	   
	.reset(eth_reset)
    );

//ip_packet_proc_fsm: decode the IP packet, provide udp interface, store the ICMP reply frame into a fifo.
ip_packet_proc_fsm #(.IcmpFifoAddr(IcmpFifoAddr)) u_ip_packet_proc_fsm (
    .ip_rd_clk(ip_rd_clk), 
    .ip_rd_enable(ip_rd_enable), 
    .ip_rd_data(ip_rd_data), 
    .ip_rd_data_valid(ip_rd_data_valid), 
    .ip_rd_ack(ip_rd_ack),
	
    .udp_frame(udp_frame), 
    .icmp_frame(icmp_frame), 
    .rx_frame_processed(rx_frame_processed), 
    .IcmpCheckSum(IcmpCheckSum), 
    .IPFrameLen(IPFrameLen), 
	
    .icmp_tx_clk(ip_tx_rd_clk), 
    .icmp_tx_sof_n(ip_tx_rd_sof_n), 
    .icmp_tx_data_out(ip_tx_rd_data_out), 
    .icmp_tx_eof_n(ip_tx_rd_eof_n), 
    .icmp_tx_src_rdy_n(ip_tx_rd_src_rdy_n), 
    .icmp_tx_dst_rdy_n(ip_tx_rd_dst_rdy_n), 
	 .icmp_tx_tx_fifo_rd_addr(ip_tx_rd_fifo_addr),
    .icmp_rx_fifo_status(), 
    .icmp_rx_overflow(),
	
    .udp_rx_clk(udp_rx_clk), 
    .udp_rxd(udp_rxd), 
    .udp_rx_dv(udp_rx_dv), 
	
    .reset(eth_reset)
    );
	
//arp_reply_fsm : 
arp_reply_fsm #(.ArpFifoAddr(ArpFifoAddr)) u_arp_reply_fsm (
    //ARP reply fifo interface
	.arp_tx_clk(Eth_reply_rd_clk), 
    .arp_tx_sof_n(Eth_reply_rd_sof_n), 
    .arp_tx_data_out(Eth_reply_rd_data_out), 
    .arp_tx_eof_n(Eth_reply_rd_eof_n), 
    .arp_tx_src_rdy_n(Eth_reply_rd_src_rdy_n), 
    .arp_tx_dst_rdy_n(Eth_reply_rd_dst_rdy_n), 
    .arp_tx_fifo_rd_addr(Eth_reply_rd_fifo_addr), 
    .arp_tx_fifo_status(), 
    .arp_tx_overflow(), 
	
	//ARP reply control signals and frame content.
    .arp_tx_reply_frame(arp_tx_reply_frame), 
    .arp_req(arp_req), 
    .arp_reply(arp_reply), 
    
	.reset(eth_reset)
    );	
	
//ip_reply_fsm : Provide IP header and pack up the UDP and ICMP reply packets into a IP frame alternatively.
ip_reply_fsm #(.IpFifoAddr(IpFifoAddr)) u_ip_reply_fsm (
	//ICMP/UDP reply fifo interface (BUS)
    .ip_tx_clk(Eth_reply_rd_clk), 
    .ip_tx_sof_n(Eth_reply_rd_sof_n), 
    .ip_tx_data_out(Eth_reply_rd_data_out), 
    .ip_tx_eof_n(Eth_reply_rd_eof_n), 
    .ip_tx_src_rdy_n(Eth_reply_rd_src_rdy_n), 
    .ip_tx_dst_rdy_n(Eth_reply_rd_dst_rdy_n), 
    .ip_rx_fifo_rd_addr(Eth_reply_rd_fifo_addr), 
    .ip_rx_fifo_status(), 
    .ip_rx_overflow(), 
	
	//IP reply interface
    .ip_tx_rd_clk(ip_tx_rd_clk), 
    .ip_tx_rd_sof_n(ip_tx_rd_sof_n), 
    .ip_tx_rd_data_out(ip_tx_rd_data_out), 
    .ip_tx_rd_eof_n(ip_tx_rd_eof_n), 
    .ip_tx_rd_src_rdy_n(ip_tx_rd_src_rdy_n), 
    .ip_tx_rd_dst_rdy_n(ip_tx_rd_dst_rdy_n), 
    .ip_tx_rd_fifo_addr(ip_tx_rd_fifo_addr), 
	
	//Reply IP addresses
    .ip_tx_IP(ip_tx_IP),
	
    .reset(eth_reset)
    );

//Eth_tx_fsm : Pack the ARP/IP reply packet into an Ethernet packet.
//Add the Ethernet MAC address and Ethernet type parameters into the packet header.
Eth_tx_fsm u_Eth_tx_fsm (
    //Ethernet reply fifo interface
	.Eth_tx_clk(tx_ll_clock), 
    .Eth_tx_sof_n(tx_ll_sof_n), 
    .Eth_tx_data_out(tx_ll_data), 
    .Eth_tx_eof_n(tx_ll_eof_n), 
    .Eth_tx_src_rdy_n(tx_ll_src_rdy_n), 
    .Eth_tx_dst_rdy_n(tx_ll_dst_rdy_n), 
	
    .Eth_tx_fifo_status(), 
    .Eth_tx_overflow(), 	
	
	//ARP/IP reply fifo bus interface
    .Eth_reply_rd_clk(Eth_reply_rd_clk), 
    .Eth_reply_rd_sof_n(Eth_reply_rd_sof_n), 
    .Eth_reply_rd_data_out(Eth_reply_rd_data_out), 
    .Eth_reply_rd_eof_n(Eth_reply_rd_eof_n), 
    .Eth_reply_rd_src_rdy_n(Eth_reply_rd_src_rdy_n), 
    .Eth_reply_rd_dst_rdy_n(Eth_reply_rd_dst_rdy_n), 
    .Eth_reply_rd_fifo_addr(Eth_reply_rd_fifo_addr), 
	
    //Ethernet reply MAC addresses
	.Eth_reply_MAC(Eth_reply_MAC), 
    
	.reset(eth_reset)
    );


generate 
	if(!Simulation) begin: EMACORE
	xgbe2_ll_wrapper #(.EMAC_PHYINITAUTONEG_ENABLE(EMAC_PHYINITAUTONEG_ENABLE)) u_xgbe2_ll_wrapper (
		.mgtclk_p(mgtrefclk_p), 
		.mgtclk_n(mgtrefclk_n), 
		
		.rx_ll_clock(rx_ll_clock), 
		.rx_ll_reset(rx_ll_reset), 
		.rx_ll_data(rx_ll_data), 
		.rx_ll_sof_n(rx_ll_sof_n), 
		.rx_ll_eof_n(rx_ll_eof_n), 
		.rx_ll_src_rdy_n(rx_ll_src_rdy_n), 
		.rx_ll_dst_rdy_n(rx_ll_dst_rdy_n), 

		.tx_ll_clock(tx_ll_clock), 
		.tx_ll_reset(tx_ll_reset), 
		.tx_ll_data(tx_ll_data), 
		.tx_ll_sof_n(tx_ll_sof_n), 
		.tx_ll_eof_n(tx_ll_eof_n), 
		.tx_ll_src_rdy_n(tx_ll_src_rdy_n), 
		.tx_ll_dst_rdy_n(tx_ll_dst_rdy_n), 

		.txp(txp), 
		.txn(txn), 
		.rxp(rxp), 
		.rxn(rxn), 
		.EMACCLIENTSYNCACQSTATUS (dcs_eth_sync),
		.emacclient_status(), 
		.reset(reset)
	);	
	assign eth_reset = rx_ll_reset | tx_ll_reset;
	end else begin
	rx_ll_fifo_stimulus u_rx_ll_fifo_stimulus (
    .rx_ll_clock(rx_ll_clock), 
    .rx_ll_data(rx_ll_data), 
    .rx_ll_sof_n(rx_ll_sof_n), 
    .rx_ll_eof_n(rx_ll_eof_n), 
    .rx_ll_src_rdy_n(rx_ll_src_rdy_n)
    );
	assign eth_reset = reset;
	assign tx_ll_clock = rx_ll_clock;
	assign tx_ll_dst_rdy_n = 1'b0;
	end
	endgenerate

//udp_reply_mux: Select one of multiple UDP reply fifos (support 64 fifos) and forwards
//one frame in one of the fifo into a single fifo.
udp_reply_mux #(.MaxUdpCh(3), .UdpFifoAddr(UdpFifoAddr)) u_udp_reply_mux (
    .udp_sw_tx_clk(ip_tx_rd_clk), 
    .udp_sw_tx_sof_n(ip_tx_rd_sof_n), 
    .udp_sw_tx_data_out(ip_tx_rd_data_out), 
    .udp_sw_tx_eof_n(ip_tx_rd_eof_n), 
    .udp_sw_tx_src_rdy_n(ip_tx_rd_src_rdy_n), 
    .udp_sw_tx_dst_rdy_n(ip_tx_rd_dst_rdy_n), 
    .udp_sw_tx_fifo_rd_addr(ip_tx_rd_fifo_addr), 
    .udp_sw_tx_fifo_status(), 
    .udp_sw_tx_overflow(), 
	
    .udp_tx_rd_clk(udp_tx_rd_clk), 
    .udp_tx_rd_sof_n(udp_tx_rd_sof_n), 
    .udp_tx_rd_data_out(udp_tx_rd_data_out), 
    .udp_tx_rd_eof_n(udp_tx_rd_eof_n), 
    .udp_tx_rd_src_rdy_n(udp_tx_rd_src_rdy_n), 
    .udp_tx_rd_dst_rdy_n(udp_tx_rd_dst_rdy_n), 
    .udp_tx_rd_fifo_addr(udp_tx_rd_fifo_addr), 
	
    .reset(eth_reset)
    );	


assign ip_rd_clk = rx_ll_clock;
assign udp_rx_src_ip = ip_tx_IP[31:0];
	
	 endmodule
	 