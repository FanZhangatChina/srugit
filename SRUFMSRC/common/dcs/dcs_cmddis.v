`timescale 1ns / 1ps
`define DLY #1

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module dcs_cmddis #(
	parameter slowcontrol_port = 16'h1001
)
(
      //------------------------------------
		input       			udp_rx_clk,           // Receive clock to client MAC.      
		input [7:0] 			udp_rxd,              // Received Data to client MAC.
		input       			udp_rx_dv,            // Received control signal to client MAC.

		output       			dcs_rx_clk,           // Receive clock to client MAC.      
		output reg [7:0] 		dcs_rxd = 8'h0,       // Received Data to client MAC.
		output reg [40:0]		dcs_rx_dv = 41'h0,            // Received control signal to client MAC.

		output reg [15:0]		udp_rx_dst_port = 16'h1001,
		output reg [15:0]		udp_rx_src_port = 16'h1777,
		
		input 					reset
    );



		reg [40:0] dcs_rx_dv_i = 41'h0;
	
		always @(posedge dcs_rx_clk)
		if(reset)
		begin
			dcs_rxd <= `DLY 8'h0;
		end
		else
		begin
			dcs_rxd <= `DLY udp_rxd;			
		end
			

	 parameter st0 = 0;
	 parameter st1 = 1;
	 parameter st2 = 2;
	 parameter st3 = 3;
	 parameter st4 = 4;
	 parameter st5 = 5;
	 parameter st6 = 6;
	 parameter st7 = 7;
	 parameter st8 = 8;
	 parameter st9 = 9;
	 parameter st10 = 10;
	 parameter st11 = 11;
	 parameter st12 = 12;
	 parameter st13 = 13;
	 parameter st14 = 14;
	 parameter st15 = 15;
	 parameter st16 = 16;

reg [4:0] st = st0;

always @(posedge udp_rx_clk)
if(reset)
begin
dcs_rx_dv <= `DLY  41'h0;
dcs_rx_dv_i <= `DLY  41'h0;
udp_rx_dst_port <= `DLY 16'h0;
udp_rx_src_port <= `DLY 16'h0;

st <= `DLY st0;
end else case(st)
	st0 : begin
	dcs_rx_dv <= 41'h0;
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= udp_rx_dst_port;
	//udp_rx_src_port <= udp_rx_src_port;
	
	if(udp_rx_dv) //byte1
	begin
	udp_rx_src_port <= {udp_rxd,8'h0};
	st <= `DLY st1;
	end
	else
	begin
	udp_rx_src_port <= udp_rx_src_port;
	st <= `DLY st0;
	end
	end
	
	st1 : begin
	dcs_rx_dv <= `DLY  41'h0; //byte2
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= udp_rx_dst_port;
	udp_rx_src_port <= `DLY {udp_rx_src_port[15:8],udp_rxd};
	st <= `DLY st2;
	end
	
	st2 : begin
	dcs_rx_dv <= `DLY  41'h0; //byte3
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY {udp_rxd,8'h0};
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st3;
	end
	
	st3 : begin
	dcs_rx_dv <= `DLY  41'h0; //byte4
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY {udp_rx_dst_port[15:8],udp_rxd};
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st4;
	end
	
	st4 : begin
	dcs_rx_dv <= `DLY  41'h0; //length
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	if(udp_rx_dst_port == slowcontrol_port)
	st <= `DLY st5;
	else
	st <= `DLY st16;
	end
	
	st5 : begin
	dcs_rx_dv <= `DLY  41'h0; //length
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st6;
	end
	
	st6 : begin
	dcs_rx_dv <= `DLY  41'h0; //checksum
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st7;
	end
	
	st7 : begin
	dcs_rx_dv <= `DLY  41'h0; //checksum
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st8;
	end

	st8 : begin
	dcs_rx_dv <= `DLY  41'h0; //cs8
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st9;
	end
	
	st9 : begin
	dcs_rx_dv_i <= `DLY  {udp_rxd[4:0],36'h0}; //cs7
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st10;
	end
	
	st10 : begin
	dcs_rx_dv_i <= `DLY  {dcs_rx_dv_i[40:36],udp_rxd,28'h0}; //cs6
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st11;
	end
	
	st11 : begin
	dcs_rx_dv_i <= `DLY  {dcs_rx_dv_i[40:28],udp_rxd,20'h0}; //cs5
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st12;
	end

	st12: begin
	dcs_rx_dv_i <= `DLY  dcs_rx_dv_i; //cs4
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st13;
	end
	
	st13 : begin
	dcs_rx_dv_i <= `DLY  {dcs_rx_dv_i[40:20],udp_rxd[3:0],16'h0}; //cs3
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st14;
	end
	
	st14 : begin
	dcs_rx_dv_i <= `DLY  {dcs_rx_dv_i[40:16],udp_rxd,8'h0}; //cs2
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st15;
	end
	
	st15 : begin
	dcs_rx_dv_i <= `DLY  {dcs_rx_dv_i[40:8],udp_rxd}; //cs1
	dcs_rx_dv <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	st <= `DLY st16;
	end

	st16 : begin
	dcs_rx_dv_i <= `DLY  dcs_rx_dv_i; //cs1
	udp_rx_dst_port <= `DLY udp_rx_dst_port;
	udp_rx_src_port <= udp_rx_src_port;
	
	if(udp_rx_dv)
		begin
		st <= `DLY st16;
		dcs_rx_dv <= `DLY  dcs_rx_dv_i;
		end
	else
		begin
		st <= `DLY st0;
		dcs_rx_dv <= `DLY  41'h0;
		end
	end
	
	default : begin
	dcs_rx_dv <= `DLY  41'h0; //cs1
	dcs_rx_dv_i <= `DLY  41'h0;
	udp_rx_dst_port <= `DLY 16'h0;
	udp_rx_src_port <= `DLY 16'h0;
	
	st <= `DLY st0;
	end
	endcase

	assign dcs_rx_clk = udp_rx_clk;

endmodule
