`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:28 03/01/2011 
// Design Name: 
// Module Name:    scController 
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
module scController(
	///
	input clk, clk125, clk10M, rstn,
	/// configuration registers
	input [15:0] cfg_scport, cfg_scmode,
	//// rx interface
	input [7:0] udprx_data, 
	input [15:0] udprx_checksum, udprx_dstport,
	input [31:0] udprx_srcIP,
	input udprx_datavalid,
	output udprx_portAck,
	//// slow control bus
	output [15:0]	 sc_port,
	output [31:0]	 sc_data, sc_addr, sc_subaddr,
	output 		 	 sc_wr, sc_op, sc_frame,
	input	 			 sc_ack,
	input [31:0]	 sc_rply_error, sc_rply_data,
	//// tx interface
	output [15:0] 	sctx_udptxSrcPort, sctx_udptxDstPort, sctx_length,
	output [31:0] 	sctx_udptxDstIP,
	output [7:0] 	sctx_data,
	output 			sctx_start, sctx_stop, sctx_req, sctx_done,
	input 			sctx_ack, sctx_txdatardy	
	
    );

	wire [15:0]	 sc_port_i;
	wire [31:0]	 sc_data_i, sc_addr_i, sc_subaddr_i;
	wire 		 	 sc_wr_i, sc_op_i, sc_frame_i;
	
	assign sc_port = sc_port_i;
	assign sc_data = sc_data_i;
	assign sc_addr = sc_addr_i;
	assign sc_subaddr = sc_subaddr_i;
	assign sc_wr = sc_wr_i;
	assign sc_op = sc_op_i;
	assign sc_frame = sc_frame_i;

(* KEEP="TRUE" *) wire sc_queue_empty, sc_queue_full, sc_queue_rden, sc_queue_rd_sof, sc_queue_rd_eof, sc_queue_rd_datavalid;
(* KEEP="TRUE" *) wire [15:0] sc_queue_length_out, sc_queue_dstport_out;
(* KEEP="TRUE" *) wire [31:0] sc_queue_rd_data;
(* KEEP="TRUE" *) wire [31:0] sc_queue_srcIP;
(* KEEP="TRUE" *) wire error_flag;
(* KEEP="TRUE" *) wire [7:0] error;
(* KEEP="TRUE" *) wire [31:0] error_IP, error_reqID;

scRXqueue scRXqueue (
    .eclk(clk125), 
    .clk(clk10M), 
    .rstn(rstn), 
 	 .cfg_scsrcport(cfg_scport),
	 .cfg_scmode(cfg_scmode),
	 //////////////////
    .rxdata(udprx_data), 
    .rxdatavalid(udprx_datavalid), 
    .dstport(udprx_dstport),
	 .srcIP(udprx_srcIP),
	 .rxchecksum(udprx_checksum),
    .rxAck(udprx_portAck), 
	 /////////////
	 .error_flag(error_flag),
	 .error(error),
    .error_IP(error_IP), 
    .error_reqID(error_reqID), 
	 /////////////
    .queue_empty(sc_queue_empty), 
    .queue_full(sc_queue_full), 
    .rden(sc_queue_rden), 
    .rd_data(sc_queue_rd_data), 
    .rd_sof(sc_queue_rd_sof), 
    .rd_eof(sc_queue_rd_eof), 
    .rd_datavalid(sc_queue_rd_datavalid), 
    .length_out(sc_queue_length_out), 
	 .srcIP_out(sc_queue_srcIP),
    .dstport_out(sc_queue_dstport_out)
    );
(* KEEP="TRUE" *) wire rxerr_txreq, rxerr_txstart, rxerr_txack, rxerr_txdstrdy, rxerr_txdone;
(* KEEP="TRUE" *) wire [7:0] rxerr_txdata;
(* KEEP="TRUE" *) wire [15:0] rxerr_txdstPort, rxerr_txsrcPort, rxerr_txlength;
(* KEEP="TRUE" *) wire [31:0] rxerr_txdstIP;

(* KEEP_HIERARCHY="TRUE" *) scRXErrorQueue scRXErrorQueue (
    .clk(clk125), 
    .rstn(rstn), 
    .error_flag(error_flag), 
    .error_data(error), 
    .error_IP(error_IP), 
    .error_reqID(error_reqID), 
    .txreq(rxerr_txreq), 
    .txstart(rxerr_txstart), 
    .txack(rxerr_txack), 
    .txdstrdy(sctx_txdatardy), 
    .txdata(rxerr_txdata), 
    .txdstPort(rxerr_txdstPort), 
    .txsrcPort(rxerr_txsrcPort), 
    .txdstIP(rxerr_txdstIP), 
    .txlength(rxerr_txlength), 
    .txdone(rxerr_txdone)
    );
	(* KEEP="TRUE" *) wire scrply_txreq, scrply_txdone, scerr_txreq, scerr_txdone;
//	assign scrply_txreq = 1'b0;
//	assign scrply_txdone = 1'b1;
	////////////////////////////////// TX ARBITER ///////////////////////////////////
   parameter stTXIDLE = 4'b0001;
   parameter stTXRXERR = 4'b0010;
   parameter stTXSCRPLY = 4'b0100;
   parameter stTXSCERR = 4'b1000;

   (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="4'b0001" *) reg [3:0] state = stTXIDLE;

	assign sctx_req = rxerr_txreq | scrply_txreq | scerr_txreq;

   always@(posedge clk125 or negedge rstn)
      if (!rstn) begin
         state <= stTXIDLE;
      end
      else
         (* PARALLEL_CASE *) case (state)
            stTXIDLE : begin
					if (sctx_ack)
						if (rxerr_txreq)
							state <= stTXRXERR;
						else if (scrply_txreq)
							state <= stTXSCRPLY;
						else if (scerr_txreq)
							state <= stTXSCERR;
						else
							state <= stTXIDLE;
            end
            stTXRXERR : begin
               if (rxerr_txdone)
                  state <= stTXIDLE;
               else
                  state <= stTXRXERR;
            end
            stTXSCRPLY : begin
               if (scrply_txdone)
                  state <= stTXIDLE;
               else
                  state <= stTXSCRPLY;
            end
            stTXSCERR : begin
               if (scerr_txdone)
                  state <= stTXIDLE;
               else
                  state <= stTXSCERR;
            end
            default : begin  // Fault Recovery
               state <= stTXIDLE;
            end   
         endcase
	
	wire [31:0] scrply_txdstIP, scerr_txdstIP;
	wire [15:0] scrply_txsrcPort, scrply_txlength, scerr_txsrcPort, scerr_txdstPort, scerr_txlength;
	wire [7:0] scrply_txdata, scerr_txdata;
	(* KEEP="TRUE" *) wire scrply_txstart, scerr_txstart, scerr_txack, scrply_txack;
	
	assign rxerr_txack = state[1];
	assign scrply_txack = state[2];
	assign scerr_txack = state[3];
	
	assign sctx_udptxSrcPort = state[1] ? rxerr_txsrcPort : 
										state[2] ? scrply_txsrcPort :
										state[3] ? scerr_txsrcPort :
										rxerr_txsrcPort;
	assign sctx_udptxDstPort = state[1] ? rxerr_txdstPort : 
										state[2] ? cfg_scport : 
										state[3] ? cfg_scport : 
										rxerr_txdstPort;
	assign sctx_udptxDstIP = 	state[1] ? rxerr_txdstIP : 
										state[2] ? scrply_txdstIP : 
										state[3] ? scerr_txdstIP : 
										rxerr_txdstIP;
	assign sctx_length = state[1] ? rxerr_txlength : 
								state[2] ? scrply_txlength : 
								state[3] ? scerr_txlength : 
								rxerr_txlength;
	assign sctx_data = 	state[1] ? rxerr_txdata : 
								state[2] ? scrply_txdata : 
								state[3] ? scerr_txdata : rxerr_txdata;
	assign sctx_start = 	state[1] ? rxerr_txstart : 
								state[2] ? scrply_txstart : 
								state[3] ? scerr_txstart : rxerr_txstart;
	assign sctx_stop = 1'b1;
	
	assign sctx_done = 	state[1] ? rxerr_txdone : 
								state[2] ? scrply_txdone : 
								state[3] ? scerr_txdone : 1'b1;


(* KEEP="TRUE" *) wire [31:0] sc_ip;
(* KEEP="TRUE" *) wire [127:0] sc_rply_bulk;
(* KEEP="TRUE" *) wire sc_error_flag;
(* KEEP="TRUE" *) wire [7:0] sc_error;
////////
scRXdecode2 scRXdecode2 (
    .clk(clk10M), 
    .rstn(rstn), 
	 /////////////////////
    .scq_full(sc_queue_full), 
    .scq_empty(sc_queue_empty), 
    .scq_data(sc_queue_rd_data), 
    .scq_datavalid(sc_queue_rd_datavalid), 
    .scq_length(sc_queue_length_out), 
    .scq_srcIP(sc_queue_srcIP), 
    .scq_dstPort(sc_queue_dstport_out), 
    .scq_sof(sc_queue_rd_sof), 
    .scq_eof(sc_queue_rd_eof), 
    .scq_ren(sc_queue_rden), 
	 /////////////////////
	 .error_flag(sc_error_flag),
	 .frame_error(sc_error),
	 /////////////////////
	 .sc_ip(sc_ip),
	 .sc_rply_bulk(sc_rply_bulk),
    .sc_port(sc_port_i), 
    .sc_data(sc_data_i), 
    .sc_addr(sc_addr_i), 
    .sc_subaddr(sc_subaddr_i), 
    .sc_wr(sc_wr_i), 
    .sc_op(sc_op_i), 
    .sc_frame(sc_frame_i), 
    .sc_ack(sc_ack)
    );
	 
scRplyQueue scRplyQueue (
    .clk(clk10M), 
    .eclk(clk125), 
    .rstn(rstn), 
    .sc_frame(sc_frame_i), 
    .sc_ack(sc_ack), 
    .sc_op(sc_op_i), 
    .sc_ip(sc_ip), 
    .sc_port(sc_port_i), 
    .sc_rply_bulk(sc_rply_bulk), 
    .sc_rply_error(sc_rply_error), 
    .sc_rply_data(sc_rply_data), 
    .txreq(scrply_txreq), 
    .txstart(scrply_txstart), 
    .txack(scrply_txack), 
    .txdstrdy(sctx_txdatardy), 
    .txdata(scrply_txdata), 
    .txsrcPort(scrply_txsrcPort), 
    .txdstIP(scrply_txdstIP), 
    .txlength(scrply_txlength), 
    .txdone(scrply_txdone)
    );
scDecodeErrorQueue scDecodeErrorQueue (
    .clk(clk10M), 
    .clke(clk125), 
    .rstn(rstn), 
    .error_flag(sc_error_flag), 
    .error_data(sc_error), 
    .error_IP(sc_ip), 
    .error_reqID(sc_rply_bulk[127:96]), 
    .txreq(scerr_txreq), 
    .txstart(scerr_txstart), 
    .txack(scerr_txack), 
    .txdstrdy(sctx_txdatardy), 
    .txdata(scerr_txdata), 
    .txdstPort(scerr_txdstPort), 
    .txsrcPort(scerr_txsrcPort), 
    .txdstIP(scerr_txdstIP), 
    .txlength(scerr_txlength), 
    .txdone(scerr_txdone)
    );

endmodule
