//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : ddl_stimulus
//* File            : ddl_stimulus.v
//* Description     : DDL data stimulus for simulation 
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*     18-01-2013 : Last modified
//*
//*******************************************************************************
`timescale 1ns / 1ps
module ddl_tlk_stimulus(
output reg ddl_usrclk = 1'b0,
output gtx_txoutclk,
output gtx_rxrecclk,
output [15:0] ddl0_rxdata,
output ddl0_rx_er,
output ddl0_rx_dv,
//output [1:0] ddl0_rxcharisk,

output [15:0] ddl1_rxdata,
output ddl1_rx_er,
output ddl1_rx_dv,
//output [1:0] ddl1_rxcharisk,

input reset
);

wire [1:0] ddl0_rxcharisk;
wire [1:0] ddl1_rxcharisk;

assign gtx_txoutclk = ddl_usrclk;
assign gtx_rxrecclk = ddl_usrclk;


reg ddlcmd_req0 = 1'b0;
reg [31:0] ddlcmd0 = 32'h014;
wire ddlcmd_ack0;

assign ddl0_rx_er = 1'b0;
assign ddl1_rx_er = 1'b0;
assign ddl0_rx_dv = (ddl0_rxcharisk == 2'b00) ? 1'b1 : 1'b0;
assign ddl1_rx_dv = (ddl1_rxcharisk == 2'b00) ? 1'b1 : 1'b0;

initial
begin
ddlcmd_req0 = 1'b0;
#40000;
@(posedge ddl_usrclk);
$display("send a DDL command %t", $realtime);
//while(!ddlcmd_ack0)
ddlcmd_req0 = 1'b1;
while(!ddlcmd_ack0)
begin
@(posedge ddl_usrclk);
end
$display("DDL command done %t", $realtime);
ddlcmd_req0 = 1'b0;
end

ddl_packet_encoder u_ddl_packet_encoder0 (
    .rd_clk(ddl_usrclk), 
//    .tx_data(16'h0),
//	 .tx_rd_enable(), 	
//    .tx_data_valid(1'b0), 
//    .tx_ack(),
	 .rd_en(), 
    .dout(), 
    .prog_empty(1'b1), 
    .empty(1'b1), 

    .ddl_ReplyAck(ddlcmd_ack0), 
    .ddl_ReplyReq(ddlcmd_req0), 
    .ddl_Reply(ddlcmd0), 
    .ddl_DtstwAck(), 
    //.ddl_DtstwReq(), 
    //.DTSTW(), 

    .txchardispmode(), 
    .txchardispval(), 
    .tx_charisk(ddl0_rxcharisk), 
    .txd(ddl0_rxdata), 
	
    .diag_payload(16'h00cc), 
	 .ddl_xoff(1'b0),
	
    .reset(reset)
    );
	
	
	ddl_packet_encoder u_ddl_packet_encoder1 (
    .rd_clk(ddl_usrclk), 
	 
//    .tx_data(16'h0),
//	 .tx_rd_enable(), 	
//    .tx_data_valid(1'b0), 
//    .tx_ack(),
	 .rd_en(), 
    .dout(), 
    .prog_empty(), 
    .empty(1'b0), 

    .ddl_ReplyAck(), 
    .ddl_ReplyReq(), 
    .ddl_Reply(), 
    .ddl_DtstwAck(), 
    //.ddl_DtstwReq(1'b0), 
    //.DTSTW(), 

    .txchardispmode(), 
    .txchardispval(), 
    .tx_charisk(ddl1_rxcharisk), 
    .txd(ddl1_rxdata), 
	
    .diag_payload(16'h00cc), 
	 .ddl_xoff(1'b0), 
	
    .reset(reset)
    );

  initial
  begin
    ddl_usrclk <= 1'b0;
    forever
    begin
      ddl_usrclk <= 1'b0;
      #4.7;
      ddl_usrclk <= 1'b1;
      #4.7;
    end
  end

initial
begin

end

endmodule
