//
// Pixel FSM
//
module pixel_fsm (clk, reset, pxl_start_i, loc_timer_m_i, loc_timer_en, adj_timer_m_i, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, pxl_done_o);
	input clk, reset, pxl_start_i, loc_timer_m_i, adj_timer_m_i;
	output reg loc_timer_en, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, pxl_done_o;
	reg [2:0] state;
	reg [2:0] next_state;
// State encoding
	parameter RESET = 3'b000; parameter LOC_PIXEL = 3'b001; parameter IDLE = 3'b010; 
	parameter ADJ_PIXEL = 3'b011; parameter PXL_DONE = 3'b100;
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
						next_state = PXL_DONE; end			

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


// Pixel Counter, counts every time a Pixel_Done signal is asserted
// When 9 gradients are done, send a signal to indicate kernel done
module pixel_counter (clk, reset, pxl_done_i, pxl_q, kernel_done_o);
	input clk, reset, pxl_done_i;
	output kernel_done_o;
	output [3:0] pxl_q;
	reg [3:0] pxl_tmp;
	reg kernel_done_o = 0;
	wire pixel_count_max;

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

// Demuxer 4:16 
module demux (data_in, data_sel, data_out);
		input data_in;
		input [3:0] data_sel; 
		output reg [15:0] data_out;
		
		always @(data_in, data_sel) 
		begin
			case (data_sel)
   			4'b0000 : begin data_out[15:0] = 0; end 
			4'b0001 : begin data_out[0] = data_in; data_out[15:1] = 0; end 
			4'b0010 : begin data_out[1] = data_in; data_out[0] = 0; end 
			4'b0011 : begin data_out[2] = data_in; data_out[1:0] = 0; end 
			4'b0100 : begin data_out[3] = data_in; data_out[2:0] = 0; end 
			4'b0101 : begin data_out[4] = data_in; data_out[3:0] = 0; end 
			4'b0110 : begin data_out[5] = data_in; data_out[4:0] = 0; end 
			4'b0111 : begin data_out[6] = data_in; data_out[5:0] = 0; end 
			4'b1000 : begin data_out[7] = data_in; data_out[6:0] = 0; end 
			4'b1001 : begin data_out[8] = data_in; data_out[7:0] = 0; end 
			4'b1010 : begin data_out[9] = data_in; data_out[8:0] = 0; end 
			4'b1011 : begin data_out[10] = data_in; data_out[9:0] = 0; end 
			4'b1100 : begin data_out[11] = data_in; data_out[10:0] = 0; end 
			4'b1101 : begin data_out[12] = data_in; data_out[11:0] = 0; end 
			4'b1110 : begin data_out[13] = data_in; data_out[12:0] = 0; end 
			4'b1111 : begin data_out[14] = data_in; data_out[13:0] = 0; end 
			default : begin data_out[15:0] = 0; end
    			endcase   
		end
endmodule


// Complete module instantiation and wiring
module pixel (clk, reset, pxl_start_i, loc_timer_m_i, loc_timer_en, adj_timer_m_i, adj_timer_en, 
			s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, pxl_done_o, 
			loc_timer_max, loc_max_clk, adj_timer_max, adj_max_clk, pxl_done_i, pxl_q, 
			kernel_done_o, data_in, data_sel, data_out);
	input clk, reset, pxl_start_i, loc_timer_m_i, adj_timer_m_i, pxl_done_i, data_in;
	input [9:0] loc_max_clk, adj_max_clk;
	output [3:0] pxl_q, data_sel;
	output loc_timer_en, adj_timer_en, s_p1, s_p2, s1, s2, s1_inv, s2_inv, v_b1, v_b0, pxl_done_o, loc_timer_max, adj_timer_max, kernel_done_o;
	output [15:0] data_out;

//Define internal nets for wiring
	wire loc_timer_m_i_net, adj_timer_m_i_net, pxl_done_i_net, s_p1_net, s_p2_net, s1_net, s2_net, s1_inv_net, s2_inv_net, v_b1_net, v_b0_net;
	wire [3:0] data_sel_net;
	assign loc_timer_m_i_net = loc_timer_max;
	assign adj_timer_m_i_net = adj_timer_max;
	assign pxl_done_i_net = pxl_done_o;
	assign data_sel_net = pxl_q;
	assign s_p1_net = s_p1;
	assign s_p2_net = s_p2;
	assign s1_net = s1;
	assign s2_net = s2;
	assign s1_inv_net = s1_inv;
	assign s2_inv_net = s2_inv;
	assign v_b1_net = v_b1;
	assign v_b0_net = v_b0;
		
	pixel_fsm inst1(
	.clk(clk),
	.reset(reset),
	.pxl_start_i(pxl_start_i),
	.pxl_done_o(pxl_done_o),
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
	.v_b0(v_b0)
	);
	
	loc_timer_int inst2(
	.clk(clk),
	.loc_timer_en(loc_timer_en),
	.loc_max_clk(loc_max_clk),
	.loc_timer_max(loc_timer_max)
	);	
	
	adj_timer_int inst3(
	.clk(clk),
	.adj_timer_en(adj_timer_en),
	.adj_max_clk(adj_max_clk),
	.adj_timer_max(adj_timer_max)
	);

	pixel_counter inst4(
	.clk(clk),
	.reset(reset),
	.pxl_done_i(pxl_done_i_net),
	.pxl_q(pxl_q),
	.kernel_done_o(kernel_done_o)
	);
	
	demux demux_sp1(
	.data_in(s_p1_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
	demux demux_sp2(
	.data_in(s_p2_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
	demux demux_s1(
	.data_in(s1_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
	demux demux_s2(
	.data_in(s2_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);

	demux demux_s1_inv(
	.data_in(s1_inv_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
	demux demux_s2_inv(
	.data_in(s2_inv_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
	demux demux_vb1(
	.data_in(v_b1_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
	demux demux_vb0(
	.data_in(v_b0_net),
	.data_sel(data_sel_net),
	.data_out(data_out)
	);
	
endmodule


