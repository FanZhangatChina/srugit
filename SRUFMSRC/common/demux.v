`timescale 1ns / 1ps

// ALICE/PHOS SRU
// Equivalent SRU = SRUV3FM2015071611_EMCal
// Fan Zhang. 16 July 2015

module demux(
	input 					dcsclk,
	input  		[5:0] 	dtc_mon_sel, 
	input 		[639:0] 	dtc_dout,
	output reg  [15:0]	dtc_deser_dout = 16'b0
    );

wire [15:0]			dtc_deser_dout_i [39:0];

genvar j;
generate
for (j=0; j < 40; j=j+1)
begin : dtc_dout_u
assign dtc_deser_dout_i[j] = dtc_dout[((j+1)*16-1) : ((j+1)*16-16)];
end
endgenerate

always @(posedge dcsclk)
begin
   case (dtc_mon_sel)
6'd0 : dtc_deser_dout <= dtc_deser_dout_i[0];
6'd1 : dtc_deser_dout <= dtc_deser_dout_i[1];
6'd2 : dtc_deser_dout <= dtc_deser_dout_i[2];
6'd3 : dtc_deser_dout <= dtc_deser_dout_i[3];
6'd4 : dtc_deser_dout <= dtc_deser_dout_i[4];
6'd5 : dtc_deser_dout <= dtc_deser_dout_i[5];
6'd6 : dtc_deser_dout <= dtc_deser_dout_i[6];
6'd7 : dtc_deser_dout <= dtc_deser_dout_i[7];
6'd8 : dtc_deser_dout <= dtc_deser_dout_i[8];
6'd9 : dtc_deser_dout <= dtc_deser_dout_i[9];
6'd10 : dtc_deser_dout <= dtc_deser_dout_i[10];
6'd11 : dtc_deser_dout <= dtc_deser_dout_i[11];
6'd12 : dtc_deser_dout <= dtc_deser_dout_i[12];
6'd13 : dtc_deser_dout <= dtc_deser_dout_i[13];
6'd14 : dtc_deser_dout <= dtc_deser_dout_i[14];
6'd15 : dtc_deser_dout <= dtc_deser_dout_i[15];
6'd16 : dtc_deser_dout <= dtc_deser_dout_i[16];
6'd17 : dtc_deser_dout <= dtc_deser_dout_i[17];
6'd18 : dtc_deser_dout <= dtc_deser_dout_i[18];
6'd19 : dtc_deser_dout <= dtc_deser_dout_i[19];
6'd20 : dtc_deser_dout <= dtc_deser_dout_i[20];
6'd21 : dtc_deser_dout <= dtc_deser_dout_i[21];
6'd22 : dtc_deser_dout <= dtc_deser_dout_i[22];
6'd23 : dtc_deser_dout <= dtc_deser_dout_i[23];
6'd24 : dtc_deser_dout <= dtc_deser_dout_i[24];
6'd25 : dtc_deser_dout <= dtc_deser_dout_i[25];
6'd26 : dtc_deser_dout <= dtc_deser_dout_i[26];
6'd27 : dtc_deser_dout <= dtc_deser_dout_i[27];
6'd28 : dtc_deser_dout <= dtc_deser_dout_i[28];
6'd29 : dtc_deser_dout <= dtc_deser_dout_i[29];
6'd30 : dtc_deser_dout <= dtc_deser_dout_i[30];
6'd31 : dtc_deser_dout <= dtc_deser_dout_i[31];
6'd32 : dtc_deser_dout <= dtc_deser_dout_i[32];
6'd33 : dtc_deser_dout <= dtc_deser_dout_i[33];
6'd34 : dtc_deser_dout <= dtc_deser_dout_i[34];
6'd35 : dtc_deser_dout <= dtc_deser_dout_i[35];
6'd36 : dtc_deser_dout <= dtc_deser_dout_i[36];
6'd37 : dtc_deser_dout <= dtc_deser_dout_i[37];
6'd38 : dtc_deser_dout <= dtc_deser_dout_i[38];
6'd39 : dtc_deser_dout <= dtc_deser_dout_i[39];
   
   default : dtc_deser_dout <= dtc_deser_dout_i[0];
   endcase
end

endmodule
