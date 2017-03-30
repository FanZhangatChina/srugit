//////////////////////////////////////////////////////////////////////////////////
module Hex2BCD(sys_clk, HexIn, BCD_out, busy);
    //works tested kw 8/1/08
        // converts a POSITVE or UNSIGNED binary value into a 4 digit BCD
        //signal valid at negative going edge of busy
        //based on Jermia's Mans Code
    input [15:0] HexIn;    //check that it does not exceed max value
    input sys_clk;

    output reg [15:0] BCD_out = 0;
    output reg busy = 0;
      

       //BCD conversion is based on shift-register technique with carry depending on whether value>=5

       reg [3:0] digit0, digit1, digit2, digit3;
       wire carry0, carry1, carry2;
       reg [4:0] counter =0;
             
       assign carry0=(digit0>4);
       assign carry1=(digit1>4);
       assign carry2=(digit2>4);

       always @(posedge sys_clk) begin
              if (counter==0) begin
                     digit0<=0;
                     digit1<=0;
                     digit2<=0;
                     digit3<=0;
                     busy <= 1'b1;
                     counter <= counter + 3'h1;
              end
             
              else if (counter<17) begin
                if (carry0)
                           digit0<={digit0-3'h5,HexIn[16-counter]};
                else
                           digit0<={digit0[2:0],HexIn[16-counter]};
             
                if (carry1)
                           digit1<={digit1-3'h5,carry0};
                else
                           digit1<={digit1[2:0],carry0};
      
                if (carry2)
                           digit2<={digit2-3'h5,carry1};
                else
                           digit2<={digit2[2:0],carry1};
      
                digit3<={digit3[2:0],carry2};
                counter <= counter + 3'h1;
              end
             
              else if (counter == 17 ) begin
                     if( HexIn < 10000 ) //check that the BCD input value is not exceeding 9999
                           BCD_out <= {digit3,digit2,digit1,digit0}; //if so force output always to 9999
                     else
                           BCD_out <= 16'h9999; //maximum value to be displayed Maybe should be 0xFFFF?
                     busy <= 1'b0;
                           counter <= 0;
              end
      
       end

endmodule
