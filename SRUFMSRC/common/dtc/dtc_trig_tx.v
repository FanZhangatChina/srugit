`timescale 1ns / 1ps
`define DLY #1

// ALICE/EMCal SRU
// This module sends triggers and commands to DTC ports
// Equivalent SRU = SRUV3FM2015070806_PHOS/SRUV3FM2015070901_PHOS
// Fan Zhang. 11 July 2015

module dtc_master_tx(
		//dtc phy
		output dtc_trig_p,
		output dtc_trig_n,
		
		//trigger pulse input
		 input FeeTrig,
		 input rdocmd, //width
		 input abortcmd,
		 input FastCmd,
		 input [7:0] FastCmdCode,
		 output	FastCmdAck,

		//command interface
		input [31:0] cmd_addr,				
		input [31:0] cmd_data,				
		input cmd_dv,							
		output reg cmd_dv_ack = 1'b0,
		
		input bitclk,
		input bitclkdiv,
		
		input reset
	);
	
	parameter rwcmd_code = 8'hE1;
	parameter rdocmd_code = 8'hE2;
	parameter abortcmd_code = 8'hEA;
//	parameter sampsync_code = 8'hE4;
	
	reg [7:0] dtc_pdin = 8'h0;
	wire dtc_trig; 
	wire dtc_sdout;
	
	 dtc_dout_ser u_dtc_dout_ser (
	   .dtc_pdin(dtc_pdin), // input rst
		.dtc_sdout(dtc_sdout),

		//clock phase shift interface
		.bitclk(bitclk),		
		
		.reset(reset)
	);

		 reg FastCmd_ack = 1'b0;
		 reg rdocmd_ack = 1'b0;
		 reg abortcmd_ack = 1'b0;
		 
		 assign FastCmdAck = FastCmd_ack;
		 
wire rdocmd_buffer;
cmdackfsm u_rdocmd (
    .reset(reset), 
    .clk(bitclkdiv), 
    .cmd(rdocmd), 
    .cmd_ack(rdocmd_ack), 
    .cmd_buffer(rdocmd_buffer)
    );
	 
wire abortcmd_buffer;
cmdackfsm u_abortcmd (
    .reset(reset), 
    .clk(bitclkdiv), 
    .cmd(abortcmd), 
    .cmd_ack(abortcmd_ack), 
    .cmd_buffer(abortcmd_buffer)
    );

wire FastCmd_buffer;
cmdackfsm u_FastCmd (
    .reset(reset), 
    .clk(bitclkdiv), 
    .cmd(FastCmd), 
    .cmd_ack(FastCmd_ack), 
    .cmd_buffer(FastCmd_buffer)
    );

parameter st0 = 15'b000_0000_0000_0001;
parameter st1 = 15'b000_0000_0000_0010;
parameter st2 = 15'b000_0000_0000_0100;

parameter st4 = 15'b000_0000_0001_0000;
parameter st5 = 15'b000_0000_0010_0000;
parameter st6 = 15'b000_0000_0100_0000;
parameter st7 = 15'b000_0000_1000_0000;

parameter st8 = 15'b000_0001_0000_0000;
parameter st9 = 15'b000_0010_0000_0000;
parameter st10 = 15'b000_0100_0000_0000;
parameter st11 = 15'b000_1000_0000_0000;

parameter st12 = 15'b001_0000_0000_0000;
parameter st13 = 15'b010_0000_0000_0000;
parameter st14 = 15'b100_0000_0000_0000;

reg [14:0] st = st0;

   (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="15'b000_0000_0000_0001" *) 

	always @(posedge bitclkdiv)
	if(reset)
	begin
	dtc_pdin <= `DLY  8'h0;
	
	st <= `DLY  st0;
	end else case(st)
	st0 : begin
	dtc_pdin <= `DLY  8'h0;
	
	if(rdocmd_buffer)
	st <= `DLY  st1;
	else if(abortcmd_buffer)
	st <= `DLY  st2;
	else if(FastCmd_buffer)
	st <= `DLY  st13;
   else 
	if(cmd_dv)
   st <= st4;	
	else
	st <= st0;
	
	end
	
	st1: begin
	dtc_pdin <= `DLY  rdocmd_code;
	st <= `DLY  st14;
	end
	
	st2: begin
	dtc_pdin <= `DLY  abortcmd_code;
	st <= `DLY  st14;
	end
	
	st13: begin
	dtc_pdin <= `DLY  FastCmdCode;
	st <= `DLY  st14;
	end
	
	//command
	st4: begin
	dtc_pdin <=`DLY  rwcmd_code;
	st <= `DLY  st5;
	end
	
	st5: begin
	dtc_pdin <= `DLY  cmd_addr[31:24];
	st <= `DLY  st6;
	end
	
	st6: begin
	dtc_pdin <= `DLY  cmd_addr[23:16];
	st <= `DLY  st7;
	end
	
	st7: begin
	dtc_pdin <= `DLY  cmd_addr[15:8];
	st <= `DLY  st8;
	end
	
	st8: begin
	dtc_pdin <= `DLY  cmd_addr[7:0];
	st <= `DLY  st9;
	end
	
	st9: begin
	dtc_pdin <= `DLY  cmd_data[31:24];
	st <= `DLY  st10;
	end
	
	st10: begin
	dtc_pdin <= `DLY  cmd_data[23:16];
	st <= `DLY  st11;
	end
	
	st11: begin
	dtc_pdin <= `DLY  cmd_data[15:8];
	st <= `DLY  st12;
	end
	
	st12: begin
	dtc_pdin <= `DLY  cmd_data[7:0];
	st <= `DLY  st14;
	end	
	
	st14: begin
	dtc_pdin <= 8'h0;
	st <= st0;
	end
	
	default: begin
	dtc_pdin <= `DLY  8'h0;
	st <= `DLY  st0;
	end	
	endcase
	
	
	always @(posedge bitclkdiv)
	if(reset)
	rdocmd_ack <= 1'b0;
	else if(st == st1)
	rdocmd_ack <= 1'b1;
	else
	rdocmd_ack <= 1'b0;

	always @(posedge bitclkdiv)
	if(reset)
	abortcmd_ack <= 1'b0;
	else if(st == st2)
	abortcmd_ack <= 1'b1;
	else
	abortcmd_ack <= 1'b0;

	always @(posedge bitclkdiv)
	if(reset)
	FastCmd_ack <= 1'b0;
	else if(st == st13)
	FastCmd_ack <= 1'b1;
	else
	FastCmd_ack <= 1'b0;	
	
	always @(posedge bitclkdiv)
	if(reset)
	cmd_dv_ack <= 1'b0;
	else if(st == st4)
	cmd_dv_ack <= 1'b1;
	else
	cmd_dv_ack <= 1'b0;	

	ODDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) ODDR_DTCOUT (
      .Q(dtc_trig),   // 1-bit DDR output
      .C(bitclk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(dtc_sdout), // 1-bit data input (positive edge)
      .D2(FeeTrig), // 1-bit data input (negative edge)
      .R(reset),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
	
   OBUFDS #(
      .IOSTANDARD("DEFAULT") // Specify the output I/O standard
   ) OBUFDS_dtc_trig (
      .O(dtc_trig_p),     // Diff_p output (connect directly to top-level port)
      .OB(dtc_trig_n),   // Diff_n output (connect directly to top-level port)
      .I(dtc_trig)      // Buffer input 
   );	
	
endmodule
	