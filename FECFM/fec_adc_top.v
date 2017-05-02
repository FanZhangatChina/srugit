/*
Copyright (c) 2015-2017 Fan Zhang
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * fec_adc_top
 */

/*
 * I2C master
 */
module fec_adc_top (
    input  wire        clk,
    input  wire        rst,

    /*
     * Host interface
     */
    output wire [149:0]  data_out,
    output wire          data_out_valid,
    input  wire          data_out_ready,
	 
    /*
     * I2C interface
     */
    output wire        i2c_scl,
    inout  wire        i2c_sda,
	 
    /*
     * Status
     */
    output wire        missed_ack

    /*
     * Configuration
     */

);	  

/*
I2C
Read
    __    ___ ___ ___ ___ ___ ___ ___         ___ ___ ___ ___ ___ ___ ___ ___     ___ ___ ___ ___ ___ ___ ___ ___        __
sda   \__/_6_X_5_X_4_X_3_X_2_X_1_X_0_\_R___A_/_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_\_A_/_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_\_A____/
    ____   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   ____
scl  ST \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ SP

Write
    __    ___ ___ ___ ___ ___ ___ ___ ___     ___ ___ ___ ___ ___ ___ ___ ___     ___ ___ ___ ___ ___ ___ ___ ___ ___    __
sda   \__/_6_X_5_X_4_X_3_X_2_X_1_X_0_/_W_\_A_/_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_\_A_/_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_/_N_\__/
    ____   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   ____
scl  ST \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ SP

*/
/*
I2C Address (7 bits)
Four MSBs of AD7417 are set to 4'b0101
Three LSBs of 3 ADC7417 chips (IC13,IC14,IC15) are set to 3'b000, 3'b010, 3'b001 respectively.
		IC13_wr = 8'b0101_0000;
		IC13_rd = 8'b0101_0001;
		IC14_wr = 8'b0101_0100;
		IC14_rd = 8'b0101_0101;
		IC15_wr = 8'b0101_0010;
		IC15_rd = 8'b0101_0011;


AD7417 Operation procedure
(1) Read Temp1 from IC13
Write: 8'h50,8'h00
Read:  8'h51, DH, DL
(2) Read AN1 from IC13
Write: 8'h50,8'h01,8'h00 ; Set config register, select AN1
Write: 8'h50,8'h04
Read:  8'h51, DH, DL
(2) Read AN2 from IC13
Write: 8'h50,8'h01,8'h20 ; Set config register, select AN1
Write: 8'h50,8'h04
Read:  8'h51, DH, DL
...

Input clock cycle
The minimum clock period must >= 2.5us (400kHz)(Page 3 in AD7417 datasheet)
Fscl = Fclk % 4
Fclk = 40MHz % 256 ~ 15.625kHz (Period = 64us)

Minimum monitoring time
64us*4*(50+80*4)*3=256us*1110cycles ~ 0.3s

Example of interfacing with tristate pins:
(this will work for any tristate bus)
assign scl_i = scl_pin;
assign scl_pin = scl_t ? 1'bz : scl_o;
assign sda_i = sda_pin;
assign sda_pin = sda_t ? 1'bz : sda_o;

Equivalent code that does not use *_t connections:
(we can get away with this because I2C is open-drain)
assign sda_i = sda_pin;
assign sda_pin = sda_o ? 1'bz : 1'b0;

Design Strategy:
CONVST is not used to save power, since only small number of AD7417, the saved power can be negleted.
Firmware can be simplified to enhance stability when CONVST is not used.	 
*/

localparam [4:0]
    STATE_IDLE = 4'd0,
    STATE_ACTIVE_WRITE = 4'd1,
    STATE_ACTIVE_READ = 4'd2,
    STATE_START_WAIT = 4'd3,
    STATE_START = 4'd4,
    STATE_ADDRESS_1 = 4'd5,
    STATE_ADDRESS_2 = 4'd6,
    STATE_WRITE_1 = 4'd7,
    STATE_WRITE_2 = 4'd8,
    STATE_WRITE_3 = 4'd9,
    STATE_READ = 4'd10,
    STATE_STOP = 4'd11;

reg [4:0] state_reg = STATE_IDLE, state_next;


localparam [4:0]
    PHY_STATE_IDLE = 5'd0,
    PHY_STATE_ACTIVE = 5'd1,
    PHY_STATE_REPEATED_START_1 = 5'd2,
    PHY_STATE_REPEATED_START_2 = 5'd3,
    PHY_STATE_START_1 = 5'd4,
    PHY_STATE_START_2 = 5'd5,
    PHY_STATE_WRITE_BIT_1 = 5'd6,
    PHY_STATE_WRITE_BIT_2 = 5'd7,
    PHY_STATE_WRITE_BIT_3 = 5'd8,
    PHY_STATE_READ_BIT_1 = 5'd9,
    PHY_STATE_READ_BIT_2 = 5'd10,
    PHY_STATE_READ_BIT_3 = 5'd11,
    PHY_STATE_READ_BIT_4 = 5'd12,
    PHY_STATE_STOP_1 = 5'd13,
    PHY_STATE_STOP_2 = 5'd14,
    PHY_STATE_STOP_3 = 5'd15;

reg [4:0] phy_state_reg = STATE_IDLE, phy_state_next;


reg i2c_sda_o = 1'b1;
reg i2c_scl_o = 1'b1;
assign i2c_sda = i2c_sda_o ? 1'bz : 1'b0;

//always @* begin
always @(posedge clk) begin
    if(rst)
	 phy_state_next = PHY_STATE_IDLE;

//    phy_rx_data_next = phy_rx_data_reg;
//
//    delay_next = delay_reg;
//    delay_scl_next = delay_scl_reg;
//    delay_sda_next = delay_sda_reg;
//
//    scl_o_next = scl_o_reg;
//    sda_o_next = sda_o_reg;
//
//    bus_control_next = bus_control_reg;
//
//    if (phy_release_bus) begin
//        // release bus and return to idle state
        i2c_sda_o = 1'b1;
        i2c_scl_o = 1'b1;
//        delay_scl_next = 1'b0;
//        delay_sda_next = 1'b0;
//        delay_next = 1'b0;
//        phy_state_next = PHY_STATE_IDLE;
//    end else if (delay_scl_reg) begin
//        // wait for SCL to match command
//        delay_scl_next = scl_o_reg & ~scl_i_reg;
//        phy_state_next = phy_state_reg;
//    end else if (delay_sda_reg) begin
//        // wait for SDA to match command
//        delay_sda_next = sda_o_reg & ~sda_i_reg;
//        phy_state_next = phy_state_reg;
//    end else if (delay_reg > 0) begin
//        // time delay
//        delay_next = delay_reg - 1;
//        phy_state_next = phy_state_reg;
    end else begin
        case (phy_state_reg)
            PHY_STATE_IDLE: begin
                // bus idle - wait for start command
                sda_o_next = 1'b1;
                scl_o_next = 1'b1;
                if (phy_start_bit) begin
                    sda_o_next = 1'b0;
                    delay_next = prescale;
                    phy_state_next = PHY_STATE_START_1;
                end else begin
                    phy_state_next = PHY_STATE_IDLE;
                end
            end
            PHY_STATE_ACTIVE: begin
                // bus active
                if (phy_start_bit) begin
						  i2c_sda_o = 1'b1;
						  i2c_scl_o = 1'b1;
//                    sda_o_next = 1'b1;
//                    delay_next = prescale;
                    phy_state_next = PHY_STATE_REPEATED_START_1;
                end else if (phy_write_bit) begin
                    sda_o_next = phy_tx_data;
                    delay_next = prescale;
                    phy_state_next = PHY_STATE_WRITE_BIT_1;
                end else if (phy_read_bit) begin
                    sda_o_next = 1'b1;
                    delay_next = prescale;
                    phy_state_next = PHY_STATE_READ_BIT_1;
                end else if (phy_stop_bit) begin
                    sda_o_next = 1'b0;
                    delay_next = prescale;
                    phy_state_next = PHY_STATE_STOP_1;
                end else begin
                    phy_state_next = PHY_STATE_ACTIVE;
                end
            end
            PHY_STATE_REPEATED_START_1: begin
                // generate repeated start bit
                //         ______
                // sda XXX/      \_______
                //            _______
                // scl ______/       \___
                //
					 i2c_sda_o = 1'b1;
					 i2c_scl_o = 1'b1;
//                scl_o_next = 1'b1;
//                delay_scl_next = 1'b1;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_REPEATED_START_2;
            end
            PHY_STATE_REPEATED_START_2: begin
                // generate repeated start bit
                //         ______
                // sda XXX/      \_______
                //            _______
                // scl ______/       \___
                //
					 i2c_sda_o = 1'b0;
					 i2c_scl_o = 1'b1;
//                sda_o_next = 1'b0;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_START_1;
            end
            PHY_STATE_START_1: begin
                // generate start bit
                //     ___
                // sda    \_______
                //     _______
                // scl        \___
                //
					 i2c_sda_o = 1'b0;
					 i2c_scl_o = 1'b0;
//                scl_o_next = 1'b0;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_START_2;
            end
            PHY_STATE_START_2: begin
                // generate start bit
                //     ___
                // sda    \_______
                //     _______
                // scl        \___
                //
					 i2c_sda_o = 1'b0;
					 i2c_scl_o = 1'b0;
//                bus_control_next = 1'b1;
                phy_state_next = PHY_STATE_ACTIVE;
            end
            PHY_STATE_WRITE_BIT_1: begin
                // write bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__

                scl_o_next = 1'b1;
                delay_scl_next = 1'b1;
                delay_next = prescale << 1;
                phy_state_next = PHY_STATE_WRITE_BIT_2;
            end
            PHY_STATE_WRITE_BIT_2: begin
                // write bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__

                scl_o_next = 1'b0;
                delay_next = prescale;
                phy_state_next = PHY_STATE_WRITE_BIT_3;
            end
            PHY_STATE_WRITE_BIT_3: begin
                // write bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__

                phy_state_next = PHY_STATE_ACTIVE;
            end
            PHY_STATE_READ_BIT_1: begin
                // read bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__
					 i2c_sda_o = 1'b1;
					 i2c_scl_o = 1'b1;

                
//					 scl_o_next = 1'b1;
//                delay_scl_next = 1'b1;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_READ_BIT_2;
            end
            PHY_STATE_READ_BIT_2: begin
                // read bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__
					 i2c_sda_o = 1'b1;
					 i2c_scl_o = 1'b1;

                phy_rx_data_next = sda_i_reg;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_READ_BIT_3;
            end
            PHY_STATE_READ_BIT_3: begin
                // read bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__
					 i2c_sda_o = 1'b1;
					 i2c_scl_o = 1'b0;

//                scl_o_next = 1'b0;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_READ_BIT_4;
            end
            PHY_STATE_READ_BIT_4: begin
                // read bit
                //      ________
                // sda X________X
                //        ____
                // scl __/    \__
					 i2c_sda_o = 1'b1;
					 i2c_scl_o = 1'b0;

                phy_state_next = PHY_STATE_ACTIVE;
            end
            PHY_STATE_STOP_1: begin
                // stop bit
                //                 ___
                // sda XXX\_______/
                //             _______
                // scl _______/
					 i2c_sda_o = 1'b0;
					 i2c_scl_o = 1'b0;
//                scl_o_next = 1'b1;
//                delay_scl_next = 1'b1;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_STOP_2;
            end
            PHY_STATE_STOP_2: begin
                // stop bit
                //                 ___
                // sda XXX\_______/
                //             _______
                // scl _______/
					 i2c_sda_o = 1'b0;
					 i2c_scl_o = 1'b1;
//                sda_o_next = 1'b1;
//                delay_next = prescale;
                phy_state_next = PHY_STATE_STOP_3;
            end
            PHY_STATE_STOP_3: begin
                // stop bit
                //                 ___
                // sda XXX\_______/
                //             _______
                // scl _______/
					 i2c_sda_o = 1'b1;
					 i2c_scl_o = 1'b1;
                bus_control_next = 1'b0;
                phy_state_next = PHY_STATE_IDLE;
            end
        endcase
    end
end

endmodule
