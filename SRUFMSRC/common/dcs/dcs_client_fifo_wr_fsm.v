`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module dcs_client_fifo_wr_fsm(
		//DCS rx_fifo read interface
		input  				dcs_rd_clk,//40MHz
		output 				dcs_rd_sof_n,
		output [7:0] 		dcs_rd_data_out,
		output 				dcs_rd_eof_n,
		output 				dcs_rd_src_rdy_n,
		input  				dcs_rd_dst_rdy_n,
		input  [5:0]		dcs_rd_addr,
		output [3:0]  		dcs_rx_fifo_status,
		output 				dcs_rx_overflow,
		
		//DCS rx_fifo write interface
		input					dcs_wr_clk, //40MHz
		input  [63:0]		dcs_cmd_reply,
		input					dcs_cmd_update,
		input  [15:0]		dcs_udp_dst_port,
		input  [15:0]		dcs_udp_src_port,
		
		output				udp_reply_stored,
		 
		input 				reset
		);

		parameter DcsFifoAddr = 6'h3f;
		parameter DcsNode = 6'd1;
		parameter dcs_udp_tx_length = 16'd20;
		parameter dcs_udp_tx_chksum = 16'h0;
		// Signals for DCS rx_fifo
		reg 				dcs_wr_enable = 1'b0;
		wire [7:0] 		dcs_rx_data;
		reg 				dcs_rx_data_valid = 1'b0; 
		reg 				dcs_rx_good_frame = 1'b0;
		wire 				dcs_rx_bad_frame;
		
		wire[175:0]			dcs_udp_frame_wire;
		reg[175:0]			dcs_udp_frame_reg = 176'h0;
		
		wire [31:0] dcs_node;
		assign dcs_node = DcsNode;
		
		assign dcs_udp_frame_wire = {dcs_udp_tx_length, dcs_udp_src_port, dcs_udp_dst_port,
		dcs_udp_tx_length,dcs_udp_tx_chksum,dcs_node,dcs_cmd_reply}; //18bytes
		assign udp_reply_stored = dcs_wr_enable;
		
		//States are Wait_s,FrameLoad_s,DataWr_s,We_s,
		parameter Wait_s = 4'b0001; 		parameter FrameLoad_s = 4'b0010; 
		parameter DataWr_s = 4'b0100; 		parameter We_s = 4'b1000; 

		reg [3:0] st = Wait_s;
		reg [4:0] cnt = 5'd0;
		
		always @(posedge dcs_wr_clk)
		if(reset)
			begin
			dcs_wr_enable <= 1'b0;
			dcs_rx_data_valid <= 1'b0;
			dcs_rx_good_frame <= 1'b0;
			
			dcs_udp_frame_reg <= 176'h0;
			cnt <= 5'd0;
			
			st <= Wait_s;
			end else case(st)
			Wait_s : begin
			dcs_wr_enable <= 1'b0;
			dcs_rx_data_valid <= 1'b0;
			dcs_rx_good_frame <= 1'b0;
			
			dcs_udp_frame_reg <= 176'h0;
			cnt <= 5'd0;			
			
			if(dcs_cmd_update)
			st <= FrameLoad_s;
			else
			st <= Wait_s;			
			end

			FrameLoad_s : begin
			dcs_wr_enable <= 1'b1;
			dcs_rx_data_valid <= 1'b1;
			dcs_rx_good_frame <= 1'b0;

			dcs_udp_frame_reg <= dcs_udp_frame_wire;
			cnt <= 5'd0;	
			
			st <= DataWr_s;			
			end			
			
			DataWr_s : begin
			dcs_wr_enable <= 1'b1;
			dcs_rx_data_valid <= 1'b1;
			dcs_udp_frame_reg <= {dcs_udp_frame_reg[167:0], 8'h55};
			cnt <= cnt+ 5'd1;
			
			if(cnt == 5'd20)
			begin
			dcs_rx_good_frame <= 1'b1;
			st <= We_s;
			end
			else
			begin
			dcs_rx_good_frame <= 1'b0;
			st <= DataWr_s;
			end
			end	

			We_s : begin
			dcs_wr_enable <= 1'b1;
			dcs_rx_data_valid <= 1'b0;
			dcs_rx_good_frame <= 1'b0;
			dcs_udp_frame_reg <= dcs_udp_frame_reg;
			cnt <= cnt + 5'd1;
			
			if(cnt == 5'd24)
			st <= Wait_s;
			else
			st <= We_s;			
			end	

			default : begin
			dcs_wr_enable <= 1'b0;
			dcs_rx_data_valid <= 1'b0;
			dcs_rx_good_frame <= 1'b0;
			dcs_udp_frame_reg <= 176'h0;
			cnt <= 5'd0;
			
			st <= Wait_s;			
			end	
			endcase
		
		assign dcs_rx_data = dcs_udp_frame_reg[175:168];

	   // DCS Reply Receiver FIFO
   rx_client_fifo_8_rdbus #(.FifoInitAddr(DcsFifoAddr)) u_rx_client_fifo_8_rdbus (
      .rd_clk          (dcs_rd_clk),
      .rd_sreset       (reset),
      .rd_data_out     (dcs_rd_data_out),
      .rd_sof_n        (dcs_rd_sof_n),
      .rd_eof_n        (dcs_rd_eof_n),
      .rd_src_rdy_n    (dcs_rd_src_rdy_n),
      .rd_dst_rdy_n    (dcs_rd_dst_rdy_n),
      .rx_fifo_status  (dcs_rx_fifo_status),
	   .rd_addr		   	(dcs_rd_addr),
		
      .wr_sreset       (reset),
      .wr_clk          (dcs_wr_clk),
      .wr_enable       (dcs_wr_enable),
      .rx_data         (dcs_rx_data),
      .rx_data_valid   (dcs_rx_data_valid),
      .rx_good_frame   (dcs_rx_good_frame),
      .rx_bad_frame    (dcs_rx_bad_frame),
      .overflow        (dcs_rx_overflow)		
   );  
   
   assign dcs_rx_bad_frame = 1'b0;
	
endmodule
