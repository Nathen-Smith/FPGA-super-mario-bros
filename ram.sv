
/*** Chris Pratt ***/
module ram_mario(
	output logic [2:0] q,
	input logic [9:0] ADDR,
	input clk
);
	logic [2:0] mem[26 * 32];
	always_ff @ (posedge clk) begin
		q <= mem[ADDR];
	end	

	initial begin
		$readmemh("mario_right.txt", mem);
	end

endmodule

/*** solid block ***/
module ram_block(
    output logic [1:0] q,
    input logic [9:0] ADDR,
    input clk
);
	logic [2:0] mem[32 * 32];
	always_ff @ (posedge clk) begin
		q <= mem[ADDR];
	end


	initial begin
		$readmemh("block.txt", mem);
	end

endmodule
