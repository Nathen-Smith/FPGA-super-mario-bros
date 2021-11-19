//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input blank, Clk, pixel_clk, Reset,
							  input        [9:0] BallX, BallY, DrawX, DrawY, Ball_SizeX, Ball_SizeY,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
	int DistX, DistY, Size;
	assign DistX = DrawX - BallX;
	assign DistY = DrawY - BallY;
	assign SizeX = Ball_SizeX;
	assign SizeY = Ball_SizeY;
	
	
	
	logic [1:0] LOCAL_REG [15][20];
	
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
	
		if(Reset)
		begin
			int i,j;
			for(i = 0; i < 15; i++)
			begin
				for(j = 0; j < 20; j++)
				begin
					LOCAL_REG[i][j] <= i + j;
				end
			end
		end
		
		else
		begin
		end
	
	end
	
	
// determine if current pixel is the character rectangle
always_comb begin:Ball_on_proc

	if ((DrawX <= BallX + 8) && (DrawX >= BallX - 8) &&
		(DrawY <= BallY + 16) && (DrawY >= BallY - 16))
		ball_on = 1'b1;
	else 
		ball_on = 1'b0;
end 

// assign RGB   always_comb
always_ff @ (posedge pixel_clk) begin:RGB_Display
	 
		  if(blank == 1'b0)
		  begin
				Red <= 8'h00;
            Green <= 8'h00;
            Blue <= 8'h00;
		  end
        else if ((ball_on == 1'b1)) 
        begin 
            Red <= 8'hff;
            Green <= 8'h55;
            Blue <= 8'h00;
        end       

		  	else if (LOCAL_REG[DrawY[9:5]][DrawX[9:5]] === 2'b00) begin
				Red <= 8'h00; 
				Green <= 8'h00;
				Blue <= 8'h7f;
			end
	
			else if(LOCAL_REG[DrawY[9:5]][DrawX[9:5]] === 2'b01) begin
				Red <= 8'h8d; 
				Green <= 8'hfc;
				Blue <= 8'hc7;
			end
			
			else if(LOCAL_REG[DrawY[9:5]][DrawX[9:5]] === 2'b10) begin
				Red <= 8'h11; 
				Green <= 8'h5c;
				Blue <= 8'hc7;
			end
			
			else if(LOCAL_REG[DrawY[9:5]][DrawX[9:5]] === 2'b11) begin
				Red <= 8'h22; 
				Green <= 8'hfc;
				Blue <= 8'h00;
			end
			

			

    end 
    
endmodule
