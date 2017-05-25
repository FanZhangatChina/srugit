`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:57 03/28/2017 
// Design Name: 
// Module Name:    dac_ctrl_fsm 
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
module dac_ctrl_fsm(
	input reset,
	input clkin,
	input hv_update,
	input [319:0] hv_reg_din,
	input [3:0]	dac_dout,
	
	output [3:0] dac_sclk,
	output [3:0] dac_din,
	output [3:0] dac_cs,
	output 	reg	 dac_load	= 1'b0
    );

	reg [15:0] dac0_pdin, dac1_pdin, dac2_pdin, dac3_pdin;
	reg dac_cs_i = 1'b1;
	wire dac_sclk_i;
	assign dac_sclk_i = clkin;
	assign dac_sclk = {dac_sclk_i, dac_sclk_i, dac_sclk_i, dac_sclk_i};
	
	reg [9:0] hv_reg0,hv_reg1,hv_reg2, hv_reg3, hv_reg4, hv_reg5, hv_reg6,hv_reg7;
	reg [9:0] hv_reg8,hv_reg9,hv_reg10,hv_reg11,hv_reg12,hv_reg13,hv_reg14,hv_reg15;
	reg [9:0] hv_reg16,hv_reg17,hv_reg18,hv_reg19,hv_reg20,hv_reg21,hv_reg22,hv_reg23;
	reg [9:0] hv_reg24,hv_reg25,hv_reg26,hv_reg27,hv_reg28,hv_reg29,hv_reg30,hv_reg31;
	
	always @(posedge dac_sclk_i)
	begin
	hv_reg0 <= hv_reg_din[9:0];
	hv_reg1 <= hv_reg_din[19:10];
	hv_reg2 <= hv_reg_din[29:20];
	hv_reg3 <= hv_reg_din[39:30];
	hv_reg4 <= hv_reg_din[49:40];
	hv_reg5 <= hv_reg_din[59:50];
	hv_reg6 <= hv_reg_din[69:60];
	hv_reg7 <= hv_reg_din[79:70];
	
	hv_reg8 <= hv_reg_din[89:80];
	hv_reg9 <= hv_reg_din[99:90];
	hv_reg10 <= hv_reg_din[109:100];
	hv_reg11 <= hv_reg_din[119:110];
	hv_reg12 <= hv_reg_din[129:120];
	hv_reg13 <= hv_reg_din[139:130];
	hv_reg14 <= hv_reg_din[149:140];
	hv_reg15 <= hv_reg_din[159:150];
	
	hv_reg16 <= hv_reg_din[169:160];
	hv_reg17 <= hv_reg_din[179:170];
	hv_reg18 <= hv_reg_din[189:180];
	hv_reg19 <= hv_reg_din[199:190];
	hv_reg20 <= hv_reg_din[209:200];
	hv_reg21 <= hv_reg_din[219:210];
	hv_reg22 <= hv_reg_din[229:220];
	hv_reg23 <= hv_reg_din[239:230];

	hv_reg24 <= hv_reg_din[249:240];
	hv_reg25 <= hv_reg_din[259:250];
	hv_reg26 <= hv_reg_din[269:260];
	hv_reg27 <= hv_reg_din[279:270];
	hv_reg28 <= hv_reg_din[289:280];
	hv_reg29 <= hv_reg_din[299:290];
	hv_reg30 <= hv_reg_din[309:300];
	hv_reg31 <= hv_reg_din[319:310];
	end

	parameter st_IDLE = 2'b01;
	parameter st_UPDATE = 2'b10;
	reg [1:0] state = 2'b01;
	reg [7:0] bitcnt = 8'h0;
	
	always @(negedge reset or posedge dac_sclk_i)
	if(~reset)
	begin
	bitcnt <= 8'h0;
	state  <= st_IDLE;
	end else case(state)
	st_IDLE : begin
	bitcnt <= 8'h0;
	
	if(hv_update)
	state  <= st_UPDATE;
	else   
	state  <= st_IDLE;
	end
	
	st_UPDATE : begin
	bitcnt <= bitcnt + 8'h1;
	
	if(bitcnt == 8'd180)
	state  <= st_IDLE;
	else   
	state  <= st_UPDATE;
	end
	
	default : begin
	bitcnt <= 8'h0;
	state  <= st_IDLE;
	end
	endcase
	
	
	always @(posedge dac_sclk_i)
	case(bitcnt)
	8'd0 : begin dac0_pdin <= 16'hff;  dac1_pdin <= 16'hff; dac2_pdin <= 16'hff; dac3_pdin <= 16'hff; end
	8'd20 : begin dac0_pdin <= {4'h2, hv_reg0, 2'b00};  dac1_pdin <= {4'h2, hv_reg8, 2'b00}; dac2_pdin <= {4'h2, hv_reg16, 2'b00}; dac3_pdin <= {4'h2, hv_reg24, 2'b00}; end
	8'd40 : begin dac0_pdin <= {4'h3, hv_reg1, 2'b00};  dac1_pdin <= {4'h3, hv_reg9, 2'b00}; dac2_pdin <= {4'h3, hv_reg17, 2'b00}; dac3_pdin <= {4'h3, hv_reg25, 2'b00}; end
	8'd60 : begin dac0_pdin <= {4'h4, hv_reg2, 2'b00};  dac1_pdin <= {4'h4, hv_reg10, 2'b00}; dac2_pdin <= {4'h4, hv_reg18, 2'b00}; dac3_pdin <= {4'h4, hv_reg26, 2'b00}; end
	8'd80 : begin dac0_pdin <= {4'h5, hv_reg3, 2'b00};  dac1_pdin <= {4'h5, hv_reg11, 2'b00}; dac2_pdin <= {4'h5, hv_reg19, 2'b00}; dac3_pdin <= {4'h5, hv_reg27, 2'b00}; end
	8'd100 : begin dac0_pdin <= {4'h6, hv_reg4, 2'b00};  dac1_pdin <= {4'h6, hv_reg12, 2'b00}; dac2_pdin <= {4'h6, hv_reg20, 2'b00}; dac3_pdin <= {4'h6, hv_reg28, 2'b00}; end
	8'd120 : begin dac0_pdin <= {4'h7, hv_reg5, 2'b00};  dac1_pdin <= {4'h7, hv_reg13, 2'b00}; dac2_pdin <= {4'h7, hv_reg21, 2'b00}; dac3_pdin <= {4'h7, hv_reg29, 2'b00}; end
	8'd140 : begin dac0_pdin <= {4'h8, hv_reg6, 2'b00};  dac1_pdin <= {4'h8, hv_reg14, 2'b00}; dac2_pdin <= {4'h8, hv_reg22, 2'b00}; dac3_pdin <= {4'h8, hv_reg30, 2'b00}; end
	8'd160 : begin dac0_pdin <= {4'h9, hv_reg7, 2'b00};  dac1_pdin <= {4'h9, hv_reg15, 2'b00}; dac2_pdin <= {4'h9, hv_reg23, 2'b00}; dac3_pdin <= {4'h9, hv_reg31, 2'b00}; end
	default : begin
	dac0_pdin <= dac0_pdin;
	dac1_pdin <= dac1_pdin;
	dac2_pdin <= dac2_pdin;
	dac3_pdin <= dac3_pdin;
	end
	endcase
	
	always  @(negedge reset or posedge dac_sclk_i)
	if(~reset)
	dac_cs_i <= 1'b1;
	else
	case(bitcnt)
	8'd17, 8'd37, 8'd57, 8'd77, 8'd97, 8'd117, 8'd137, 8'd157, 8'd177 : dac_cs_i <= 1'b1;
	8'h1,  8'd21, 8'd41, 8'd61, 8'd81, 8'd101, 8'd121, 8'd141, 8'd161 : dac_cs_i <= 1'b0;
	default : begin dac_cs_i <= dac_cs_i; end
	endcase
	
	assign dac_cs = {dac_cs_i,dac_cs_i,dac_cs_i,dac_cs_i};
	
	always  @(negedge reset or posedge dac_sclk_i)
	if(~reset)
	dac_load <= 1'b1;
	else
	case(bitcnt)	
	8'd180 : dac_load <= 1'b0;
	8'd0, 8'd196 : dac_load <= 1'b1;
	default dac_load <= dac_load;
	endcase
	
   parameter piso_shift = 16;
   
   reg [piso_shift-2:0] dac0_pi_reg, dac1_pi_reg, dac2_pi_reg, dac3_pi_reg;
   reg                  dac0_din, dac1_din, dac2_din, dac3_din;

   always @(posedge dac_sclk_i)
      if (dac_cs_i) begin
         dac0_pi_reg <= dac0_pdin[piso_shift-2:0];
         dac0_din    <= dac0_pdin[piso_shift-1];
      end
      else begin
         dac0_pi_reg <= {dac0_pi_reg[piso_shift-3:0],1'b0};
         dac0_din   <= dac0_pi_reg[piso_shift-2];
      end
		
   always @(posedge dac_sclk_i)
      if (dac_cs_i) begin
         dac1_pi_reg <= dac1_pdin[piso_shift-2:0];
         dac1_din    <= dac1_pdin[piso_shift-1];
      end
      else begin
         dac1_pi_reg <= {dac1_pi_reg[piso_shift-3:0],1'b0};
         dac1_din   <= dac1_pi_reg[piso_shift-2];
      end
		
   always @(posedge dac_sclk_i)
      if (dac_cs_i) begin
         dac2_pi_reg <= dac2_pdin[piso_shift-2:0];
         dac2_din    <= dac2_pdin[piso_shift-1];
      end
      else begin
         dac2_pi_reg <= {dac2_pi_reg[piso_shift-3:0],1'b0};
         dac2_din   <= dac2_pi_reg[piso_shift-2];
      end
		
   always @(posedge dac_sclk_i)
      if (dac_cs_i) begin
         dac3_pi_reg <= dac3_pdin[piso_shift-2:0];
         dac3_din    <= dac3_pdin[piso_shift-1];
      end
      else begin
         dac3_pi_reg <= {dac3_pi_reg[piso_shift-3:0],1'b0};
         dac3_din   <= dac3_pi_reg[piso_shift-2];
      end	

assign dac_din[0] = dac0_din;
assign dac_din[1] = dac1_din;
assign dac_din[2] = dac2_din;
assign dac_din[3] = dac3_din;


endmodule
