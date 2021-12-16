/* State machine for jumping
 * this reads in keycodes and boundary and sends out
 * signals to physics module
 */
 
 
module jump_fsm( input Reset, frame_clk, jump_en, hit_ground,
					input [31:0] keycode,
               output int jump_x_motion,
					jump_y_motion);

	enum logic [5:0] {
		no_jump,
		jump_up_1,
		jump_up_2,
		jump_up_3,
		jump_up_4,
		jump_up_5,
		jump_up_6,
		jump_up_7,
		jump_up_8,
		jump_up_9,
		jump_up_10,
		jump_up_11,
		jump_up_12,
		jump_up_13,
		jump_up_14,
		jump_up_15,
		jump_up_16,
		jump_up_17,
		jump_up_18,
		jump_up_19,
		jump_up_20
		
	} state, next_state;

	always_ff @ (posedge Reset or posedge frame_clk)
	begin
		if (Reset)
			state <= no_jump;
		else
			state <= next_state;
	end
	
	always_comb
	begin
		jump_x_motion = 0;
		jump_y_motion = 0;
		if (hit_ground)
			next_state = no_jump;
		else
			next_state = state;
		// jump state machine
		unique case (state)
			no_jump :
				if (jump_en)
					next_state = jump_up_1;
				else
					next_state = no_jump;
			
			jump_up_1 :
				next_state = jump_up_2;
			jump_up_2 :
				next_state = jump_up_3;
			jump_up_3 :
				next_state = jump_up_4;
			jump_up_4 :
				next_state = jump_up_5;
			jump_up_5 :
				next_state = jump_up_6;
			jump_up_6 :
				next_state = jump_up_7;
			jump_up_7 :
				next_state = jump_up_8;
			jump_up_8 :
				next_state = jump_up_9;
			jump_up_9 :
				next_state = jump_up_10;
			jump_up_10 :
				next_state = jump_up_11;
			jump_up_11 :
				next_state = jump_up_12;
			jump_up_12:
				next_state = jump_up_13;
			jump_up_13 :
				next_state = jump_up_14;
			jump_up_14 :
				next_state = jump_up_15;
			jump_up_15 :
				next_state = jump_up_16;
			jump_up_16 :
				next_state = jump_up_17;
			jump_up_17 :
				next_state = jump_up_18;
			jump_up_18 :
				next_state = jump_up_19;
			jump_up_19 :
				next_state = jump_up_20;
			jump_up_20 :
				next_state =no_jump;
			
			default : ;
		endcase
		
		// assign base velocities for movement
		case (state)
			no_jump : begin
				jump_x_motion = 0;
				jump_y_motion = 0;
			end
			
			jump_up_1 : jump_y_motion = -12;
			jump_up_2 : jump_y_motion = -12;
			jump_up_3 : jump_y_motion = -12;
			jump_up_4 : jump_y_motion = -12;
			jump_up_5 : jump_y_motion = -10;
			jump_up_6 : jump_y_motion = -10;
			jump_up_7 : jump_y_motion = -10;
			jump_up_8 : jump_y_motion = -10;
			jump_up_9 : jump_y_motion = -8;
			jump_up_10 : jump_y_motion = -8;
			jump_up_11 : jump_y_motion = -6;
			jump_up_12 : jump_y_motion = -6;
			jump_up_13 : jump_y_motion = -4;
			jump_up_14 : jump_y_motion = -4;
			jump_up_15 : jump_y_motion = -2;
			jump_up_16 : jump_y_motion = -2;
			jump_up_17 : jump_y_motion = -2;
			jump_up_18 : jump_y_motion = -2;
			jump_up_19 : jump_y_motion = 0;
			jump_up_20 : jump_y_motion = 0;
			
			default : ;
		
		endcase
		
		
		
	end
	
endmodule
	
	

	
	
	
