`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:18 12/26/2012 
// Design Name: 
// Module Name:    frame_typ 
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
module frame_typ;

   // data field
   reg [7:0]  data  [0:127];
   reg        valid [0:127];
   reg        error [0:127];

   // Indicate to the testbench that the frame contains an error
   reg        bad_frame;

`define FRAME_TYP [8*128+128+128+1:1]

   reg `FRAME_TYP bits;

   function `FRAME_TYP tobits;
      input dummy;
      begin
   bits = {data[ 0],  data[ 1],  data[ 2],  data[ 3],  data[ 4],
          data[ 5],  data[ 6],  data[ 7],  data[ 8],  data[ 9],
          data[10],  data[11],  data[12],  data[13],  data[14],
          data[15],  data[16],  data[17],  data[18],  data[19],
          data[20],  data[21],  data[22],  data[23],  data[24],
          data[25],  data[26],  data[27],  data[28],  data[29],
          data[30],  data[31],  data[32],  data[33],  data[34],
          data[35],  data[36],  data[37],  data[38],  data[39],
          data[40],  data[41],  data[42],  data[43],  data[44],
          data[45],  data[46],  data[47],  data[48],  data[49],
          data[50],  data[51],  data[52],  data[53],  data[54],
          data[55],  data[56],  data[57],  data[58],  data[59],
          data[60],  data[61],  data[62],  data[63],  data[64],  
			 data[65],  data[66],
          data[67],  data[68],  data[69],  data[70],  data[71],
          data[72],  data[73],  data[74],  data[75],  data[76],
          data[77],  data[78],  data[79],  data[80],  data[81],
          data[82],  data[83],  data[84],  data[85],  data[86],
          data[87],  data[88],  data[89],  data[90],  data[91],
          data[92],  data[93],  data[94],  data[95],  data[96],
          data[97],  data[98],  data[99],  data[100],  data[101],
          data[102],  data[103],  data[104],  data[105],  data[106],
          data[107],  data[108],  data[109],  data[110],  data[111],
          data[112],  data[113],  data[114],  data[115],  data[116],
          data[117],  data[118],  data[119],  data[120],  data[121],
          data[122],  data[123],  data[124],  data[125],  data[126],
          data[127],
			 valid[ 0],  valid[ 1],  valid[ 2],  valid[ 3],  valid[ 4],
          valid[ 5],  valid[ 6],  valid[ 7],  valid[ 8],  valid[ 9],
          valid[10],  valid[11],  valid[12],  valid[13],  valid[14],
          valid[15],  valid[16],  valid[17],  valid[18],  valid[19],
          valid[20],  valid[21],  valid[22],  valid[23],  valid[24],
          valid[25],  valid[26],  valid[27],  valid[28],  valid[29],
          valid[30],  valid[31],  valid[32],  valid[33],  valid[34],
          valid[35],  valid[36],  valid[37],  valid[38],  valid[39],
          valid[40],  valid[41],  valid[42],  valid[43],  valid[44],
          valid[45],  valid[46],  valid[47],  valid[48],  valid[49],
          valid[50],  valid[51],  valid[52],  valid[53],  valid[54],
          valid[55],  valid[56],  valid[57],  valid[58],  valid[59],
          valid[60],  valid[61],  valid[62],  valid[63],  valid[64],  
			 valid[65],  valid[66],
          valid[67],  valid[68],  valid[69],  valid[70],  valid[71],
          valid[72],  valid[73],  valid[74],  valid[75],  valid[76],
          valid[77],  valid[78],  valid[79],  valid[80],  valid[81],
          valid[82],  valid[83],  valid[84],  valid[85],  valid[86],
          valid[87],  valid[88],  valid[89],  valid[90],  valid[91],
          valid[92],  valid[93],  valid[94],  valid[95],  valid[96],
          valid[97],  valid[98],  valid[99],  valid[100],  valid[101],
          valid[102],  valid[103],  valid[104],  valid[105],  valid[106],
          valid[107],  valid[108],  valid[109],  valid[110],  valid[111],
          valid[112],  valid[113],  valid[114],  valid[115],  valid[116],
          valid[117],  valid[118],  valid[119],  valid[120],  valid[121],
          valid[122],  valid[123],  valid[124],  valid[125],  valid[126],
          valid[127],			 
			 error[ 0],  error[ 1],  error[ 2],  error[ 3],  error[ 4],
          error[ 5],  error[ 6],  error[ 7],  error[ 8],  error[ 9],
          error[10],  error[11],  error[12],  error[13],  error[14],
          error[15],  error[16],  error[17],  error[18],  error[19],
          error[20],  error[21],  error[22],  error[23],  error[24],
          error[25],  error[26],  error[27],  error[28],  error[29],
          error[30],  error[31],  error[32],  error[33],  error[34],
          error[35],  error[36],  error[37],  error[38],  error[39],
          error[40],  error[41],  error[42],  error[43],  error[44],
          error[45],  error[46],  error[47],  error[48],  error[49],
          error[50],  error[51],  error[52],  error[53],  error[54],
          error[55],  error[56],  error[57],  error[58],  error[59],
          error[60],  error[61],  error[62],  error[63],  error[64],  
			 error[65],  error[66],
          error[67],  error[68],  error[69],  error[70],  error[71],
          error[72],  error[73],  error[74],  error[75],  error[76],
          error[77],  error[78],  error[79],  error[80],  error[81],
          error[82],  error[83],  error[84],  error[85],  error[86],
          error[87],  error[88],  error[89],  error[90],  error[91],
          error[92],  error[93],  error[94],  error[95],  error[96],
          error[97],  error[98],  error[99],  error[100],  error[101],
          error[102],  error[103],  error[104],  error[105],  error[106],
          error[107],  error[108],  error[109],  error[110],  error[111],
          error[112],  error[113],  error[114],  error[115],  error[116],
          error[117],  error[118],  error[119],  error[120],  error[121],
          error[122],  error[123],  error[124],  error[125],  error[126],
          error[127],
          bad_frame};
   tobits = bits;
      end
   endfunction // tobits

   task frombits;
      input `FRAME_TYP frame;
      begin
   bits = frame;
          {data[ 0],  data[ 1],  data[ 2],  data[ 3],  data[ 4],
          data[ 5],  data[ 6],  data[ 7],  data[ 8],  data[ 9],
          data[10],  data[11],  data[12],  data[13],  data[14],
          data[15],  data[16],  data[17],  data[18],  data[19],
          data[20],  data[21],  data[22],  data[23],  data[24],
          data[25],  data[26],  data[27],  data[28],  data[29],
          data[30],  data[31],  data[32],  data[33],  data[34],
          data[35],  data[36],  data[37],  data[38],  data[39],
          data[40],  data[41],  data[42],  data[43],  data[44],
          data[45],  data[46],  data[47],  data[48],  data[49],
          data[50],  data[51],  data[52],  data[53],  data[54],
          data[55],  data[56],  data[57],  data[58],  data[59],
          data[60],  data[61],  data[62],  data[63],  data[64],  
			 data[65],  data[66],
          data[67],  data[68],  data[69],  data[70],  data[71],
          data[72],  data[73],  data[74],  data[75],  data[76],
          data[77],  data[78],  data[79],  data[80],  data[81],
          data[82],  data[83],  data[84],  data[85],  data[86],
          data[87],  data[88],  data[89],  data[90],  data[91],
          data[92],  data[93],  data[94],  data[95],  data[96],
          data[97],  data[98],  data[99],  data[100],  data[101],
          data[102],  data[103],  data[104],  data[105],  data[106],
          data[107],  data[108],  data[109],  data[110],  data[111],
          data[112],  data[113],  data[114],  data[115],  data[116],
          data[117],  data[118],  data[119],  data[120],  data[121],
          data[122],  data[123],  data[124],  data[125],  data[126],
          data[127],
			 valid[ 0],  valid[ 1],  valid[ 2],  valid[ 3],  valid[ 4],
          valid[ 5],  valid[ 6],  valid[ 7],  valid[ 8],  valid[ 9],
          valid[10],  valid[11],  valid[12],  valid[13],  valid[14],
          valid[15],  valid[16],  valid[17],  valid[18],  valid[19],
          valid[20],  valid[21],  valid[22],  valid[23],  valid[24],
          valid[25],  valid[26],  valid[27],  valid[28],  valid[29],
          valid[30],  valid[31],  valid[32],  valid[33],  valid[34],
          valid[35],  valid[36],  valid[37],  valid[38],  valid[39],
          valid[40],  valid[41],  valid[42],  valid[43],  valid[44],
          valid[45],  valid[46],  valid[47],  valid[48],  valid[49],
          valid[50],  valid[51],  valid[52],  valid[53],  valid[54],
          valid[55],  valid[56],  valid[57],  valid[58],  valid[59],
          valid[60],  valid[61],  valid[62],  valid[63],  valid[64],  
			 valid[65],  valid[66],
          valid[67],  valid[68],  valid[69],  valid[70],  valid[71],
          valid[72],  valid[73],  valid[74],  valid[75],  valid[76],
          valid[77],  valid[78],  valid[79],  valid[80],  valid[81],
          valid[82],  valid[83],  valid[84],  valid[85],  valid[86],
          valid[87],  valid[88],  valid[89],  valid[90],  valid[91],
          valid[92],  valid[93],  valid[94],  valid[95],  valid[96],
          valid[97],  valid[98],  valid[99],  valid[100],  valid[101],
          valid[102],  valid[103],  valid[104],  valid[105],  valid[106],
          valid[107],  valid[108],  valid[109],  valid[110],  valid[111],
          valid[112],  valid[113],  valid[114],  valid[115],  valid[116],
          valid[117],  valid[118],  valid[119],  valid[120],  valid[121],
          valid[122],  valid[123],  valid[124],  valid[125],  valid[126],
          valid[127],			 
			 error[ 0],  error[ 1],  error[ 2],  error[ 3],  error[ 4],
          error[ 5],  error[ 6],  error[ 7],  error[ 8],  error[ 9],
          error[10],  error[11],  error[12],  error[13],  error[14],
          error[15],  error[16],  error[17],  error[18],  error[19],
          error[20],  error[21],  error[22],  error[23],  error[24],
          error[25],  error[26],  error[27],  error[28],  error[29],
          error[30],  error[31],  error[32],  error[33],  error[34],
          error[35],  error[36],  error[37],  error[38],  error[39],
          error[40],  error[41],  error[42],  error[43],  error[44],
          error[45],  error[46],  error[47],  error[48],  error[49],
          error[50],  error[51],  error[52],  error[53],  error[54],
          error[55],  error[56],  error[57],  error[58],  error[59],
          error[60],  error[61],  error[62],  error[63],  error[64],  
			 error[65],  error[66],
          error[67],  error[68],  error[69],  error[70],  error[71],
          error[72],  error[73],  error[74],  error[75],  error[76],
          error[77],  error[78],  error[79],  error[80],  error[81],
          error[82],  error[83],  error[84],  error[85],  error[86],
          error[87],  error[88],  error[89],  error[90],  error[91],
          error[92],  error[93],  error[94],  error[95],  error[96],
          error[97],  error[98],  error[99],  error[100],  error[101],
          error[102],  error[103],  error[104],  error[105],  error[106],
          error[107],  error[108],  error[109],  error[110],  error[111],
          error[112],  error[113],  error[114],  error[115],  error[116],
          error[117],  error[118],  error[119],  error[120],  error[121],
          error[122],  error[123],  error[124],  error[125],  error[126],
          error[127],
          bad_frame} = bits;
      end
   endtask // frombits

endmodule // frame_typ

