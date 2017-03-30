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
    );

	reg [15:0] dac0_pdin, dac1_pdin, dac2_pdin, dac3_pdin;


	always @(negedge reset or posedge sclk)
	if(~reset)
	begin
	bitcnt <= 8'h0;
	state  <= st_IDLE;
	end else case(state)
	st_IDLE : begin
	bitcnt <= 8'h0;
	
	if(ap_start)
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
	
	
	always @(posedge sclk)
	case(bitcnt)
	8'd0 : begin dac0_pdin <= 16'hff;  dac1_pdin <= 16'hff; dac2_pdin <= 16'hff; dac3_pdin <= 16'hff; end
	8'd20 : begin dac0_pdin <= {4'h2, hv_reg0, 2'b00};  dac1_pdin <= {4'h2, hv_reg8, 2'b00}; dac2_pdin <= {4'h2, hv_reg16, 2'b00}; dac3_pdin <= {4'h2, hv_reg24, 2'b00}; end
	8'd40 : begin dac0_pdin <= {4'h3, hv_reg1, 2'b00};  dac1_pdin <= {4'h3, hv_reg9, 2'b00}; dac2_pdin <= {4'h3, hv_reg17, 2'b00}; dac3_pdin <= {4'h3, hv_reg25, 2'b00}; end
	8'd80 : begin dac0_pdin <= {4'h4, hv_reg2, 2'b00};  dac1_pdin <= {4'h4, hv_reg10, 2'b00}; dac2_pdin <= {4'h4, hv_reg18, 2'b00}; dac3_pdin <= {4'h4, hv_reg26, 2'b00}; end
	8'd100 : begin dac0_pdin <= {4'h5, hv_reg3, 2'b00};  dac1_pdin <= {4'h5, hv_reg11, 2'b00}; dac2_pdin <= {4'h5, hv_reg19, 2'b00}; dac3_pdin <= {4'h5, hv_reg27, 2'b00}; end
	8'd120 : begin dac0_pdin <= {4'h6, hv_reg4, 2'b00};  dac1_pdin <= {4'h6, hv_reg12, 2'b00}; dac2_pdin <= {4'h6, hv_reg20, 2'b00}; dac3_pdin <= {4'h6, hv_reg28, 2'b00}; end
	8'd140 : begin dac0_pdin <= {4'h7, hv_reg5, 2'b00};  dac1_pdin <= {4'h7, hv_reg13, 2'b00}; dac2_pdin <= {4'h7, hv_reg21, 2'b00}; dac3_pdin <= {4'h7, hv_reg29, 2'b00}; end
	8'd160 : begin dac0_pdin <= {4'h8, hv_reg6, 2'b00};  dac1_pdin <= {4'h8, hv_reg14, 2'b00}; dac2_pdin <= {4'h8, hv_reg22, 2'b00}; dac3_pdin <= {4'h8, hv_reg30, 2'b00}; end
	8'd180 : begin dac0_pdin <= {4'h9, hv_reg7, 2'b00};  dac1_pdin <= {4'h9, hv_reg15, 2'b00}; dac2_pdin <= {4'h9, hv_reg23, 2'b00}; dac3_pdin <= {4'h9, hv_reg31, 2'b00}; end
	default : begin
	dac0_pdin <= dac0_pdin;
	dac1_pdin <= dac1_pdin;
	dac2_pdin <= dac2_pdin;
	dac3_pdin <= dac3_pdin;
	end
	endcase
	
	always @(posedge sclk)
	case(bitcnt)
	8'hff, 8'd16, 8'd36, 8'd56, 8'd76, 8'd96, 8'd116, 8'd136, 8'd156, 8'd176 : dac_cs_i <= 1'b1;
	8'h0,  8'd20, 8'd40, 8'd60, 8'd80, 8'd100, 8'd120, 8'd140, 8'd160, 8'd180 : dac_cs_i <= 1'b0;
	default : begin dac_cs_i <= dac_cs_i; end
	endcase


   parameter piso_shift = 16;
   
   reg [piso_shift-2:0] dac0_pi_reg, dac1_pi_reg, dac2_pi_reg, dac3_pi_reg;
   reg                  dac0_din, dac1_din, dac2_din, dac3_din;

   always @(posedge sclk)
      if (dac0_cs) begin
         dac0_pi_reg <= dac0_pdin[piso_shift-2:0];
         dac0_din    <= dac0_pdin[piso_shift-1];
      end
      else begin
         dac0_pi_reg <= {dac0_pi_reg[piso_shift-3:0],1'b0};
         dac0_din   <= dac0_pi_reg[piso_shift-1];
      end
		
   always @(posedge sclk)
      if (dac1_cs) begin
         dac1_pi_reg <= dac1_pdin[piso_shift-2:0];
         dac1_din    <= dac1_pdin[piso_shift-1];
      end
      else begin
         dac1_pi_reg <= {dac1_pi_reg[piso_shift-3:0],1'b0};
         dac1_din   <= dac1_pi_reg[piso_shift-1];
      end
		
   always @(posedge sclk)
      if (dac2_cs) begin
         dac2_pi_reg <= dac2_pdin[piso_shift-2:0];
         dac2_din    <= dac2_pdin[piso_shift-1];
      end
      else begin
         dac2_pi_reg <= {dac2_pi_reg[piso_shift-3:0],1'b0};
         dac2_din   <= dac2_pi_reg[piso_shift-1];
      end
		
   always @(posedge sclk)
      if (dac3_cs) begin
         dac3_pi_reg <= dac3_pdin[piso_shift-2:0];
         dac3_din    <= dac3_pdin[piso_shift-1];
      end
      else begin
         dac3_pi_reg <= {dac3_pi_reg[piso_shift-3:0],1'b0};
         dac3_din   <= dac3_pi_reg[piso_shift-1];
      end		
endmodule
