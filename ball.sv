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
		.frame_clk(frame_clk), //should it be frame_clk?
		.jump_en(jump_en),
		.hit_ground(hit_ground),
		.keycode(keycode),
		.jump_x_motion(jump_x_motion),
		.jump_y_motion(jump_y_motion),
		);
		
	
 
	// logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size_X, Ball_Size_Y, vx_test;


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
	
	logic [2:0] mario_data;
	logic [9:0] mario_address;
	
	ram_mario mario_ram(.q(mario_data), .ADDR(mario_address), .clk(Clk)); 
	
	// logic hit_boundary_left, hit_boundary_right, hit_boundary_up, hit_boundary_down;
	logic [23:0] mario_pallete [7];
	
	assign mario_pallete[0] = 24'h000000;
   assign mario_pallete[1] = 24'hF83800;
   assign mario_pallete[2] = 24'hE09230;
   assign mario_pallete[3] = 24'hEA9A30;
   assign mario_pallete[4] = 24'hEF9D34;
   assign mario_pallete[5] = 24'hffa440;
   assign mario_pallete[6] = 24'hac7c00;
	
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
			// 15 tall 20 wide
			LOCAL_REG[10][14] <= 3'b111;
			LOCAL_REG[10][15] <= 3'b111;
			LOCAL_REG[10][16] <= 3'b111;
			LOCAL_REG[10][17] <= 3'b111;
			LOCAL_REG[9][16] <= 3'b111;
			LOCAL_REG[9][15] <= 3'b111;
			LOCAL_REG[7][12] <= 3'b111;
			LOCAL_REG[6][12] <= 3'b111;
		end
		
		else
		begin
		end
	end
	
	
	
	
	
	
	
	
// 26x32
logic [3:0] gravity, gravity_next;
logic [9:0] self_vx, self_vy, self_x, self_y, vx_test, self_x0, self_y0;
logic [9:0] self_vx_next, self_vy_next, self_x_next, self_y_next, vx_test_next;
parameter [3:0] v_terminal=6; // maximum y motion when falling
parameter [9:0] self_w=26;
parameter [9:0] self_h=32;
int v;
logic in_air;
logic [9:0] vxleft_allowed, vxright_allowed, vxleft_allowed_next, vxright_allowed_next; 
	//max v in both directions (accounts for direction)
logic [9:0] jump_x_motion, jump_y_motion;
logic jump_en, hit_ground;
logic [9:0] key_vx, key_vy;
parameter [2:0] max_vx=2;

always_comb begin
	// default values
    gravity_next = gravity;
	self_vx_next = self_vx;
	self_vy_next = self_vy;
	self_x_next = self_x;
	self_y_next = self_y;
	vx_test_next = vx_test;
	vxleft_allowed_next = vxleft_allowed;
	vxright_allowed_next = vxright_allowed;
	in_air = ((LOCAL_REG[(self_y+gravity+1)>>5][self_x>>5][2] != 1'b1) &&
		(LOCAL_REG[(self_y+gravity+1)>>5][(self_x-self_w)>>5][2] != 1'b1));
		
	if (in_air) begin
		// both bottom corners are not on solid
		if (1+gravity > v_terminal) gravity_next = v_terminal;
		else gravity_next = 1+gravity;
	end else if (~in_air) begin
		// either bottom corner is on top of a solid
		gravity_next = 0;
		if((LOCAL_REG[(self_y+5)>>5][self_x-self_w>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+5)>>5][self_x>>5][2]!=1'b1)) gravity_next=5;
		else if((LOCAL_REG[(self_y+4)>>5][self_x-self_w>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+4)>>5][self_x>>5][2]!=1'b1)) gravity_next=4;
		else if((LOCAL_REG[(self_y+3)>>5][self_x-self_w>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+3)>>5][self_x>>5][2]!=1'b1)) gravity_next=3;
		else if((LOCAL_REG[(self_y+2)>>5][self_x-self_w>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+2)>>5][self_x>>5][2]!=1'b1)) gravity_next=2;
		else if((LOCAL_REG[(self_y+1)>>5][self_x-self_w>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+1)>>5][self_x>>5][2]!=1'b1)) gravity_next=1;
	end
	// NEED TO EXTEND TO MULTIPLE SOLID BLOCKS
	
	/*** pixel overlap test ***/
	// if (LOCAL_REG[(self_y)>>5][self_x>>5][2]==1'b1)
		// self_vx_next = -1;
	// else if (LOCAL_REG[(self_y)>>5][self_x>>5][2]!=1'b1) begin
		// self_vx_next = 0;
	// end
	// if (LOCAL_REG[(self_y)>>5][(self_x-self_w+1)>>5][2]==1'b1)
		// self_vx_next = 1;
	// else if (LOCAL_REG[(self_y)>>5][(self_x-self_w+1)>>5][2]!=1'b1) begin
		// self_vx_next = 0;
	// end
	
	/*** compute maximum allowed vx in both directions ***/
	// MAX VX LEFT
	if ((LOCAL_REG[(self_y)>>5][(self_x-self_w-1)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w-1)>>5][2]!=1'b1)
		) begin
		// both left corners are allowed at max_vx
		vxleft_allowed_next = -2;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x-self_w)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w)>>5][2]!=1'b1)
	) begin
		// one px away is ok
		vxleft_allowed_next = -1;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x-self_w)>>5][2]==1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w)>>5][2]==1'b1)
	) begin
		// next to us is a solid block
		vxleft_allowed_next = 0;
	end
	
	// MAX VX RIGHT
	if ((LOCAL_REG[(self_y)>>5][(self_x+2)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+2)>>5][2]!=1'b1)
		) begin
		// both right corners are allowed at max_vx
		vxright_allowed_next = 2;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x+1)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+1)>>5][2]!=1'b1)
	) begin
		// one px away is ok
		vxright_allowed_next = 1;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x+1)>>5][2]==1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+1)>>5][2]==1'b1)
	) begin
		// next to us is a solid block
		vxright_allowed_next = 0;
	end
	
	self_x_next = (self_x + self_vx_next);
	self_y_next = (self_y + self_vy_next + gravity_next);
	
	
end

always_ff @ (posedge Reset or posedge frame_clk) begin
	if(Reset) begin
		gravity <= 4'd0;
		self_x <= 30;
		self_y <= 33;
		self_vx <= 10'd0;
		self_vy <= 10'd0;
		vx_test <= 10'd0;
		hit_ground <= 0;
		
	end else begin
		
		case (keycode)
			// Combination of W & A. Jump left
			32'h00001A04, 32'h0000041A : begin
				key_vx <= vxleft_allowed_next;	
				if ((LOCAL_REG[(self_y+1)>>5][self_x>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1)>>5][2]==1'b1))
					jump_en <= 1'b1;
				else jump_en <= 1'b0;
				end

			// Combination of W & D. Go Jump right
			32'h00001A07, 32'h00000071A : begin
				key_vx <= vxright_allowed_next;
				if ((LOCAL_REG[(self_y+1)>>5][self_x>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1)>>5][2]==1'b1))
					jump_en <= 1'b1;
				else jump_en <= 1'b0;
				end

			// Jump up
			32'h1A : begin
				if ((LOCAL_REG[(self_y+1)>>5][self_x>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1)>>5][2]==1'b1))
					jump_en <= 1'b1;
				else jump_en <= 1'b0;
				key_vx <= 0;
				end

			// left (A)
			32'h04 : begin
				key_vx <= vxleft_allowed_next;
				jump_en <= 1'b0;
				end

			// right (D)
			32'h07 : begin
				key_vx <= vxright_allowed_next; //clock delay!!!
				jump_en <= 1'b0;
				end
				
			default: begin
				key_vx <= 0;
				jump_en <= 1'b0;
				end
		endcase 
		
		if ((LOCAL_REG[(self_y+1)>>5][self_x>>5][2]==1'b1) ||
			(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1)>>5][2]==1'b1)) begin
			// below is solid. we need to know whether to interrupt the fsm or not
			hit_ground <= 1;
		end else begin
			hit_ground <= 0;
		end
		gravity <= gravity_next;
		self_vx <= self_vx_next;
		self_vy <= self_vy_next;
		self_x <= self_x_next + key_vx;
		self_y <= self_y_next + jump_y_motion;
		vx_test <= vx_test_next;
	end
	  
end

	
logic ball_on;
always_comb begin:Ball_on_proc
	// if (DrawX === self_x && DrawY === self_y) 
	
	if ((DrawX >= self_x-self_w+1) && (DrawX <= self_x) &&
		(DrawY >= self_y-self_h+1) && (DrawY <= self_y)) begin
		ball_on = 1'b1;
		mario_address = ((31 - (self_y - DrawY))*self_w)+(25 - (self_x - DrawX));
	end else begin
		ball_on = 1'b0;
		mario_address = 0;
		end
end 
	
always_ff @ (posedge pixel_clk) begin:RGB_Display

	if(~blank) begin
		Red <= 8'h00;
		Green <= 8'h00;
		Blue <= 8'h00;
	end
	else if ((ball_on == 1'b1)) begin 
		Red <= mario_pallete[mario_data][23:16];
		Green <= mario_pallete[mario_data][15:8];
		Blue <= mario_pallete[mario_data][7:0];
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
