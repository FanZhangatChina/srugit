`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module sru_cmd_par #(
parameter SRUFMVer = 32'h12120502, 
parameter SruFifoAddr = 6'd41,
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
		input 						dcsclk,

		//-------------------------------------------------------
		//SRU DCS interface
		input       				dcs_rx_clk,           
		input [7:0] 				dcs_rxd,              
		input 						dcs_rx_dv, 		
		
		//SRU command reply interface
		input  						dcs_rd_clk,//40MHz
		output 						dcs_rd_sof_n,
		output [7:0] 				dcs_rd_data_out,
		output 						dcs_rd_eof_n,
		output 						dcs_rd_src_rdy_n,
		input  						dcs_rd_dst_rdy_n,
		input  [5:0]				dcs_rd_addr,
		output [3:0]  				dcs_rx_fifo_status,
		output 						dcs_rx_overflow,
		input  [15:0]				dcs_udp_dst_port,
		input  [15:0]				dcs_udp_src_port,			
		//-------------------------------------------------------

		//-------------------------------------------------------			
		//Status register
		input [31:0]				sru_sn,
		input [31:0]				local_ip,
		//SRUFMVer
		input [31:0]				sru_status,		
		input [39:0]				dtc_err_flag,
		
		//-------------------------------------------------------
		//configuration parameters (16'h10 --> 16'h1a)
		output reg	[31:0]		srucfg = {24'h0, 2'b00, 2'b00, 3'h3, 1'b1},
//		output reg	[39:0]		dtc_power_en = 40'h00000_FFFFF,
		output reg	[39:0]		dtc_power_en = 40'h00000_00000,
		output reg	[39:0]		dtc_rdo_mask = 40'hfffff_fffff,
		output reg	[39:0]		altrocfg = 40'h0,
		output reg	[31:0]		trigl1tw = {16'd300, 16'd120},
		output reg	[31:0]		trigl2tw = {16'd20000, 16'd200},
		output reg	[16:0]		ptrigcfg = {1'h0, 16'h4E20},
		output reg	[31:0]		testtrigcfg0 = {16'h12C0, 16'h0064},
		output reg	[31:0]		testtrigcfg1 = {12'h0,4'b1101,16'h1770},
		output reg  [16:0]      psscancfg = {1'b0, 16'h0011}, //scan mode, scan steps, ~0.5 ns
		
		//-------------------------------------------------------			
		//commands
		output					  	RegFsmRst,
		output					  	BusyClr,
		output reg					strig_cmd = 1'b0,
		output reg 					trigcnt_clr = 1'b0,
		output reg 					trigerr_clr = 1'b0,
		output   				   FPGAReload,
		output  					   FastCmd,
		output reg				   pscmd = 1'b0,
		output reg [7:0]     	FastCmdCode = 8'h0,
		output    				   walign,
		output  					   errtest,
		output 						ddlinit,
		
		//-------------------------------------------------------
		//Debug registers
		output 	[15:0]		  	dtc_deser_dout,
		input 	[639:0] 			dtc_dout,		
		input 	[639:0] 			errcnt,

		input		[255:0]			debugreg,
		input 	[31:0]			L2aBunCnt,
		input 	[31:0]			L2aOrbCnt,	
		input 	[31:0]			TrigDebugReg,
		input 	[63:0]			DTCEcnt,
		input 	[63:0] 			ddl_if_debug,
		input 	[31:0] 			L2aMes8Cnt,
		input 	[39:0] 			DTCEventRdy,
		input		[1:0]				sclkphasecnt,
		output						FEE_Err_Flag_OR,
		output						DTC_Link_Flag_OR,
		
		input 	[31:0] 			sem_status,
		input		[15:0]			dtcref_phase,
		
		input 						reset
);	
	
		//-------------------------------------------------------
		reg [6:0] 				SruMonAddr = 7'h0;
		wire 						USER_TEMP_ALARM_OUT;
		reg [15:0] 				SRUMonData = 16'h0;	
  	//SRU DCS interface
		wire 						udp_cmd_dv;
		wire [31:0]				udp_cmd_addr;
		wire [31:0]				udp_cmd_data;
		wire [63:0]				dcs_cmd_reply;
		wire 						dcs_cmd_update;	
		reg [31:0]				rcmd_reply_data = 32'h0;
		reg				   	rcmd_reply_dv = 1'b0;	
		
		wire [39:0]				DtcSyncErrFlag;
		reg [5:0] 				dtc_mon_sel = 6'h0;		
		reg [31:0] 				BusyCnt = 32'h0;	 
		//----------------------------------------------------------------------------------------------
		wire [31:0] 			l0_cnt;
		wire [31:0] 			l1_cnt;
		wire [31:0] 			l2a_cnt;
		wire [31:0] 			l2r_cnt;		
		
		wire [31:0] 			trigout_cnt;
		wire [31:0] 			rdocmdout_cnt;
		wire [31:0] 			abortcmdout_cnt;		
		wire [31:0] 			trigerr_cnt;
		
		assign l0_cnt = debugreg[31:0];
		assign l1_cnt = debugreg[63:32];
		assign l2a_cnt = debugreg[95:64];
		assign l2r_cnt = debugreg[127:96];
		assign trigout_cnt = debugreg[159:128];
		assign rdocmdout_cnt = debugreg[191:160];
		assign abortcmdout_cnt = debugreg[223:192];
		assign trigerr_cnt = debugreg[255:224];		
		//----------------------------------------------------------------------------------------------			
		//----------------------------------------------------------------------------------------------
		reg 						reset_cmd = 1'b0;
		
		reg 						busyclr_cmd = 1'b0;
		
		reg 						FastCmd_i = 1'b0;
		reg [15:0] 				FastCmd_reg = 16'h0;

		reg 						ddlinit_cmd = 1'b0;
		reg [15:0] 				ddlinit_reg = 16'h0;
		
		reg 						FPGAReload_i = 1'b0;

		reg 						walign_cmd = 1'b0;
		reg [31:0] 				walign_reg = 32'h0;
		
		reg 						errtest_cmd = 1'b0;
		reg [31:0] 				errtest_reg = 32'h0;
		
		SwitchEmu u_ResetSwitch (
		 .clk(dcsclk), 
		 .pulse_in(reset_cmd), 
		 .pulse_out(RegFsmRst)
		 );

		SwitchEmu u_BusyClrSwitch (
		 .clk(dcsclk), 
		 .pulse_in(busyclr_cmd), 
		 .pulse_out(BusyClr)
		 );
		 
		always @(posedge dcsclk)
		if(FastCmd_i)
		FastCmd_reg <= 16'hffff;
		else
		FastCmd_reg <= {FastCmd_reg[14:0],1'b0};
		assign FastCmd = FastCmd_reg[15];

		always @(posedge dcsclk)
		if(ddlinit_cmd)
		ddlinit_reg <= 16'hffff;
		else
		ddlinit_reg <= {ddlinit_reg[14:0],1'b0};
		assign ddlinit = ddlinit_reg[15];

		SwitchEmu u_FPGAReLoadSwitch (
		 .clk(dcsclk), 
		 .pulse_in(FPGAReload_i), 
		 .pulse_out(FPGAReload)
		 );

		always @(posedge dcsclk)
		if(walign_cmd)
		walign_reg <= 32'hffffffff;
		else
		walign_reg <= {walign_reg[30:0],1'b0};
		assign walign = walign_reg[31];
		
		always @(posedge dcsclk)
		if(errtest_cmd)
		errtest_reg <= 32'hffffffff;
		else
		errtest_reg <= {errtest_reg[30:0],1'b0};
		assign errtest = errtest_reg[31];
		
		
		//----------------------------------------------------------------------------------------------
		//----------------------------------------------------------------------------------------------
		//DTC power switch configuration: dtc_power_en won't be set into default value after reset
		always @(posedge dcsclk)
		if(udp_cmd_dv)
			if(udp_cmd_addr[31]) //read
			begin
				dtc_power_en <= dtc_power_en;
				srucfg <= srucfg;
			end
			else
				case(udp_cmd_addr[15:0])
					16'h20 : begin srucfg <=   udp_cmd_data; end	
					16'h21 : begin dtc_power_en[19:0] <=   udp_cmd_data[19:0]; end
					16'h22 : begin dtc_power_en[39:20] <=   udp_cmd_data[19:0]; end
					default : begin dtc_power_en <= dtc_power_en; srucfg <= srucfg;end
				endcase //if
		else
				begin
				dtc_power_en <= dtc_power_en;
				srucfg <= srucfg;
				end
//----------------------------------------------------------------------------------------------
//Commands
always @(posedge dcsclk)
if(reset)
	begin
	reset_cmd <= 1'b1;
	end
else if(udp_cmd_dv & (udp_cmd_addr == 32'h0000_0010))
				begin
				reset_cmd <= 1'b1;  //
				end
			else
				begin
				reset_cmd <= 1'b0;
				end //if

always @(posedge dcsclk)
//if(reset)
if(RegFsmRst)
	begin
	strig_cmd <= 1'b0;
	FastCmd_i <= 1'b1;  FastCmdCode <= 8'hE8;
	pscmd <= 1'b0; psscancfg <= {1'b0, 16'h11}; dtc_mon_sel <= 6'h0;
	FPGAReload_i <= 1'b0;
	trigcnt_clr <= 1'b0;
	trigerr_clr <= 1'b0;
	pscmd <= 1'b0;
	busyclr_cmd <= 1'b0;
	ddlinit_cmd <= 1'b0;
	end
else if(udp_cmd_dv)
			if(udp_cmd_addr[31]) 
				begin
				pscmd <= 1'b0; psscancfg <= psscancfg; dtc_mon_sel <= dtc_mon_sel;
				walign_cmd <= 1'b0;
				busyclr_cmd <= 1'b0;
				strig_cmd <= 1'b0;
				FastCmd_i <= 1'b0; FastCmdCode <= FastCmdCode;
				FPGAReload_i <= 1'b0;
				trigcnt_clr <= 1'b0;
				trigerr_clr <= 1'b0;
				errtest_cmd <= 1'b0;
				ddlinit_cmd <= 1'b0;
				end
			else
				case(udp_cmd_addr[15:0])//write
					16'h11 : begin pscmd <=   1'b1; psscancfg <= udp_cmd_data[16:0]; dtc_mon_sel <= udp_cmd_data[29:24]; end
					16'h12 : begin walign_cmd <=   1'b1; end
					16'h13 : begin busyclr_cmd <=   1'b1; end
					16'h14 : begin ddlinit_cmd <=   1'b1; end
					
					16'h40 : begin FPGAReload_i <= 1'b1; end						
					16'h41 : begin FastCmd_i <= 1'b1;  FastCmdCode <= udp_cmd_data[7:0]; end
					16'h42 : begin strig_cmd <=   1'b1; end					
					16'h43 : begin trigcnt_clr <=   1'b1; end
					16'h44 : begin trigerr_clr <=   1'b1; end					
					16'h45 : begin errtest_cmd <=   1'b1; end
					
					default : begin
									pscmd <= 1'b0; psscancfg <= psscancfg; dtc_mon_sel <= dtc_mon_sel;
									walign_cmd <= 1'b0;
									busyclr_cmd <= 1'b0;
									strig_cmd <= 1'b0;
									FastCmd_i <= 1'b0; FastCmdCode <= FastCmdCode;
									FPGAReload_i <= 1'b0;
									trigcnt_clr <= 1'b0;
									trigerr_clr <= 1'b0;
									errtest_cmd <= 1'b0;
									ddlinit_cmd <= 1'b0;
								 end
				endcase //if
		else //if(udp_cmd_dv)
			begin
			pscmd <= 1'b0; psscancfg <= psscancfg; dtc_mon_sel <= dtc_mon_sel;
			walign_cmd <= 1'b0;			
			busyclr_cmd <= 1'b0;			
			strig_cmd <= 1'b0;
			FastCmd_i <= 1'b0; FastCmdCode <= FastCmdCode;
			FPGAReload_i <= 1'b0;
			trigcnt_clr <= 1'b0;
			trigerr_clr <= 1'b0;
			errtest_cmd <= 1'b0;
			ddlinit_cmd <= 1'b0;
			end		
//----------------------------------------------------------------------------------------------		
//Write commands
always @(posedge dcsclk)
if(RegFsmRst)
	begin 
	SruMonAddr <= SruMonAddr;
	dtc_rdo_mask <= SimDtcRdoMask; 
	altrocfg <= SimAltroCfg; 
	trigl1tw <= SimTrigL1Tw; 
	trigl2tw <= SimTrigL2Tw; 
	ptrigcfg <= SimPTrigCfg; 
	testtrigcfg0 <= SimTestTrigCfg0; 
	testtrigcfg1 <= SimTestTrigCfg1; 
	end
else 
if(udp_cmd_dv)
			if(udp_cmd_addr[31]) 
					begin 
					SruMonAddr <= SruMonAddr;
					dtc_rdo_mask <= dtc_rdo_mask; 
					altrocfg <= altrocfg; 
					trigl1tw <= trigl1tw; 
					trigl2tw <= trigl2tw; 
					ptrigcfg <= ptrigcfg; 
					testtrigcfg0 <= testtrigcfg0; 
					testtrigcfg1 <= testtrigcfg1; 
					end			
				else case(udp_cmd_addr[15:0])//write
					16'h07 : begin SruMonAddr <= udp_cmd_data[6:0]; end
					16'h23 : begin dtc_rdo_mask[19:0] <=   udp_cmd_data[19:0]; end
					16'h24 : begin dtc_rdo_mask[39:20] <=   udp_cmd_data[19:0]; end
					16'h27 : begin altrocfg[19:0] <=   udp_cmd_data[19:0]; end
					16'h28 : begin altrocfg[39:20] <=   udp_cmd_data[24:5]; end
					16'h29 : begin trigl1tw <=   udp_cmd_data; end	
					16'h2A : begin trigl2tw <=   udp_cmd_data; end	
					
					16'h50 : begin ptrigcfg <=   udp_cmd_data[16:0]; end	
					16'h51 : begin testtrigcfg0 <=   udp_cmd_data; end	
					16'h52 : begin testtrigcfg1 <=   udp_cmd_data; end	
					
					default : begin 
					SruMonAddr <= SruMonAddr;
					dtc_rdo_mask <= dtc_rdo_mask; 
					altrocfg <= altrocfg; 
					trigl1tw <= trigl1tw; 
					trigl2tw <= trigl2tw; 
					ptrigcfg <= ptrigcfg; 
					testtrigcfg0 <= testtrigcfg0; 
					testtrigcfg1 <= testtrigcfg1; 
					end
				endcase
		else // if(udp_cmd_dv)
					begin 
					SruMonAddr <= SruMonAddr;
					dtc_rdo_mask <= dtc_rdo_mask; 
					altrocfg <= altrocfg; 
					trigl1tw <= trigl1tw; 
					trigl2tw <= trigl2tw; 
					ptrigcfg <= ptrigcfg; 
					testtrigcfg0 <= testtrigcfg0; 
					testtrigcfg1 <= testtrigcfg1; 
					end
//----------------------------------------------------------------------------------------------
//Start of decoder of read commands
always @(posedge dcsclk)
//if(reset)
if(RegFsmRst)
begin rcmd_reply_data <=   32'h0;   rcmd_reply_dv <=   1'b0; end
	else if(udp_cmd_dv)
				if(udp_cmd_addr[31]) //read
				begin
					case (udp_cmd_addr[15:0])
					//0x00~0x0a
					16'h1 : begin rcmd_reply_data <=   sru_sn;  rcmd_reply_dv <=   1'b1; end
					16'h2 : begin rcmd_reply_data <=   local_ip;  rcmd_reply_dv <=   1'b1; end
					16'h3 : begin rcmd_reply_data <=   SRUFMVer;  rcmd_reply_dv <=   1'b1; end
					16'h4 : begin rcmd_reply_data <=   sru_status;  rcmd_reply_dv <=   1'b1; end
					
					16'h5 : begin rcmd_reply_data <=   {12'h0,dtc_err_flag[19:0]};  rcmd_reply_dv <=   1'b1; end
					16'h6 : begin rcmd_reply_data <=   {12'h0,dtc_err_flag[39:20]};  rcmd_reply_dv <=   1'b1; end					
					16'h7 : begin rcmd_reply_data <=   {USER_TEMP_ALARM_OUT,4'h0,SruMonAddr,SRUMonData};  rcmd_reply_dv <=   1'b1; end//					16'h8 : begin rcmd_reply_data <=   {12'h0,dtc_locked[39:20]};  rcmd_reply_dv <=   1'b1; end
					
					16'h20 : begin rcmd_reply_data <=   srucfg;  rcmd_reply_dv <=   1'b1; end					
					16'h21 : begin rcmd_reply_data <=   {12'h0,dtc_power_en[19:0]};  rcmd_reply_dv <=   1'b1; end
					16'h22 : begin rcmd_reply_data <=   {12'h0,dtc_power_en[39:20]};  rcmd_reply_dv <=   1'b1; end
					16'h23 : begin rcmd_reply_data <=   {12'h0,dtc_rdo_mask[19:0]};  rcmd_reply_dv <=   1'b1; end
					16'h24 : begin rcmd_reply_data <=   {12'h0,dtc_rdo_mask[39:20]};  rcmd_reply_dv <=   1'b1; end

					16'h27 : begin rcmd_reply_data <=   {12'h0,altrocfg[19:0]};  rcmd_reply_dv <=   1'b1; end
					16'h28 : begin rcmd_reply_data <=   {7'h0,altrocfg[39:20],3'h0,sclkphasecnt};  rcmd_reply_dv <=   1'b1; end
					16'h29 : begin rcmd_reply_data <=   trigl1tw;  rcmd_reply_dv <=   1'b1; end
					16'h2a : begin rcmd_reply_data <=   trigl2tw;  rcmd_reply_dv <=   1'b1; end										
					
					16'h50 : begin rcmd_reply_data <=   ptrigcfg;  rcmd_reply_dv <=   1'b1; end
					16'h51 : begin rcmd_reply_data <=   testtrigcfg0;  rcmd_reply_dv <=   1'b1; end
					16'h52 : begin rcmd_reply_data <=   testtrigcfg1;  rcmd_reply_dv <=   1'b1; end
					
					//Read only registers
					16'h60 : begin rcmd_reply_data <=   l0_cnt;  rcmd_reply_dv <=   1'b1; end
					16'h61 : begin rcmd_reply_data <=   l1_cnt;  rcmd_reply_dv <=   1'b1; end
					16'h62 : begin rcmd_reply_data <=   l2a_cnt;  rcmd_reply_dv <=   1'b1; end
					16'h63 : begin rcmd_reply_data <=   l2r_cnt;  rcmd_reply_dv <=   1'b1; end
					
					16'h64 : begin rcmd_reply_data <=   trigout_cnt;  rcmd_reply_dv <=   1'b1; end
					16'h65 : begin rcmd_reply_data <=   rdocmdout_cnt;  rcmd_reply_dv <=   1'b1; end
					16'h66 : begin rcmd_reply_data <=   abortcmdout_cnt;  rcmd_reply_dv <=   1'b1; end
					
					16'h67 : begin rcmd_reply_data <=   trigerr_cnt;  rcmd_reply_dv <=   1'b1; end
					
					16'h68 : begin rcmd_reply_data <=   {12'h0,DtcSyncErrFlag[19:0]};  rcmd_reply_dv <=   1'b1; end
					16'h69 : begin rcmd_reply_data <=   {12'h0,DtcSyncErrFlag[39:20]};  rcmd_reply_dv <=   1'b1; end
					
					16'h6a : begin rcmd_reply_data <=   L2aBunCnt;  rcmd_reply_dv <=   1'b1; end	
					16'h6b : begin rcmd_reply_data <=   L2aOrbCnt;  rcmd_reply_dv <=   1'b1; end					
				
					16'h72 : begin rcmd_reply_data <=   32'h0;  rcmd_reply_dv <=   1'b1; end	
					16'h73 : begin rcmd_reply_data <=   32'h0;  rcmd_reply_dv <=   1'b1; end	
					16'h74 : begin rcmd_reply_data <=   32'h0;  rcmd_reply_dv <=   1'b1; end

//					16'h72 : begin rcmd_reply_data <=   ddl_if_debug[31:0];  rcmd_reply_dv <=   1'b1; end	
//					16'h73 : begin rcmd_reply_data <=   ddl_if_debug[63:32];  rcmd_reply_dv <=   1'b1; end	
//					16'h74 : begin rcmd_reply_data <=   TrigDebugReg;  rcmd_reply_dv <=   1'b1; end
					16'h75 : begin rcmd_reply_data <=   DTCEcnt[31:0];  rcmd_reply_dv <=   1'b1; end	
					16'h76 : begin rcmd_reply_data <=   DTCEcnt[63:32];  rcmd_reply_dv <=   1'b1; end
					16'h79 : begin rcmd_reply_data <=   BusyCnt;  rcmd_reply_dv <=   1'b1; end
					16'h7a : begin rcmd_reply_data <=   L2aMes8Cnt;  rcmd_reply_dv <=   1'b1; end
					16'h7b : begin rcmd_reply_data <=   DTCEventRdy[19:0];  rcmd_reply_dv <=   1'b1; end	
					16'h7c : begin rcmd_reply_data <=   DTCEventRdy[39:20];  rcmd_reply_dv <=   1'b1; end	
					16'h7d : begin rcmd_reply_data <=   sem_status;  rcmd_reply_dv <=   1'b1; end	
					16'h7e : begin rcmd_reply_data <=   {16'h0,dtcref_phase};  rcmd_reply_dv <=   1'b1; end	
					

					16'h1028 : begin rcmd_reply_data <= {16'h0, dtc_dout[15:0]}; rcmd_reply_dv <= 1'b1; end
					16'h1029 : begin rcmd_reply_data <= {16'h0, dtc_dout[31:16]}; rcmd_reply_dv <= 1'b1; end
					16'h102a : begin rcmd_reply_data <= {16'h0, dtc_dout[47:32]}; rcmd_reply_dv <= 1'b1; end
					16'h102b : begin rcmd_reply_data <= {16'h0, dtc_dout[63:48]}; rcmd_reply_dv <= 1'b1; end
					16'h102c : begin rcmd_reply_data <= {16'h0, dtc_dout[79:64]}; rcmd_reply_dv <= 1'b1; end
					16'h102d : begin rcmd_reply_data <= {16'h0, dtc_dout[95:80]}; rcmd_reply_dv <= 1'b1; end
					16'h102e : begin rcmd_reply_data <= {16'h0, dtc_dout[111:96]}; rcmd_reply_dv <= 1'b1; end
					16'h102f : begin rcmd_reply_data <= {16'h0, dtc_dout[127:112]}; rcmd_reply_dv <= 1'b1; end
					16'h1030 : begin rcmd_reply_data <= {16'h0, dtc_dout[143:128]}; rcmd_reply_dv <= 1'b1; end
					16'h1031 : begin rcmd_reply_data <= {16'h0, dtc_dout[159:144]}; rcmd_reply_dv <= 1'b1; end
					16'h1032 : begin rcmd_reply_data <= {16'h0, dtc_dout[175:160]}; rcmd_reply_dv <= 1'b1; end
					16'h1033 : begin rcmd_reply_data <= {16'h0, dtc_dout[191:176]}; rcmd_reply_dv <= 1'b1; end
					16'h1034 : begin rcmd_reply_data <= {16'h0, dtc_dout[207:192]}; rcmd_reply_dv <= 1'b1; end
					16'h1035 : begin rcmd_reply_data <= {16'h0, dtc_dout[223:208]}; rcmd_reply_dv <= 1'b1; end
					16'h1036 : begin rcmd_reply_data <= {16'h0, dtc_dout[239:224]}; rcmd_reply_dv <= 1'b1; end
					16'h1037 : begin rcmd_reply_data <= {16'h0, dtc_dout[255:240]}; rcmd_reply_dv <= 1'b1; end
					16'h1038 : begin rcmd_reply_data <= {16'h0, dtc_dout[271:256]}; rcmd_reply_dv <= 1'b1; end
					16'h1039 : begin rcmd_reply_data <= {16'h0, dtc_dout[287:272]}; rcmd_reply_dv <= 1'b1; end
					16'h103a : begin rcmd_reply_data <= {16'h0, dtc_dout[303:288]}; rcmd_reply_dv <= 1'b1; end
					16'h103b : begin rcmd_reply_data <= {16'h0, dtc_dout[319:304]}; rcmd_reply_dv <= 1'b1; end
					16'h103c : begin rcmd_reply_data <= {16'h0, dtc_dout[335:320]}; rcmd_reply_dv <= 1'b1; end
					16'h103d : begin rcmd_reply_data <= {16'h0, dtc_dout[351:336]}; rcmd_reply_dv <= 1'b1; end
					16'h103e : begin rcmd_reply_data <= {16'h0, dtc_dout[367:352]}; rcmd_reply_dv <= 1'b1; end
					16'h103f : begin rcmd_reply_data <= {16'h0, dtc_dout[383:368]}; rcmd_reply_dv <= 1'b1; end
					16'h1040 : begin rcmd_reply_data <= {16'h0, dtc_dout[399:384]}; rcmd_reply_dv <= 1'b1; end
					16'h1041 : begin rcmd_reply_data <= {16'h0, dtc_dout[415:400]}; rcmd_reply_dv <= 1'b1; end
					16'h1042 : begin rcmd_reply_data <= {16'h0, dtc_dout[431:416]}; rcmd_reply_dv <= 1'b1; end
					16'h1043 : begin rcmd_reply_data <= {16'h0, dtc_dout[447:432]}; rcmd_reply_dv <= 1'b1; end
					16'h1044 : begin rcmd_reply_data <= {16'h0, dtc_dout[463:448]}; rcmd_reply_dv <= 1'b1; end
					16'h1045 : begin rcmd_reply_data <= {16'h0, dtc_dout[479:464]}; rcmd_reply_dv <= 1'b1; end
					16'h1046 : begin rcmd_reply_data <= {16'h0, dtc_dout[495:480]}; rcmd_reply_dv <= 1'b1; end
					16'h1047 : begin rcmd_reply_data <= {16'h0, dtc_dout[511:496]}; rcmd_reply_dv <= 1'b1; end
					16'h1048 : begin rcmd_reply_data <= {16'h0, dtc_dout[527:512]}; rcmd_reply_dv <= 1'b1; end
					16'h1049 : begin rcmd_reply_data <= {16'h0, dtc_dout[543:528]}; rcmd_reply_dv <= 1'b1; end
					16'h104a : begin rcmd_reply_data <= {16'h0, dtc_dout[559:544]}; rcmd_reply_dv <= 1'b1; end
					16'h104b : begin rcmd_reply_data <= {16'h0, dtc_dout[575:560]}; rcmd_reply_dv <= 1'b1; end
					16'h104c : begin rcmd_reply_data <= {16'h0, dtc_dout[591:576]}; rcmd_reply_dv <= 1'b1; end
					16'h104d : begin rcmd_reply_data <= {16'h0, dtc_dout[607:592]}; rcmd_reply_dv <= 1'b1; end
					16'h104e : begin rcmd_reply_data <= {16'h0, dtc_dout[623:608]}; rcmd_reply_dv <= 1'b1; end
					16'h104f : begin rcmd_reply_data <= {16'h0, dtc_dout[639:624]}; rcmd_reply_dv <= 1'b1; end


//					16'h10a0 : begin rcmd_reply_data <= {16'h0,errcnt[15:0]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a1 : begin rcmd_reply_data <= {16'h0,errcnt[31:16]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a2 : begin rcmd_reply_data <= {16'h0,errcnt[47:32]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a3 : begin rcmd_reply_data <= {16'h0,errcnt[63:48]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a4 : begin rcmd_reply_data <= {16'h0,errcnt[79:64]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a5 : begin rcmd_reply_data <= {16'h0,errcnt[95:80]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a6 : begin rcmd_reply_data <= {16'h0,errcnt[111:96]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a7 : begin rcmd_reply_data <= {16'h0,errcnt[127:112]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a8 : begin rcmd_reply_data <= {16'h0,errcnt[143:128]}; rcmd_reply_dv <= 1'b1; end
//					16'h10a9 : begin rcmd_reply_data <= {16'h0,errcnt[159:144]}; rcmd_reply_dv <= 1'b1; end
//					16'h10aa : begin rcmd_reply_data <= {16'h0,errcnt[175:160]}; rcmd_reply_dv <= 1'b1; end
//					16'h10ab : begin rcmd_reply_data <= {16'h0,errcnt[191:176]}; rcmd_reply_dv <= 1'b1; end
//					16'h10ac : begin rcmd_reply_data <= {16'h0,errcnt[207:192]}; rcmd_reply_dv <= 1'b1; end
//					16'h10ad : begin rcmd_reply_data <= {16'h0,errcnt[223:208]}; rcmd_reply_dv <= 1'b1; end
//					16'h10ae : begin rcmd_reply_data <= {16'h0,errcnt[239:224]}; rcmd_reply_dv <= 1'b1; end
//					16'h10af : begin rcmd_reply_data <= {16'h0,errcnt[255:240]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b0 : begin rcmd_reply_data <= {16'h0,errcnt[271:256]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b1 : begin rcmd_reply_data <= {16'h0,errcnt[287:272]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b2 : begin rcmd_reply_data <= {16'h0,errcnt[303:288]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b3 : begin rcmd_reply_data <= {16'h0,errcnt[319:304]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b4 : begin rcmd_reply_data <= {16'h0,errcnt[335:320]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b5 : begin rcmd_reply_data <= {16'h0,errcnt[351:336]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b6 : begin rcmd_reply_data <= {16'h0,errcnt[367:352]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b7 : begin rcmd_reply_data <= {16'h0,errcnt[383:368]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b8 : begin rcmd_reply_data <= {16'h0,errcnt[399:384]}; rcmd_reply_dv <= 1'b1; end
//					16'h10b9 : begin rcmd_reply_data <= {16'h0,errcnt[415:400]}; rcmd_reply_dv <= 1'b1; end
//					16'h10ba : begin rcmd_reply_data <= {16'h0,errcnt[431:416]}; rcmd_reply_dv <= 1'b1; end
//					16'h10bb : begin rcmd_reply_data <= {16'h0,errcnt[447:432]}; rcmd_reply_dv <= 1'b1; end
//					16'h10bc : begin rcmd_reply_data <= {16'h0,errcnt[463:448]}; rcmd_reply_dv <= 1'b1; end
//					16'h10bd : begin rcmd_reply_data <= {16'h0,errcnt[479:464]}; rcmd_reply_dv <= 1'b1; end
//					16'h10be : begin rcmd_reply_data <= {16'h0,errcnt[495:480]}; rcmd_reply_dv <= 1'b1; end
//					16'h10bf : begin rcmd_reply_data <= {16'h0,errcnt[511:496]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c0 : begin rcmd_reply_data <= {16'h0,errcnt[527:512]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c1 : begin rcmd_reply_data <= {16'h0,errcnt[543:528]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c2 : begin rcmd_reply_data <= {16'h0,errcnt[559:544]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c3 : begin rcmd_reply_data <= {16'h0,errcnt[575:560]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c4 : begin rcmd_reply_data <= {16'h0,errcnt[591:576]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c5 : begin rcmd_reply_data <= {16'h0,errcnt[607:592]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c6 : begin rcmd_reply_data <= {16'h0,errcnt[623:608]}; rcmd_reply_dv <= 1'b1; end
//					16'h10c7 : begin rcmd_reply_data <= {16'h0,errcnt[639:624]}; rcmd_reply_dv <= 1'b1; end
					
					default: begin rcmd_reply_data <=   32'h0;   rcmd_reply_dv <=   1'b0; end
					endcase
				end 
				else begin rcmd_reply_data <=   32'h0;   rcmd_reply_dv <=   1'b0; end //if(udp_cmd_addr[31]) //read
			
		else begin rcmd_reply_data <=   32'h0;   rcmd_reply_dv <=   1'b0; end //if(udp_cmd_dv)
//--------------------------------------------------------------------------------------------------------------
//End of decoder of read commands	

//-------------------------------------------------------
srudcsreplyack usrudcsreplyack (
    .reset(RegFsmRst), 
    .dcsclk(dcsclk), 
    .rcmd_reply_dv(rcmd_reply_dv), 
    .udp_cmd_addr(udp_cmd_addr), 
    .rcmd_reply_data(rcmd_reply_data), 
    .dcs_cmd_update(dcs_cmd_update), 
    .dcs_cmd_reply(dcs_cmd_reply)
    );
			
//-------------------------------------------------------

//-------------------------------------------------------

sru_dcs_fifo #(.SruFifoAddr(SruFifoAddr)) u_sru_dcs_fifo (
    .gclk_40m(dcsclk), 
	
    .dcs_rx_clk(dcs_rx_clk), 
    .dcs_rxd(dcs_rxd), 
    .dcs_rx_dv(dcs_rx_dv),
	
    .dcs_rd_clk(dcs_rd_clk), 
    .dcs_rd_sof_n(dcs_rd_sof_n), 
    .dcs_rd_data_out(dcs_rd_data_out), 
    .dcs_rd_eof_n(dcs_rd_eof_n), 
    .dcs_rd_src_rdy_n(dcs_rd_src_rdy_n), 
    .dcs_rd_dst_rdy_n(dcs_rd_dst_rdy_n),
	 .dcs_rd_addr(dcs_rd_addr),	
    .dcs_rx_fifo_status(dcs_rx_fifo_status), 
    .dcs_rx_overflow(dcs_rx_overflow),
	 .dcs_udp_dst_port(dcs_udp_dst_port),
	 .dcs_udp_src_port(dcs_udp_src_port),	
	
    .dcs_cmd_reply(dcs_cmd_reply), 
    .dcs_cmd_update(dcs_cmd_update), 
	
    .udp_cmd_dv(udp_cmd_dv), 
    .udp_cmd_addr(udp_cmd_addr), 
    .udp_cmd_data(udp_cmd_data), 
	
    .reset(RegFsmRst)
    );	

//----------------------------------------------------------------------------------
 
demux u_dtcout (
    .dcsclk(dcsclk), 
    .dtc_mon_sel(dtc_mon_sel), 
    .dtc_dout(dtc_dout), 
    .dtc_deser_dout(dtc_deser_dout)
    );

always @(posedge dcsclk)
if(RegFsmRst|BusyClr)
BusyCnt <= 32'h0;
else if(sru_status[0])
BusyCnt <= BusyCnt + 1;
else
BusyCnt <= BusyCnt;

RegArrayCheck U_RegArrayCheck (
    .din(errcnt), 
    .dout(DtcSyncErrFlag)
    );	

wire EOS_OUT;
wire DRDY_OUT;
wire [15:0] SRUMonData_i;
  srutempmonitor u_srutempmonitor
(
      .DADDR_IN(SruMonAddr),
      .DCLK_IN(dcsclk),
      .DEN_IN(EOS_OUT),
      .DI_IN(16'h0),
      .DWE_IN(1'b0),
      .RESET_IN(RegFsmRst),
      .USER_TEMP_ALARM_OUT(USER_TEMP_ALARM_OUT),
      .DO_OUT(SRUMonData_i),
      .DRDY_OUT(DRDY_OUT),
		.EOS_OUT(EOS_OUT),
      .VP_IN(1'b0),
      .VN_IN(1'b0)
      );


always @(posedge dcsclk)
if(DRDY_OUT)
SRUMonData <= SRUMonData_i;
else
SRUMonData <= SRUMonData;


wire [39:0] FEE_Err_Flag_OR_i, DTC_Link_Flag_OR_i;
assign FEE_Err_Flag_OR_i = DtcSyncErrFlag & (~dtc_rdo_mask);
assign DTC_Link_Flag_OR_i = dtc_err_flag & (~dtc_rdo_mask);
assign FEE_Err_Flag_OR = (FEE_Err_Flag_OR_i != 40'h0) ? 1'b1 : 1'b0;
assign DTC_Link_Flag_OR = (DTC_Link_Flag_OR_i != 40'h0) ? 1'b1 : 1'b0;
		
endmodule
