/*
 * SPDX-FileCopyrightText: 2020 Efabless Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

// This include is relative to $CARAVEL_PATH (see Makefile)
#include <defs.h>
#include <stub.c>

/*
	Wishbone Test:
		- Configures MPRJ lower 8-IO pins as outputs
		- Checks counter value through the wishbone port
*/

void main()
{

	/* 
	IO Control Registers
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |
	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |
	
	 
	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |
	*/

	/* Set up the housekeeping SPI to be connected internally so	*/
	/* that external pin changes don't affect it.			*/

    reg_spi_enable = 1;
    reg_wb_enable = 1;
	// reg_spimaster_config = 0xa002;	// Enable, prescaler = 2,
                                        // connect to housekeeping SPI

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

    reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_27 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_26 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_25 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_24 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_23 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_22 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_21 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_20 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_19 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_MGMT_STD_OUTPUT;


	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);


    
    /* Testbench start condition starts the simulation*/
	reg_mprj_datal = 0xAB600000;


    uint32_t *to_wb = (uint32_t *) &reg_mprj_slave;        //wb base addr

    //------ REGS ADDRs table (WSB) 
    uint8_t TIME_UP_1 = 0;           //1 0
    uint8_t TIME_DOWN_1 = 1;         //2 4
    uint8_t TIME_UP_2 = 2;           //3 8
    uint8_t TIME_DOWN_2 = 3;        //.. C
    uint8_t TIME_UP_3 = 4;          
    uint8_t TIME_DOWN_3 = 5;
    uint8_t TIME_UP_4 = 6;
    uint8_t TIME_DOWN_4 = 7;
    uint8_t TIME_UP_5 = 8;
    uint8_t TIME_DOWN_5 = 9;
    uint8_t TIME_UP_6 = 10;
    uint8_t TIME_DOWN_6 = 11;
    uint8_t TIME_UP_7 = 12;
    uint8_t TIME_DOWN_7 = 13;
    uint8_t COUNT_UP = 14;
    uint8_t COUNT_DOWN = 15;
    uint8_t COUNT_VALUE = 16;
    uint8_t Q = 17;

    // uint8_t VD1 = 14;
    // uint8_t VD2 = 15;
    // uint8_t SW1 = 16;
    // uint8_t SW2 = 17;
    // uint8_t SH = 18;
    // uint8_t SH_COMP = 19;
    // uint8_t SH_RST = 20;
    // uint8_t COUNTER_RST = 21;
    // uint8_t CMP_TMR = 22;

    // Introducing data using WB inetrface
    to_wb[TIME_DOWN_1] = 775;
    to_wb[TIME_UP_1] = 776; 
    to_wb[TIME_UP_2] = 333;
    to_wb[TIME_DOWN_2] = 444;

    /* Testbench $finish condition stops the simulation*/
    reg_mprj_datal = 0xAB610000;
   
}