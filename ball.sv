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


module  ball (	input Reset, frame_clk, pixel_clk, Clk, blank,
				input [31:0] keycode,
				input [9:0] DrawX, DrawY, g_prev,
				output [9:0]  BallX, BallY, BallSizeX, BallSizeY, g,
				output logic [7:0]  Red, Green, Blue
			);	
					
	fsm F(.Reset(Reset_h),
		.frame_clk(frame_clk),
		.jump_en(jump_en),
		.hit_ground(hit_ground),
		.keycode(keycode),
		.jump_x_motion(jump_x_motion),
		.jump_y_motion(jump_y_motion),
		);	
 
	parameter [23:0] transparent = 24'hE00B8E;
	
	logic [2:0] mario_data;
	logic [9:0] mario_address;
	ram_mario mario_ram(.q(mario_data), .ADDR(mario_address), .clk(Clk)); 
	
	logic [1:0] brick_data;
	logic [9:0] brick_addr;
	ram_block bricks_ram(.q(brick_data),.ADDR(brick_addr),.clk(Clk));
	
	logic [1:0] coin_data;
	logic [9:0] coin_addr;
	ram_coin coin_ram(.q(coin_data),.ADDR(coin_addr),.clk(Clk));
	
	logic [1:0] zero_data;
	logic [9:0] zero_addr;
	ram_zero zero_ram(.q(zero_data), .ADDR(zero_addr), .clk(Clk));
	
	logic [1:0] one_data;
	logic [9:0] one_addr;
	ram_one one_ram(.q(one_data), .ADDR(one_addr), .clk(Clk));
	
	logic [1:0] two_data;
	logic [9:0] two_addr;
	ram_two two_ram(.q(two_data), .ADDR(two_addr), .clk(Clk));
	
	logic [1:0] three_data;
	logic [9:0] three_addr;
	ram_three three_ram(.q(three_data), .ADDR(three_addr), .clk(Clk));
	
	logic [1:0] floor_data;
	ram_brick floor_ram(.q(floor_data), .ADDR(floor_addr), .clk(Clk));
	
	// logic [1:0] three_data;
	// logic [9:0] three_addr;
	// ram_three three_ram(.q(three_data), .ADDR(three_addr), .clk(Clk));
	
	// logic hit_boundary_left, hit_boundary_right, hit_boundary_up, hit_boundary_down;
	logic [23:0] mario_pallete [7];
	assign mario_pallete[0] = 24'hE00B8E;
	assign mario_pallete[1] = 24'hF83800;
	assign mario_pallete[2] = 24'hE09230;
	assign mario_pallete[3] = 24'hEA9A30;
	assign mario_pallete[4] = 24'hEF9D34;
	assign mario_pallete[5] = 24'hffa440;
	assign mario_pallete[6] = 24'hac7c00; 
	
	logic [23:0] block_pallete [3];
	assign block_pallete[0] = 24'h000000;
	assign block_pallete[1] = 24'h833d00;
	assign block_pallete[2] = 24'h3c1800;
	
	logic [23:0] coin_pallete[4];
	assign coin_pallete[0] = 24'h000000;
	assign coin_pallete[1] = 24'hffffff;
	assign coin_pallete[2] = 24'hffc107;
	assign coin_pallete[3] = 24'hE00B8E;
	
	logic [23:0] number_pallete[2];
	assign number_pallete[0] = 24'heeaf36;
	assign number_pallete[1] = 24'h6185f8;
	
	logic [23:0] brick_pallete[4];
	assign brick_pallete[0] = 24'h000000;
	assign brick_pallete[1] = 24'ha55c39;
	assign brick_pallete[2] = 24'h1f1615;
	assign brick_pallete[3] = 24'hffcdc5;
	
	
	logic [2:0] LOCAL_REG [15][60];
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
		 
		if (1'b1) begin
			int i,j;
			for(i = 0; i < 15; i++) begin
				for(j = 0; j < 60; j++) begin
					if (i >= 11)
						LOCAL_REG[i][j] <= 3'b110;
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
			
			LOCAL_REG[8][19] <= 3'b111;
			LOCAL_REG[8][20] <= 3'b111;
			
			LOCAL_REG[c1_y][c1_x] <= c1_data; //coin 1
			
			LOCAL_REG[c2_y][c2_x] <= c2_data; //coin 2
			
			LOCAL_REG[c3_y][c3_x] <= c3_data;
			
			
			LOCAL_REG[10][25] <= 3'b111;
			LOCAL_REG[10][26] <= 3'b111;
			LOCAL_REG[10][27] <= 3'b111;
			LOCAL_REG[10][28] <= 3'b111;
			LOCAL_REG[9][26] <= 3'b111;
			LOCAL_REG[9][27] <= 3'b111;
			LOCAL_REG[9][28] <= 3'b111;
			LOCAL_REG[8][28] <= 3'b111;
			LOCAL_REG[8][27] <= 3'b111;
			LOCAL_REG[7][28] <= 3'b111;
			
			LOCAL_REG[6][32] <= 3'b111;
			LOCAL_REG[6][33] <= 3'b111;
			LOCAL_REG[6][34] <= 3'b111;
			
			LOCAL_REG[7][37] <= 3'b111;
			LOCAL_REG[8][37] <= 3'b111;
			
			
			for(int i=46;i<54;i++) begin
				LOCAL_REG[10][i] <= 3'b111;
				if ((i>46)&&(i<53))
					LOCAL_REG[9][i] <= 3'b111;
			end

			LOCAL_REG[7][56] <= 3'b111;
			LOCAL_REG[8][56] <= 3'b111;
			
		end
		
		else
		begin
		end
	end
	
// 26x32
int gravity, gravity_next;
int self_vx, self_vy, self_x, self_y, vx_test, self_x0, self_y0;
int self_vx_next, self_vy_next, self_x_next, self_y_next, vx_test_next;	
int v;
logic in_air;
int vxleft_allowed, vxright_allowed, vxleft_allowed_next, vxright_allowed_next; 
	//max v in both directions (accounts for direction)
int jump_x_motion, jump_y_motion;	
logic jump_en, hit_ground;
int key_vx, key_vy;
int x_shift, x_shift_next;
logic face_left, face_left_next;

int coin_total, coin_total_next; // deprecated?

/*** coin 1 ***/
parameter [7:0] c1_x=14;
parameter [7:0] c1_y=7;
logic [1:0] c1_on, c1_on_next;
logic [2:0] c1_data;
assign c1_data = (c1_on?3'b010:3'b000);

/*** coin 2 ***/
parameter [7:0] c2_x=20;
parameter [7:0] c2_y=6;
logic [1:0] c2_on, c2_on_next;
logic [2:0] c2_data;
assign c2_data = (c2_on?3'b010:3'b000);


parameter [7:0] c3_x=39;
parameter [7:0] c3_y=5;
logic [1:0] c3_on, c3_on_next;
logic [2:0] c3_data;
assign c3_data = (c3_on?3'b010:3'b000);


logic [2:0] score;
always_comb begin
	score = 0;
	if (~(c1_on[0]))
		score += 1;
	if (~(c2_on[0]))
		score += 1;
	if (~(c3_on[0]))
		score += 1;
end





parameter [3:0] v_terminal=6; // maximum y motion when falling
parameter [9:0] self_w=26;
parameter [9:0] self_h=32;
parameter [9:0] max_x_vga=384; //absolute pos on vga screen to stay at
parameter [9:0] min_x_vga=190;
parameter [2:0] max_vx=4;
parameter[7:0] score_x = 1;
parameter[7:0] score_y = 0;

always_comb begin
	// default values
	c3_on_next = c3_on;
	c2_on_next = c2_on;
	c1_on_next = c1_on;
	face_left_next = face_left;
	x_shift_next = x_shift;
    gravity_next = gravity;
	self_vx_next = self_vx;
	self_vy_next = self_vy;
	self_x_next = self_x;
	self_y_next = self_y;
	vx_test_next = vx_test;
	vxleft_allowed_next = vxleft_allowed;
	vxright_allowed_next = vxright_allowed;
		
	if (((self_y>>5)==c1_y)&&((self_x+x_shift)>>5==c1_x) ||
		(((self_y-self_h+1)>>5)==c1_y)&&((self_x+x_shift)>>5==c1_x) ||
		((self_y>>5)==c1_y)&&((self_x+x_shift-self_w+1)>>5==c1_x) ||
		(((self_y-self_h+1)>>5)==c1_y)&&((self_x+x_shift-self_w+1)>>5==c1_x)&&c1_on[0])
		c1_on_next = 2'b00;
	else if (((self_y>>5)==c2_y)&&((self_x+x_shift)>>5==c2_x) ||
		(((self_y-self_h+1)>>5)==c2_y)&&((self_x+x_shift)>>5==c2_x) ||
		((self_y>>5)==c2_y)&&((self_x+x_shift-self_w+1)>>5==c2_x) ||
		(((self_y-self_h+1)>>5)==c2_y)&&((self_x+x_shift-self_w+1)>>5==c2_x)&&c2_on[0])
		c2_on_next = 2'b00;
	else if (((self_y>>5)==c3_y)&&((self_x+x_shift)>>5==c3_x) ||
		(((self_y-self_h+1)>>5)==c3_y)&&((self_x+x_shift)>>5==c3_x) ||
		((self_y>>5)==c3_y)&&((self_x+x_shift-self_w+1)>>5==c3_x) ||
		(((self_y-self_h+1)>>5)==c3_y)&&((self_x+x_shift-self_w+1)>>5==c3_x)&&c3_on[0])
		c3_on_next = 2'b00;
			
	in_air = ((LOCAL_REG[(self_y+gravity+1)>>5][(self_x+x_shift)>>5][2] != 1'b1) &&
		(LOCAL_REG[(self_y+gravity+1)>>5][(self_x-self_w+x_shift)>>5][2] != 1'b1));
		
	if (in_air) begin
		// both bottom corners are not on solid
		if (1+gravity > v_terminal) gravity_next = v_terminal;
		else gravity_next = 1+gravity;
	end else if (~in_air) begin
		// either bottom corner is on top of a solid
		gravity_next = 0;
		if((LOCAL_REG[(self_y+5)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+5)>>5][(self_x+x_shift)>>5][2]!=1'b1)) gravity_next=5;
		else if((LOCAL_REG[(self_y+4)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+4)>>5][(self_x+x_shift)>>5][2]!=1'b1)) gravity_next=4;
		else if((LOCAL_REG[(self_y+3)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+3)>>5][(self_x+x_shift)>>5][2]!=1'b1)) gravity_next=3;
		else if((LOCAL_REG[(self_y+2)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+2)>>5][(self_x+x_shift)>>5][2]!=1'b1)) gravity_next=2;
		else if((LOCAL_REG[(self_y+1)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1)&&
			(LOCAL_REG[(self_y+1)>>5][(self_x+x_shift)>>5][2]!=1'b1)) gravity_next=1;
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
	if ((LOCAL_REG[(self_y)>>5][(self_x-self_w-3+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w-3+x_shift)>>5][2]!=1'b1)
		) begin
		vxleft_allowed_next = -4;
	end else if ((LOCAL_REG[(self_y)>>5][(self_x-self_w-2+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w-2+x_shift)>>5][2]!=1'b1)
		) begin
		vxleft_allowed_next = -3;
	end else if ((LOCAL_REG[(self_y)>>5][(self_x-self_w-1+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w-1+x_shift)>>5][2]!=1'b1)
		) begin
		vxleft_allowed_next = -2;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w+x_shift)>>5][2]!=1'b1)
	) begin
		vxleft_allowed_next = -1;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x-self_w+x_shift)>>5][2]==1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x-self_w+x_shift)>>5][2]==1'b1)
	) begin
		// next to us is a solid block
		vxleft_allowed_next = 0;
	end
	
	// MAX VX RIGHT
	if ((LOCAL_REG[(self_y)>>5][(self_x+4+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+4+x_shift)>>5][2]!=1'b1)
		) begin
		// both right corners are allowed at max_vx
		vxright_allowed_next = 4;
	end else if ((LOCAL_REG[(self_y)>>5][(self_x+3+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+3+x_shift)>>5][2]!=1'b1)
		) begin
		vxright_allowed_next = 3;
	end else if ((LOCAL_REG[(self_y)>>5][(self_x+2+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+2+x_shift)>>5][2]!=1'b1)
		) begin
		vxright_allowed_next = 2;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x+1+x_shift)>>5][2]!=1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+1+x_shift)>>5][2]!=1'b1)
	) begin
		vxright_allowed_next = 1;
	end else if (
		(LOCAL_REG[(self_y)>>5][(self_x+1+x_shift)>>5][2]==1'b1) &&
		(LOCAL_REG[(self_y-self_h)>>5][(self_x+1+x_shift)>>5][2]==1'b1)
	) begin
		// next to us is a solid block
		vxright_allowed_next = 0;
	end
		
	self_x_next = (self_x);
	self_y_next = (self_y + gravity_next);
	
end

logic die;
assign die = ((self_y>>5)>18?1'b1:1'b0);

always_ff @ (posedge Reset or posedge frame_clk or posedge die) begin
	if(Reset || die) begin
		gravity <= 4'd0;
		self_x <= 228;
		self_y <= 33;
		self_vx <= 10'd0;
		self_vy <= 10'd0;
		vx_test <= 10'd0;
		hit_ground <= 0;
		x_shift <= 10'd0;
		key_vx <= 0;
		c1_on <= 2'b01;
		c2_on <= 2'b01;
		c3_on <= 2'b01;
		face_left <= 1'b0;
		
	end else begin
		
		case (keycode)
			// Combination of W & A. Jump left
			32'h00001A04, 32'h0000041A : begin
				key_vx <= vxleft_allowed_next;	
				face_left <= 1'b1;
				if ((LOCAL_REG[(self_y+1)>>5][(self_x+x_shift)>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1+x_shift)>>5][2]==1'b1))
					jump_en <= 1'b1;
				else jump_en <= 1'b0;
				end

			// Combination of W & D. Go Jump right
			32'h00001A07, 32'h00000071A : begin
				key_vx <= vxright_allowed_next;
				face_left <= 1'b0;
				if ((LOCAL_REG[(self_y+1)>>5][(self_x+x_shift)>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1+x_shift)>>5][2]==1'b1))
					jump_en <= 1'b1;
				else jump_en <= 1'b0;
				end

			// Jump up
			32'h1A : begin
				face_left <= face_left_next;
				if ((LOCAL_REG[(self_y+1)>>5][(self_x+x_shift)>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1+x_shift)>>5][2]==1'b1))
					jump_en <= 1'b1;
				else jump_en <= 1'b0;
				key_vx <= 0;
				end

			// left (A)
			32'h04 : begin
				face_left <= 1'b1;
				key_vx <= vxleft_allowed_next;
				jump_en <= 1'b0;
				end

			// right (D)
			32'h07 : begin
				face_left <= 1'b0;
				key_vx <= vxright_allowed_next;
				jump_en <= 1'b0;
				end
				
			default: begin
				face_left <= face_left_next;
				key_vx <= 0;
				jump_en <= 1'b0;
				end
		endcase 
		
		if ((LOCAL_REG[(self_y+1)>>5][(self_x+x_shift)>>5][2]==1'b1) ||
			(LOCAL_REG[(self_y+1)>>5][(self_x-self_w+1+x_shift)>>5][2]==1'b1)) begin
			// below is solid. we need to know whether to interrupt the fsm or not
			hit_ground <= 1;
		end else begin
			hit_ground <= 0;
		end
		
		if ((LOCAL_REG[(self_y-self_h+jump_y_motion-1)>>5][(self_x+x_shift)>>5][2]==1'b1) ||
			(LOCAL_REG[(self_y-self_h+jump_y_motion-1)>>5][(self_x-self_w+1+x_shift)>>5][2]==1'b1)) begin
			hit_ground <= 1;
			for(int i=0;i>=-12;i--) begin
				if 	((LOCAL_REG[(self_y-self_h+i-1)>>5][(self_x+x_shift)>>5][2]==1'b1) ||
					(LOCAL_REG[(self_y-self_h+i-1)>>5][(self_x-self_w+1+x_shift)>>5][2]==1'b1)) begin
					self_y <= self_y_next + i;
					break;
				end
			end
		end else begin
			hit_ground <= 0;
			self_y <= self_y_next + jump_y_motion;
		end
		
		gravity <= gravity_next;
		self_vx <= self_vx_next;
		self_vy <= self_vy_next;
		
		if ((self_x_next + key_vx) > max_x_vga) begin
			// right corner passing right bound
			x_shift <= x_shift_next + (key_vx);
			self_x <= max_x_vga;
		end else if ((self_x_next-self_w + key_vx) <= min_x_vga) begin
			// left corner passing left bound
			x_shift <= x_shift_next + (key_vx);
			self_x <= min_x_vga+self_w-1;
		end else begin
			// in between
			x_shift <= x_shift_next;
			self_x <= (key_vx + self_x_next);
		end
		
		vx_test <= vx_test_next;
		c1_on <= c1_on_next;
		c2_on <= c2_on_next;
		c3_on <= c3_on_next;
	end
	  
end

logic ball_on;
logic brick_on;
logic coin_on;
logic [9:0] block_offset;
logic score_on;
logic floor_on;
logic [9:0] floor_addr;

always_comb begin:Ball_on_proc
	block_offset = 5'd0;
	
	ball_on = 1'b0;	
	mario_address = 10'd0;
	
	brick_on = 1'b0;
	brick_addr = 10'd0;
	
	coin_on=1'b0;
	coin_addr=10'd0;
	
	zero_addr = 10'd0;
	one_addr = 10'd0;
	two_addr = 10'd0;
	three_addr = 10'd0;
	
	score_on = 1'b0;
	
	floor_on = 1'b0;
	floor_addr = 10'd0;
	
	if ((DrawX >= self_x-self_w+1) && (DrawX <= self_x) &&
		(DrawY >= self_y-self_h+1) && (DrawY <= self_y)) begin
		ball_on = 1'b1;	
		mario_address = ((31-(self_y-DrawY))*self_w)+(face_left?
			(self_x-DrawX):(25-(self_x-DrawX)));
	end else if (LOCAL_REG[DrawY[9:5]][(DrawX+x_shift)>>5]==3'b111) begin
		// code for block
		block_offset=DrawX+x_shift;
		brick_on=1'b1;
		brick_addr=(DrawY[4:0]*32) + block_offset[4:0];
	end else if (LOCAL_REG[DrawY[9:5]][(DrawX+x_shift)>>5]==3'b110) begin
		// code for brick/floor
		block_offset=DrawX+x_shift;
		floor_on=1'b1;
		floor_addr=(DrawY[4:0]*32) + block_offset[4:0];
	end else if (LOCAL_REG[DrawY[9:5]][(DrawX+x_shift)>>5]==3'b010) begin
		// code for coin
		block_offset=DrawX+x_shift;
		coin_on = 1'b1;
		if ((block_offset[4:0] <= 1) || (block_offset[4:0] >= 30))
			coin_addr=10'd0; //give it transparent
		else
			coin_addr=(DrawY[4:0]*32) + block_offset[4:0]-2;
	end else if ((DrawY[9:5]==score_y)&&(DrawX[9:5]==score_x)) begin
		score_on = 1'b1; 
		zero_addr = DrawY[4:0]*32 + DrawX[4:0];
		one_addr = DrawY[4:0]*32 + DrawX[4:0];
		two_addr = DrawY[4:0]*32 + DrawX[4:0];
		three_addr = DrawY[4:0]*32 + DrawX[4:0];
	end
end 
	
always_ff @ (posedge pixel_clk) begin:RGB_Display

	if(~blank) begin
		Red <= 8'h00;
		Green <= 8'h00;
		Blue <= 8'h00;
	end else begin
		if (score_on == 1'b1) begin
			if(score == 3'b000) begin
				Red <= number_pallete[zero_data][23:16];
				Green <= number_pallete[zero_data][15:8];
				Blue <= number_pallete[zero_data][7:0];
			end else if (score == 3'b001) begin
				Red <= number_pallete[one_data][23:16];
				Green <= number_pallete[one_data][15:8];
				Blue <= number_pallete[one_data][7:0];
			end else if (score == 3'b010) begin
				Red <= number_pallete[two_data][23:16];
				Green <= number_pallete[two_data][15:8];
				Blue <= number_pallete[two_data][7:0];
			end else if (score == 3'b011) begin
				Red <= number_pallete[three_data][23:16];
				Green <= number_pallete[three_data][15:8];
				Blue <= number_pallete[three_data][7:0];
			end
		end else if (ball_on==1'b1) begin 
			if(mario_pallete[mario_data] == transparent ) begin
				Red <= 8'h61; 
				Green <= 8'h85;
				Blue <= 8'hf8;
			end else begin
				Red <= mario_pallete[mario_data][23:16];
				Green <= mario_pallete[mario_data][15:8];
				Blue <= mario_pallete[mario_data][7:0];
			end
		end else if (brick_on==1'b1) begin
			Red <= block_pallete[brick_data][23:16];
			Green <= block_pallete[brick_data][15:8];
			Blue <= block_pallete[brick_data][7:0];
		end else if (floor_on==1'b1) begin
			Red <= brick_pallete[floor_data][23:16];
			Green <= brick_pallete[floor_data][15:8];
			Blue <= brick_pallete[floor_data][7:0];
		end else if (coin_on==1'b1) begin
			if(coin_pallete[coin_data]==transparent) begin
				Red <= 8'h61; 
				Green <= 8'h85;
				Blue <= 8'hf8;
			end else begin
				Red <= coin_pallete[coin_data][23:16];
				Green <= coin_pallete[coin_data][15:8];
				Blue <= coin_pallete[coin_data][7:0];
			end
		end else begin
			unique case (LOCAL_REG[DrawY[9:5]][(DrawX+x_shift)>>5])
				3'b000, 3'b001 : begin
					Red <= 8'h61; 
					Green <= 8'h85;
					Blue <= 8'hf8;
				end
				3'b100, 3'b101, 3'b110, 3'b111 : begin
					Red <= 8'h00; 
					Green <= 8'h00;
					Blue <= 8'h50;
				end
			endcase
		end
		
		
	end
end
endmodule
