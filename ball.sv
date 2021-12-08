//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, pixel_clk, Clk, blank,
					input [31:0] keycode,
					input [9:0] DrawX, DrawY, g_prev,
               output [9:0]  BallX, BallY, BallSizeX, BallSizeY, g,
				   output logic [7:0]  Red, Green, Blue
					);
					
			
	
	fsm F(.Reset(Reset_h),
		.frame_clk(Clk), //should it be frame_clk?
		.jump_en(jump_en),
		.keycode(keycode),
		.jump_x_motion(jump_x_motion),
		.jump_y_motion(jump_y_motion),
		);
 
	// logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size_X, Ball_Size_Y, vx_test;
	logic [9:0] jump_x_motion, jump_y_motion;
	logic jump_en;

	parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
	parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
	parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
	parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
	parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
	parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

	assign Ball_Size_X = 16; 	// assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign Ball_Size_Y = 24;
	
	// logic hit_boundary_left, hit_boundary_right, hit_boundary_up, hit_boundary_down;
	
	logic [2:0] LOCAL_REG [15][20];
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
		 
		if (1'b1) begin
//			int i,j;
//			for(i = 0; i < 15; i++)
//			begin
//				for(j = 0; j < 20; j++)
//				begin
//					LOCAL_REG[i][j] <= i + j;
//				end
//			end
			int i,j;
			for(i = 0; i < 15; i++) begin
				for(j = 0; j < 20; j++) begin
					if (i >= 11)
						LOCAL_REG[i][j] <= 3'b111;
					else
						LOCAL_REG[i][j] <= 3'b000;
					end
			end
			LOCAL_REG[10][16] <= 3'b111;
			LOCAL_REG[10][17] <= 3'b111;
			LOCAL_REG[10][18] <= 3'b111;
			LOCAL_REG[10][19] <= 3'b111;
			LOCAL_REG[9][18] <= 3'b111;
			LOCAL_REG[9][17] <= 3'b111;
		end
		
		else
		begin
		end
	end
	
	
	
	
	
	
	
	
	
logic [3:0] gravity, gravity_next;
logic [9:0] self_vx, self_vy, self_x, self_y, vx_test, self_x0, self_y0;
logic [9:0] self_vx_next, self_vy_next, self_x_next, self_y_next, vx_test_next;
parameter [3:0] v_terminal=10; // maximum y motion when falling
int v;

always_comb begin
	// default values
    gravity_next = gravity;
	self_vx_next = self_vx;
	self_vy_next = self_vy;
	self_x_next = self_x;
	self_y_next = self_y;
	vx_test_next = vx_test;

    // Calculate gravity_next
	// case (keycode)
		// Combination of W & A. Go NorthWest
		// 32'h00001A04, 32'h0000041A : begin
			// self_vx_next = -2;//top left
			// self_vy_next = -10;
			// jump_en = 1'b0;
			// end

		// Combination of W & D. Go NorthEast
		// 32'h00001A07, 32'h00000071A : begin
			// self_vx_next = 2;
			// self_vy_next = -10;
			// jump_en = 1'b0;
			// end

		// 32'h1A : begin
			// jump_en = 1'b0;
			// self_vy_next = -10;
			// self_vx_next = 0;
			// end

		// 32'h04 : begin
			// jump_en = 1'b0;
			// self_vx_next = -2;//A
			// self_vy_next = 0;
			// end

		// 32'h07 : begin
			// right (D)
			// self_vx_next = 2;
			// jump_en = 1'b0;
			// self_vy_next = 0;
			// end

		// default: begin
			// jump_en = 1'b0;
			// self_vy_next = 0;
			// self_vx_next = 0;
			// gravity_next = 0;
			// end	 
	// endcase 
	
	if (LOCAL_REG[(self_y+(gravity+1
			))>>5][self_x>>5] !== 3'b111)begin
			if (1+gravity > v_terminal)
				gravity_next = v_terminal;
			else
				gravity_next = 1+gravity;
				// may instead do an increment by 0.5?
				// or implement a counter
	end else if (LOCAL_REG[(self_y+gravity+1)>>5][self_x>>5] === 3'b111) begin
		gravity_next = 0;
		if(LOCAL_REG[(self_y+9)>>5][self_x>>5]!==3'b111)gravity_next=9;
		else if(LOCAL_REG[(self_y+8)>>5][self_x>>5]!==3'b111)gravity_next=8;
		else if(LOCAL_REG[(self_y+7)>>5][self_x>>5]!==3'b111)gravity_next=7;
		else if(LOCAL_REG[(self_y+6)>>5][self_x>>5]!==3'b111)gravity_next=6;
		else if(LOCAL_REG[(self_y+5)>>5][self_x>>5]!==3'b111)gravity_next=5;
		else if(LOCAL_REG[(self_y+4)>>5][self_x>>5]!==3'b111)gravity_next=4;
		else if(LOCAL_REG[(self_y+3)>>5][self_x>>5]!==3'b111)gravity_next=3;
		else if(LOCAL_REG[(self_y+2)>>5][self_x>>5]!==3'b111)gravity_next=2;
		else if(LOCAL_REG[(self_y+1)>>5][self_x>>5]!==3'b111)gravity_next=1;


	end
	
	// pixel overlap test
	if (LOCAL_REG[(self_y)>>5][self_x>>5] === 3'b111)
		self_vx_next = 1;
	else if (LOCAL_REG[(self_y)>>5][self_x>>5] !== 3'b111) begin
		self_vx_next = 0;
	end
		
	self_x_next = (self_x + self_vx_next);
	self_y_next = (self_y + self_vy_next + gravity_next);
	
	
end

logic [9:0] key_vx, key_vy;
always_ff @ (posedge Reset or posedge frame_clk) begin
	if(Reset) begin
		gravity <= 4'd0;
		self_x <= 10;
		self_y <= 3;
		self_vx <= 10'd0;
		self_vy <= 10'd0;
		vx_test <= 10'd0;
	end else begin
		case (keycode)
			// Combination of W & A. Go NorthWest
			32'h00001A04, 32'h0000041A : begin
				key_vx <= -2;//top left
				key_vy <= -10;
				end

			// Combination of W & D. Go NorthEast
			32'h00001A07, 32'h00000071A : begin
				key_vx <= 2;
				key_vy <= -10;
				end

			32'h1A : begin
				key_vy <= -10;
				key_vx <= 0;
				end

			32'h04 : begin
				key_vx <= -2;//A
				key_vy <= 0;
				end

			32'h07 : begin
				// right (D)
				key_vx <= 2;
				key_vy <= 0;
				end

			default: begin
				key_vy <= 0;
				key_vx <= 0;
				end	 
		endcase 
		gravity <= gravity_next;
		self_vx <= self_vx_next;
		self_vy <= self_vy_next;
		self_x <= self_x_next + key_vx;
		self_y <= self_y_next + key_vy;
		vx_test <= vx_test_next;
	end
	  
end

	
logic ball_on;
always_comb begin:Ball_on_proc
	if (DrawX === self_x && DrawY === self_y) 
		ball_on = 1'b1;
	else 
		ball_on = 1'b0;
end 
	
always_ff @ (posedge pixel_clk) begin:RGB_Display

	if(~blank) begin
		Red <= 8'h00;
		Green <= 8'h00;
		Blue <= 8'h00;
	end
	else if ((ball_on == 1'b1)) begin 
		Red <= 8'hff;
		Green <= 8'h55;
		Blue <= 8'h00;
	end
	else begin
		unique case (LOCAL_REG[DrawY[9:5]][DrawX[9:5]])
			3'b000, 3'b001, 3'b010, 3'b011 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h7f;
			end
			3'b100, 3'b101, 3'b110, 3'b111 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h50;
			end
		endcase
	
		end
	end









/*
always_ff @ (posedge Reset or posedge frame_clk) begin: Move_Ball
	if (Reset) begin // Asynchronous Reset 
		Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
		Ball_X_Motion <= 10'd0; //Ball_X_Step;
		// Ball_Y_Pos <= 479 - (4*32) - Ball_Size_Y +1 ; //do not overlap
		Ball_Y_Pos <= 11;
		Ball_X_Pos <= Ball_X_Center - 12;
		gravity <= 10'd0;
		vx_test <= 10'd0;
	end
	else begin
		// if ( (Ball_Y_Pos + 16) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
			// hit_boundary_down <= 1'b1;

		// else if ( (Ball_Y_Pos - 16) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
			// hit_boundary_up <= 1'b1;

		// else if ( (Ball_X_Pos + 8) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
			// hit_boundary_right <= 1'b1;  // 2's complement.

		// else if ( (Ball_X_Pos - 5) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
			// hit_boundary_left <= 1'b1;

		// else begin
			// hit_boundary_up <= 1'b0;
			// hit_boundary_down <= 1'b0;
			// hit_boundary_left <= 1'b0;
			// hit_boundary_right <= 1'b0;
		// end




//			 if (jump_x_motion === 0 && jump_y_motion === 0)
//			 begin
		case (keycode)

			// Combination of W & A. Go NorthWest
			32'h00001A04, 32'h0000041A : begin
				Ball_X_Motion <= -2;//top left
				jump_en <= 1'b1;
				end

			// Combination of W & D. Go NorthEast
			32'h00001A07, 32'h00000071A : begin
				Ball_X_Motion <= 2;
				jump_en <= 1'b1;
				end

			32'h1A : begin
				jump_en <= 1'b1;
				Ball_Y_Motion <= 0;
				Ball_X_Motion <= 0;
				end

			32'h04 : begin
				jump_en <= 1'b0;
				Ball_X_Motion <= -2;//A
				Ball_Y_Motion<= 0;
				end

			32'h07 : begin
				// right (D)
				Ball_X_Motion <= 0;
				jump_en <= 1'b0;
				Ball_Y_Motion <= 0;
				end

			default: begin
				jump_en <= 1'b0;
				Ball_Y_Motion <= 0;
				Ball_X_Motion <= 0;
				gravity <= 0;
				end	 
		endcase 
		// if (LOCAL_REG[(Ball_Y_Pos+ 2 )>>5][Ball_X_Pos>>5] !== 3'b111)
			// gravity <= 1;
		// else if (LOCAL_REG[(Ball_Y_Pos + 2)>>5][Ball_X_Pos>>5] === 3'b111) begin
			// gravity <= 0;
		// end
		
		// if (LOCAL_REG[(Ball_Y_Pos+ gravity + 1 )>>5][Ball_X_Pos>>5] !== 3'b111)
			// gravity <= 2;
		// else if (LOCAL_REG[(Ball_Y_Pos + gravity + 1)>>5][Ball_X_Pos>>5] === 3'b111) begin
			// gravity <= 0;
			// for(int v = 2; v >= 0; v=v-1) begin
				// if (LOCAL_REG[(Ball_Y_Pos+v + 1)>>5][Ball_X_Pos>>5] !== 3'b111) begin
					// gravity <= v;
					// break;
				// end
			// end
		// end
			
//		if (
//			(LOCAL_REG[(Ball_Y_Pos+2)>>5][Ball_X_Pos>>5] !== 3'b111)
//		) begin
//			// the pixel below is not solid
//			gravity <= 1; //
//		end else if (
//			LOCAL_REG[(Ball_Y_Pos+2)>>5][Ball_X_Pos>>5] === 3'b111
//		) begin
//			// current one is not solid
//			// one below is solid
//			gravity <= 0;
//		end else begin
//			gravity <= 0;
//		end

		// if ((LOCAL_REG[(Ball_Y_Pos + 2)>>5][Ball_X_Pos>>5] !== 3'b111) &&
			// (LOCAL_REG[(Ball_Y_Pos+1)>>5][Ball_X_Pos>>5] !== 3'b111)
		// ) begin
		
		
			// 1) gravity boundaries
			// check for collision with the proposed gravity motion (g_new)
			// if there is a collision,
			// find the nearest velocity so there is no collision
			// (this is in range 0:g_new)
		
		
		
		
		// assign some value 0-n
		// if there is a collision, find the nearest pixel with no collision
		
		
		// PIXEL CHECK FOR CORRECTNESS
		// if gravity hits the bottom, will it collide?
		if (LOCAL_REG[(Ball_Y_Pos)>>5][(Ball_X_Pos)>>5] === 3'b111) begin
			vx_test <= 1;
		end else if (LOCAL_REG[(Ball_Y_Pos)>>5][(Ball_X_Pos)>>5] !== 3'b111) begin
			vx_test <= 0;
		end
		
		
		
		

		// if(hit_boundary_left) begin
			// Ball_Y_Pos <= Ball_Y_Pos;  // Update ball position
			// Ball_X_Pos <= Ball_X_Pos + 4;
		// end
		// else if(hit_boundary_right) begin
			// Ball_Y_Pos <= Ball_Y_Pos;  // Update ball position
			// Ball_X_Pos <= Ball_X_Pos - 1;
		// end

		// else begin
		// DONT ADJUST!!!
		// CHECK BOUNDS ON XY EVERY TIME IT CHANGES (keypress)
//		if (x_motion_pre > 0) begin
//			y_pre_bound <= (Ball_Y_Pos+Ball_Size_Y-1);
//			x_pre_bound <= (Ball_X_Pos+Ball_Size_X-1);
			// right X side is (xpos + xsize - 1)
			// check for if within range 2px
			
//			if (LOCAL_REG[y_pre_bound>>5][(x_pre_bound+6)>>5] === 2'b00) begin
				// BOTTOM RIGHT
//				Ball_X_Motion <= 0;
//				if (LOCAL_REG[(y_pre_bound)>>5][(x_pre_bound+1)>>5] === 2'b00) begin
//					Ball_X_Motion <= 1;
//					if (LOCAL_REG[(y_pre_bound)>>5][(x_pre_bound)>>5] === 2'b00) begin
//						Ball_X_Motion <= 0;
//					end
//				end
//			end
//			else if (LOCAL_REG[(x_pre_bound)>>5][(x_pre_bound+2)>>5] === 2'b00) begin
//				// TOP RIGHT
//				Ball_X_Motion <= 2;
//				if (LOCAL_REG[(x_pre_bound)>>5][(x_pre_bound+1)>>5] === 2'b00) begin
//					Ball_X_Motion <= 1;
//					if (LOCAL_REG[(x_pre_bound)>>5][(x_pre_bound)>>5] === 2'b00) begin
//						Ball_X_Motion <= 0;
//					end
//				end
//			end
//			else Ball_X_Motion <= x_motion_pre;
//		end
//		else if (x_motion_pre < 0) begin
//			y_pre_bound <= (Ball_Y_Pos-Ball_Size_Y);
//			x_pre_bound <= (Ball_X_Pos-Ball_Size_X);
//			if (LOCAL_REG[y_pre_bound>>5][(x_pre_bound-6)>>5] === 2'b00) begin
//				Ball_X_Motion <= 0;
//			end
//		
//		end
		Ball_X_Motion <= x_motion_pre;
		Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion + jump_y_motion + gravity);
		Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion + jump_x_motion+ vx_test);

//		Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
//		Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
		// end
	end
end  


	 
assign BallX = Ball_X_Pos;

assign BallY = Ball_Y_Pos;

assign Ball_SizeX = Ball_Size_X;

assign Ball_SizeY = Ball_Size_Y;

assign g = gravity;

	
logic ball_on;
always_comb begin:Ball_on_proc

//	if ((DrawX <= BallX + Ball_Size_X - 1) && (DrawX >= BallX - Ball_Size_X) &&
//		(DrawY <= BallY + Ball_Size_Y - 1) && (DrawY >= BallY - Ball_Size_Y))
	
	// bottom right corner
	if (DrawX === Ball_X_Pos && DrawY === Ball_Y_Pos) 
		ball_on = 1'b1;
	else 
		ball_on = 1'b0;
end 


	
	
always_ff @ (posedge pixel_clk) begin:RGB_Display

	if(~blank) begin
		Red <= 8'h00;
		Green <= 8'h00;
		Blue <= 8'h00;
	end
	else if ((ball_on == 1'b1)) begin 
		Red <= 8'hff;
		Green <= 8'h55;
		Blue <= 8'h00;
	end
	else begin
		unique case (LOCAL_REG[DrawY[9:5]][DrawX[9:5]])
			3'b000 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h7f;
			end
			3'b001 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h7f;
			end
			3'b010 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h7f;
			end
			3'b011 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h7f;
			end
			3'b100 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h50;
			end
			3'b101 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h50;
			end
			3'b110 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h50;
			end
			3'b111 : begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h50;
			end
		endcase
	
		end
	end
	
*/

endmodule
