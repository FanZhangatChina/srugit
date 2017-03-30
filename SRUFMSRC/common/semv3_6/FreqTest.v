module FreqTest(
input wire iCLK,
input wire ClkTest,

output wire SigAlive
//output reg [25:0] ClkFreq = 20'h0 
 
);

wire clk_2s;
reg [23:0] ClkFreq_i = 24'h0;
reg [23:0] ClkFreq = 24'h0;

OneSecond u0(
.iCLK(iCLK),
.oClK(clk_2s)
);

assign SigAlive = ClkFreq[23] | ClkFreq[22] | ClkFreq[21] | ClkFreq[20] |
ClkFreq[19] | ClkFreq[18] | ClkFreq[17] | ClkFreq[16] | ClkFreq[15] |
ClkFreq[14] | ClkFreq[13] | ClkFreq[12] | ClkFreq[11] | ClkFreq[10] |
ClkFreq[9] | ClkFreq[8] | ClkFreq[7] | ClkFreq[6] | ClkFreq[5] |
ClkFreq[4] | ClkFreq[3]; //| ClkFreq[] | ClkFreq[] | ClkFreq[] 

parameter ST0 = 2'h0;
parameter ST1 = 2'h1;
parameter ST2 = 2'h2;

reg [1:0] state = ST0;
always @(posedge ClkTest)
case(state)
ST0 : begin
if(clk_2s)
state <= ST1;
else
state <= ST0;
ClkFreq_i <= 24'h0;
ClkFreq <= ClkFreq;
end

ST1 : begin
ClkFreq_i <= ClkFreq_i + 1'b1;
if(clk_2s)
state <= ST1;
else
state <= ST2;
ClkFreq <= ClkFreq;
end

ST2 : begin
ClkFreq_i <= ClkFreq_i;
ClkFreq <= ClkFreq_i;
state <= ST0;
end

default : begin
ClkFreq_i <= 24'h0;
ClkFreq <= 24'h0;
state <= ST0;
end
endcase

endmodule
