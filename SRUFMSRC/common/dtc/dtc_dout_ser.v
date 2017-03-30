//2
module dtc_dout_ser
 (
  // From the device out to the system
  input  [7:0] dtc_pdin,
  output dtc_sdout,
  input              bitclk,        // Fast clock input from PLL/MMCM
  input              reset
  );

reg [2:0] bitcnt = 3'h0;
reg [7:0] pdata_reg = 8'h0;
wire load;

assign load = bitcnt[2]&bitcnt[1]&bitcnt[0];

always @(posedge bitclk)
if(reset)
bitcnt <= 3'd0;
else
bitcnt <= bitcnt + 3'd1;


always @(posedge bitclk)
if(load)
pdata_reg <= dtc_pdin;
else
pdata_reg <= {pdata_reg[6:0],1'b0};

assign dtc_sdout = pdata_reg[7];
endmodule
