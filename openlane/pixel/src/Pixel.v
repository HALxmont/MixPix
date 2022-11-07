//
// Pixel FSM
//
module pixel_fsm (clk, reset, pxl_start_i, loc_timer_m_i, loc_timer_en, adj_timer_m_i, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, sh, pxl_done_o);
	input clk, reset, pxl_start_i, loc_timer_m_i, adj_timer_m_i;
	output reg loc_timer_en, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, sh, pxl_done_o;
	reg [2:0] state;
	reg [2:0] next_state;
// State encoding
	parameter RESET = 3'b000; parameter LOC_PIXEL = 3'b001; parameter IDLE = 3'b010; 
	parameter ADJ_PIXEL = 3'b011; parameter SAM_PIXEL = 3'b100; parameter PXL_DONE = 3'b101;
// Initial state	
	initial begin
		state = 3'b000;
	end
// Reset, if high, stay in state RESET, otherwise go to the next state
	always @(posedge clk or posedge reset)// or loc_timer_m_i or adj_timer_m_i)
	begin
		if (reset) state <= RESET;
		else state <= next_state;
	end
// Next state equations
	always @(state or pxl_start_i or loc_timer_m_i or adj_timer_m_i)
	begin
		case (state)
			RESET:		if (pxl_start_i==1'b0) begin
						next_state = RESET; end
					else begin
						next_state = LOC_PIXEL; end
			
			LOC_PIXEL: 	if (loc_timer_m_i==1'b0) begin
						next_state = LOC_PIXEL; end
					else begin
						next_state = IDLE;	end		
			
			IDLE: next_state = ADJ_PIXEL;
			
			ADJ_PIXEL: 	if (adj_timer_m_i==1'b0) begin
						next_state = ADJ_PIXEL; end
					else begin
						next_state = SAM_PIXEL; end
			
			SAM_PIXEL: next_state = PXL_DONE;			

			PXL_DONE: next_state = RESET;
		endcase
	end
// Outputs driven by each state	
	always @(state)
	begin
		case (state)
			RESET:		begin
						loc_timer_en = 1'b0;
						adj_timer_en = 1'b0;
						s_p1 = 1'b0;
						s_p2 = 1'b0; 
						s1 = 1'b0; 
						s1_inv = ~s1;
						s2 = 1'b0;
						s2_inv = ~s2;
						v_b1 = 1'b0;
						v_b0 = ~v_b1;
						sh = 1'b0;
						pxl_done_o = 1'b0;
					end
				
			LOC_PIXEL:	begin 
						loc_timer_en = 1'b1;
						adj_timer_en = 1'b0;
						s_p1 = 1'b1; 
						s_p2 = 1'b0; 
						s1 = 1'b1;
						s1_inv = ~s1; 
						s2 = 1'b0;
						s2_inv = ~s2; 
						v_b1 = 1'b1; 
						v_b0 = ~v_b1;
						sh = 1'b0;
						pxl_done_o = 1'b0;
					end
			
			IDLE:		begin 
						loc_timer_en = 1'b0;
						adj_timer_en = 1'b0;
						s_p1 = 1'b0; 
						s_p2 = 1'b0; 
						s1 = 1'b0; 
						s1_inv = ~s1;
						s2 = 1'b0; 
						s2_inv = ~s2;
						v_b1 = 1'b0; 
						v_b0 = ~v_b1;
						sh = 1'b0;						
						pxl_done_o = 1'b0;
					end
				
			ADJ_PIXEL: 	begin
						loc_timer_en = 1'b0;
						adj_timer_en = 1'b1;
						s_p1 = 1'b0; 
						s_p2 = 1'b1;
						s1 = 1'b0;
						s1_inv = ~s1;
						s2 = 1'b1; 
						s2_inv = ~s2;
						v_b1 = 1'b1; 
						v_b0 = ~v_b1;
						sh = 1'b0;						
						pxl_done_o = 1'b0;
					end
				
			SAM_PIXEL: 	begin
						loc_timer_en = 1'b0;
						adj_timer_en = 1'b0;
						s_p1 = 1'b0; 
						s_p2 = 1'b0;
						s1 = 1'b0;
						s1_inv = ~s1;
						s2 = 1'b0; 
						s2_inv = ~s2;
						v_b1 = 1'b1; 
						v_b0 = ~v_b1;
						sh = 1'b1;						
						pxl_done_o = 1'b0;
					end	
				
								
			PXL_DONE:	begin 
						loc_timer_en = 1'b0;
						adj_timer_en = 1'b0;
						s_p1 = 1'b0; 
						s_p2 = 1'b0; 
						s1 = 1'b0; 
						s1_inv = ~s1;
						s2 = 1'b0; 
						s2_inv = ~s2;
						v_b1 = 1'b0; 
						v_b0 = ~v_b1;
						sh = 1'b0;						
						pxl_done_o = 1'b1;
					end
		endcase
	end

endmodule

// Local timer module, keeps track of the time necessary to integrate the current of the local photodiode

module loc_timer_int(clk, reset, loc_timer_en, loc_max_clk, loc_timer_max);
	input clk, reset, loc_timer_en;
	input [9:0] loc_max_clk; 
	output loc_timer_max;
	reg [9:0] loc_timer_q;
//Max value of timer in clock cycles; Valor máximo timer en pulsos de reloj	
//	localparam LOC_MAX_CLK = 400;	
	initial begin
		loc_timer_q = 10'b0000000000;
	end

	always @(posedge clk or posedge reset)
	begin
		if (reset) 	
			loc_timer_q <= 10'b0;	
		else if (!loc_timer_en||(loc_timer_q == loc_max_clk))
			loc_timer_q <= 10'b0;
		else
			loc_timer_q <= loc_timer_q+1;
	end

//Assigns timer_max to max value of timer;  Asignar salida timer_max a máximo valor del timer
	assign loc_timer_max = (loc_timer_q == loc_max_clk);
endmodule	

// Adjacent timer module, keeps track of the time necessary to integrate the current of the adjacent photodiode

module adj_timer_int(clk, reset, adj_timer_en, adj_max_clk, adj_timer_max);
	input clk, reset, adj_timer_en;
	input [9:0] adj_max_clk;
	output adj_timer_max;
	reg [9:0] adj_timer_q;
//Max value of timer in clock cycles; Valor máximo timer en pulsos de reloj	
//	localparam ADJ_MAX_CLK = 400;	
	initial begin
		adj_timer_q = 10'b0000000000;
	end

	always @(posedge clk or posedge reset)
	begin
		if (reset) 	
			adj_timer_q <= 10'b0;	
		else if (!adj_timer_en||(adj_timer_q == adj_max_clk))
			adj_timer_q <= 10'b0;
		else
			adj_timer_q <= adj_timer_q+1;
	end

//Assigns timer_max to max value of timer;  Asignar salida timer_max a máximo valor del timer
	assign adj_timer_max = (adj_timer_q == adj_max_clk);
endmodule	



// Sampling timer module, keeps track of the time necessary to sample the pixel voltage signal  (100ns)
/*
module sam_timer_int(clk, reset, sam_timer_en, sam_max_clk, sam_timer_max);
	input clk, reset, sam_timer_en;
	input [9:0] sam_max_clk;
	output sam_timer_max;
	reg [9:0] sam_timer_q;
//Max value of timer in clock cycles; Valor máximo timer en pulsos de reloj	
//	localparam ADJ_MAX_CLK = 400;	
	initial begin
		sam_timer_q = 10'b0000000000;
	end

	always @(posedge clk or posedge reset)
	begin
		if (reset) 	
			sam_timer_q <= 10'b0;	
		else if (!sam_timer_en||(sam_timer_q == sam_max_clk))
			sam_timer_q <= 10'b0;
		else
			sam_timer_q <= sam_timer_q+1;
	end

//Assigns timer_max to max value of timer
	assign sam_timer_max = (sam_timer_q == sam_max_clk);
endmodule	
*/

// Pixel Counter, counts every time a Pixel_Done signal is asserted
// When 9 gradients are done, send a signal to indicate kernel done
module pixel_counter (clk, reset, pxl_done_i, pxl_q, kernel_done_o);
	input clk, reset, pxl_done_i;
	output kernel_done_o;
	output [3:0] pxl_q;
	reg [3:0] pxl_tmp;
	reg kernel_done_o = 0;
	wire pixel_count_max;
	
	initial begin
		pxl_tmp = 4'b0000;
	end


	always @(posedge clk or posedge reset)
	begin
		if (reset)
			pxl_tmp <= 4'b0001;		//Start from 1
		else if (kernel_done_o)
			pxl_tmp <= 4'b0000;		//Start from 0
		else if (pxl_done_i)
			pxl_tmp <= pxl_tmp + 1'b1;	//Increase 1
	end

	assign pxl_q = pxl_tmp;
	assign pixel_count_max = (pxl_q == 4'b1010); // Counts until 9 pixels
	
	always @(posedge clk) 
	begin
    		kernel_done_o <= pixel_count_max;
	end   	

	
endmodule


// Multiplexer for clock signal
module clk_mux (clk_in_ext, clk_in_wb, clk_sel, clk_out);
		input clk_in_ext, clk_in_wb;
		input [1:0] clk_sel; 
		output reg clk_out;
		
		always @(clk_in_ext or clk_in_wb or clk_sel) 
		begin
			case (clk_sel)
   			2'b00 : clk_out = clk_in_ext;
			2'b01 :	clk_out = clk_in_wb;
			2'b10 : clk_out = 0;
			2'b11 : clk_out = 0;
			default : begin clk_out = clk_in_ext; end
    			endcase   
		end
endmodule

// Multiplexer for reset signal
module reset_mux (reset_in_ext, reset_in_wb, reset_sel, reset_out);
		input reset_in_ext, reset_in_wb;
		input [1:0] reset_sel; 
		output reg reset_out;
		
		always @(reset_in_ext, reset_in_wb, reset_sel) 
		begin
			case (reset_sel)
   			2'b00 : reset_out = reset_in_ext;
			2'b01 :	reset_out = reset_in_wb;
			2'b10 : reset_out = 0;
			2'b11 : reset_out = 0;
			default : begin reset_out = reset_in_ext; end
    			endcase   
		end
endmodule


// Multiplexer for pixel_start signal
module pxl_start_mux (pxl_start_in_ext, pxl_start_in_wb, pxl_start_sel, pxl_start_out);
		input pxl_start_in_ext, pxl_start_in_wb;
		input [1:0] pxl_start_sel; 
		output reg pxl_start_out;
		
		always @(pxl_start_in_ext or pxl_start_in_wb or pxl_start_sel) 
		begin
			case (pxl_start_sel)
   			2'b00 : pxl_start_out = pxl_start_in_ext;
			2'b01 :	pxl_start_out = pxl_start_in_wb;
			2'b10 : pxl_start_out = 0;
			2'b11 : pxl_start_out = 0;
			default : begin pxl_start_out = pxl_start_in_ext; end
    			endcase   
		end
endmodule


// Complete module instantiation and wiring
module pixel (clk, reset, pxl_start_i, loc_timer_m_i, loc_timer_en, adj_timer_m_i, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, sh, pxl_done_o, loc_timer_max, loc_max_clk, adj_timer_max, adj_max_clk, pxl_done_i, pxl_q, kernel_done_o, clk_in_ext, clk_in_wb, clk_sel, clk_out, reset_in_ext, reset_in_wb, reset_sel, reset_out, pxl_start_in_ext, pxl_start_in_wb, pxl_start_sel, pxl_start_out);
	input clk, reset, pxl_start_i, loc_timer_m_i, adj_timer_m_i, pxl_done_i, clk_in_ext, clk_in_wb, reset_in_ext, reset_in_wb, pxl_start_in_ext, pxl_start_in_wb;
	input [9:0] loc_max_clk, adj_max_clk;
	input [1:0] clk_sel, reset_sel, pxl_start_sel; 
	output [3:0] pxl_q;
	output loc_timer_en, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, sh, pxl_done_o, loc_timer_max, adj_timer_max, kernel_done_o, clk_out, reset_out, pxl_start_out;



//Define internal nets for wiring
	wire loc_timer_m_i_net, adj_timer_m_i_net, pxl_done_i_net, clk_net, reset_net, pxl_start_i_net;
	assign loc_timer_m_i_net = loc_timer_max;
	assign adj_timer_m_i_net = adj_timer_max;
	assign pxl_done_i_net = pxl_done_o;
	assign clk_net = clk_out;
	assign reset_net = reset_out;
	assign pxl_start_i_net = pxl_start_out;

	pixel_fsm inst1(
	.clk(clk_net),
	.reset(reset_net),
	.pxl_start_i(pxl_start_i_net),
	.loc_timer_en(loc_timer_en),
	.loc_timer_m_i(loc_timer_m_i_net),
	.adj_timer_en(adj_timer_en),
	.adj_timer_m_i(adj_timer_m_i_net),
	.s_p1(s_p1),
	.s_p2(s_p2),
	.s1(s1),
	.s1_inv(s1_inv),
	.s2(s2),
	.s2_inv(s2_inv),
	.v_b1(v_b1),
	.v_b0(v_b0),
	.sh(sh),
	.pxl_done_o(pxl_done_o)
	);
	
	loc_timer_int inst2(
	.clk(clk_net),
	.loc_timer_en(loc_timer_en),
	.loc_max_clk(loc_max_clk),
	.loc_timer_max(loc_timer_max)
	);	
	
	adj_timer_int inst3(
	.clk(clk_net),
	.adj_timer_en(adj_timer_en),
	.adj_max_clk(adj_max_clk),
	.adj_timer_max(adj_timer_max)
	);

	pixel_counter inst4(
	.clk(clk_net),
	.reset(reset_net),
	.pxl_done_i(pxl_done_i_net),
	.pxl_q(pxl_q),
	.kernel_done_o(kernel_done_o)
	);
	
	clk_mux inst5(
	.clk_in_ext(clk_in_ext),
	.clk_in_wb(clk_in_wb),
	.clk_sel(clk_sel),
	.clk_out(clk_out)
	);
	
	reset_mux inst6(
	.reset_in_ext(reset_in_ext),
	.reset_in_wb(reset_in_wb),
	.reset_sel(reset_sel),
	.reset_out(reset_out)
	);
	
	pxl_start_mux inst7(
	.pxl_start_in_ext(pxl_start_in_ext),
	.pxl_start_in_wb(pxl_start_in_wb),
	.pxl_start_sel(pxl_start_sel),
	.pxl_start_out(pxl_start_out)
	);
	
		
endmodule


