///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.7
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chipscope_vio.v
// /___/   /\     Timestamp  : Tue Sep 13 22:07:24 ÷–≈∑œƒ¡Ó ± 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module chipscope_vio(
    CONTROL,
    ASYNC_IN) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input [7 : 0] ASYNC_IN;

endmodule
