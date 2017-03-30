`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module FlashTop(
	input clk,
	input reset,
	
	input FPGAReload,
	
	 //Global SC interface
   input [15:0] sc_port,
   input [31:0] sc_data,
   input [31:0] sc_addr,
   input [31:0] sc_subaddr,
   input sc_op,
   input sc_frame,
   input sc_wr,
   output sc_ack,
   output [31:0] sc_rply_data,
   output [31:0] sc_rply_error, 

	output [31:0] SRU_ip,
	output [31:0] SRU_SN,
	
	output [22:0] FLASH_A,
	inout [15:0] FLASH_DQ,
	output FLASH_CS_B,
	output FLASH_OE_B,
	output FLASH_WE_B,
	output FLASH_RS0,
	output FLASH_RS1,
	
	output FPGA_PROG_B
    );

	 //Flash SC interface
    wire [15:0] flash_sc_port;
    wire [31:0] flash_sc_data;
    wire [31:0] flash_sc_addr;
    wire [31:0] flash_sc_subaddr;
    wire flash_sc_op;
    wire flash_sc_frame;
    wire flash_sc_wr;
    wire flash_sc_ack;
    wire [31:0] flash_sc_rply_data;
    wire [31:0] flash_sc_rply_error;
	 
	 wire [23:0] FLASH_A_i;
	 wire [15:0] FLASH_DQin;
	 wire [15:0] FLASH_DQout;
	 wire FLASH_DQ_t;


// Instantiate the module
sc_flash_if  #(
      .flash_port(16'h2777)
   ) u_sc_flash_if (
    .clk(clk), 
    .rstn(~reset), 
    .state_led(), //unconnected
    .sc_port(flash_sc_port), 
    .sc_data(flash_sc_data), 
    .sc_addr(flash_sc_addr), 
    .sc_subaddr(flash_sc_subaddr), 
    .sc_op(flash_sc_op), 
    .sc_frame(flash_sc_frame), 
    .sc_wr(flash_sc_wr), 
    .sc_ack(flash_sc_ack), 
    .sc_rply_data(flash_sc_rply_data), 
    .sc_rply_error(flash_sc_rply_error), 
    .A(FLASH_A_i), 
    .DQout(FLASH_DQout), 
    .DQin(FLASH_DQin), 
    .DQ_T(FLASH_DQ_t), 
    .FLASH_CS_B(FLASH_CS_B), 
    .FLASH_OE_B(FLASH_OE_B), 
    .FLASH_WE_B(FLASH_WE_B)
    );


ReadIPinFlash u_ReadIPinFlash (
    .clk(clk), 
    .rstn(~reset), 
    .local_ip(SRU_ip), 
	 
    .sc_port(sc_port), 
    .sc_data(sc_data), 
    .sc_addr(sc_addr), 
    .sc_subaddr(sc_subaddr), 
    .sc_op(sc_op), 
    .sc_frame(sc_frame), 
    .sc_wr(sc_wr), 
    .sc_ack(sc_ack), 
    .sc_rply_data(sc_rply_data), 
    .sc_rply_error(sc_rply_error), 
	 
    .flash_sc_port(flash_sc_port), 
    .flash_sc_data(flash_sc_data), 
    .flash_sc_addr(flash_sc_addr), 
    .flash_sc_subaddr(flash_sc_subaddr), 
    .flash_sc_op(flash_sc_op), 
    .flash_sc_frame(flash_sc_frame), 
    .flash_sc_wr(flash_sc_wr), 
    .flash_sc_ack(flash_sc_ack), 
    .flash_sc_rply_data(flash_sc_rply_data), 
    .flash_sc_rply_error(flash_sc_rply_error)
    );

   EFUSE_USR #(
      .SIM_EFUSE_VALUE(32'h00000007)  // Value of the 32-bit non-volatile design ID used in simulation
   )
   EFUSE_USR_u (
      .EFUSEUSR(SRU_SN)  // 32-bit output: User E-Fuse register value output
   );

assign FLASH_A = FLASH_A_i[22:0];
assign FLASH_RS0 = FLASH_A_i[22];
assign FLASH_RS1 = FLASH_A_i[23];


  genvar m;
  generate
  for (m=0; m < 16; m=m+1) 
  begin: flash_d
  IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_dq (
      .O(FLASH_DQin[m]),     // Buffer output
      .IO(FLASH_DQ[m]),   // Buffer inout port (connect directly to top-level port)
      .I(FLASH_DQout[m]),     // Buffer input
      .T(FLASH_DQ_t)      // 3-state enable input, high=input, low=output
   );
	end 
	endgenerate

  IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_FPGA_PROG_B (
      .O(),     // Buffer output
      .IO(FPGA_PROG_B),   // Buffer inout port (connect directly to top-level port)
      .I(1'b0),     // Buffer input
      .T(~FPGAReload)      // 3-state enable input, high=input, low=output
   );

endmodule
