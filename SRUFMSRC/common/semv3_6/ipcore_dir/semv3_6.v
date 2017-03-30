////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: semv3_6.v
// /___/   /\     Timestamp: Wed Sep 14 00:15:04 2016
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -w -sim -ofmt verilog C:/Xilinx/SRUFM/SRUFMSRC/common/semv3_6/ipcore_dir/tmp/_cg/semv3_6.ngc C:/Xilinx/SRUFM/SRUFMSRC/common/semv3_6/ipcore_dir/tmp/_cg/semv3_6.v 
// Device	: 6vlx130tff1156-1
// Input file	: C:/Xilinx/SRUFM/SRUFMSRC/common/semv3_6/ipcore_dir/tmp/_cg/semv3_6.ngc
// Output file	: C:/Xilinx/SRUFM/SRUFMSRC/common/semv3_6/ipcore_dir/tmp/_cg/semv3_6.v
// # of Modules	: 1
// Design Name	: semv3_6
// Xilinx        : C:\Xilinx\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module semv3_6 (
  monitor_txfull, monitor_rxempty, icap_busy, icap_clk, icap_grant, fecc_crcerr, fecc_eccerr, fecc_eccerrsingle, fecc_syndromevalid, status_heartbeat
, status_initialization, status_observation, status_correction, status_classification, status_injection, status_essential, status_uncorrectable, 
monitor_txwrite, monitor_rxread, icap_csb, icap_rdwrb, icap_request, monitor_rxdata, icap_o, fecc_syndrome, fecc_far, fecc_synbit, fecc_synword, 
monitor_txdata, icap_i
)/* synthesis syn_black_box syn_noprune=1 */;
  input monitor_txfull;
  input monitor_rxempty;
  input icap_busy;
  input icap_clk;
  input icap_grant;
  input fecc_crcerr;
  input fecc_eccerr;
  input fecc_eccerrsingle;
  input fecc_syndromevalid;
  output status_heartbeat;
  output status_initialization;
  output status_observation;
  output status_correction;
  output status_classification;
  output status_injection;
  output status_essential;
  output status_uncorrectable;
  output monitor_txwrite;
  output monitor_rxread;
  output icap_csb;
  output icap_rdwrb;
  output icap_request;
  input [7 : 0] monitor_rxdata;
  input [31 : 0] icap_o;
  input [12 : 0] fecc_syndrome;
  input [23 : 0] fecc_far;
  input [4 : 0] fecc_synbit;
  input [6 : 0] fecc_synword;
  output [7 : 0] monitor_txdata;
  output [31 : 0] icap_i;
  
  // synthesis translate_off
  
  wire NlwRenamedSignal_status_heartbeat;
  wire \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg ;
  wire N0;
  wire N1;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<5>_178 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<4>_179 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<4>_180 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<3>_181 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<3>_182 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<2>_183 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<2>_184 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<1>_185 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<1>_186 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<0>_187 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<0>_188 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<7>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<6>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<5>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<4>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<3>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<2>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<1>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Result<0>1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/b_ena ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_a ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_b ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_c ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/word_count[6]_PWR_7_o_equal_16_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count[16]_frame_locate[16]_equal_32_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_6_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_24_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_26_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_25_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_275 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_276 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_277 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_sbe_296 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_0_314 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_1_315 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_2_316 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_3_317 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_4_318 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_5_319 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_6_320 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_7_321 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_8_322 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_9_323 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_10_324 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_11_325 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_12_326 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_13_327 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_14_328 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_15_329 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_330 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_flm_386 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/read_strobe ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A101_475 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<9>_477 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<8>_478 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<7>_479 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<6>_480 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<5>_481 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<4>_482 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<3>_483 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<2>_484 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<2>_485 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<1>_486 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<0>_487 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<0>_488 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/sync_init_INV_10_o ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0258_inv ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<0> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<1> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<2> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<3> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<4> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<5> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<6> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<7> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<8> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<9> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<10> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc1 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<0> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<1> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<2> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<3> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<4> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<5> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<6> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<7> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<8> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<9> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<10> ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc4 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[0] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[1] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[2] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[3] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[4] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[5] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[6] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[7] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[9] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[10] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[11] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[12] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[13] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[14] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[15] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[16] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[18] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[19] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[20] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[21] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[22] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[23] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[24] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[25] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[27] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[28] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[29] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[30] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[31] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[32] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[33] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[34] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/go ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_8_583 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_9_584 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_10_585 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[26] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[35] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[17] ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_fast_route ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_fast_route ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_out ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_in ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_parity ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_parity ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_pulse ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_t_state ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry_value ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_shift_in ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/condition_met ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/invert_arith_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry_in ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_shift_in ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable_value ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/io_initial_decode ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_zero ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/read_active ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/write_active ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_fetch_type ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_type ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_type ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_parity ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_type ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/push_or_pop_type ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/move_group ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_update_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_write ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_write ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_flag ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_write ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_zero ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_carry ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/interrupt_ack_internal ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/clean_int ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ;
  wire N2;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>1_871 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>2_872 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>3_873 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>4_874 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>5_875 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>6_876 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>9_877 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>1_878 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>4_879 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>5_880 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>6_881 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>7_882 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>8_883 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>9_884 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>10_885 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>11_886 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>12_887 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>13_888 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>1_889 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>2_890 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>5_891 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>6_892 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>7_893 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>8_894 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>9_895 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>10_896 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>11_897 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>12_898 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>1_899 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>2_900 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>3_901 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>4_902 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>5_903 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>6_904 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>7_905 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>8_906 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>9_907 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>10_908 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>11_909 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>1_910 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>2_911 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>3_912 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>4_913 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>5_914 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>6_915 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>7_916 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>8_917 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>10_918 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>11_919 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>1_920 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>2_921 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>5_922 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>6_923 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>7_924 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>8_925 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>9_926 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>10_927 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>11_928 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>1_929 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>2_930 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>3_931 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>4_932 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>5_933 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>6_934 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>7_935 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>8_936 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>10_937 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>11_938 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port46 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port461_940 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port462_941 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port463_942 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port464_943 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port465_944 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port466_945 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port467_946 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port468_947 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port469_948 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port4610_949 ;
  wire N4;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt9 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt91_952 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt92_953 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_glue_set_954 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_glue_set_955 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_glue_set_956 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_glue_set_957 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_9_glue_set_958 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_8_glue_set_959 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_7_glue_set_960 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_6_glue_set_961 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_5_glue_set_962 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_4_glue_set_963 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_3_glue_set_964 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_2_glue_set_965 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_1_glue_set_966 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_0_glue_set_967 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<6>_rt_968 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<5>_rt_969 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<4>_rt_970 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<3>_rt_971 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<2>_rt_972 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<1>_rt_973 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<15>_rt_974 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<14>_rt_975 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<13>_rt_976 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<12>_rt_977 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<11>_rt_978 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<10>_rt_979 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<9>_rt_980 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<8>_rt_981 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<7>_rt_982 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<6>_rt_983 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<5>_rt_984 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<4>_rt_985 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<3>_rt_986 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<2>_rt_987 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<1>_rt_988 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<7>_rt_989 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<16>_rt_990 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg_rstpot_991 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_rstpot_992 ;
  wire \U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_rstpot_993 ;
  wire N6;
  wire N8;
  wire N9;
  wire N10;
  wire N11;
  wire N12;
  wire N13;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<15>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<14>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<13>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<12>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<11>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<10>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<9>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<8>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<7>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<6>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<5>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<4>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<3>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<2>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<1>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<0>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOPADOP<1>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOPADOP<0>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<15>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<14>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<13>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<12>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<11>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<10>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<9>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<8>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<7>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<6>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<5>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<4>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<3>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<2>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<1>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<0>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOPADOP<1>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOPADOP<0>_UNCONNECTED ;
  wire \NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/storage_DOPADOP<0>_UNCONNECTED ;
  wire [7 : 0] NlwRenamedSig_OI_monitor_txdata;
  wire [31 : 0] NlwRenamedSig_OI_icap_i;
  wire [6 : 0] \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg ;
  wire [6 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy ;
  wire [0 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_lut ;
  wire [15 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy ;
  wire [0 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_lut ;
  wire [16 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/Result ;
  wire [17 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 ;
  wire [17 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/in_port ;
  wire [16 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count ;
  wire [16 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/word_count ;
  wire [23 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap ;
  wire [16 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total ;
  wire [5 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg ;
  wire [17 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/instruction ;
  wire [5 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/port_id ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/address ;
  wire [6 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd ;
  wire [4 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt ;
  wire [23 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly ;
  wire [12 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn ;
  wire [8 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr ;
  wire [8 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra ;
  wire [3 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value ;
  wire [8 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry ;
  wire [4 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector ;
  wire [8 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry ;
  wire [3 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry ;
  wire [3 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value ;
  wire [4 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group ;
  wire [7 : 6] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector ;
  wire [4 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data ;
  wire [9 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data ;
  wire [7 : 0] \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy ;
  assign
    NlwRenamedSignal_status_heartbeat = fecc_syndromevalid,
    monitor_txdata[7] = NlwRenamedSig_OI_monitor_txdata[7],
    monitor_txdata[6] = NlwRenamedSig_OI_monitor_txdata[6],
    monitor_txdata[5] = NlwRenamedSig_OI_monitor_txdata[5],
    monitor_txdata[4] = NlwRenamedSig_OI_monitor_txdata[4],
    monitor_txdata[3] = NlwRenamedSig_OI_monitor_txdata[3],
    monitor_txdata[2] = NlwRenamedSig_OI_monitor_txdata[2],
    monitor_txdata[1] = NlwRenamedSig_OI_monitor_txdata[1],
    monitor_txdata[0] = NlwRenamedSig_OI_monitor_txdata[0],
    icap_i[31] = NlwRenamedSig_OI_icap_i[31],
    icap_i[30] = NlwRenamedSig_OI_icap_i[30],
    icap_i[29] = NlwRenamedSig_OI_icap_i[29],
    icap_i[28] = NlwRenamedSig_OI_icap_i[28],
    icap_i[27] = NlwRenamedSig_OI_icap_i[27],
    icap_i[26] = NlwRenamedSig_OI_icap_i[26],
    icap_i[25] = NlwRenamedSig_OI_icap_i[25],
    icap_i[24] = NlwRenamedSig_OI_icap_i[24],
    icap_i[23] = NlwRenamedSig_OI_icap_i[23],
    icap_i[22] = NlwRenamedSig_OI_icap_i[22],
    icap_i[21] = NlwRenamedSig_OI_icap_i[21],
    icap_i[20] = NlwRenamedSig_OI_icap_i[20],
    icap_i[19] = NlwRenamedSig_OI_icap_i[19],
    icap_i[18] = NlwRenamedSig_OI_icap_i[18],
    icap_i[17] = NlwRenamedSig_OI_icap_i[17],
    icap_i[16] = NlwRenamedSig_OI_icap_i[16],
    icap_i[15] = NlwRenamedSig_OI_icap_i[15],
    icap_i[14] = NlwRenamedSig_OI_icap_i[14],
    icap_i[13] = NlwRenamedSig_OI_icap_i[13],
    icap_i[12] = NlwRenamedSig_OI_icap_i[12],
    icap_i[11] = NlwRenamedSig_OI_icap_i[11],
    icap_i[10] = NlwRenamedSig_OI_icap_i[10],
    icap_i[9] = NlwRenamedSig_OI_icap_i[9],
    icap_i[8] = NlwRenamedSig_OI_icap_i[8],
    icap_i[7] = NlwRenamedSig_OI_icap_i[7],
    icap_i[6] = NlwRenamedSig_OI_icap_i[6],
    icap_i[5] = NlwRenamedSig_OI_icap_i[5],
    icap_i[4] = NlwRenamedSig_OI_icap_i[4],
    icap_i[3] = NlwRenamedSig_OI_icap_i[3],
    icap_i[2] = NlwRenamedSig_OI_icap_i[2],
    icap_i[1] = NlwRenamedSig_OI_icap_i[1],
    icap_i[0] = NlwRenamedSig_OI_icap_i[0],
    status_heartbeat = NlwRenamedSignal_status_heartbeat,
    status_initialization = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [0],
    status_observation = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [1],
    status_correction = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [2],
    status_classification = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [3],
    status_injection = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4],
    status_essential = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [6],
    status_uncorrectable = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [5],
    icap_request = \NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg ;
  VCC   XST_VCC (
    .P(N0)
  );
  GND   XST_GND (
    .G(N1)
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<7>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [6]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<7>_rt_989 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<7>1 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<6>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [5]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<6>_rt_968 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<6>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<6>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [5]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<6>_rt_968 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [6])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [4]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<5>_rt_969 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<5>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [4]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<5>_rt_969 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [5])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [3]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<4>_rt_970 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<4>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [3]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<4>_rt_970 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [4])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [2]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<3>_rt_971 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<3>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [2]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<3>_rt_971 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [3])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [1]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<2>_rt_972 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<2>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [1]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<2>_rt_972 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [2])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [0]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<1>_rt_973 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<1>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [0]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<1>_rt_973 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [1])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<0>  (
    .CI(N1),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_lut [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<0>1 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<0>  (
    .CI(N1),
    .DI(N0),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_lut [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy [0])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<16>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [15]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<16>_rt_990 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [16])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<15>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [14]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<15>_rt_974 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [15])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<15>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [14]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<15>_rt_974 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [15])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<14>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [13]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<14>_rt_975 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [14])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<14>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [13]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<14>_rt_975 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [14])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<13>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [12]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<13>_rt_976 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [13])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<13>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [12]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<13>_rt_976 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [13])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<12>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [11]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<12>_rt_977 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [12])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<12>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [11]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<12>_rt_977 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [12])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<11>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [10]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<11>_rt_978 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [11])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<11>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [10]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<11>_rt_978 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [11])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<10>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [9]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<10>_rt_979 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [10])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<10>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [9]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<10>_rt_979 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [10])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<9>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [8]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<9>_rt_980 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [9])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<9>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [8]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<9>_rt_980 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [9])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<8>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [7]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<8>_rt_981 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [8])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<8>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [7]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<8>_rt_981 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [8])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<7>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [6]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<7>_rt_982 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [7])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<7>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [6]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<7>_rt_982 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [7])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<6>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [5]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<6>_rt_983 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [6])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<6>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [5]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<6>_rt_983 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [6])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [4]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<5>_rt_984 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [5])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [4]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<5>_rt_984 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [5])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [3]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<4>_rt_985 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [4])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [3]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<4>_rt_985 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [4])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [2]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<3>_rt_986 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [3])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [2]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<3>_rt_986 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [3])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [1]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<2>_rt_987 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [2])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [1]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<2>_rt_987 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [2])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [0]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<1>_rt_988 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [1])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [0]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<1>_rt_988 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [1])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<0>  (
    .CI(N1),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_lut [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<0>  (
    .CI(N1),
    .DI(N0),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_lut [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<4>_179 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<5>_178 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count[16]_frame_locate[16]_equal_32_o )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<5>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_15_329 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_330 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<5>_178 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<3>_181 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<4>_180 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<4>_179 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<4>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_12_326 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_13_327 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [14]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_14_328 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<4>_180 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<2>_183 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<3>_182 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<3>_181 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<3>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [9]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_9_323 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [10]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_10_324 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [11]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_11_325 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<3>_182 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<1>_185 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<2>_184 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<2>_183 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<2>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [6]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_6_320 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [7]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_7_321 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [8]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_8_322 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<2>_184 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<0>_187 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<1>_186 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<1>_185 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<1>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_3_317 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_4_318 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [5]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_5_319 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<1>_186 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<0>  (
    .CI(N0),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<0>_188 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_cy<0>_187 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<0>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_0_314 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_1_315 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [2]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_2_316 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcompar_frame_count[16]_frame_locate[16]_equal_32_o_lut<0>_188 )
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_16  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [16]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [16])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_15  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [15]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [15])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_14  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [14]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [14])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_13  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [13]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [13])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_12  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [12]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [12])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_11  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [11]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [11])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_10  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [10]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [10])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_9  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [9]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [9])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_8  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [8]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [8])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_7  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [7]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [7])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_6  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [6]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [6])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_5  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [5]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [5])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_4  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [4]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [4])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_3  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [3]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [3])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_2  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [2]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [2])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_1  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [1]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [1])
  );
  FDSE #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_count_0  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result [0]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_7  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<7>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [7])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<6>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [6])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<5>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [5])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<4>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<3>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<2>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<1>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/Result<0>1 ),
    .R(NlwRenamedSignal_status_heartbeat),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_flm  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count[16]_frame_locate[16]_equal_32_o ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_flm_386 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_sbe  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_eccerrsingle),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_sbe_296 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_16  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [16]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [16])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_15  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [15]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [15])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_14  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [14]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [14])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_13  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [13]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [13])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_12  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [12]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [12])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_11  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [11]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [11])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_10  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [10]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [10])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_9  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [9]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [9])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_8  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [8]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [8])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_7  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [7])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [6])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [5])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_0_314 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_1_315 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_3_317 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_4_318 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_2_316 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_5_319 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_6_320 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_7  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_7_321 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_8  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_8_322 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_9  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_9_323 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_10  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_10_324 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_12  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_12_326 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_13  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_13_327 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_11  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_11_325 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_14  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_14_328 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_15  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_15_329 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [6])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [5])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/status_reg_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o ),
    .D(NlwRenamedSig_OI_monitor_txdata[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [0])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_16  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [16]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [16])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_15  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [15]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [15])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_14  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [14]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [14])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_13  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [13]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [13])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_12  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [12]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [12])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_11  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [11]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [11])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_10  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [10]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [10])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_9  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [9]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [9])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_8  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [8]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [8])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_7  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [7]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [7])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [6]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [6])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [5]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [5])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [4]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [4])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [3]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [3])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [2]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [2])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [1]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [1])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_total_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [0]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [6])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [5])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synword[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synbit[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synbit[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synbit[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synbit[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_synbit[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_12  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[12]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [12])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_11  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[11]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [11])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_10  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[10]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [10])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_9  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[9]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [9])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_8  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[8]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [8])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_7  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [7])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [6])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [5])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event ),
    .D(fecc_syndrome[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [0])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_23  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [23]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [23])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_22  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [22]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [22])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_21  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [21]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [21])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_20  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [20]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [20])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_19  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [19]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [19])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_18  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [18]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [18])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_17  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [17]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [17])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_16  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [16]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [16])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_15  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [15]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [15])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_14  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [14]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [14])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_13  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [13]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [13])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_12  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [12]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [12])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_11  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [11]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [11])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_10  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [10]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [10])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_9  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [9]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [9])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_8  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [8]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [8])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_7  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [7]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [7])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_6  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [6]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [6])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_5  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [5]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [5])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_4  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [4]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [4])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_3  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [3]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [3])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_2  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [2]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [2])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_1  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [1]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [1])
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap_0  (
    .C(icap_clk),
    .CE(NlwRenamedSignal_status_heartbeat),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [0]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/long_gap  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count[6]_PWR_7_o_equal_16_o ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_23  (
    .C(icap_clk),
    .D(fecc_far[23]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [23])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_22  (
    .C(icap_clk),
    .D(fecc_far[22]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [22])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_21  (
    .C(icap_clk),
    .D(fecc_far[21]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [21])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_20  (
    .C(icap_clk),
    .D(fecc_far[20]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [20])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_19  (
    .C(icap_clk),
    .D(fecc_far[19]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [19])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_18  (
    .C(icap_clk),
    .D(fecc_far[18]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [18])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_17  (
    .C(icap_clk),
    .D(fecc_far[17]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [17])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_16  (
    .C(icap_clk),
    .D(fecc_far[16]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [16])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_15  (
    .C(icap_clk),
    .D(fecc_far[15]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [15])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_14  (
    .C(icap_clk),
    .D(fecc_far[14]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [14])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_13  (
    .C(icap_clk),
    .D(fecc_far[13]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [13])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_12  (
    .C(icap_clk),
    .D(fecc_far[12]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [12])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_11  (
    .C(icap_clk),
    .D(fecc_far[11]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [11])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_10  (
    .C(icap_clk),
    .D(fecc_far[10]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [10])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_9  (
    .C(icap_clk),
    .D(fecc_far[9]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [9])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_8  (
    .C(icap_clk),
    .D(fecc_far[8]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [8])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_7  (
    .C(icap_clk),
    .D(fecc_far[7]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_6  (
    .C(icap_clk),
    .D(fecc_far[6]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_5  (
    .C(icap_clk),
    .D(fecc_far[5]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_4  (
    .C(icap_clk),
    .D(fecc_far[4]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_3  (
    .C(icap_clk),
    .D(fecc_far[3]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_2  (
    .C(icap_clk),
    .D(fecc_far[2]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_1  (
    .C(icap_clk),
    .D(fecc_far[1]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly_0  (
    .C(icap_clk),
    .D(fecc_far[0]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [0])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<10>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<9>_477 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<10> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<10> )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<9>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<8>_478 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<9> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<9> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<9>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<8>_478 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<9> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<9>_477 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<8>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<7>_479 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<8> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<8> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<8>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<7>_479 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<8> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<8>_478 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<7>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<6>_480 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<7> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<7> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<7>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<6>_480 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<7> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<7>_479 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<6>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<5>_481 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<6> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<6> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<6>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<5>_481 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<6> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<6>_480 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<4>_482 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<5> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<5> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<5>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<4>_482 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<5> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<5>_481 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<3>_483 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<4> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<4> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<4>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<3>_483 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<4> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<4>_482 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<2>_484 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<3> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<3> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<3>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<2>_484 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<3> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<3>_483 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<1>_486 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<2>_485 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<2> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<2>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<1>_486 ),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<2> ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<2>_485 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<2>_484 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<0>_487 ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<1> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<1> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<1>  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<0>_487 ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<1> ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<1>_486 )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_xor<0>  (
    .CI(N1),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<0>_488 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<0> )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<0>  (
    .CI(N1),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<0> ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<0>_488 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_cy<0>_487 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<10> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<9> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_8  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<8> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [8])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<7> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<6> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<5> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<4> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<3> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<2> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_7  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [7])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_6  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [6])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_5  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [5])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<1> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr[10]_sta_ptr[10]_mux_11_OUT<0> ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_8  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0258_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_8_583 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_9  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0258_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_9_584 )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_10  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0258_inv ),
    .D(NlwRenamedSig_OI_monitor_txdata[6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_10_585 )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero_cymux  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero_carry ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero_carry )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero_muxcy  (
    .CI(N0),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero_carry )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_xor  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [3]),
    .LI(N1),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_fast_route )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [6]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_zero )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity_xor  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity_carry ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_parity ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity_muxcy  (
    .CI(N0),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_parity ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity_carry )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_high  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [8]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [9])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_8  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [7]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [8])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_8  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [7]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [8])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_7  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [6]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [7])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_7  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [6]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [7])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_6  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [5]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [6])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_6  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [5]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [6])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_5  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [4]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [5])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_5  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [4]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [5])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [3]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [4])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [3]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [4])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [2]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [3])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [2]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [3])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [1]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [2])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [1]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [2])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [0]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [1])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [0]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [1])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_xor  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_carry ),
    .LI(N1),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_fast_route )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_xor_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [3]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [4])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_xor_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [2]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [3])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_xor_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [1]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [2])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_xor_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [0]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [1])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_xor_0  (
    .CI(N1),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [0])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_xor_0  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_muxcy_0  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value_carry [0])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_7  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [6]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [7])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_out_xor  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [7]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/invert_arith_carry ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_out )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_6  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [5]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [6])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_5  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [4]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [5])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [3]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [4])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [2]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [3])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [1]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [2])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [0]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [1])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_xor_0  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_in ),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_in_muxcy  (
    .CI(N0),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry_in ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_in )
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_high  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [8]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [9])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_8  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [7]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [8])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_8  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [7]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [8])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_7  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [6]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [7])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_7  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [6]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [7])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_6  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [5]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [6])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_6  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [5]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [6])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_5  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [4]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [5])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_5  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [4]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [5])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [3]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [4])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [3]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [4])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [2]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [3])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [2]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [3])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [1]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [2])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [1]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [2])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [0]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [1])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [0]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [1])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_parity_muxcy  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [2]),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_parity ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [3])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_muxcy_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [2]),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [3])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_muxcy_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [1]),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [2])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_muxcy_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [0]),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [1])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_muxcy_0  (
    .CI(N1),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address_carry [0])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [7]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [7]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [7])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [6]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [6]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [6])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [5]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [5])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [4]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [4])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [3]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [3])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [2]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [2])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [1]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [1])
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [0]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_muxcy  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [1]),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [2])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift_muxcy  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [0]),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift_carry ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [1])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [7]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [7])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [6]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [6])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [5])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [4])
  );
  LUT4 #(
    .INIT ( 16'h6996 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_parity_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [6]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_parity )
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [3])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [2])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [1])
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/or_lut_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_group [0])
  );
  LUT4 #(
    .INIT ( 16'h6996 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_parity_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_parity )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_7  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [6]),
    .DI(NlwRenamedSig_OI_monitor_txdata[7]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [7])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_6  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [5]),
    .DI(NlwRenamedSig_OI_monitor_txdata[6]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [6])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_5  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [4]),
    .DI(NlwRenamedSig_OI_monitor_txdata[5]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [5])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_4  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [3]),
    .DI(NlwRenamedSig_OI_monitor_txdata[4]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [4])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_3  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [2]),
    .DI(NlwRenamedSig_OI_monitor_txdata[3]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [3])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_2  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [1]),
    .DI(NlwRenamedSig_OI_monitor_txdata[2]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [2])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_1  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [0]),
    .DI(NlwRenamedSig_OI_monitor_txdata[1]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [1])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_muxcy_0  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_in ),
    .DI(NlwRenamedSig_OI_monitor_txdata[0]),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_internal_carry [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_9  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [9]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [9])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [8]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [8])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/value_select_mux_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/address [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_value [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_cymux  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_zero_carry ),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_zero ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_zero ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_carry )
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_muxcy  (
    .CI(N1),
    .DI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_carry ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_carry ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_carry [0])
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_count_inv  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt )
  );
  LUT4 #(
    .INIT ( 16'hA999 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_lut_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [4])
  );
  LUT4 #(
    .INIT ( 16'hA999 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_lut_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [3])
  );
  LUT4 #(
    .INIT ( 16'hA999 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_lut_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [2])
  );
  LUT4 #(
    .INIT ( 16'hA999 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_lut_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [1])
  );
  LUT4 #(
    .INIT ( 16'h6555 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/count_lut_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/push_or_pop_type ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_stack_address [0])
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_inv  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_write ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable )
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/invert_enable  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_enable_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_write ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_enable )
  );
  LUT4 #(
    .INIT ( 16'h0080 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_pulse_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/clean_int ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_pulse )
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state_lut  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_t_state )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(NlwRenamedSig_OI_monitor_txdata[7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(NlwRenamedSig_OI_monitor_txdata[6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(NlwRenamedSig_OI_monitor_txdata[5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(NlwRenamedSig_OI_monitor_txdata[4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(NlwRenamedSig_OI_monitor_txdata[3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(NlwRenamedSig_OI_monitor_txdata[2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_mux_lut_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in ),
    .I2(NlwRenamedSig_OI_monitor_txdata[1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(NlwRenamedSig_OI_monitor_txdata[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry_value )
  );
  MUXF5   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in_muxf5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_shift_in ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_shift_in ),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_in )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_shift_in_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag ),
    .I2(NlwRenamedSig_OI_monitor_txdata[7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/low_shift_in )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/mux_lut_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_group [0])
  );
  XORCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_xor_0  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .LI(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_vector [0])
  );
  MUXCY   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_muxcy_0  (
    .CI(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .DI(N1),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector_carry [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1])
  );
  LUT2 #(
    .INIT ( 4'hD ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_move_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/condition_met ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/valid_to_move )
  );
  LUT3 #(
    .INIT ( 8'h2F ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/condition_met ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/move_group ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/normal_count )
  );
  LUT4 #(
    .INIT ( 16'h5A3C ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/condition_met_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_flag ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/condition_met )
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_7  (
    .I0(NlwRenamedSig_OI_monitor_txdata[7]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [7])
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_out_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/invert_arith_carry )
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_6  (
    .I0(NlwRenamedSig_OI_monitor_txdata[6]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [6])
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_5  (
    .I0(NlwRenamedSig_OI_monitor_txdata[5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [5])
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_4  (
    .I0(NlwRenamedSig_OI_monitor_txdata[4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [4])
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_3  (
    .I0(NlwRenamedSig_OI_monitor_txdata[3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [3])
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_2  (
    .I0(NlwRenamedSig_OI_monitor_txdata[2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [2])
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_1  (
    .I0(NlwRenamedSig_OI_monitor_txdata[1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [1])
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_lut_0  (
    .I0(NlwRenamedSig_OI_monitor_txdata[0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/half_arith [0])
  );
  LUT3 #(
    .INIT ( 8'h6C ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_in_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry_in )
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand [7]),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [7])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/second_operand [6]),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [6])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [5])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [4])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [3])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [2])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [1])
  );
  LUT4 #(
    .INIT ( 16'h6E8A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_lut_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [0])
  );
  LUT4 #(
    .INIT ( 16'h8000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_write ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_shift_in_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [1]),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/high_shift_in )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/operand_select_mux_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0])
  );
  LUT3 #(
    .INIT ( 8'h04 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_value_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/interrupt_ack_internal ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable_value )
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift_inv  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift )
  );
  LUT2 #(
    .INIT ( 4'h3 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_carry_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_carry ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_carry )
  );
  LUT4 #(
    .INIT ( 16'h0010 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/io_decode_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/io_initial_decode )
  );
  LUT3 #(
    .INIT ( 8'hF3 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_carry )
  );
  LUT3 #(
    .INIT ( 8'h3F ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_zero_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_zero ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shadow_zero )
  );
  LUT4 #(
    .INIT ( 16'h0100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/read_active_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/io_initial_decode ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/read_active )
  );
  LUT4 #(
    .INIT ( 16'h4000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/write_active_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/io_initial_decode ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/write_active )
  );
  LUT4 #(
    .INIT ( 16'h0002 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_fetch_type_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_fetch_type )
  );
  LUT3 #(
    .INIT ( 8'h1F ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith )
  );
  LUT4 #(
    .INIT ( 16'hFFE2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical )
  );
  LUT4 #(
    .INIT ( 16'h0400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_type_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_type )
  );
  LUT4 #(
    .INIT ( 16'h0145 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_type_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_type )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_9  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [9])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [8])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/vector_select_mux_0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_vector [0])
  );
  LUT2 #(
    .INIT ( 4'hC ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift_carry_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift_carry )
  );
  LUT4 #(
    .INIT ( 16'hF3FF ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_parity_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/parity ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_parity )
  );
  LUT4 #(
    .INIT ( 16'h41FC ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_type_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_type )
  );
  LUT4 #(
    .INIT ( 16'h5400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/push_pop_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/push_or_pop_type )
  );
  LUT4 #(
    .INIT ( 16'h1000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/call_type )
  );
  LUT4 #(
    .INIT ( 16'h7400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/move_group_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/move_group )
  );
  LUT4 #(
    .INIT ( 16'hEAAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_update_lut  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_update_enable )
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_9  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [9]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [9])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_8  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [8]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [8])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_7  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [7])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_6  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [6]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [6])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_5  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [5]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [5])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_4  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [4]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [4])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_3  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [3]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [3])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_2  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [2]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [2])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_1  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [1]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [1])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_bit_0  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/address [0]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_write_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [0])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_7  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [7])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_6  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[6]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [6])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_5  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[5]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [5])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_4  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[4]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [4])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_3  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[3]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [3])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_2  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[2]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [2])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_1  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[1]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [1])
  );
  RAM64X1S #(
    .INIT ( 64'h0000000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_bit_0  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .A4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .A5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .D(NlwRenamedSig_OI_monitor_txdata[0]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_enable ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [0])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_7  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [7]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[7]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [7])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_6  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [6]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[6]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [6])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_5  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [5]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[5]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [5])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_4  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [4]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[4]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [4])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_3  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [3]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[3]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [3])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_2  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [2]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[2]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [2])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_1  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [1]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[1]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [1])
  );
  RAM16X1D #(
    .INIT ( 16'h0000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/reg_loop_register_bit_0  (
    .A0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8]),
    .A1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9]),
    .A2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10]),
    .A3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11]),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/alu_result [0]),
    .DPRA0(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4]),
    .DPRA1(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5]),
    .DPRA2(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6]),
    .DPRA3(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7]),
    .WCLK(icap_clk),
    .WE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_enable ),
    .SPO(NlwRenamedSig_OI_monitor_txdata[0]),
    .DPO(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sy [0])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_count_loop_register_bit_4  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [4])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_count_loop_register_bit_3  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [3])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_count_loop_register_bit_2  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [2])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_count_loop_register_bit_1  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [1])
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_count_loop_register_bit_0  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/next_stack_address [0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_address [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_9  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [9]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [9])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_8  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [8]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [8])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [7]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [6]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [5]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [4]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [3]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [2]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [1]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_flop_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_ram_data [0]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/stack_pop_data [0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/read_strobe_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/read_active ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/read_strobe )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/write_strobe_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/write_active ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe )
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/input_fetch_type ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_group )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry_out ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_carry )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_flop_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_value [0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_arith ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/arith_result [0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_flop_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_value [0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_shift ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_result [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pipeline_bit  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry_value ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shift_carry )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [7]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [6]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [5]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [4]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [3]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [2]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [1]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_flop_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_value [0]),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/sel_logical ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/logical_result [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [7]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [6]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [5]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [4]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [3]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [2]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [1]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_flop_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_data [0]),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/store_data [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_write_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_type ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/memory_write )
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_write_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_type ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/register_write )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag_flop  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_enable ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_fast_route ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_flag_flop  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_enable ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_fast_route ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_flag )
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_write_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_type ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/flag_write )
  );
  FDRE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable_flop  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_update_enable ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable_value ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_enable )
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_zero_flop  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/zero_flag ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_zero )
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_carry_flop  (
    .C(icap_clk),
    .CE(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/carry_flag ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/shadow_carry )
  );
  FD #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/ack_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/interrupt_ack_internal )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_pulse ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/int_capture_flop  (
    .C(icap_clk),
    .D(N1),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/clean_int )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/toggle_flop  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/not_t_state ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/t_state )
  );
  LUT3 #(
    .INIT ( 8'h08 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 )
  );
  LUT6 #(
    .INIT ( 64'h0002000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_24_o<6>1  (
    .I0(NlwRenamedSig_OI_monitor_txdata[6]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_24_o )
  );
  LUT6 #(
    .INIT ( 64'h0002000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1  (
    .I0(NlwRenamedSig_OI_monitor_txdata[7]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o )
  );
  LUT6 #(
    .INIT ( 64'h0000080000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_6_o<4>1  (
    .I0(NlwRenamedSig_OI_monitor_txdata[4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_6_o )
  );
  LUT5 #(
    .INIT ( 32'h02000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/monitor_txwrite1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ),
    .O(monitor_txwrite)
  );
  LUT5 #(
    .INIT ( 32'h40000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_25_o1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_25_o )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_26_o1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o1_151 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_26_o )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o1 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o )
  );
  LUT5 #(
    .INIT ( 32'h00000004 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o1 )
  );
  LUT3 #(
    .INIT ( 8'h08 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o1 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_2_o )
  );
  LUT3 #(
    .INIT ( 8'h08 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o1 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_3_o )
  );
  LUT4 #(
    .INIT ( 16'h0010 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel<5>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction19  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction21  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [10]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [10]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [10])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction31  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [11]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [11]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [11])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction41  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [12]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [12]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [12])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction51  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [13]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [13])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction61  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [14]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [14])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction71  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [15]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [15])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction81  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [16]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [16]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [16])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction91  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [17]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [17])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction101  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction111  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction121  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction131  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction141  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction151  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction161  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction171  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [8]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [8])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/Mmux_instruction181  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [9]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/instruction [9])
  );
  LUT3 #(
    .INIT ( 8'h08 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event1  (
    .I0(fecc_eccerr),
    .I1(NlwRenamedSignal_status_heartbeat),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_275 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/first_ecc_event )
  );
  LUT6 #(
    .INIT ( 64'h04000000AEAAAAAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_wea31  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[17] ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [2])
  );
  LUT6 #(
    .INIT ( 64'h40000000EAAAAAAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_wea41  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[17] ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [3])
  );
  LUT6 #(
    .INIT ( 64'h04000000AEAAAAAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_wea21  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[17] ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [1])
  );
  LUT6 #(
    .INIT ( 64'h01000000ABAAAAAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_wea11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[17] ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [0])
  );
  LUT5 #(
    .INIT ( 32'h40000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/go1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/go )
  );
  LUT3 #(
    .INIT ( 8'hE0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/read_strobe ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc1 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A21  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A101_475 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<10> )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A101  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A101_475 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<8> )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A111  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A101_475 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<9> )
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<0> )
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A31  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<1> )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A41  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<2> )
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A51  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [3]),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<3> )
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A61  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [4]),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<4> )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A71  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<5> )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A81  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<6> )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A91  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_A<7> )
  );
  LUT2 #(
    .INIT ( 4'hB ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_icap_csb11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[35] ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .O(icap_csb)
  );
  LUT2 #(
    .INIT ( 4'hB ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_icap_rdwrb11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[26] ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .O(icap_rdwrb)
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2]),
    .I2(NlwRenamedSig_OI_icap_i[5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra21  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [3]),
    .I2(NlwRenamedSig_OI_icap_i[4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra31  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [4]),
    .I2(NlwRenamedSig_OI_icap_i[3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra41  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [5]),
    .I2(NlwRenamedSig_OI_icap_i[2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra51  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [6]),
    .I2(NlwRenamedSig_OI_icap_i[1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra61  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [7]),
    .I2(NlwRenamedSig_OI_icap_i[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra71  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [8]),
    .I2(NlwRenamedSig_OI_icap_i[15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra81  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 ),
    .I2(NlwRenamedSig_OI_icap_i[14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_addra91  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 ),
    .I2(NlwRenamedSig_OI_icap_i[13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [8])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina110  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(icap_o[7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[0] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina210  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(icap_o[14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[10] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina33  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(icap_o[13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[11] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina41  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(icap_o[12]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[12] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina51  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(icap_o[11]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[13] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina61  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(icap_o[10]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[14] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina71  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(icap_o[9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[15] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina81  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(icap_o[8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[16] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina91  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(icap_o[23]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[18] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina101  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(icap_o[22]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[19] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina111  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(icap_o[6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[1] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina121  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(icap_o[21]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[20] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina131  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(icap_o[20]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[21] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina141  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(icap_o[19]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[22] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina151  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(icap_o[18]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[23] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina161  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(icap_o[17]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[24] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina171  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(icap_o[16]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[25] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina181  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(icap_o[31]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[27] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina191  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[1]),
    .I2(icap_o[30]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[28] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina201  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(icap_o[29]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[29] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina211  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[2]),
    .I2(icap_o[5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[2] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina221  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(icap_o[28]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[30] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina231  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(icap_o[27]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[31] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina241  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(icap_o[26]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[32] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina251  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(icap_o[25]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[33] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina261  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(icap_o[24]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[34] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina271  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[3]),
    .I2(icap_o[4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[3] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina281  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[4]),
    .I2(icap_o[3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[4] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina291  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[5]),
    .I2(icap_o[2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[5] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina301  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[6]),
    .I2(icap_o[1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[6] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina311  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[7]),
    .I2(icap_o[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[7] )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_dina321  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/ctl_ena_586 ),
    .I1(NlwRenamedSig_OI_monitor_txdata[0]),
    .I2(icap_o[15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[9] )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/monitor_rxread_SW0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/read_strobe ),
    .O(N2)
  );
  LUT6 #(
    .INIT ( 64'h0002000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/monitor_rxread  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .I5(N2),
    .O(monitor_rxread)
  );
  LUT5 #(
    .INIT ( 32'hFD75A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [7]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [7]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>1_871 )
  );
  LUT6 #(
    .INIT ( 64'h5D4D5C4C19091808 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [7]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_276 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>1_871 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>2_872 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [23]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [23]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [15]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>3_873 )
  );
  LUT5 #(
    .INIT ( 32'hA8202020 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>3_873 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>4_874 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[8]),
    .I3(NlwRenamedSig_OI_icap_i[24]),
    .I4(NlwRenamedSig_OI_icap_i[16]),
    .I5(NlwRenamedSig_OI_icap_i[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>5_875 )
  );
  LUT6 #(
    .INIT ( 64'hAAAACCCCF0F0FF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [7]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>5_875 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>6_876 )
  );
  LUT6 #(
    .INIT ( 64'h5551151144400400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>4_874 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>2_872 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>9_877 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [7])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [8]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [16]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [0]),
    .I5(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>1_878 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [16]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_flm_386 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>5_880 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFBEAFFFF5140 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [8]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>5_880 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>6_881 )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(monitor_txfull),
    .I3(monitor_rxdata[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>7_882 )
  );
  LUT6 #(
    .INIT ( 64'hF7E65544B3A21100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>7_882 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>1_878 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>6_881 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>4_879 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>8_883 )
  );
  LUT5 #(
    .INIT ( 32'hFD75A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>9  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>9_884 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFBEAFFFF5140 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>9_884 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>10_885 )
  );
  LUT6 #(
    .INIT ( 64'h22200200AAAAAAAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>10_885 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [8]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [16]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>11_886 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>12  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [16]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [16]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [8]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>12_887 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>13  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [0]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>12_887 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>13_888 )
  );
  LUT6 #(
    .INIT ( 64'h5551151144400400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>14  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>13_888 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>11_886 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>8_883 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [0])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [17]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [17]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [9]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>1_889 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>1_889 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>2_890 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(NlwRenamedSig_OI_icap_i[6]),
    .I2(NlwRenamedSig_OI_icap_i[14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>6_892 )
  );
  LUT6 #(
    .INIT ( 64'hAAAAAAAAF7D5A280 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I2(NlwRenamedSig_OI_icap_i[30]),
    .I3(NlwRenamedSig_OI_icap_i[22]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>6_892 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>7_893 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>7_893 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>8_894 )
  );
  LUT6 #(
    .INIT ( 64'h1154005411100010 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>9  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [9]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>9_895 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(monitor_rxempty),
    .I2(monitor_rxdata[1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>10_896 )
  );
  LUT6 #(
    .INIT ( 64'h5554454411100100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [9]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>10_896 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>11_897 )
  );
  LUT4 #(
    .INIT ( 16'hF5E4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>12  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>9_895 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>11_897 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>8_894 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>12_898 )
  );
  LUT6 #(
    .INIT ( 64'h5551151144400400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>13  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>2_890 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>5_891 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>12_898 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [1])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[13]),
    .I3(NlwRenamedSig_OI_icap_i[29]),
    .I4(NlwRenamedSig_OI_icap_i[21]),
    .I5(NlwRenamedSig_OI_icap_i[5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>1_899 )
  );
  LUT6 #(
    .INIT ( 64'hAAAAF0F0CCCCFF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>1_899 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>2_900 )
  );
  LUT5 #(
    .INIT ( 32'h5E0E5404 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [2]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [10]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>3_901 )
  );
  LUT6 #(
    .INIT ( 64'h5150414011100100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [2]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [10]),
    .I5(monitor_rxdata[2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>4_902 )
  );
  LUT6 #(
    .INIT ( 64'h5554111045440100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>3_901 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>4_902 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>2_900 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>5_903 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>6  (
    .I0(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>6_904 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [10]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>6_904 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [2]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>7_905 )
  );
  LUT6 #(
    .INIT ( 64'hA22AA22280088000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [10]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>7_905 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>8_906 )
  );
  LUT2 #(
    .INIT ( 4'h4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>9  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>9_907 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [18]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [18]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [10]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [10]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>10_908 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>9_907 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [2]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [2]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>10_908 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>11_909 )
  );
  LUT5 #(
    .INIT ( 32'h55554440 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>12  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>11_909 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>8_906 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>5_903 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [2])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[12]),
    .I3(NlwRenamedSig_OI_icap_i[28]),
    .I4(NlwRenamedSig_OI_icap_i[20]),
    .I5(NlwRenamedSig_OI_icap_i[4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>1_910 )
  );
  LUT6 #(
    .INIT ( 64'hA0A0C0C00000F000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>1_910 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>2_911 )
  );
  LUT6 #(
    .INIT ( 64'h1154005411100010 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [11]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>3_912 )
  );
  LUT6 #(
    .INIT ( 64'h5150414011100100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [11]),
    .I5(monitor_rxdata[3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>4_913 )
  );
  LUT5 #(
    .INIT ( 32'h51515140 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>4_913 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>3_912 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>2_911 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>5_914 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>6  (
    .I0(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>6_915 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [11]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>6_915 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [3]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>7_916 )
  );
  LUT6 #(
    .INIT ( 64'hA22AA22280088000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [11]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>7_916 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>8_917 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [19]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [19]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [11]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [11]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>10_918 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>9_907 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [3]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>10_918 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>11_919 )
  );
  LUT5 #(
    .INIT ( 32'h55554440 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>12  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>11_919 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>8_917 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<3>5_914 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [3])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [20]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [20]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [12]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [12]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>1_920 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [4]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>1_920 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>2_921 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>6  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[11]),
    .I3(NlwRenamedSig_OI_icap_i[27]),
    .I4(NlwRenamedSig_OI_icap_i[19]),
    .I5(NlwRenamedSig_OI_icap_i[3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>6_923 )
  );
  LUT6 #(
    .INIT ( 64'hCCCCF0F0AAAAFF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_8_583 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>6_923 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>7_924 )
  );
  LUT5 #(
    .INIT ( 32'h5E0E5404 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [4]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [12]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>8_925 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>9  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [12]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>9_926 )
  );
  LUT6 #(
    .INIT ( 64'h7632101054101010 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>9_926 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_277 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I5(monitor_rxdata[4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>10_927 )
  );
  LUT5 #(
    .INIT ( 32'hFE54BA10 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>8_925 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>10_927 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>7_924 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>11_928 )
  );
  LUT6 #(
    .INIT ( 64'h5551151144400400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>12  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>2_921 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>5_922 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>11_928 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [4])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[9]),
    .I3(NlwRenamedSig_OI_icap_i[25]),
    .I4(NlwRenamedSig_OI_icap_i[17]),
    .I5(NlwRenamedSig_OI_icap_i[1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>1_929 )
  );
  LUT6 #(
    .INIT ( 64'hCCCCF0F0AAAAFF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>2  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_10_585 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [6]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>1_929 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>2_930 )
  );
  LUT5 #(
    .INIT ( 32'h5E0E5404 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>3  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [6]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>3_931 )
  );
  LUT6 #(
    .INIT ( 64'h5150414011100100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [6]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [14]),
    .I5(monitor_rxdata[6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>4_932 )
  );
  LUT6 #(
    .INIT ( 64'h5554111045440100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>5  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>3_931 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>4_932 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>2_930 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>5_933 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>6  (
    .I0(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>6_934 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>7  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [14]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>6_934 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [6]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_275 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>7_935 )
  );
  LUT6 #(
    .INIT ( 64'hA222222280000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>8  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(icap_grant),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>7_935 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>8_936 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>10  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [22]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [22]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [14]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>10_937 )
  );
  LUT6 #(
    .INIT ( 64'hAAA22A2288800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<2>9_907 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [6]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [6]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>10_937 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>11_938 )
  );
  LUT5 #(
    .INIT ( 32'h55554440 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>12  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>11_938 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>8_936 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<6>5_933 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [6])
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port461  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [21]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [21]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [13]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port46 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port462  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port461_940 )
  );
  LUT6 #(
    .INIT ( 64'h9991191188800800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port463  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_sbe_296 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [5]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port461_940 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port462_941 )
  );
  LUT6 #(
    .INIT ( 64'hAA2AA8288A0A8808 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port464  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(monitor_rxdata[5]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [5]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port463_942 )
  );
  LUT6 #(
    .INIT ( 64'h5DFF5D5508FF0800 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port465  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port46 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port462_941 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port463_942 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port464_943 )
  );
  LUT5 #(
    .INIT ( 32'hFD75A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port466  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [5]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [5]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port465_944 )
  );
  LUT6 #(
    .INIT ( 64'h6662262244400400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port467  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synwd [5]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [5]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port465_944 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port466_945 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port468  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[10]),
    .I3(NlwRenamedSig_OI_icap_i[26]),
    .I4(NlwRenamedSig_OI_icap_i[18]),
    .I5(NlwRenamedSig_OI_icap_i[2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port467_946 )
  );
  LUT6 #(
    .INIT ( 64'hCCCCF0F0AAAAFF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port469  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_9_584 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [5]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port467_946 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port468_947 )
  );
  LUT5 #(
    .INIT ( 32'hBAAA1000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port4610  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [13]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port468_947 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port469_948 )
  );
  LUT6 #(
    .INIT ( 64'hBF1FB111AF0FA000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port4611  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [4]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port466_945 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port464_943 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port469_948 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port4610_949 )
  );
  LUT2 #(
    .INIT ( 4'h4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port4612  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/Mmux_in_port4610_949 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port [5])
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count[6]_PWR_7_o_equal_16_o<6>_SW0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [5]),
    .O(N4)
  );
  LUT6 #(
    .INIT ( 64'h0002000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/word_count[6]_PWR_7_o_equal_16_o<6>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [2]),
    .I3(N4),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count[6]_PWR_7_o_equal_16_o )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt91  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_10_585 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_8_583 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [8]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [2]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt9 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt92  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [5]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [6]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [6]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr_9_584 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt91_952 )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt93  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [7]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [3]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt92_953 )
  );
  LUT3 #(
    .INIT ( 8'h80 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt94  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt9 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt91_952 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt92_953 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_glue_set_954 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_275 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_glue_set_955 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_277 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_glue_set_956 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_276 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_glue_set_957 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_9  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_9_glue_set_958 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [9])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_8  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_8_glue_set_959 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [8])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_7  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_7_glue_set_960 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_6  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_6_glue_set_961 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_5  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_5_glue_set_962 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_4  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_4_glue_set_963 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_3  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_3_glue_set_964 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_2  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_2_glue_set_965 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_1  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_1_glue_set_966 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_0  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_0_glue_set_967 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/address [0])
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<6>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<6>_rt_968 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<5>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<5>_rt_969 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<4>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<4>_rt_970 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<3>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<3>_rt_971 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<2>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<2>_rt_972 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<1>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_cy<1>_rt_973 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<15>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [15]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<15>_rt_974 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<14>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [14]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<14>_rt_975 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<13>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [13]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<13>_rt_976 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<12>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [12]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<12>_rt_977 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<11>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [11]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<11>_rt_978 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<10>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [10]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<10>_rt_979 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<9>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [9]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<9>_rt_980 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<8>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [8]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<8>_rt_981 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<7>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<7>_rt_982 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<6>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [6]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<6>_rt_983 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<5>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [5]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<5>_rt_984 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<4>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [4]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<4>_rt_985 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<3>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [3]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<3>_rt_986 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<2>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<2>_rt_987 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<1>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_cy<1>_rt_988 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<7>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_xor<7>_rt_989 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<16>_rt  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [16]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_xor<16>_rt_990 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg_rstpot  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_26_o ),
    .I1(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg ),
    .I2(NlwRenamedSig_OI_monitor_txdata[7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg_rstpot_991 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg_rstpot_991 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/ireq_reg )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_rstpot_992 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_330 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_rstpot  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_25_o ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 ),
    .I2(NlwRenamedSig_OI_monitor_txdata[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_rstpot_993 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_rstpot_993 ),
    .R(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/bank_sel_reg_295 )
  );
  LUT6 #(
    .INIT ( 64'h1E1EF0F011EEFF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<0>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/read_strobe ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I3(NlwRenamedSig_OI_monitor_txdata[0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<0>_488 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFDFFFFFF ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A121  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc4 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 )
  );
  LUT6 #(
    .INIT ( 64'hAAAAF0F0CCCCFF00 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>4  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/end_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [8]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I3(N6),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>4_879 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000010 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh11  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [2]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [4]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<0>3_SW0  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [1]),
    .I2(NlwRenamedSig_OI_icap_i[15]),
    .I3(NlwRenamedSig_OI_icap_i[31]),
    .I4(NlwRenamedSig_OI_icap_i[23]),
    .I5(NlwRenamedSig_OI_icap_i[7]),
    .O(N6)
  );
  LUT3 #(
    .INIT ( 8'hBA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/long_gap_387 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_6_o ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_277 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_eos_glue_set_955 )
  );
  LUT3 #(
    .INIT ( 8'hBA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_glue_set  (
    .I0(fecc_crcerr),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_22_o ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_276 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_crc_glue_set_956 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_9_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [9]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [9]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_9_glue_set_958 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_8_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [8]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [8]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_8_glue_set_959 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_7_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [7]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [7]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_7_glue_set_960 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_6_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [6]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [6]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_6_glue_set_961 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_5_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [5]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [5]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_5_glue_set_962 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_4_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_4_glue_set_963 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_3_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_3_glue_set_964 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_2_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [2]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_2_glue_set_965 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_1_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_1_glue_set_966 )
  );
  LUT4 #(
    .INIT ( 16'hFFE4 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_0_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_enable ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/address [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/inc_pc_value [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/active_interrupt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_kcpsm3/pc_loop_register_bit_0_glue_set_967 )
  );
  LUT5 #(
    .INIT ( 32'hEAAA2AAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_rstpot  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_330 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_1_o1 ),
    .I4(NlwRenamedSig_OI_monitor_txdata[0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_locate_16_rstpot_992 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFFDFFF ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A1011  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc4 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A101_475 )
  );
  LUT6 #(
    .INIT ( 64'h8000800000008000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0291_inv )
  );
  LUT6 #(
    .INIT ( 64'hCCCCFF00C6C6F50A ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<2>  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt ),
    .I3(NlwRenamedSig_OI_monitor_txdata[2]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_A12 ),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc1 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Mmux_sta_ptr[10]_sta_ptr[10]_mux_11_OUT_rs_lut<2>_485 )
  );
  LUT4 #(
    .INIT ( 16'h7222 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_275 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/ws_pid[5]_AND_24_o ),
    .I2(NlwRenamedSignal_status_heartbeat),
    .I3(fecc_eccerr),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_ecc_glue_set_954 )
  );
  LUT6 #(
    .INIT ( 64'h0002000000000000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0258_inv1  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/dbuf_sel ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc4 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/Sh1 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/port_id [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/write_strobe ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/_n0258_inv )
  );
  LUT4 #(
    .INIT ( 16'h2AAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc41  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt9 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt91_952 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt92_953 ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/inc4 )
  );
  LUT5 #(
    .INIT ( 32'hFFFF2AAA ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_glue_set  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_582 ),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt9 ),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt91_952 ),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/halt92_953 ),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/go ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/burst_glue_set_957 )
  );
  MUXF7   \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>5  (
    .I0(N8),
    .I1(N9),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>5_891 )
  );
  LUT5 #(
    .INIT ( 32'h5E0E5404 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>5_F  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [9]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [1]),
    .O(N8)
  );
  LUT6 #(
    .INIT ( 64'h7773373366622622 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<1>5_G  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I2(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [1]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [1]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [9]),
    .O(N9)
  );
  MUXF7   \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>5  (
    .I0(N10),
    .I1(N11),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>5_922 )
  );
  LUT5 #(
    .INIT ( 32'h5E0E5404 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>5_F  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_synbt [4]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [12]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_syn [12]),
    .O(N10)
  );
  LUT6 #(
    .INIT ( 64'h5551151144400400 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<4>5_G  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\NlwRenamedSig_OI_U0/wrapper_wrapper/genv6.wrapper_controller/status_reg [4]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_dly [4]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/fecc_far_cap [4]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/rdbk_efcr [4]),
    .O(N11)
  );
  MUXF7   \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>9  (
    .I0(N12),
    .I1(N13),
    .S(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [2]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>9_877 )
  );
  LUT6 #(
    .INIT ( 64'hBEAEBAAA14041000 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>9_F  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [7]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [15]),
    .I5(\U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>6_876 ),
    .O(N12)
  );
  LUT6 #(
    .INIT ( 64'h5150414011100100 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/in_port<7>9_G  (
    .I0(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [1]),
    .I1(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [3]),
    .I2(\U0/wrapper_wrapper/genv6.wrapper_controller/pid_reg [0]),
    .I3(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [7]),
    .I4(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_total [15]),
    .I5(monitor_rxdata[7]),
    .O(N13)
  );
  FD #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/init_sync_a  (
    .C(icap_clk),
    .D(N1),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_a )
  );
  FD #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/init_sync_b  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_a ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_b )
  );
  FD #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/init_sync_c  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_b ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_c )
  );
  FD #(
    .INIT ( 1'b1 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/init_sync_d  (
    .C(icap_clk),
    .D(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_c ),
    .Q(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init )
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_lut<0>_INV_0  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_word_count_lut [0])
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_lut<0>_INV_0  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/frame_count [0]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/Mcount_frame_count_lut [0])
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv1_INV_0  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count [7]),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/word_count<7>_inv )
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/b_ena1_INV_0  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/ssi_init_c ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/b_ena )
  );
  INV   \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/sync_init_INV_10_o1_INV_0  (
    .I(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .O(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/sync_init_INV_10_o )
  );
  RAMB18E1 #(
    .INITP_00 ( 256'h76A0CA0FD37D3CCFFFCFFFFF7FFF4D57F76AA832803FD34F4D3F33778FFFFF8F ),
    .INITP_01 ( 256'h3C15400CBFEFFBFEF3FF3FBCCCFFCCCFEFFBFFFFDBFFFF6FFF4CFCDF3F3DFF5F ),
    .INITP_02 ( 256'h00000000002D2D28A2D2D23CFFCFED75EA8000A0B580A0AEEEEEEC2D55400333 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'hB4AA0A5ED0A69003000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h888C88C88C88C88BC302CB2CB3888BFFE30FFE30820FBFDEFFE5DAAAA8BFFCB4 ),
    .INITP_07 ( 256'hEBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCB00C2FBEFBFA2200EAAEA88A88B4B ),
    .INIT_00 ( 256'hCF1E0F01401540154015401540154015401540154015C000CF1E0F0040154015 ),
    .INIT_01 ( 256'h40016003505E2002401E401A031B033A001F0330006050674008501B4004C000 ),
    .INIT_02 ( 256'hCB0A0AEC0B020E000F00011300F203AB5C464060600650462001401E0346505E ),
    .INIT_03 ( 256'h03AE54414F0154414E43CC08CE09CF0ACD08CA09CB0AFCD04D0E01554C08CA09 ),
    .INIT_04 ( 256'h4002405302DE012403AE02E103AB544F40086003402FAF008E01AB008A014053 ),
    .INIT_05 ( 256'h00E1009A015D03564063A0DF032A00EB013000E1009A015D0356405C405C5452 ),
    .INIT_06 ( 256'h5C8540606006548A2020032A508A2004401E4002033A00080330C020032A00EB ),
    .INIT_07 ( 256'h4F0154824E43CD08CE09CF0ABDC04C0E01554D08CE09CF0A0E000F00011300F0 ),
    .INIT_08 ( 256'hA0BF032A40910330C040032A508E250100EB013000E64074AF008E0140855482 ),
    .INIT_09 ( 256'h03CE03D003CE54A3470267034095000040020321033A000254982020032A0330 ),
    .INIT_0A ( 256'h54BA4708A00000BF03BA03D403E203BC03CE03D003EC54AE4704A00000BF03BA ),
    .INIT_0B ( 256'h03E6A00003BA03CC03EA03CCA00000D400BF03BA03DC03E403BC03CE03D003EC ),
    .INIT_0C ( 256'h030460080304600903BC03C803DE03BA03046004030460050304600603BC03C8 ),
    .INIT_0D ( 256'h03BA0304600B03BC03EE03CA03BC0304600A03BC03CE03F4A00003BA03046007 ),
    .INIT_0E ( 256'hA00003BA03CE03E203D0A00003BA03C803DE03CCA00003BA03EA03E403CCA000 ),
    .INIT_0F ( 256'h4C0E015501170B000A04AF00AE00AD009CA04F274E264D254C240A0040F30A04 ),
    .INIT_10 ( 256'hCA01AF00BE60BD509C406609650864070B010A434F0E01554E0E01554D0E0155 ),
    .INIT_11 ( 256'h0159CC0E0159CD0E0159CE0E0159CF0E0159A00001170B010A44A0005D0BEB00 ),
    .INIT_12 ( 256'hA0005D2BE100C001C208020001010043C10AC00901000000A000CA0E0159CB0E ),
    .INIT_13 ( 256'h1947080809080A080B0E06004B084A084908480805000700C10AC00901000000 ),
    .INIT_14 ( 256'h03BC03EE03CA03BC03051C7003BC03CE03F4A000553647518701553B46208601 ),
    .INIT_15 ( 256'hA000C01400E0A00055592010400CA00055552020400CA000C50103BA03051C60 ),
    .INIT_16 ( 256'h00000000000000000000A000516720014007A000516320104007A000C0070010 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_20 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0500040000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h5AF2C0010101A007030002002008030002002010600B620A0300050204EC42E3 ),
    .INIT_2F ( 256'hA00056FC2002400CA000C008C209C30AF0104008C209C30AB350924042EE0106 ),
    .INIT_30 ( 256'h0C0601000C060100A00003FC0316030C03FC0316030C1C00A00057002001400C ),
    .INIT_31 ( 256'h03BA03EE03DE03C803D6A000813081075B19410AA00001000C0601000C060100 ),
    .INIT_32 ( 256'hA000A01F4000A000A0604000432503D8A00003BC03C003E453284000032DA000 ),
    .INIT_33 ( 256'h03ECC100D100032AA11F11004343032A03BC03CC03D2C100D100032DA1601100 ),
    .INIT_34 ( 256'hA00003590C000382C00A00C4C00B00BBC00900A4A00003BA0304032D03BC03CC ),
    .INIT_35 ( 256'h03860100008003930F000E000D00A00003590C0DA00003590C10A00003590C07 ),
    .INIT_36 ( 256'hC00900B8437F00C4C00B004FC0090034437F00C4C00B0077C009004CA0000368 ),
    .INIT_37 ( 256'hC00A00C2C00B0037C00900EC037F00C2C00B002FC0090094437F00F4C00B00FF ),
    .INIT_38 ( 256'hC209023DC20A0204C108C008C2090255C20A0204A00057822080400AA0000382 ),
    .INIT_39 ( 256'h0004A0004F084E084D084C08039FA000CF08CE08CD08CC08039FA000C108C008 ),
    .INIT_3A ( 256'h037403B1A000036E03B1A00003680393A000039903620386A000C0090040C00A ),
    .INIT_3B ( 256'h43FC015F43FC012043FC010DA00003A86C046D056E060F00038601000020A000 ),
    .INIT_3C ( 256'h43FC014443FC014343FC014243FC014143FC013643FC013343FC013643FC013E ),
    .INIT_3D ( 256'h43FC014C43FC014B43FC014A43FC014943FC014843FC014743FC014643FC0145 ),
    .INIT_3E ( 256'h43FC015443FC015343FC015243FC015143FC015043FC014F43FC014E43FC014D ),
    .INIT_3F ( 256'h43FFA000C10D030043FC015A43FC015943FC015843FC015743FC015643FC0155 ),
    .INIT_A ( 18'h00000 ),
    .INIT_B ( 18'h00000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_MODE ( "TDP" ),
    .RDADDR_COLLISION_HWCONFIG ( "DELAYED_WRITE" ),
    .RSTREG_PRIORITY_A ( "REGCE" ),
    .RSTREG_PRIORITY_B ( "REGCE" ),
    .SIM_COLLISION_CHECK ( "ALL" ),
    .SIM_DEVICE ( "VIRTEX6" ),
    .SRVAL_A ( 18'h00000 ),
    .SRVAL_B ( 18'h00000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .READ_WIDTH_A ( 18 ),
    .READ_WIDTH_B ( 18 ),
    .WRITE_WIDTH_A ( 18 ),
    .WRITE_WIDTH_B ( 18 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18  (
    .CLKARDCLK(icap_clk),
    .CLKBWRCLK(icap_clk),
    .ENARDEN(N1),
    .ENBWREN(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/b_ena ),
    .REGCEAREGCE(N1),
    .REGCEB(N1),
    .RSTRAMARSTRAM(N1),
    .RSTRAMB(N1),
    .RSTREGARSTREG(N1),
    .RSTREGB(N1),
    .ADDRARDADDR({N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N1, N1, N1, N1}),
    .ADDRBWRADDR({\U0/wrapper_wrapper/genv6.wrapper_controller/address [9], \U0/wrapper_wrapper/genv6.wrapper_controller/address [8], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [7], \U0/wrapper_wrapper/genv6.wrapper_controller/address [6], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [5], \U0/wrapper_wrapper/genv6.wrapper_controller/address [4], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [3], \U0/wrapper_wrapper/genv6.wrapper_controller/address [2], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [1], \U0/wrapper_wrapper/genv6.wrapper_controller/address [0], N1, N1, N1, N1}),
    .DIADI({N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0}),
    .DIBDI({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPADIP({N0, N0}),
    .DIPBDIP({N1, N1}),
    .DOADO({\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<15>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<14>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<13>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<12>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<11>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<10>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<9>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<8>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<7>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<6>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<5>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<4>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<3>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<2>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<1>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOADO<0>_UNCONNECTED }),
    .DOBDO({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [15], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [14], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [13], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [12], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [11], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [10], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [9], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [8], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [7], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [6], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [5], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [4], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [3], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [2], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [1], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [0]}),
    .DOPADOP({\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOPADOP<1>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw1/fw1_1024x18_DOPADOP<0>_UNCONNECTED }),
    .DOPBDOP({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [17], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction1 [16]}),
    .WEA({N1, N1}),
    .WEBWE({N1, N1, N1, N1})
  );
  RAMB18E1 #(
    .INITP_00 ( 256'hCE3E3E3F8D3488FCFFFF7D34F488D374FCFFFF888FFFFF7F0FFF33FF8DDDDF8F ),
    .INITP_01 ( 256'hCF0FFCFFFAAB7C373CC3D3F7FCBCFD3F7FF7D34F70FDDD22222234A222222823 ),
    .INITP_02 ( 256'hFBFFFFFFFA080CD334E2D2DCB724B3FFCFFFEA03FFF54036AED0FE00034F3CCC ),
    .INITP_03 ( 256'hD2D28A2667666AAABC3C30030B30C030B0C300C330C0030BFF333FC3FBFFFFFF ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000002 ),
    .INITP_05 ( 256'hB4AA0A5ED0A69003000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h888C88C88C88C88BC302CB2CB3888BFFE30FFE30820FBFDEFFE5DAAAA8BFFCB4 ),
    .INITP_07 ( 256'hEBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCB00C2FBEFBFA2200EAAEA88A88B4B ),
    .INIT_00 ( 256'hCF1E0F01510A40105094400050404002501B4001032DC000CF1E0F000142C000 ),
    .INIT_01 ( 256'h010100800346017E018E401A031B033A001F033000604015401540154015C000 ),
    .INIT_02 ( 256'hE000400401F901F601F901F603560353018801A2017A541D4C93039903620386 ),
    .INIT_03 ( 256'h40020321033A000201F303560353017A018301CE017A0346E0024006E0014005 ),
    .INIT_04 ( 256'h405E5450400E6010C0130080E010E080505020804013547B2080546420404014 ),
    .INIT_05 ( 256'h03BA03D840020321019403BA03EC545D4053405E54574049400D545D2002400C ),
    .INIT_06 ( 256'hE00300085C734051401A507720204014E012401CE011401B40020321033A0000 ),
    .INIT_07 ( 256'h033A000403BAE0030001407D0087E0030002407D0087E0030004407D00810087 ),
    .INIT_08 ( 256'h4016E009401DE0044017E0054018E0064019A000E00BA01F4014E00A401A4002 ),
    .INIT_09 ( 256'h400FE00D4010E00E4011E00F4012E010E08050B220804013A000E0074015E008 ),
    .INIT_0A ( 256'h400A40CBA00F600C03BC03EA54AF400B50F8400C50F820086010C0130080E00C ),
    .INIT_0B ( 256'h405240F0019403BA03EC54BF405340F254B9404F400D54F12002400C40F254B2 ),
    .INIT_0C ( 256'h03BA03FC03161100C01F58EF01E7400D02FC03BC54EF4020400D02FC03EA54D1 ),
    .INIT_0D ( 256'h010458EF01E7400D02FC0A00020903BC54EF4020400D02FC03E254F1404E4000 ),
    .INIT_0E ( 256'h03BA4106EE10ED0FEC0EEB0DEA0C54DBC20103FC03161100DA0054E0C10101E0 ),
    .INIT_0F ( 256'h03056C0F03FC0316A10F611003BC03E240020321033A000203BA03E440020321 ),
    .INIT_10 ( 256'h6C0E6B0D6A0C513E2008401E4002033A001003BA03056C0C03056C0D03056C0E ),
    .INIT_11 ( 256'hCD02CC0101E0E00A5D3E4051A07F10B001E001E001E0E00BA01F10A06E106D0F ),
    .INIT_12 ( 256'h01F901F6035601C00346593EFFE0FBD0DAC0AE016F026B016A0051342E80CE03 ),
    .INIT_13 ( 256'h033A000001F3035601B103AE02E103AB0346EE06ED05EC044E194D184C1701FD ),
    .INIT_14 ( 256'hA000554CC00101500024B0002080401EA000033A0001016E0159014840020321 ),
    .INIT_15 ( 256'h400D55612002400C0382C0000000A0005556C20102FFA0005551C101015501FF ),
    .INIT_16 ( 256'h03C603F2A000C01FA00F401FC0130080400E400E4161400E55662020400C415C ),
    .INIT_17 ( 256'h03CC03D8A00003BA03DC03E4417C03C203BE03C403F203BE03E003D003EC03BE ),
    .INIT_18 ( 256'h03EC03D2A00003BC03DC03CA03CE03EA418C03EE03D803E203D8418C03E603C8 ),
    .INIT_19 ( 256'h0335033F03BA03056C0003056C0103056C0203BC03D203E04343A00F401F03BC ),
    .INIT_1A ( 256'hAEFD03A4010200E003A8CC80CD03AC3FAD7CAEFEAF0103A4010100C0A000018E ),
    .INIT_1B ( 256'hA00003A80C000D040386010000A003A80C800D050E000F000386010000C003A8 ),
    .INIT_1C ( 256'h010100C0A00003A80C800386010000A003A80C800D000E000F000386010000C0 ),
    .INIT_1D ( 256'hA0000368038601020060036203860102008003A8CC80CF40AC7FADFDAFBF03A4 ),
    .INIT_1E ( 256'hC0F6B80080075DF1C011B800C0E9B80080B9A0000F000E000D000C000B000A06 ),
    .INIT_1F ( 256'h51FD20014007A00051F920104007A000C0070010A000C01400E0A000800AA000 ),
    .INIT_20 ( 256'h000000000000000000000000000000000000000000000000000000000000A000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0500040000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h5AF2C0010101A007030002002008030002002010600B620A0300050204EC42E3 ),
    .INIT_2F ( 256'hA00056FC2002400CA000C008C209C30AF0104008C209C30AB350924042EE0106 ),
    .INIT_30 ( 256'h0C0601000C060100A00003FC0316030C03FC0316030C1C00A00057002001400C ),
    .INIT_31 ( 256'h03BA03EE03DE03C803D6A000813081075B19410AA00001000C0601000C060100 ),
    .INIT_32 ( 256'hA000A01F4000A000A0604000432503D8A00003BC03C003E453284000032DA000 ),
    .INIT_33 ( 256'h03ECC100D100032AA11F11004343032A03BC03CC03D2C100D100032DA1601100 ),
    .INIT_34 ( 256'hA00003590C000382C00A00C4C00B00BBC00900A4A00003BA0304032D03BC03CC ),
    .INIT_35 ( 256'h03860100008003930F000E000D00A00003590C0DA00003590C10A00003590C07 ),
    .INIT_36 ( 256'hC00900B8437F00C4C00B004FC0090034437F00C4C00B0077C009004CA0000368 ),
    .INIT_37 ( 256'hC00A00C2C00B0037C00900EC037F00C2C00B002FC0090094437F00F4C00B00FF ),
    .INIT_38 ( 256'hC209023DC20A0204C108C008C2090255C20A0204A00057822080400AA0000382 ),
    .INIT_39 ( 256'h0004A0004F084E084D084C08039FA000CF08CE08CD08CC08039FA000C108C008 ),
    .INIT_3A ( 256'h037403B1A000036E03B1A00003680393A000039903620386A000C0090040C00A ),
    .INIT_3B ( 256'h43FC015F43FC012043FC010DA00003A86C046D056E060F00038601000020A000 ),
    .INIT_3C ( 256'h43FC014443FC014343FC014243FC014143FC013643FC013343FC013643FC013E ),
    .INIT_3D ( 256'h43FC014C43FC014B43FC014A43FC014943FC014843FC014743FC014643FC0145 ),
    .INIT_3E ( 256'h43FC015443FC015343FC015243FC015143FC015043FC014F43FC014E43FC014D ),
    .INIT_3F ( 256'h43FFA000C10D030043FC015A43FC015943FC015843FC015743FC015643FC0155 ),
    .INIT_A ( 18'h00000 ),
    .INIT_B ( 18'h00000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_MODE ( "TDP" ),
    .RDADDR_COLLISION_HWCONFIG ( "DELAYED_WRITE" ),
    .RSTREG_PRIORITY_A ( "REGCE" ),
    .RSTREG_PRIORITY_B ( "REGCE" ),
    .SIM_COLLISION_CHECK ( "ALL" ),
    .SIM_DEVICE ( "VIRTEX6" ),
    .SRVAL_A ( 18'h00000 ),
    .SRVAL_B ( 18'h00000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .READ_WIDTH_A ( 18 ),
    .READ_WIDTH_B ( 18 ),
    .WRITE_WIDTH_A ( 18 ),
    .WRITE_WIDTH_B ( 18 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18  (
    .CLKARDCLK(icap_clk),
    .CLKBWRCLK(icap_clk),
    .ENARDEN(N1),
    .ENBWREN(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/b_ena ),
    .REGCEAREGCE(N1),
    .REGCEB(N1),
    .RSTRAMARSTRAM(N1),
    .RSTRAMB(N1),
    .RSTREGARSTREG(N1),
    .RSTREGB(N1),
    .ADDRARDADDR({N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N1, N1, N1, N1}),
    .ADDRBWRADDR({\U0/wrapper_wrapper/genv6.wrapper_controller/address [9], \U0/wrapper_wrapper/genv6.wrapper_controller/address [8], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [7], \U0/wrapper_wrapper/genv6.wrapper_controller/address [6], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [5], \U0/wrapper_wrapper/genv6.wrapper_controller/address [4], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [3], \U0/wrapper_wrapper/genv6.wrapper_controller/address [2], 
\U0/wrapper_wrapper/genv6.wrapper_controller/address [1], \U0/wrapper_wrapper/genv6.wrapper_controller/address [0], N1, N1, N1, N1}),
    .DIADI({N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0, N0}),
    .DIBDI({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPADIP({N0, N0}),
    .DIPBDIP({N1, N1}),
    .DOADO({\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<15>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<14>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<13>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<12>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<11>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<10>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<9>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<8>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<7>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<6>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<5>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<4>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<3>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<2>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<1>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOADO<0>_UNCONNECTED }),
    .DOBDO({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [15], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [14], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [13], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [12], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [11], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [10], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [9], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [8], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [7], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [6], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [5], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [4], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [3], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [2], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [1], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [0]}),
    .DOPADOP({\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOPADOP<1>_UNCONNECTED , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/fw0/fw0_1024x18_DOPADOP<0>_UNCONNECTED }),
    .DOPBDOP({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [17], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_instrom/instruction0 [16]}),
    .WEA({N1, N1}),
    .WEBWE({N1, N1, N1, N1})
  );
  RAMB18E1 #(
    .INITP_00 ( 256'h3333333333333333333333333333333333333333333333333333333333333333 ),
    .INITP_01 ( 256'h3333333333333333333333333333333333333333333333333333333333333333 ),
    .INITP_02 ( 256'h3333333333333333B5777F3333F3333333333333333333333333333333333333 ),
    .INITP_03 ( 256'h3333333333333333333333333333333333333333333333333333333333333333 ),
    .INITP_04 ( 256'h33333333333333333F3333FFFFFFFFFFFFF5777F3333F33333F3333333333333 ),
    .INITP_05 ( 256'h77777777777777777777777777777777777777777F3333333333333333333333 ),
    .INITP_06 ( 256'h5555555555555555555577777777777777777777777777777777777777777777 ),
    .INITP_07 ( 256'hF3B5555555555555555555555555555555555555555555555555555555555555 ),
    .INIT_00 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_01 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_02 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_03 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_04 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_05 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_06 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_07 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_08 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_09 ( 256'h1111111111111111111111111111111111111111111111111111111111111111 ),
    .INIT_0A ( 256'h2222222222222222222222222222222222222222222222222222222211111111 ),
    .INIT_0B ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_0C ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_0D ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_0E ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_0F ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_10 ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_11 ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_12 ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_13 ( 256'h2222222222222222222222222222222222222222222222222222222222222222 ),
    .INIT_14 ( 256'h2801800120000000FFFFFFFFDEADDEADDEADDEADDEADDEAD2222222222222222 ),
    .INIT_15 ( 256'hFFFFFFFFADDD02C8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2000000020000000 ),
    .INIT_16 ( 256'h20000000000000013000800120000000200000001D1D1D1D3001800120000000 ),
    .INIT_17 ( 256'hDADADADADADADADADADADADADADADADADADADADA500000A23000400020000000 ),
    .INIT_18 ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_19 ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_1A ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_1B ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_1C ( 256'hDADADADADADADADADADADADADADADADAECCCECCCDADADADADADADADADADADADA ),
    .INIT_1D ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_1E ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_1F ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_20 ( 256'hDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA ),
    .INIT_21 ( 256'h30ADDD0120000000FFFFFFFF20000000DADADADADADADADADADADADADADADADA ),
    .INIT_22 ( 256'h200000002000000028ADDD0120000000FFFFFFFF2000000020000000DADADADA ),
    .INIT_23 ( 256'hDEADDEADDEADDEADFFFFFFFFADDD0440FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_24 ( 256'hDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD ),
    .INIT_25 ( 256'h20000000FFFFFFFF2000000020000000AA99556620000000FFFFFFFFDEADDEAD ),
    .INIT_26 ( 256'h2000000020000000480000A22800600020000000200000000000000430008001 ),
    .INIT_27 ( 256'h2000000020000000200000002000000020000000200000002000000020000000 ),
    .INIT_28 ( 256'h2000000020000000200000002000000020000000200000002000000020000000 ),
    .INIT_29 ( 256'h2000000020000000200000002000000020000000200000002000000020000000 ),
    .INIT_2A ( 256'hFFFFFFFFFFFFFFFF200000002000000020000000200000002000000020000000 ),
    .INIT_2B ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_2C ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_2D ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_2E ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_2F ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_30 ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_31 ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_32 ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_33 ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_34 ( 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_35 ( 256'hADDD02F8ADDD02F4ADDD02F0ADDD02ECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ),
    .INIT_36 ( 256'hADDD0318ADDD0314ADDD0310ADDD030CADDD0308ADDD0304ADDD0300ADDD02FC ),
    .INIT_37 ( 256'hADDD0338ADDD0334ADDD0330ADDD032CADDD0328ADDD0324ADDD0320ADDD031C ),
    .INIT_38 ( 256'hADDD0358ADDD0354ADDD0350ADDD034CADDD0348ADDD0344ADDD0340ADDD033C ),
    .INIT_39 ( 256'hADDD0378ADDD0374ADDD0370ADDD036CADDD0368ADDD0364ADDD0360ADDD035C ),
    .INIT_3A ( 256'hADDD0398ADDD0394ADDD0390ADDD038CADDD0388ADDD0384ADDD0380ADDD037C ),
    .INIT_3B ( 256'hADDD03B8ADDD03B4ADDD03B0ADDD03ACADDD03A8ADDD03A4ADDD03A0ADDD039C ),
    .INIT_3C ( 256'hADDD03D8ADDD03D4ADDD03D0ADDD03CCADDD03C8ADDD03C4ADDD03C0ADDD03BC ),
    .INIT_3D ( 256'hADDD03F8ADDD03F4ADDD03F0ADDD03ECADDD03E8ADDD03E4ADDD03E0ADDD03DC ),
    .INIT_3E ( 256'hADDD0418ADDD0414ADDD0410ADDD040CADDD0408ADDD0404ADDD0400ADDD03FC ),
    .INIT_3F ( 256'hFFFFFFFF20000000FFFFFFFFADDD042CADDD0428ADDD0424ADDD0420ADDD041C ),
    .INIT_A ( 18'h3FFFF ),
    .INIT_B ( 18'h3FFFF ),
    .INIT_FILE ( "NONE" ),
    .RAM_MODE ( "SDP" ),
    .RDADDR_COLLISION_HWCONFIG ( "DELAYED_WRITE" ),
    .RSTREG_PRIORITY_A ( "RSTREG" ),
    .RSTREG_PRIORITY_B ( "RSTREG" ),
    .SIM_COLLISION_CHECK ( "ALL" ),
    .SIM_DEVICE ( "VIRTEX6" ),
    .SRVAL_A ( 18'h3FFFF ),
    .SRVAL_B ( 18'h3FFFF ),
    .WRITE_MODE_A ( "READ_FIRST" ),
    .WRITE_MODE_B ( "READ_FIRST" ),
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .READ_WIDTH_A ( 36 ),
    .READ_WIDTH_B ( 0 ),
    .WRITE_WIDTH_A ( 0 ),
    .WRITE_WIDTH_B ( 36 ))
  \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/storage  (
    .CLKARDCLK(icap_clk),
    .CLKBWRCLK(icap_clk),
    .ENARDEN(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/sync_init_INV_10_o ),
    .ENBWREN(\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/sync_init_INV_10_o ),
    .REGCEAREGCE(N1),
    .REGCEB(N1),
    .RSTRAMARSTRAM(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .RSTRAMB(\U0/wrapper_wrapper/genv6.wrapper_controller/sync_init ),
    .RSTREGARSTREG(N1),
    .RSTREGB(N1),
    .ADDRARDADDR({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_10_581 , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr_9_580 , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [8], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [7], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [6], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [5], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [4], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [3], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/sta_ptr [2], N1, N1, N1, N1, N1}),
    .ADDRBWRADDR({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [8], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [7], \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [6], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [5], \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [4], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [3], \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [2], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [1], \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/addra [0], 
N1, N1, N1, N1, N1}),
    .DIADI({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[16] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[15] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[14] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[13] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[12] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[11] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[10] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[9] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[7] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[6] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[5] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[4] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[3] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[2] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[1] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[0] }),
    .DIBDI({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[34] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[33] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[32] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[31] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[30] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[29] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[28] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[27] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[25] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[24] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[23] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[22] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[21] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[20] , \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[19] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/dina[18] }),
    .DIPADIP({N0, N0}),
    .DIPBDIP({N1, N1}),
    .DOADO({NlwRenamedSig_OI_icap_i[8], NlwRenamedSig_OI_icap_i[9], NlwRenamedSig_OI_icap_i[10], NlwRenamedSig_OI_icap_i[11], 
NlwRenamedSig_OI_icap_i[12], NlwRenamedSig_OI_icap_i[13], NlwRenamedSig_OI_icap_i[14], NlwRenamedSig_OI_icap_i[15], NlwRenamedSig_OI_icap_i[0], 
NlwRenamedSig_OI_icap_i[1], NlwRenamedSig_OI_icap_i[2], NlwRenamedSig_OI_icap_i[3], NlwRenamedSig_OI_icap_i[4], NlwRenamedSig_OI_icap_i[5], 
NlwRenamedSig_OI_icap_i[6], NlwRenamedSig_OI_icap_i[7]}),
    .DOBDO({NlwRenamedSig_OI_icap_i[24], NlwRenamedSig_OI_icap_i[25], NlwRenamedSig_OI_icap_i[26], NlwRenamedSig_OI_icap_i[27], 
NlwRenamedSig_OI_icap_i[28], NlwRenamedSig_OI_icap_i[29], NlwRenamedSig_OI_icap_i[30], NlwRenamedSig_OI_icap_i[31], NlwRenamedSig_OI_icap_i[16], 
NlwRenamedSig_OI_icap_i[17], NlwRenamedSig_OI_icap_i[18], NlwRenamedSig_OI_icap_i[19], NlwRenamedSig_OI_icap_i[20], NlwRenamedSig_OI_icap_i[21], 
NlwRenamedSig_OI_icap_i[22], NlwRenamedSig_OI_icap_i[23]}),
    .DOPADOP({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[17] , 
\NLW_U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/controller_dbuffer_mem/storage_DOPADOP<0>_UNCONNECTED }),
    .DOPBDOP({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[35] , 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/doutb[26] }),
    .WEA({N1, N1}),
    .WEBWE({\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [3], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [2], \U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [1], 
\U0/wrapper_wrapper/genv6.wrapper_controller/controller_dbuffer/wea [0]})
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

// synthesis translate_on
