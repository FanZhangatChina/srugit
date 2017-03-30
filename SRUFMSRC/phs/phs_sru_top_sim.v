`timescale 1ns / 1ps
//******************************************************************************
// PHOS SRU 
// Designer : Fan Zhang (zhangfan@mail.hbut.edu.cn)
// Last Updated: 2015-06-26
// Note: Make changes in SwitchEmu.v, sru_cmd_par.v, ddl_fee_if.v, siu_emulator.vhd, ddl_mac
// Turn On or OFF LG
// ALTRO: 15 Samp
// LG OFF: 1792 bytes/FEE, ~ 36 k bytes/SRU; BUSY Time: DTC/DDL: 90/180 us;  102/174
// LG On: 896 bytes/FEE, ~ 18 k bytes/SRU
// Busy time: DTC: 45 us, 90 us

//*******************************************************************************
////////////////////////////////////////////////////////////////////////////////

module sru_top_sim;

	// Inputs
	reg brd_reset_n;
	reg brdclk_p;
	reg brdclk_n;
	reg ttc_clk40_p;
	reg ttc_clk40_n;
	reg htrig;
	reg sru_busy_flag_in_p;
	reg sru_busy_flag_in_n;
	reg ttc_evcntres;
	reg ttc_bcntres;
	reg ttc_ready;
	reg ttc_l1accept_p;
	reg ttc_l1accept_n;
	reg ttc_doutstr;
	reg [7:0] ttc_dout;
	reg [7:0] ttc_saddr;
	wire  ddl_rxn;
	wire  ddl_rxp;
	reg ddl_refclk_p;
	reg ddl_refclk_n;
	wire [39:0] dtc_data_p;
	wire [39:0] dtc_data_n;
	wire [39:0] dtc_return_p;
	wire [39:0] dtc_return_n;

	wire clk125m;
	reg mgtrefclk_p;
	reg mgtrefclk_n;
	wire rxp;
	wire rxn;
	reg configuration_busy = 1'b0;
	reg ddl_byteclk;
	
	// Outputs
	wire [3:0] LedIndicator;
	wire [3:0] NimOut;
	wire sru_busy_flag_out_p;
	wire sru_busy_flag_out_n;
	wire ttc_reset_b;
	wire [22:0] FLASH_A;
	wire [15:0] FLASH_DQ;
	wire FLASH_CS_B;
	wire FLASH_OE_B;
	wire FLASH_WE_B;
	wire FLASH_RS0;
	wire FLASH_RS1;
	wire FPGA_PROG_B;
	wire [1:0] ddl_txn;
	wire [1:0] ddl_txp;
	wire txp;
	wire txn;
	wire [39:0] dtc_clk_p;
	wire [39:0] dtc_clk_n;
	wire [39:0] dtc_trig_p;
	wire [39:0] dtc_trig_n;

	// Instantiate the Unit Under Test (UUT)
	sru_top #(
//.SRUHDVer(1'b1),	
.DDL_Simulation(1'b1),
.Eth_Simulation(1'b1),
.EMAC_PHYINITAUTONEG_ENABLE("FALSE"),
.SRUFMVer(32'h14032401),
.SimSruCfg({21'h0, 2'b10, 2'b00, 2'b00, 4'h3, 1'b0}),
.SimDtcRdoMask(40'hfffff_00000),
.SimAltroCfg(40'h0),
.SimTrigL1Tw({16'd300, 16'd120}),
.SimTrigL2Tw({16'd20000, 16'd200}),
.SimPTrigCfg({1'h0, 16'd800}),
.SimTestTrigCfg0({16'd212, 16'd100}),
.SimTestTrigCfg1({12'h0,4'b1101,16'd5000})
//.SIUFMID({6'h01,4'd14,4'd03,5'd24})
) u_sru_top (
		.brd_reset_n(brd_reset_n), 
		.brdclk_p(brdclk_p), 
		.brdclk_n(brdclk_n), 
		.ttc_clk40_p(ttc_clk40_p), 
		.ttc_clk40_n(ttc_clk40_n), 
		.LedIndicator(LedIndicator), 
//		.NimOut(NimOut), 
		.htrig(htrig), 
		.sru_busy_flag_in_p(sru_busy_flag_in_p), 
		.sru_busy_flag_in_n(sru_busy_flag_in_n), 
		.sru_busy_flag_out_p(sru_busy_flag_out_p), 
		.sru_busy_flag_out_n(sru_busy_flag_out_n), 
		.ttc_evcntres(ttc_evcntres), 
		.ttc_bcntres(ttc_bcntres), 
		.ttc_ready(ttc_ready), 
		.ttc_reset_b(ttc_reset_b), 
		.ttc_l1accept_p(ttc_l1accept_p), 
		.ttc_l1accept_n(ttc_l1accept_n), 
		.ttc_doutstr(ttc_doutstr), 
		.ttc_dout(ttc_dout), 
		.ttc_saddr(ttc_saddr), 
		.FLASH_A(FLASH_A), 
		.FLASH_DQ(FLASH_DQ), 
		.FLASH_CS_B(FLASH_CS_B), 
		.FLASH_OE_B(FLASH_OE_B), 
		.FLASH_WE_B(FLASH_WE_B), 
		.FLASH_RS0(FLASH_RS0), 
		.FLASH_RS1(FLASH_RS1), 
		.FPGA_PROG_B(FPGA_PROG_B), 
//		.ddl_rxn(ddl_rxn), 
//		.ddl_rxp(ddl_rxp), 
//		.ddl_txn(ddl_txn), 
//		.ddl_txp(ddl_txp), 
		.ddl_rxn(ddl_txn), 
		.ddl_rxp(ddl_txp), 
		.ddl_txn(ddl_rxn), 
		.ddl_txp(ddl_rxp), 
		
		
		.ddl_refclk_p(ddl_refclk_p), 
		.ddl_refclk_n(ddl_refclk_n), 
		.mgtrefclk_p(mgtrefclk_p), 
		.mgtrefclk_n(mgtrefclk_n), 
		.txp(txp), 
		.txn(txn), 
		.rxp(rxp), 
		.rxn(rxn), 
		.dtc_clk_p(dtc_clk_p), 
		.dtc_clk_n(dtc_clk_n), 
		.dtc_trig_p(dtc_trig_p), 
		.dtc_trig_n(dtc_trig_n), 
		.dtc_data_p(dtc_data_p), 
		.dtc_data_n(dtc_data_n), 
		.dtc_return_p(dtc_return_p), 
		.dtc_return_n(dtc_return_n)
	);

  fee_40dtc_top #(
	.LGSEN_Init(1'b0),	
	.FEEFMVer(16'h5043)
	)
u_fee_40dtc_top
    (
		.dtc_clk_p(dtc_clk_p), 
		.dtc_clk_n(dtc_clk_n), 
		.dtc_trig_p(dtc_trig_p), 
		.dtc_trig_n(dtc_trig_n),	

		.dtc_data_p(dtc_data_p), 
		.dtc_data_n(dtc_data_n), 
		.dtc_return_p(dtc_return_p), 
		.dtc_return_n(dtc_return_n)		
		
	);
	
EthPCSim u_EthPCSim (
    .clk125m(clk125m), 
    .txp(txp), 
    .txn(txn), 
    .rxp(rxp), 
    .rxn(rxn), 
	 
    .configuration_busy(configuration_busy), 
    .monitor_error()
    );

//DDLPCSim u_DDLPCSim0 (
//    .clk125m(ddl_byteclk), 
//    .txp(ddl_txp[0]), 
//    .txn(ddl_txn[0]), 
//    .rxp(ddl_rxp[0]), 
//    .rxn(ddl_rxn[0]), 
//	 
//    .configuration_busy(configuration_busy), 
//    .monitor_error()
//    );
//
//DDLPCSim u_DDLPCSim1 (
//    .clk125m(ddl_byteclk), 
//    .txp(ddl_txp[1]), 
//    .txn(ddl_txn[1]), 
//    .rxp(ddl_rxp[1]), 
//    .rxn(ddl_rxn[1]), 
//	 
//    .configuration_busy(configuration_busy), 
//    .monitor_error()
//    );	 
	

	initial begin
		// Initialize Inputs
		brd_reset_n = 0;
		
		ttc_clk40_p = 0;
		ttc_clk40_n = 0;
		htrig = 0;
		sru_busy_flag_in_p = 0;
		sru_busy_flag_in_n = 0;
		ttc_evcntres = 0;
		ttc_bcntres = 0;
		ttc_ready = 0;
		ttc_l1accept_p = 0;
		ttc_l1accept_n = 0;
		ttc_doutstr = 0;
		ttc_dout = 0;
		ttc_saddr = 0;
		configuration_busy = 1'b1;
		
		#1000;
      brd_reset_n = 1; 	
		
		repeat(3000)
		@(posedge clk125m);
		configuration_busy = 1'b0;
	end
	
	
	
    initial begin
      brdclk_p = 1'b0;
      #5;
      forever
      #5 brdclk_p = ~brdclk_p;
   end	

   initial begin
      brdclk_n = 1'b1;
      #5;
      forever
      #5 brdclk_n = ~brdclk_n;
   end  

//    initial begin
//      brdclk_p = 1'b0;
//      #12.5;
//      forever
//      #12.5 brdclk_p = ~brdclk_p;
//   end	


    initial begin
      mgtrefclk_p = 1'b0;
      #4;
      forever
      #4 mgtrefclk_p = ~mgtrefclk_p;
   end	

   initial begin
      mgtrefclk_n = 1'b1;
      #4;
      forever
      #4 mgtrefclk_n = ~mgtrefclk_n;
   end 
	
	assign clk125m = mgtrefclk_p;

   initial begin
      ddl_refclk_p = 1'b1;
      #0.235;
      forever
      #0.235 ddl_refclk_p = ~ddl_refclk_p;
   end 

   initial begin
      ddl_refclk_n = 1'b0;
      #0.235;
      forever
      #0.235 ddl_refclk_n = ~ddl_refclk_n;
   end 

   initial begin
      ddl_byteclk = 1'b1;
      #2.35;
      forever
      #2.35 ddl_byteclk = ~ddl_byteclk;
   end 

   
endmodule

