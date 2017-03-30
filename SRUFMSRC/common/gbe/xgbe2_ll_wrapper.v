`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:55:50 08/15/2011 
// Design Name: 
// Module Name:    xgbe2_ll_wrapper 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//    ---------------------------------------------------------------------
//    |EXAMPLE DESIGN WRAPPER                                             |
//    |           --------------------------------------------------------|
//    |           |LOCALLINK-LEVEL WRAPPER                                |
//    |           |              -----------------------------------------|
//    |           |              |BLOCK-LEVEL WRAPPER                     |
//    |           |              |    ---------------------               |
//    | --------  |  ----------  |    | INSTANCE-LEVEL    |               |
//    | |      |  |  |        |  |    | WRAPPER           |  ---------    |
//    | |      |->|->|        |->|--->| Tx            Tx  |->|       |--->|
//    | |      |  |  |        |  |    | client        PHY |  |       |    |
//    | | ADDR |  |  | LOCAL- |  |    | I/F           I/F |  |       |    |
//    | | SWAP |  |  | LINK   |  |    |                   |  | PHY   |    |
//    | |      |  |  | FIFO   |  |    |                   |  | I/F   |    |
//    | |      |  |  |        |  |    |                   |  |       |    |
//    | |      |  |  |        |  |    | Rx            Rx  |  |       |    |
//    | |      |  |  |        |  |    | client        PHY |  |       |    |
//    | |      |<-|<-|        |<-|<---| I/F           I/F |<-|       |<---|
//    | |      |  |  |        |  |    |                   |  ---------    |
//    | --------  |  ----------  |    ---------------------               |
//    |           |              -----------------------------------------|
//    |           --------------------------------------------------------|
//    ---------------------------------------------------------------------
//
//-----------------------------------------------------------------------------


module xgbe2_ll_wrapper
#(parameter EMAC_PHYINITAUTONEG_ENABLE = "TRUE")
(
     input mgtclk_p,
	  input mgtclk_n,
	  
	  output rx_ll_clock,         
     output rx_ll_reset,         
     output [7:0] rx_ll_data,  
     output rx_ll_sof_n,      
     output rx_ll_eof_n,      
     output rx_ll_src_rdy_n,
	  input  rx_ll_dst_rdy_n,  
	  
	  output tx_ll_clock,
	  output tx_ll_reset,
	  input  [7:0] tx_ll_data,
	  input  tx_ll_sof_n,
	  input  tx_ll_eof_n,
	  input  tx_ll_src_rdy_n,
	  output tx_ll_dst_rdy_n,
	  
	  output txp,
	  output txn,
	  input  rxp,
	  input  rxn,
	  
	  output          EMACCLIENTSYNCACQSTATUS,
	  	  
	  output [19:0] emacclient_status,
	  input reset
   );

    // Client receiver interface
    wire          EMACCLIENTRXDVLD;
    wire          EMACCLIENTRXFRAMEDROP;
    wire   [6:0]  EMACCLIENTRXSTATS;
    wire          EMACCLIENTRXSTATSVLD;
    wire          EMACCLIENTRXSTATSBYTEVLD;

    // Client transmitter interface
    wire    [7:0]  CLIENTEMACTXIFGDELAY; //input
    wire          EMACCLIENTTXSTATS;
    wire          EMACCLIENTTXSTATSVLD;
    wire          EMACCLIENTTXSTATSBYTEVLD;

    // MAC control interface
    wire           CLIENTEMACPAUSEREQ;//input
    wire   [15:0]  CLIENTEMACPAUSEVAL;//input

    //EMAC-transceiver link status
    
    wire          EMACANINTERRUPT;

    // 1000BASE-X PCS/PMA interface
     wire    [4:0]  PHYAD;//input
	 
	 wire    [3:0]  RX_LL_FIFO_STATUS;

	 assign CLIENTEMACTXIFGDELAY = 8'd0;
	 assign CLIENTEMACPAUSEREQ = 1'b0;
	 assign CLIENTEMACPAUSEVAL = 16'h0;
	 assign PHYAD = 5'h1;
	 
	 assign emacclient_status[0] = EMACCLIENTRXDVLD;
	 assign emacclient_status[1] = EMACCLIENTRXFRAMEDROP;
 	 assign emacclient_status[8:2] = EMACCLIENTRXSTATS;
	 assign emacclient_status[9] = EMACCLIENTRXSTATSVLD; 
 	 assign emacclient_status[10] = EMACCLIENTRXSTATSBYTEVLD;
	 
	 assign emacclient_status[11] = EMACCLIENTTXSTATS; 
	 assign emacclient_status[12] = EMACCLIENTTXSTATSVLD; 
	 assign emacclient_status[13] = EMACCLIENTTXSTATSBYTEVLD; 
	 
	 assign emacclient_status[14] = EMACCLIENTRXFRAMEDROP; 
	 assign emacclient_status[15] = EMACCLIENTRXFRAMEDROP; 
	 
	 assign emacclient_status[19:16] = RX_LL_FIFO_STATUS; 
  
        // Global asynchronous reset
    wire            reset_i;

    // LocalLink interface clocking signal
    wire            ll_clk_i;
	
	// Synchronous reset registers in the LocalLink clock domain
    (* ASYNC_REG = "TRUE" *)
    reg       [5:0] ll_pre_reset_i;

    reg             ll_reset_i;

    // Reset signal from the transceiver
    wire            resetdone_i;
    (* ASYNC_REG = "TRUE" *)
    reg             resetdone_r;

    // Transceiver output clock (REFCLKOUT at 125MHz)
    wire            clk125_o;

    // 125MHz clock input to wrappers
    (* KEEP = "TRUE" *)
    wire            clk125;

    // Input 125MHz differential clock for transceiver
    wire            clk_ds;
   
     assign reset_i = reset;

	 IBUFDS_GTXE1 clkingen (
      .I     (mgtclk_p),
      .IB    (mgtclk_n),
      .CEB   (1'b0),
      .O     (clk_ds),
      .ODIV2 ()
    );

    // The 125MHz clock from the transceiver is routed through a BUFG and
    // input to the MAC wrappers
    // (clk125 can be shared between multiple EMAC instances, including
    //  multiple instantiations of the EMAC wrappers)
    BUFG bufg_clk125 (
       .I (clk125_o),
       .O (clk125)
    );

    // Clock the LocalLink interface with the globally-buffered 125MHz
    // clock from the transceiver
    assign ll_clk_i = clk125;
	assign rx_ll_clock = ll_clk_i;
	assign tx_ll_clock = ll_clk_i;
	assign rx_ll_reset = ll_reset_i;
	assign tx_ll_reset = ll_reset_i;	
	
    //------------------------------------------------------------------------
    // Instantiate the LocalLink-level EMAC wrapper (xgbe2_locallink.v)
    //------------------------------------------------------------------------
	    xgbe2_locallink #(.EMAC_PHYINITAUTONEG_ENABLE(EMAC_PHYINITAUTONEG_ENABLE)) u_xgbe2_locallink
    (
    // 125MHz clock output from transceiver
    .CLK125_OUT               (clk125_o),
    // 125MHz clock input from BUFG
    .CLK125                   (clk125),

    // LocalLink receiver interface
    .RX_LL_CLOCK              (ll_clk_i),
    .RX_LL_RESET              (ll_reset_i),
    .RX_LL_DATA               (rx_ll_data),
    .RX_LL_SOF_N              (rx_ll_sof_n),
    .RX_LL_EOF_N              (rx_ll_eof_n),
    .RX_LL_SRC_RDY_N          (rx_ll_src_rdy_n),
    .RX_LL_DST_RDY_N          (rx_ll_dst_rdy_n),
    .RX_LL_FIFO_STATUS        (RX_LL_FIFO_STATUS),

    // Client receiver signals
    .EMACCLIENTRXDVLD         (EMACCLIENTRXDVLD),
    .EMACCLIENTRXFRAMEDROP    (EMACCLIENTRXFRAMEDROP),
    .EMACCLIENTRXSTATS        (EMACCLIENTRXSTATS),
    .EMACCLIENTRXSTATSVLD     (EMACCLIENTRXSTATSVLD),
    .EMACCLIENTRXSTATSBYTEVLD (EMACCLIENTRXSTATSBYTEVLD),

    // LocalLink transmitter interface
    .TX_LL_CLOCK              (ll_clk_i),
    .TX_LL_RESET              (ll_reset_i),
    .TX_LL_DATA               (tx_ll_data),
    .TX_LL_SOF_N              (tx_ll_sof_n),
    .TX_LL_EOF_N              (tx_ll_eof_n),
    .TX_LL_SRC_RDY_N          (tx_ll_src_rdy_n),
    .TX_LL_DST_RDY_N          (tx_ll_dst_rdy_n),

    // Client transmitter signals
    .CLIENTEMACTXIFGDELAY     (CLIENTEMACTXIFGDELAY),
    .EMACCLIENTTXSTATS        (EMACCLIENTTXSTATS),
    .EMACCLIENTTXSTATSVLD     (EMACCLIENTTXSTATSVLD),
    .EMACCLIENTTXSTATSBYTEVLD (EMACCLIENTTXSTATSBYTEVLD),

    // MAC control interface
    .CLIENTEMACPAUSEREQ       (CLIENTEMACPAUSEREQ),
    .CLIENTEMACPAUSEVAL       (CLIENTEMACPAUSEVAL),

    // EMAC-transceiver link status
    .EMACCLIENTSYNCACQSTATUS  (EMACCLIENTSYNCACQSTATUS),
    .EMACANINTERRUPT          (EMACANINTERRUPT),

    // 1000BASE-X PCS/PMA interface
    .TXP                      (txp),
    .TXN                      (txn),
    .RXP                      (rxp),
    .RXN                      (rxn),
    .PHYAD                    (PHYAD),
    .RESETDONE                (resetdone_i),

    // 1000BASE-X PCS/PMA clock buffer input
    .CLK_DS                   (clk_ds),

    // Asynchronous reset
    .RESET                    (reset_i)
    );

	    // Synchronize resetdone_i from the GT in the transmitter clock domain
    always @(posedge ll_clk_i, posedge reset_i)
      if (reset_i == 1'b1)
        resetdone_r <= 1'b0;
      else
        resetdone_r <= resetdone_i;

    // Create synchronous reset in the transmitter clock domain
    always @(posedge ll_clk_i, posedge reset_i)
    begin
      if (reset_i == 1'b1)
      begin
        ll_pre_reset_i <= 6'h3F;
        ll_reset_i     <= 1'b1;
      end
      else if (resetdone_r == 1'b1)
      begin
        ll_pre_reset_i[0]   <= 1'b0;
        ll_pre_reset_i[5:1] <= ll_pre_reset_i[4:0];
        ll_reset_i          <= ll_pre_reset_i[5];
      end
    end

endmodule

