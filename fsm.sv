/* State machine for jumping
 * this reads in keycodes and boundary and sends out
 * signals to physics module
 *
 *
 *
 */
 
 
module fsm( input Reset, frame_clk, jump_en,
					input [31:0] keycode,
               output [9:0] jump_x_motion,
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
		jump_up_20,
		jump_up_21,
		jump_up_22,
		jump_up_23,
		jump_up_24,
		jump_up_25,
		jump_up_26,
		jump_up_27,
		jump_up_28,
		jump_up_29,
		jump_up_30,
		jump_up_31,
		jump_up_32,
		jump_up_33,
		jump_up_34,
		jump_up_35,
		jump_up_36,
		jump_up_37,
		jump_up_38,
		jump_up_39,
		jump_up_40
		
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
		next_state = state;
		// jump motion
		jump_x_motion = 0;
		jump_y_motion = 0;
	
		
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
				next_state = jump_up_21;
			jump_up_21 :
				next_state = jump_up_22;
			jump_up_22 :
				next_state = jump_up_23;
			jump_up_23 :
				next_state = jump_up_24;
			jump_up_24 :
				next_state = jump_up_25;
			jump_up_25 :
				next_state = jump_up_26;
			jump_up_26 :
				next_state = jump_up_27;
			jump_up_27 :
				next_state = jump_up_28;
			jump_up_28 :
				next_state = jump_up_29;
			jump_up_29 :
				next_state = jump_up_30;
			jump_up_30 :
				next_state = jump_up_31;
			jump_up_31:
				next_state = jump_up_32;
			jump_up_32 :
				next_state = jump_up_33;
			jump_up_33 :
				next_state = jump_up_34;
			jump_up_34 :
				next_state = jump_up_35;
			jump_up_35 :
				next_state = jump_up_36;
			jump_up_36 :
				next_state = jump_up_37;
			jump_up_37 :
				next_state = jump_up_38;
			jump_up_38 :
				next_state = jump_up_39;
			jump_up_39 :
				next_state = jump_up_40;
			jump_up_40 :
				next_state = no_jump;
				
//			jump_left_1 :
//				next_state = jump_left_2;
//			jump_left_2 :
//				next_state = no_jump;
//			jump_right :
//				next_state = no_jump;
			default : ;
		endcase
		
		// assign base velocities for movement
		case (state)
			no_jump : begin
				jump_x_motion = 0;
				jump_y_motion = 0;
			end
//			jump_left_1 : begin
//				jump_x_motion = -4;
//				jump_y_motion = 4;
//			end
//			jump_left_2 : begin
//				jump_x_motion = -4;
//				jump_y_motion = -4;
//			end
			
			jump_up_1 : jump_y_motion = -4;
			jump_up_2 : jump_y_motion = -4;
			jump_up_3 : jump_y_motion = -4;
			jump_up_4 : jump_y_motion = -4;
			jump_up_5 : jump_y_motion = -4;
			jump_up_6 : jump_y_motion = -4;
			jump_up_7 : jump_y_motion = -2;
			jump_up_8 : jump_y_motion = -2;
			jump_up_9 : jump_y_motion = -2;
			jump_up_10 : jump_y_motion = -2;
			jump_up_11 : jump_y_motion = -1;
			jump_up_12 : jump_y_motion = -1;
			jump_up_13 : jump_y_motion = -1;
			jump_up_14 : jump_y_motion = -1;
			jump_up_15 : jump_y_motion = 0;
			jump_up_16 : jump_y_motion = 0;
			jump_up_17 : jump_y_motion = 0;
			jump_up_18 : jump_y_motion = 0;
			jump_up_19 : jump_y_motion = 0;
			jump_up_20 : jump_y_motion = 0;
			jump_up_21 : jump_y_motion = 0;
			jump_up_22 : jump_y_motion = 0;
			jump_up_23 : jump_y_motion = 1;
			jump_up_24 : jump_y_motion = 1;
			jump_up_25 : jump_y_motion = 1;
			jump_up_26 : jump_y_motion = 1;
			jump_up_27 : jump_y_motion = 2;
			jump_up_28 : jump_y_motion = 2;
			jump_up_29 : jump_y_motion = 2;
			jump_up_30 : jump_y_motion = 2;
			jump_up_31 : jump_y_motion = 4;
			jump_up_32 : jump_y_motion = 4;
			jump_up_33 : jump_y_motion = 4;
			jump_up_34 : jump_y_motion = 4;
			jump_up_35 : jump_y_motion = 4;
			jump_up_36 : jump_y_motion = 4;
			jump_up_37 : jump_y_motion = 0;
			jump_up_38 : jump_y_motion = 0;
			jump_up_39 : jump_y_motion = 0;
			jump_up_40 : jump_y_motion = 0;
			
//			jump_right : begin
//			
//			end
//			jump_up : begin
//			end
			
			default : ;
		
		endcase
		
		
		
	end
	
endmodule
	
	

	
	
	
