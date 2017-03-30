//345678901234567890123456789012345678901234567890123456789012345678901234567890
//******************************************************************************
//*
//* Module          : sru_top
//* File            : sru_top.v
//* Description     : Top module of the DDL links
//* Author/Designer : Zhang.Fan (fanzhang.ccnu@gmail.com)
//*
//*  Revision history:
//*	  06-03-2013 : Add ALTRO command handshaking (acmd_ack)
//*	  02-25-04-2013 : Add ALTRO command handshaking (acmd_ack)
//*******************************************************************************
//`timescale 1ns / 1ps
module altro_top(
		input 			rdoclk,

		//altro bus
		inout [39:0] 	bd,
		output 			writen,
		output 			cstbn,
		input 			ackn,
		input 			trsfn,
		input 			dstbn,

		//altro command interface
		input  			acmd_exec,
		input  			acmd_rw,
		input  [19:0]	acmd_addr,
		input  [19:0] 	acmd_rx,
		output [19:0] 	acmd_tx,
		output			acmd_ack,

		//dtc edata interface
		input 			fifo_rdreq,
		output [31:0] 	fifo_q,
		output 			fifo_empty,	

		//readout command
		input 			altrordo_cmd, //
		input 			altroabort_cmd, //

		//configuration
		input [31:0] 	altrochmask,
		input [4:0] 	fee_addr,
	
		input		 	LGSEN,
		output [31:0] 	HGOverFlag,	
		
		output [15:0] 	ErrALTROCmd,
		output [15:0] 	ErrALTRORdo,
		input			ErrClr,			
			
		input 			reset
    );

	//internal wires
	wire ram_addrclr;
	wire con_busy;
	wire altro_chrdo_en;
	wire fifo_almost_full;
	
	wire FlagClear;
	wire fifo_wren;
	wire Dflag;
	wire [1:0] DHeader;
	wire [6:0] ChAddr;

	altro_if u_altro_if (
		.rdoclk(rdoclk),

		//altro bus
		.bd(bd), 
		.writen(writen), 
		.cstbn(cstbn), 
		.ackn(ackn), 
		.trsfn(trsfn), 

		//altro command interface
		.acmd_exec(acmd_exec), 
		.acmd_rw(acmd_rw), 
		.acmd_addr(acmd_addr), 
		.acmd_rx(acmd_rx), 
		.acmd_tx(acmd_tx),
		.acmd_ack(acmd_ack),
		
		//configuration
		.altrochmask(altrochmask), 		
		.fee_addr(fee_addr), 
		
		.altrordo_cmd(altrordo_cmd),
		.altroabort_cmd(altroabort_cmd),
		
		//internal wires
		.fifo_almost_full(fifo_almost_full),
		.altro_chrdo_en(altro_chrdo_en),
		.ram_addrclr(ram_addrclr), 
		.con_busy(con_busy),	
		.altrochmask_LG(HGOverFlag),		
		.ErrALTROCmd(ErrALTROCmd),
		.ErrALTRORdo(ErrALTRORdo),
		.ErrClr(ErrClr),
						
		.reset(reset)
	);


	fed_build u_fed_build (
		.rdoclk(rdoclk), 

		//altro bus
		.bd(bd), 
		.trsfn(trsfn), 
		.dstbn(dstbn),
		
		.FlagClear(FlagClear), 
		.fifo_wren(fifo_wren), 
		.Dflag(Dflag), 
		.DHeader(DHeader),   
		.ChAddr(ChAddr),		
		
		//dtc edata interface
		.fifo_rdreq(fifo_rdreq), 
		.fifo_q(fifo_q), 
		.fifo_empty(fifo_empty), 

		//internal wires
		.fifo_almost_full(fifo_almost_full),
		.altro_chrdo_en(altro_chrdo_en),		
		.ram_addrclr(ram_addrclr), 
		.con_busy(con_busy),		
		
		.reset(reset)
	);
	
	LGFlagModule ULGFlagModule (
		.rdoclk(rdoclk), 
		.FlagClear(FlagClear), 
		.fifo_wren(fifo_wren), 
		.Dflag(Dflag), 
		.DHeader(DHeader),   
		.ChAddr(ChAddr),       
		.LGSEN(LGSEN),
		.OverflowFlag(HGOverFlag), 
		.reset(reset)
		);
    
endmodule
