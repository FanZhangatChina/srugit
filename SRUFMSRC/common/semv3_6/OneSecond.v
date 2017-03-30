module OneSecond(
input iCLK,
output reg oClK = 1'b0
);

reg [23:0] clkcnt = 24'h0;

always @(posedge iCLK)
if(clkcnt == 24'd8000000)
begin
oClK <= ~oClK;
clkcnt <= 24'h0;
end
else
begin
oClK <= oClK;
clkcnt <= clkcnt + 1'h1;
end

endmodule
