
//
// Signal 1 FSM VD1
//
module vd1_fsm (clk, reset, count, time_up_vd1, time_down_vd1, vd1);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_vd1, time_down_vd1;
	output reg vd1;
	reg [1:0] state;
	reg [1:0] next_state;
	//reg [9:0] time_up_vd1, time_down_vd1;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	//	time_up_vd1 = 1000; //10us equals to 1000 counts of 10ns (10MHz)
	//	time_down = 2000; //20 us
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_up_vd1)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_up_vd1)==time_down_vd1)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					vd1 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					vd1 = 1'b1;
					end
					
			FINAL_STATE:	begin
					vd1 = 1'b0;
					end
		endcase
	end

endmodule


//
// Signal 2 FSM VD2
//
module vd2_fsm (clk, reset, count, time_up_vd2, time_down_vd2, vd2);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_vd2, time_down_vd2;
	output reg vd2;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_vd2)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_vd2)==time_up_vd2)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					vd2 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					vd2 = 1'b0;
					end
					
			FINAL_STATE:	begin
					vd2 = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 3 FSM SW1
//
module sw1_fsm (clk, reset, count, time_up_sw1, time_down_sw1, sw1);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sw1, time_down_sw1;
	output reg sw1;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_up_sw1)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_up_sw1)==time_down_sw1)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sw1 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sw1 = 1'b1;
					end
					
			FINAL_STATE:	begin
					sw1 = 1'b0;
					end
		endcase
	end

endmodule

//
// Signal 4 FSM SW2
//
module sw2_fsm (clk, reset, count, time_up_sw2, time_down_sw2, sw2);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sw2, time_down_sw2;
	output reg sw2;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sw2)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sw2)==time_up_sw2)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sw2 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sw2 = 1'b0;
					end
					
			FINAL_STATE:	begin
					sw2 = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 5 FSM SH
//
module sh_fsm (clk, reset, count, time_up_sh, time_down_sh, sh);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sh, time_down_sh;
	output reg sh;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sh)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sh)==time_up_sh)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sh = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sh = 1'b0;
					end
					
			FINAL_STATE:	begin
					sh = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 6 FSM SH_CMP 
//
module sh_cmp_fsm (clk, reset, count, time_up_sh_cmp, time_down_sh_cmp, sh_cmp);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sh_cmp, time_down_sh_cmp;
	output reg sh_cmp;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sh_cmp)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sh_cmp)==time_up_sh_cmp)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sh_cmp = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sh_cmp = 1'b0;
					end
					
			FINAL_STATE:	begin
					sh_cmp = 1'b1;
					end
		endcase
	end

endmodule


//
// Signal 7 FSM SH_RST
//
module sh_reset_fsm (clk, reset, count, time_up_sh_reset, time_down_sh_reset, sh_reset);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sh_reset, time_down_sh_reset;
	output reg sh_reset;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sh_reset)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sh_reset)==time_up_sh_reset)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sh_reset = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sh_reset = 1'b0;
					end
					
			FINAL_STATE:	begin
					sh_reset = 1'b1;
					end
		endcase
	end

endmodule





//
// 12-bit Counter with Enable
//

module counter (clk, counter_reset, start, clr, q);
	input clk, counter_reset, start;
	output [11:0] q;
	input clr;
	reg [11:0] tmp;

	always @(posedge clk)
	begin
		if (counter_reset)
			tmp <= 12'b000000000000;

		else begin 
			if (clr) 
				tmp <= 12'b000000000000;
			else if (start)
				tmp <= tmp + 1;
		end

	end

	assign q = tmp;

endmodule



