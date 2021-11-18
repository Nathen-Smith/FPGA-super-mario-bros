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


module  ball ( input Reset, frame_clk, Clk, 
					input [31:0] keycode,
               output [9:0]  BallX, BallY, BallSizeX, BallSizeY
					);
					
			
	
	fsm F(.Reset(Reset_h),
		.frame_clk(frame_clk),
		.jump_en(jump_en),
		.keycode(keycode),
		.jump_x_motion(jump_x_motion),
		.jump_y_motion(jump_y_motion));
 
	logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size_X, Ball_Size_Y;
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

	assign Ball_Size_X = 8; 	// assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign Ball_Size_Y = 16;
	
	logic hit_boundary_left, hit_boundary_right, hit_boundary_up, hit_boundary_down;

	always_ff @ (posedge Reset or posedge frame_clk)
	begin: Move_Ball

	  if (Reset)  // Asynchronous Reset
	  begin 
//			integer i, j;
//			for(i = 0; i < 15; i++) begin
//				for(j = 0; j < 20; j++) begin
//					if (i % 2 == 0)
//						LOCAL_REG[i][j] <= 2'h0;
//					else
//						LOCAL_REG[i][j] <= 2'h2;
//					end
//				end
			
			Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= 200;
			Ball_X_Pos <= Ball_X_Center;
	  end
	  else begin
		  	

			 if ( (Ball_Y_Pos + 16) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					hit_boundary_down <= 1'b1;
				  
			 else if ( (Ball_Y_Pos - 16) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
				  hit_boundary_up <= 1'b1;
				  
			  else if ( (Ball_X_Pos + 8) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
				  hit_boundary_right <= 1'b1;  // 2's complement.
				  
			 else if ( (Ball_X_Pos - 5) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
				  hit_boundary_left <= 1'b1;
				  
			 else 
				begin
				  hit_boundary_up <= 1'b0;
				  hit_boundary_down <= 1'b0;
				  hit_boundary_left <= 1'b0;
				  hit_boundary_right <= 1'b0;
				end

			 
			 
			 
//			 if (jump_x_motion === 0 && jump_y_motion === 0)
//			 begin
			 case (keycode)
			 
					// Combination of W & A. Go NorthWest
					32'h00001A04, 32'h0000041A:
								begin
								Ball_X_Motion <= -2;//top left
								jump_en <= 1'b1;
								end
								
					// Combination of W & D. Go NorthEast
					32'h00001A07, 32'h00000701A:
								begin
								Ball_X_Motion <= 2;
								jump_en <= 1'b1;
								end
					
//					//Combination of S & A. Go SouthEast
//					32'h00001604:
//								begin
//								Ball_X_Motion <= -2;
//								Ball_Y_Motion <= 2;
//								end
//					
//					// Combination of S & D. Go SouthWest
//					32'h00001607:
//								begin
//								Ball_X_Motion <= 2;
//								Ball_Y_Motion <= 2;
//								end

					32'h1A : begin
									jump_en <= 1'b1;
								end
								
								
					32'h04 : begin
								jump_en <= 1'b0;
								Ball_X_Motion <= -2;//A
								Ball_Y_Motion<= 0;
								end
							  
					32'h07 : begin
								jump_en <= 1'b0;
							   Ball_X_Motion <= 2;//D
							   Ball_Y_Motion <= 0;
							   end

							 
					  
					default: begin
							   jump_en <= 1'b0;
							   Ball_Y_Motion <= 0;
							   Ball_X_Motion <= 0;
							   end	
					
						
			endcase
//			end
			 
			 if(hit_boundary_left)
			 begin
				 Ball_Y_Pos <= Ball_Y_Pos;  // Update ball position
				 Ball_X_Pos <= Ball_X_Pos + 4;
			 end
			 
			 else if(hit_boundary_right)
			 begin
				 Ball_Y_Pos <= Ball_Y_Pos;  // Update ball position
				 Ball_X_Pos <= Ball_X_Pos - 1;
			 end
			 
			 else
			 begin
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion + jump_y_motion);
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion + jump_x_motion);
			 end

		end
		end  
	 
	assign BallX = Ball_X_Pos;

	assign BallY = Ball_Y_Pos;

	assign Ball_SizeX = Ball_Size_X;
	
	assign Ball_SizeY = Ball_Size_Y;
	
	
	
	// RGB	
	
//	logic ball_on;
//	
//	always_comb begin:Ball_on_proc
//	if ((DrawX <= BallX + 8) && (DrawX >= BallX - 8) &&
//		(DrawY <= BallY + 16) && (DrawY >= BallY - 16))
//		ball_on = 1'b1;
//	else 
//		ball_on = 1'b0;
//	end 
//       
//	always_comb begin:RGB_Display
//	
//	// location of register in range 300
//
//	if ((ball_on == 1'b1)) begin 
//		Red = 8'hff;
//		Green = 8'h55;
//		Blue = 8'h00;
//		end       
//		
//	else if (LOCAL_REG[DrawY[9:5]][DrawX[9:5]] === 2'h0) begin
//		Red = 8'h00; 
//		Green = 8'h00;
//		Blue = 8'h7f;
//	end
//	
//	else begin
//		Red = 8'h00; 
//		Green = 8'h9A;
//		Blue = 8'h00;
//	end

//end


endmodule
