`timescale 1ns / 1ps


module sru_top #(
//parameter SRUHDVer = 1'b1,  //'0': SRUV2; '1' : SRUV3
parameter DDL_Simulation = 1'b0,
parameter Eth_Simulation = 1'b0,
parameter EMAC_PHYINITAUTONEG_ENABLE = "TRUE",
//parameter DetectorType = 1'b1, //'0' PHOS; '1' : EMCal
parameter SRUFMVer = 32'h16091512,
parameter SimSruCfg = {24'h0, 2'b00, 2'b00, 3'h3, 1'b1},
parameter SimDtcRdoMask = 40'hfffff_fffff,
parameter SimAltroCfg = 40'h0,
parameter SimTrigL1Tw = {16'd300, 16'd120},
parameter SimTrigL2Tw = {16'd20000, 16'd200},
parameter SimPTrigCfg = {1'h0, 16'h4E20}, //16'h4E20 = 500 us
parameter SimTestTrigCfg0 = {16'h12C0, 16'h0064}, //16'h12C0 = 120 us
parameter SimTestTrigCfg1 = {12'h0,4'b1101,16'h1770}  //16'h1770 = 150 us
)
(
		input 					brd_reset_n,
		
		//clocks for the SRUV3
		input 					brdclk_p, //100 MHz differential clock
		input 					brdclk_n,
		
		input 					ttc_clk40_p, //clock from TTC chip
		input 					ttc_clk40_n,
				
		output [3:0] 			LedIndicator,
		
		input 					htrig,
		input [1:0] 			sru_busy_flag_in_p,
		input [1:0] 			sru_busy_flag_in_n,
		output 					sru_busy_flag_out_p,
		output 					sru_busy_flag_out_n,		
		
		//TTC interface
		input 					ttc_evcntres,
		input 					ttc_bcntres,
		input 					ttc_ready,
		output 					ttc_reset_b,		
		input 					ttc_l1accept_p,
		input 					ttc_l1accept_n,		
		input 					ttc_doutstr,
		input [7:0] 			ttc_dout,		
		input [7:0] 			ttc_saddr,

		//Flash
		output [22:0] 			FLASH_A,
		output [15:0] 			FLASH_DQ,
		output 					FLASH_CS_B,
		output 					FLASH_OE_B,
		output 					FLASH_WE_B,
		output	 				FLASH_RS0,
		output 					FLASH_RS1,		
		output 					FPGA_PROG_B,

		//DDL links
		input 	[1:0] ddl_rxn,
		input 	[1:0]	ddl_rxp,
		output 	[1:0]	ddl_txn,
		output 	[1:0]	ddl_txp,
		input 			ddl_refclk_p,
		input 			ddl_refclk_n,
		
		//Ethernet links
 	   input        			mgtrefclk_p,         
	   input        			mgtrefclk_n,          
      output       			txp,                 
      output       			txn,                 
      input        			rxp,                 
      input        			rxn,                 
		
		//DTC links
		output [39:0] 			dtc_clk_p,
		output [39:0] 			dtc_clk_n,
      output [39:0] 			dtc_trig_p,
		output [39:0] 			dtc_trig_n,
		input  [39:0] 			dtc_data_p,
		input  [39:0] 			dtc_data_n,
		input  [39:0] 			dtc_return_p,
		input  [39:0] 			dtc_return_n
	 );
	 
		//-------------------------------------------------------------------------
		// Wires for DCS Ethernet modules
		parameter SruFifoAddr = 6'd2;
		parameter FlashFifoAddr = 6'd3;
		
		//Incoming UDP stream interface
		wire [7:0] 		udp_rxd;
		wire 				udp_rx_dv;
		wire 				udp_rx_clk;
		wire [15:0]		udp_rx_dst_port;
		wire [15:0]		udp_rx_src_port;
		wire [31:0]		udp_rx_src_ip;

		//UDP mux interface
		wire  			udp_tx_rd_clk;
		wire 				udp_tx_rd_sof_n;
		wire [7:0] 		udp_tx_rd_data_out;
		wire 				udp_tx_rd_eof_n;
		wire 				udp_tx_rd_src_rdy_n;
		wire 				udp_tx_rd_dst_rdy_n;
		wire [5:0]  	udp_tx_rd_fifo_addr;	
		
		//DCS command interface: 41 ports (40 FEE + SRU)
		wire				dcs_rx_clk;
		wire [7:0]		dcs_rxd;
		wire [40:0]		dcs_rx_dv;	 
		//-------------------------------------------------------------------------

		//-------------------------------------------------------------------------	
		wire				ddl_rdo_clk;
	   //wire				DtcRamclkb;
		wire	[39:0]	DtcRamenb;
		//wire  [9:0]		DtcRamaddrb;
		wire 	[1319:0]	DtcRamdoutb;
		//wire 				DtcRamReadConfirm;
		//wire [31:0]		ddl_ecnt;
		
		wire 				EventRdySent; 
		wire				ddl_tx_start;
		//wire [79:0]		rdo_cfg;
		wire [1:0]		sclkphasecnt;
		wire				STrigErrFlag;
		wire [39:0]		DTCEventRdy;
		wire 				DtcRamClr;
		wire 				DtcRamFlag;
		wire				siu_tx_en;
		//-------------------------------------------------------------------------	
		wire [39:0] 	dtc_clk;
		//DTC_RETURN, DTC_DATA. Deser
		wire [39:0] 	DeserBitclk; //Phase tunable
		wire [39:0] 	DeserBitclkDiv; //Phase tunable
		//DTC_TRIG, Ser
		wire [39:0] 	SerBitclk; //Phase untunable
		wire [39:0] 	SerBitclkDiv; //Phase untunable
		wire 				clk10m,clk10m_i;
		wire 				dcsclk,rdoclk,icap_clk;
//		wire 				brdclk;		
		//-------------------------------------------------------------------------
		//wire  			CDHVer;
		wire [7:0] 		ParReq;
		wire [31:0] 	cdh_w0;
		wire [31:0] 	cdh_w1;
		wire [31:0] 	cdh_w2;
		wire [31:0] 	cdh_w3;
		wire [31:0] 	cdh_w4;
		wire [31:0] 	cdh_w5;
		wire [31:0] 	cdh_w6;
		wire [31:0] 	cdh_w7;
		wire [31:0] 	cdh_w8;
		wire [31:0] 	cdh_w9;
		wire [31:0] 	L2aMes8Cnt;
		//-------------------------------------------------------------------------
		wire 				sru_l0;
		wire 				l1out;
		wire 				abortcmd;
		wire 				rdocmd;
		wire				FeeTrig;
		wire				pscmd;
		//-------------------------------------------------------------------------
		
		//Status register
		wire [31:0]				sru_sn;
		wire [31:0]				local_ip;
		//SRUFMVer
		wire [31:0]				sru_status;		
		wire [39:0]				dtc_err_flag;
		
		wire [31:0]				srucfg;		
		wire [39:0]				dtc_power_en;
		wire [39:0]				dtc_rdo_mask;
		wire [39:0]				ddl_sel;
		wire [39:0]				altrocfg;
		wire [31:0]				trigl1tw;
		wire [31:0]				trigl2tw;
		wire [16:0]				ptrigcfg;
		wire [31:0]				testtrigcfg0;
		wire [31:0]				testtrigcfg1;		
		wire [16:0]				psscancfg;
		
		//commands
		wire				   	strig_cmd;
		wire 						trigcnt_clr;
		wire 						trigerr_clr;
		wire   					FPGAReload;
		wire  					FastCmd;
		wire [7:0]        	FastCmdCode;
		wire   		 			walign;
		wire 		 	 			errtest;
		
		wire 	[15:0]			dtc_deser_dout;
		wire 	[639:0] 			dtc_dout;		
		wire 	[639:0] 			errcnt;

		wire	[255:0]			debugreg;

		//wire 	[31:0]			ddl_if_debug;


		wire 	[31:0]			L2aBunCnt;
		wire 	[31:0]			L2aOrbCnt;	

		wire 	[31:0]			TrigDebugReg;
		
		wire 	 					FastCmdAck;
		//-------------------------------------------------------------------------	

		//-------------------------------------------------------------------------	
		//Internal singals
		wire						BusyFlag;
		wire						dcs_eth_sync;
		
		wire 						DcsClkLockSt;
		wire 						SerClkLockSt;
		wire						psscan_flag;
		//wire 	[1:0]	   		rorc_status;
		wire			   		trig_busy;
		
		wire [5:0]  			trigerr;
		wire [31:0] 			sem_status;
		wire 						FEE_Err_Flag_OR;
		wire 						DTC_Link_Flag_OR;
		
		assign sru_status[0] = BusyFlag;
		assign sru_status[1] = 1'b0;
		assign sru_status[2] = ttc_ready;
		assign sru_status[3] = dcs_eth_sync;
		assign sru_status[4] = DcsClkLockSt;
		assign sru_status[5] = SerClkLockSt;
		//assign sru_status[7:6] = rorc_status;
		//assign sru_status[11:8] = 4'b0;
		assign sru_status[17:12] = trigerr;
		assign sru_status[19:18] = 2'h0;
		assign sru_status[20] = psscan_flag;
		assign sru_status[21] = FEE_Err_Flag_OR;
		assign sru_status[22] = DTC_Link_Flag_OR;
		assign sru_status[29:23] = 7'h0;
		assign sru_status[30] = trig_busy;
		assign sru_status[31] = sem_status[30];
		
		//-------------------------------------------------------------------------	
		wire 					RdoClkSel;
		wire [1:0]     	trig_mode;
		wire					rdocmd_opt;
		wire [1:0]			busy_in_en;
		assign RdoClkSel = srucfg[0];
		assign trig_mode  = srucfg[5:4];
		assign busy_in_en  = srucfg[7:6];
		//assign CDHVer = srucfg[31];
		assign rdocmd_opt = srucfg[30];
		assign ParReq = srucfg[23:16];	
		
		//-------------------------------------------------------------------------	
		wire [47:0]		local_mac;
		wire 	[1:0]		sru_busy_flag_in;
		//-------------------------------------------------------------------------	

		
		wire [144:0]   trig_config;
		assign trig_config = {ptrigcfg,testtrigcfg1,testtrigcfg0,trigl2tw,trigl1tw};
		//-------------------------------------------------------------------------	
		//Reset
		wire brd_rstn, reset, RegFsmRst;
		//-------------------------------------------------------------------------	
		
		//-------------------------------------------------------------------------	
		assign L2aBunCnt = {20'h0, cdh_w1[11:0]};
		assign L2aOrbCnt = {20'h0, cdh_w2[23:0]};
	//-------------------------------------------------------------------------	
		//wire [15:0]	dtcref_phase;



//    generate
//    if(DetectorType)
//    begin
			wire 	[1:0] 			ddl_rxn_i;
			wire 	[1:0]				ddl_rxp_i;
			wire 	[1:0]				ddl_txn_i;
			wire 	[1:0]				ddl_txp_i;
			assign ddl_rxn_i = ddl_rxn;
			assign ddl_rxp_i = ddl_rxp;
			assign ddl_txn = ddl_txn_i;
			assign ddl_txp = ddl_txp_i;

			wire	[1:0]				DtcRamclkb;
			wire  [19:0]			DtcRamaddrb;
			wire 	[1:0]				DtcRamReadConfirm;
			wire  [63:0]			ddl_ecnt,ddl_ecnt_i;
			wire  [119:0]			rdo_cfg;
			wire 	[63:0]			ddl_if_debug,ddl_if_debug_i;
			wire 	[3:0]	 			rorc_status;
			assign sru_status[9:6] = rorc_status;
			assign sru_status[11:10] = 2'b0;
			assign ddl_if_debug = ddl_if_debug_i;
			assign ddl_ecnt = ddl_ecnt_i;
			
			reg [1:0]		ddl_xoff;
			assign rdo_cfg = {altrocfg,dtc_rdo_mask[39:20],altrocfg,dtc_rdo_mask[19:0]};

			
			always @(posedge rdoclk)
			if(dtc_rdo_mask[19:0] == 20'hfffff)
			ddl_xoff[0] = 1'b1;
			else
			ddl_xoff[0] = 1'b0;

			always @(posedge rdoclk)
			if(dtc_rdo_mask[39:20] == 20'hfffff)
			ddl_xoff[1] = 1'b1;
			else
			ddl_xoff[1] = 1'b0;
    
//	 end else begin
//	 
//			wire 	 			ddl_rxn_i;
//			wire 				ddl_rxp_i;
//			wire 				ddl_txn_i;
//			wire 				ddl_txp_i;
//			assign ddl_rxn_i = ddl_rxn[0];
//			assign ddl_rxp_i = ddl_rxp[0];
//			assign ddl_txn = {1'b0,ddl_txn_i};
//			assign ddl_txp = {1'b0,ddl_txp_i};
//
//			wire				DtcRamclkb;
//			wire  [9:0]		DtcRamaddrb;
//			wire 				DtcRamReadConfirm;
//			wire  [63:0]	ddl_ecnt;
//			wire 	[31:0]	ddl_ecnt_i;
//			wire  [79:0]	rdo_cfg;
//			wire 	[63:0]	ddl_if_debug;
//			wire 	[31:0]	ddl_if_debug_i;
//			
//			wire 	[1:0]	 	rorc_status;
//			assign ddl_if_debug = {32'h0,ddl_if_debug_i};
//			assign ddl_ecnt = {32'h0,ddl_ecnt_i};
//			     	
//      	assign sru_status[7:6] = rorc_status;
//			assign sru_status[11:8] = 4'b0;
//			
//			assign rdo_cfg = {altrocfg,dtc_rdo_mask[39:0]};
//			
//			wire [1:0]		ddl_xoff;
//			assign ddl_xoff = 2'b11;
//		end
//		endgenerate
	 
//generate 
//if(SRUHDVer) begin		
//main_clk_gen #(.SRUHDVer(SRUHDVer))
main_clk_gen 
u_main_clk_gen (
    .RegFsmRst(RegFsmRst), 
	 .BusyClr(BusyClr),
    .brdclk_p(brdclk_p), 
//    .brdclk_n(1'b0), 
    .brdclk_n(brdclk_n), 
    .pllclkin1_p(ttc_clk40_p), 
//    .pllclkin1_n(1'b0), 
    .pllclkin1_n(ttc_clk40_n), 
    .ttc_ready(ttc_ready),
    .RdoClkSel(RdoClkSel), 
	 
    .pscmd(pscmd), 
    .psscancfg(psscancfg), 
    .deser_dout(dtc_deser_dout), 
    .psscan_flag(psscan_flag),
	// .dtcref_phase(dtcref_phase),
	 
//    .brdclk(brdclk), 
    .dcsclk(dcsclk), 
    .rdoclk(rdoclk), 
	 .icap_clk(icap_clk),
	 
    .dtc_clk_en(dtc_power_en), 
    .dtc_clk(dtc_clk), 
    .DeserBitclk(DeserBitclk), 
    .DeserBitclkDiv(DeserBitclkDiv), 
    .SerBitclk(SerBitclk), 
    .SerBitclkDiv(SerBitclkDiv), 
	 
	 .DcsClkLockSt(DcsClkLockSt), 
    .SerClkLockSt(SerClkLockSt)
    );
//end else begin
//main_clk_gen #(.SRUHDVer(SRUHDVer))
//u_main_clk_gen (
//    .RegFsmRst(RegFsmRst), 
//    .brdclk_p(brdclk_p), 
//    .brdclk_n(1'b0), 
////    .brdclk_n(brdclk_n), 
//    .pllclkin1_p(ttc_clk40_p), 
//    .pllclkin1_n(1'b0), 
////    .pllclkin1_n(ttc_clk40_n), 
//    .ttc_ready(ttc_ready),
//    .RdoClkSel(RdoClkSel), 
//	 
//    .pscmd(pscmd), 
//    .psscancfg(psscancfg), 
//    .deser_dout(dtc_deser_dout), 
//	 
//    .brdclk(brdclk), 
//    .dcsclk(dcsclk), 
//    .rdoclk(rdoclk), 
//	 
//    .dtc_clk_en(dtc_power_en), 
//    .dtc_clk(dtc_clk), 
//    .DeserBitclk(DeserBitclk), 
//    .DeserBitclkDiv(DeserBitclkDiv), 
//    .SerBitclk(SerBitclk), 
//    .SerBitclkDiv(SerBitclkDiv), 
//
//    .psscan_flag(psscan_flag),
//    .DcsClkLockSt(DcsClkLockSt), 
//    .SerClkLockSt(SerClkLockSt)
//    );
//end
//endgenerate

dcs_eth_top 
#(.Simulation(Eth_Simulation),
.EMAC_PHYINITAUTONEG_ENABLE(EMAC_PHYINITAUTONEG_ENABLE)
) u_dcs_eth_top (
    .udp_rx_clk(udp_rx_clk), 
    .udp_rxd(udp_rxd), 
    .udp_rx_dv(udp_rx_dv), 
	
    .udp_tx_rd_clk(udp_tx_rd_clk), 
    .udp_tx_rd_sof_n(udp_tx_rd_sof_n), 
    .udp_tx_rd_data_out(udp_tx_rd_data_out), 
    .udp_tx_rd_eof_n(udp_tx_rd_eof_n), 
    .udp_tx_rd_src_rdy_n(udp_tx_rd_src_rdy_n), 
    .udp_tx_rd_dst_rdy_n(udp_tx_rd_dst_rdy_n), 
    .udp_tx_rd_fifo_addr(udp_tx_rd_fifo_addr), 
	
    .local_mac(local_mac), 
    .local_ip(local_ip), 
	 .udp_rx_src_ip(udp_rx_src_ip), 
	
    .dcs_eth_sync(dcs_eth_sync), 
	
    .mgtrefclk_p(mgtrefclk_p), 
    .mgtrefclk_n(mgtrefclk_n), 
    .txp(txp), 
    .txn(txn), 
    .rxp(rxp), 
    .rxn(rxn), 
	
    .reset(reset)
    );

	dcs_cmddis #(
      .slowcontrol_port(16'h1001)) u_dcs_cmddis (
		.udp_rx_clk(udp_rx_clk), 
		.udp_rxd(udp_rxd), 
		.udp_rx_dv(udp_rx_dv), 
		
		.dcs_rx_clk(dcs_rx_clk), 
		.dcs_rxd(dcs_rxd), 
		.dcs_rx_dv(dcs_rx_dv), 
		
		.udp_rx_dst_port(udp_rx_dst_port),
		.udp_rx_src_port(udp_rx_src_port),
		
		.reset(reset)
		//.reset(RegFsmRst)
	);		
	
sru_cmd_par  #(
.SRUFMVer(SRUFMVer),
.SruFifoAddr(SruFifoAddr),
 
.SimSruCfg(SimSruCfg),
.SimDtcRdoMask(SimDtcRdoMask),
.SimAltroCfg(SimAltroCfg),
.SimTrigL1Tw(SimTrigL1Tw),
.SimTrigL2Tw(SimTrigL2Tw),
.SimPTrigCfg(SimPTrigCfg),
.SimTestTrigCfg0(SimTestTrigCfg0),
.SimTestTrigCfg1(SimTestTrigCfg1)
) u_sru_cmd_par (
   // .dcsclk(rdoclk), 
    .dcsclk(dcsclk), 
	 
    .dcs_rx_clk(dcs_rx_clk), 
    .dcs_rxd(dcs_rxd), 
    .dcs_rx_dv(dcs_rx_dv[40]), 
	 
    .dcs_rd_clk(udp_tx_rd_clk), 
    .dcs_rd_sof_n(udp_tx_rd_sof_n), 
    .dcs_rd_data_out(udp_tx_rd_data_out), 
    .dcs_rd_eof_n(udp_tx_rd_eof_n), 
    .dcs_rd_src_rdy_n(udp_tx_rd_src_rdy_n), 
    .dcs_rd_dst_rdy_n(udp_tx_rd_dst_rdy_n), 
    .dcs_rd_addr(udp_tx_rd_fifo_addr), 
    .dcs_rx_fifo_status(), 
    .dcs_rx_overflow(), 
	 .dcs_udp_dst_port(udp_rx_src_port),
	 .dcs_udp_src_port( 16'h1001),		
	 
    .sru_sn(sru_sn), 
    .local_ip(local_ip), 
    .sru_status(sru_status), 
    .dtc_err_flag(dtc_err_flag), 
    .srucfg(srucfg), 
    .dtc_power_en(dtc_power_en), 
    .dtc_rdo_mask(dtc_rdo_mask),
    .altrocfg(altrocfg), 
    .trigl1tw(trigl1tw), 
    .trigl2tw(trigl2tw), 
    .ptrigcfg(ptrigcfg),
	 
    .testtrigcfg0(testtrigcfg0), 
    .testtrigcfg1(testtrigcfg1), 
    .psscancfg(psscancfg),   
	 
    .RegFsmRst(RegFsmRst), 
    .BusyClr(BusyClr), 
    .strig_cmd(strig_cmd), 
    .trigcnt_clr(trigcnt_clr), 
    .trigerr_clr(trigerr_clr), 
    .FPGAReload(FPGAReload), 
    .FastCmd(FastCmd), 
    .pscmd(pscmd), 
    .FastCmdCode(FastCmdCode), 
    .walign(walign), 
    .errtest(errtest), 
	 
    .dtc_deser_dout(dtc_deser_dout), 
    .dtc_dout(dtc_dout), 
    .errcnt(errcnt), 
    .debugreg(debugreg), 
    .L2aBunCnt(L2aBunCnt), 
    .L2aOrbCnt(L2aOrbCnt), 
	 .ddl_if_debug(ddl_if_debug),

    .TrigDebugReg(TrigDebugReg), 
    .DTCEcnt(ddl_ecnt), 
    .L2aMes8Cnt(L2aMes8Cnt), 
    .DTCEventRdy(DTCEventRdy),
	 .sclkphasecnt(sclkphasecnt),
	 .ddlinit(ddlinit),
	 .sem_status(sem_status),
	 .FEE_Err_Flag_OR(FEE_Err_Flag_OR),
	 .DTC_Link_Flag_OR(DTC_Link_Flag_OR),
	 
	 //.dtcref_phase(dtcref_phase),
    .reset(reset)
    );

sru_40dtc_top u_sru_40dtc_top (
    .dtc_clk_p(dtc_clk_p), 
    .dtc_clk_n(dtc_clk_n), 
    .dtc_trig_p(dtc_trig_p), 
    .dtc_trig_n(dtc_trig_n), 
    .dtc_data_p(dtc_data_p), 
    .dtc_data_n(dtc_data_n), 
    .dtc_return_p(dtc_return_p), 
    .dtc_return_n(dtc_return_n), 
	
    .dcsclk(rdoclk), 
    .fee_flag(dtc_err_flag),
    .WordAlignStart(walign), 
    .errtest(errtest), 
    .errcnt(errcnt), 
 
    .FeeTrig(FeeTrig), 
    .rdocmd(rdocmd), 
    .abortcmd(abortcmd),
	 .FastCmd(FastCmd),
	 .FastCmdCode(FastCmdCode),
    .FastCmdAck(FastCmdAck), 
	 
    .rdo_cfg(rdo_cfg), 
    .DTCEventRdy(DTCEventRdy), 
    .DtcRamClr(DtcRamClr), 
    .DtcRamFlag(DtcRamFlag), 
//
    .DtcRamclkb(DtcRamclkb), 
    .DtcRamenb(DtcRamenb), 
    .DtcRamaddrb(DtcRamaddrb), 
    .DtcRamdoutb(DtcRamdoutb), 
    .DtcRamReadConfirm(DtcRamReadConfirm), 

    .dcs_rx_clk(dcs_rx_clk), 
    .dcs_rxd(dcs_rxd), 
    .dcs_rx_dv(dcs_rx_dv[39:0]),	 
    .udp_tx_clk(udp_tx_rd_clk), 
    .udp_tx_sof_n(udp_tx_rd_sof_n), 
    .udp_tx_data_out(udp_tx_rd_data_out), 
    .udp_tx_eof_n(udp_tx_rd_eof_n), 
    .udp_tx_src_rdy_n(udp_tx_rd_src_rdy_n), 
    .udp_tx_dst_rdy_n(udp_tx_rd_dst_rdy_n), 
    .udp_tx_fifo_addr(udp_tx_rd_fifo_addr), 
	 .dcs_udp_dst_port(udp_rx_src_port),
	 .dcs_udp_src_port( 16'h1001),

    .dtc_clk(dtc_clk), 
    .DeserBitclk(DeserBitclk), 
    .DeserBitclkDiv(DeserBitclkDiv), 
    .SerBitclk(SerBitclk), 
    .SerBitclkDiv(SerBitclkDiv), 
    .dtc_dout(dtc_dout),
	 .ddl_xoff(ddl_xoff),
	 
    .reset(RegFsmRst|BusyClr)
    );			

sru_trigger u_sru_trigger (
    .gclk_40m(rdoclk),
	 
    .ttc_l1accept_p(ttc_l1accept_p), 
    .ttc_l1accept_n(ttc_l1accept_n), 
    .ttc_saddr(ttc_saddr), 
    .ttc_dout(ttc_dout), 
    .ttc_doutstr(ttc_doutstr), 
    .evcntres(ttc_evcntres), 
    .bcntres(ttc_bcntres), 
	 
//    .CDHVer(CDHVer), 
    .ParReq(ParReq), 
    .cdh_w0(cdh_w0), 
    .cdh_w1(cdh_w1), 
    .cdh_w2(cdh_w2), 
    .cdh_w3(cdh_w3), 
    .cdh_w4(cdh_w4), 
    .cdh_w5(cdh_w5), 
    .cdh_w6(cdh_w6), 
    .cdh_w7(cdh_w7), 
    .cdh_w8(cdh_w8),
    .cdh_w9(cdh_w9),
    .L2aMes8Cnt(L2aMes8Cnt), 
	 
    .DtcRamFlag(DtcRamFlag), 
    .ddl_tx_start(ddl_tx_start), 
    .EventRdySent(EventRdySent), 
    .STrigErrFlag(STrigErrFlag), 
    .DtcRamClr(DtcRamClr), 
	 
//    .sru_l0(sru_l0), 
    .FeeTrig(FeeTrig), 
//    .l1out(l1out), 
    .abortcmd(abortcmd), 
    .rdocmd(rdocmd), 
	 .rdocmd_opt(rdocmd_opt),
	 
	 .trigcnt_clr(trigcnt_clr), 
    .trigcnt(debugreg), 
    .trigerr_clr(trigerr_clr), 
    .trigerr(trigerr), 
    .htrig(htrig), 
    .strig_cmd(strig_cmd), 
    .trig_config(trig_config),
    .trig_mode(trig_mode),
	 
    .DebugReg(TrigDebugReg), 
    .trig_busy(trig_busy), 
    .BusyFlag(BusyFlag), 
    .ttc_feereset(ttc_feereset), 

    .reset(BusyClr|RegFsmRst)
    );

	ddl_mac #(.Simulation(DDL_Simulation)
	) u_ddl_mac (
    .rdoclk(rdoclk), 
	 
    .DtcRamclkb(DtcRamclkb), 
    .DtcRamenb(DtcRamenb), 
    .DtcRamaddrb(DtcRamaddrb), 
    .DtcRamdoutb(DtcRamdoutb), 
    .DtcRamReadConfirm(DtcRamReadConfirm), 
   // .CDHVer(CDHVer), 
    .cdh_w0(cdh_w0), 
    .cdh_w1(cdh_w1), 
    .cdh_w2(cdh_w2), 
    .cdh_w3(cdh_w3), 
    .cdh_w4(cdh_w4), 
    .cdh_w5(cdh_w5), 
    .cdh_w6(cdh_w6), 
    .cdh_w7(cdh_w7), 
    .cdh_w8(cdh_w8), 
    .cdh_w9(cdh_w9), 
    .rdo_cfg(rdo_cfg), 
    .sclkphasecnt(sclkphasecnt), 
    .STrigErrFlag(STrigErrFlag), 
    .EventRdySent(EventRdySent), 
    .ddl_tx_start(ddl_tx_start), 
	 .ddl_ecnt(ddl_ecnt_i),
	 .ddl_if_debug(ddl_if_debug_i),
	 
    .rorc_status(rorc_status),
	 .SIUIP(local_ip[7:0]),//Use SN
 
    .ddl_rxn(ddl_rxn_i), 
    .ddl_rxp(ddl_rxp_i), 
    .ddl_txn(ddl_txn_i), 
    .ddl_txp(ddl_txp_i), 
    .ddl_refclk_p(ddl_refclk_p), 
    .ddl_refclk_n(ddl_refclk_n),
	 .BusyClr(BusyClr),
	 .ddlinit(ddlinit),
	 .ddl_xoff(ddl_xoff),
	 
    .reset(reset)
    //.reset(reset|RegFsmRst)
    );
	
	
FlashToUDP #(.DcsFifoAddr(FlashFifoAddr)) u_FlashToUDP (
    .udp_rx_clk(udp_rx_clk), 
    .udp_rxd(udp_rxd), 
    .udp_rx_dv(udp_rx_dv), 
	 
	 .udp_rx_dst_port(udp_rx_dst_port),
	 .udp_rx_src_ip(udp_rx_src_ip),	 
	
    .dcs_rd_clk(udp_tx_rd_clk), 
    .dcs_rd_sof_n(udp_tx_rd_sof_n), 
    .dcs_rd_data_out(udp_tx_rd_data_out), 
    .dcs_rd_eof_n(udp_tx_rd_eof_n), 
    .dcs_rd_src_rdy_n(udp_tx_rd_src_rdy_n), 
    .dcs_rd_dst_rdy_n(udp_tx_rd_dst_rdy_n),
	 .dcs_rd_addr(udp_tx_rd_fifo_addr),	
    .dcs_rx_fifo_status(), 
    .dcs_rx_overflow(), 
	
    .fpga_ip(local_ip), 
    .fpga_mac(local_mac), 	
    .sru_sn(sru_sn), 
	
    .FPGAReload(FPGAReload), 
	
    .FLASH_A(FLASH_A), 
    .FLASH_DQ(FLASH_DQ), 
    .FLASH_CS_B(FLASH_CS_B), 
    .FLASH_OE_B(FLASH_OE_B), 
    .FLASH_WE_B(FLASH_WE_B), 
    .FLASH_RS0(FLASH_RS0), 
    .FLASH_RS1(FLASH_RS1), 
    .FPGA_PROG_B(FPGA_PROG_B), 
	
    .gclk_40m(dcsclk), 
    .SlowClk(clk10m), 
    .reset(RegFsmRst|BusyClr)
    );
	
//-------------------------------------------------------------------------
   IBUF reset_ibuf ( .I (brd_reset_n), .O (brd_rstn));
 
   BUFR #(.BUFR_DIVIDE("4"),  .SIM_DEVICE("VIRTEX6")
   ) BUFR_SC (.O(clk10m_i), .CE(1'b1), .CLR(reset), .I(dcsclk));
	
   BUFG BUFG_SC (.O(clk10m), .I(clk10m_i));
   
   IBUFDS #(.DIFF_TERM("FALSE"), .IOSTANDARD("DEFAULT")) 
	IBUFDS_busy_in (.O(sru_busy_flag_in[0]), .I(sru_busy_flag_in_p[0]), .IB(sru_busy_flag_in_n[0]));	
   
	IBUFDS #(.DIFF_TERM("FALSE"), .IOSTANDARD("DEFAULT")) 
	IBUFDS_busy_in1 (.O(sru_busy_flag_in[1]), .I(sru_busy_flag_in_p[1]), .IB(sru_busy_flag_in_n[1]));	
	
   OBUFDS #(.IOSTANDARD("DEFAULT")) OBUFDS_busy_out (
      .O(sru_busy_flag_out_p), .OB(sru_busy_flag_out_n), .I(BusyFlag));  
		
//wire status_heartbeat_out;
assign ttc_reset_b = 1'b1;
assign reset = ~brd_rstn;	

assign BusyFlag = (sru_busy_flag_in[0] & busy_in_en[0]) | (sru_busy_flag_in[1] & busy_in_en[1]) | trig_busy;
reg [24:0] clkdiv = 25'h0;
always @(posedge dcsclk)
clkdiv <= clkdiv + 1'b1;
//------------------------------------------
assign LedIndicator[0] = BusyFlag & clkdiv[24];	 
assign LedIndicator[1] = ttc_ready & clkdiv[23];
assign LedIndicator[2] = dcs_eth_sync & clkdiv[23];
assign LedIndicator[3] = DcsClkLockSt & SerClkLockSt & clkdiv[23];
//assign LedIndicator[3] = status_heartbeat_out;


SCLKPhaseDetect u_SCLKPhaseDetect (
    .reset(reset), 
    .clk(rdoclk), 
    .ttc_bcntres(ttc_bcntres), 
    .FastCmd(FastCmd), 
    .FastCmdCode(FastCmdCode), 
    .FastCmdAck(FastCmdAck), 
    .sclkphasecnt(sclkphasecnt)
    );

//semv3_6_sem_example u_sem_v3_6_wrapper (
//    .sem_clk(semclk), 
//	 .status_heartbeat_out(status_heartbeat_out),
//    .sem_status(sem_status)
//    );

semv3_6_sem_example u_sem_v3_6_wrapper (
    .icap_clk(icap_clk), 
    .sem_status(sem_status)
    );

	 
endmodule

