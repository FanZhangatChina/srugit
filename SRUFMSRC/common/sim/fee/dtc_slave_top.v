`timescale 1ns / 1ps
`define DLY #1
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:49:46 08/11/2011 
// Design Name: 
// Module Name:    dtc_slave_top 
//////////////////////////////////////////////////////////////////////////////////
module dtc_slave_top
#(
parameter LGSEN_Init = 1'b1,
parameter FEEFMVer = 16'h5040
)
(
		//dtc phy
		input         	dtc_clk,                     // Differential -ve of clock from Master DTC to Slave DTC.
		input 		  	dtc_trig,                    // Differential -ve of trigger from Master DTC to Slave DTC.
		output		  	dtc_data,                    // Differential -ve of data from Slave DTC to Master DTC.
		output 		  	dtc_return,                  // Differential -ve of return from Slave DTC to Master DTC.    
	 
		output  			trig_l0n,//low active 
		output  			trig_l1n,

		input 			fee_flag,
	
		input 			rdoclk,
		input       	reset                 // Asynchronous reset for entire core.
	);


		wire 			fifo_rdreq;
		wire [31:0] 	fifo_q;
		wire 			fifo_empty;	
	
	//wire		altrordo_cmd;
	//wire		altroabort_cmd;
	wire		sampclksync_cmd;
	//wire 		[63:0] altrochmask;
	wire 		[4:0] fee_addr;

	wire dtc_fpga_cmd_exec;
	wire dtc_fpga_cmd_rnw;
	wire [7:0] dtc_fpga_cmd_addr;
	wire [15:0] dtc_fpga_cmd_wdata;
	wire [15:0] dtc_fpga_cmd_rdata;
	
	wire acmd_exec;
	wire acmd_rw;
	wire [19:0] acmd_addr;
	wire [19:0] acmd_rx;
	wire [19:0] acmd_tx;
	wire acmd_ack;
	wire fpga_cmd_ack;
	
	wire cstbn;
	wire writen;
	wire ackn;
	wire trsfn;
	wire dstbn;
	wire [39:0] bd;

	
wire [31:0] altrochmask;

wire altrordo_cmd;
wire altroabort_cmd;

wire dcsresetcnt;
wire DtcCmdRst;
wire cmd_exec;
wire ErrClr;	
wire LGSEN;
wire [31:0] HGOverFlag;

wire [15:0] GErrSt, ErrALTROCmd, ErrALTRORdo, ErrFpgaCmd;	
	
	parameter st0 = 1'b0;
parameter st1 = 1'b1;
reg st = st0;
reg [3:0] delay_cnt = 4'd0;
wire reset_i,dcsresetall;
assign reset_i = dcsresetall;
reg reset_ii = 1'b0;

always @(posedge rdoclk)
if(reset_i)
begin
reset_ii <= `DLY  1'b1;
delay_cnt <= `DLY  4'd0;
st <= `DLY  st0;
end
else case(st)
st0: begin
reset_ii <= `DLY  1'b1;
delay_cnt <= `DLY  delay_cnt + 4'd1;
if(delay_cnt == 4'd12)
st <= `DLY  st1;
else
st <= `DLY  st0;
end

st1: begin
delay_cnt <= `DLY  4'd0;
reset_ii <= `DLY  1'b0;
st <= `DLY  st1;
end

default: begin
delay_cnt <= `DLY  4'd0;
reset_ii <= `DLY  1'b0;
st <= `DLY  st1;
end
endcase
	
	dtc_top dtc_top_uut (
		
		// dtc phy 
		.dtc_clk(dtc_clk),  
		.dtc_trig(dtc_trig),
		.dtc_data(dtc_data), 
		.dtc_return(dtc_return),

		//memory interface
		.dtc_fpga_cmd_exec(dtc_fpga_cmd_exec), 
		.dtc_fpga_cmd_rnw(dtc_fpga_cmd_rnw),		
		.dtc_fpga_cmd_addr(dtc_fpga_cmd_addr),		
		.dtc_fpga_cmd_wdata(dtc_fpga_cmd_wdata),
		.dtc_fpga_cmd_rdata(dtc_fpga_cmd_rdata),
		.fpga_cmd_ack(fpga_cmd_ack),
		
		.acmd_exec(acmd_exec), 
		.acmd_rw(acmd_rw), 
		.acmd_addr(acmd_addr), 
		.acmd_rx(acmd_rx), 
		.acmd_tx(acmd_tx),
		.acmd_ack(acmd_ack), 				
		
		//dtc trig
		.trig_l0n(trig_l0n),
		.trig_l1n(trig_l1n),
		.altrordo_cmd(altrordo_cmd),
		.altroabort_cmd(altroabort_cmd),
		.sampclksync_cmd(sampclksync_cmd),
		.DtcCmdRst(DtcCmdRst),
				
		.fifo_rdreq(fifo_rdreq), 
		.fifo_q(fifo_q), 
		.fifo_empty(fifo_empty),	

		.fee_flag(fee_flag),
		.event_rdo_cnt(event_rdo_cnt),
		.CntRst(CntRst),
				 		
		.rdoclk(rdoclk),		
		.reset(reset|reset_ii)
	);
	
	
memory_interface 
#(.LGSEN_Init(LGSEN_Init),
.FEEFMVer(FEEFMVer)
)
U9(
.reset(reset|reset_ii),
.clk_40m(rdoclk),

.cmd_exec(dtc_fpga_cmd_exec),
.cmd_rw(dtc_fpga_cmd_rnw),
.cmd_addr(dtc_fpga_cmd_addr),
.cmd_rx(dtc_fpga_cmd_wdata),
.cmd_tx(dtc_fpga_cmd_rdata),
.cmd_ack(fpga_cmd_ack),

.fee_addr(fee_addr),//5 bits
.reg_st({allps_error,altrops_error,biasps_error,shaperps_error}),//4 bits
.reg_en(reg_en),//3 bits

.Thyst_H(Thyst_H), 
.Toti_H(Toti_H), 

.temp_toi({oti_3,oti_2,oti_1}),//3 bits
.altrochmask(altrochmask),//32 bits
//.dcsresetaltro(dcsresetaltro),
//.dcsresetall(dcsresetall),
.dcsresetcnt(dcsresetcnt),
.Hv_update_cmd(Hv_update_cmd),

//For TVI monitoring
.adc_read_finish(adc_read_finish),
.adc_result(adc_result),
.adc_cnt(adc_cnt),

//For HV Update
.ram_data_out0(ram_data_out0),
.ram_data_out1(ram_data_out1),
.ram_data_out2(ram_data_out2),
.ram_data_out3(ram_data_out3),
.dac_cnt(dac_cnt),

.event_rdo_cnt(event_rdo_cnt),
.L0cnt(L0cnt),
.L1cnt(L1cnt),
.L2ACNT(L2ACNT),
.L2RCNT(L2RCNT),
.CmdCnt(CmdCnt),
//.HGTh(HGTh),
.LGSEN(LGSEN),
.HGOverFlag(HGOverFlag),
.GErrSt(GErrSt),
.ErrALTROCmd(ErrALTROCmd),
.ErrALTRORdo(ErrALTRORdo),
.ErrFpgaCmd(ErrFpgaCmd),
.ErrClr(ErrClr),

//For Card_SN module
.Card_SN_W_cmd(Card_SN_W_cmd),
.Card_SN_W(Card_SN_W),
.Card_SN_R(Card_SN_R)
);

	altro_top u_altro_top (
		.rdoclk(rdoclk), 
		.bd(bd), 
		.cstbn(cstbn), 
		.writen(writen), 
		.ackn(ackn), 
		.trsfn(trsfn), 
		.dstbn(dstbn), 
		
		.acmd_exec(acmd_exec), 
		.acmd_rw(acmd_rw), 
		.acmd_addr(acmd_addr), 
		.acmd_rx(acmd_rx), 
		.acmd_tx(acmd_tx), 
		.acmd_ack(acmd_ack),
		
		.fifo_rdreq(fifo_rdreq), 
		.fifo_q(fifo_q), 
		.fifo_empty(fifo_empty), 
		
		.altrordo_cmd(altrordo_cmd), 
		.altroabort_cmd(altroabort_cmd), 
		
		.altrochmask(altrochmask), 
		.fee_addr(fee_addr),

		.LGSEN(1'b1),
		.HGOverFlag(HGOverFlag),
		
		.ErrALTROCmd(ErrALTROCmd),
		.ErrALTRORdo(ErrALTRORdo),							
		.ErrClr(1'b0), 		
		 
		.reset(reset|reset_ii)
	);
	
	altro_emulator u_altro_emulator (
		.rdoclk(rdoclk),
		
		.cstbn(cstbn), 
		.writen(writen), 
		
		.ackn(ackn), 
		.trsfn(trsfn), 
		.dstbn(dstbn), 
		
		.bd(bd), 
		
		.reset(reset|reset_ii)
	);



endmodule
