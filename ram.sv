
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

/*** coin ***/
module ram_coin(
    output logic [1:0] q,
    input logic [9:0] ADDR,
    input clk
);
	logic [1:0] mem[28 * 32];
	always_ff @ (posedge clk) begin
		q <= mem[ADDR];
	end

	initial begin
		$readmemh("coin.txt", mem);
	end

endmodule

module ram_zero(
    output logic [1:0] q,
    input logic [9:0] ADDR,
    input clk
);

logic [1:0] mem[32 * 32];
always_ff @ (posedge clk)
begin
    q <= mem[ADDR];
end

initial begin
    $readmemh("zero.txt", mem);
end

endmodule

module ram_one(
    output logic [1:0] q,
    input logic [9:0] ADDR,
    input clk
);

logic [1:0] mem[32 * 32];
always_ff @ (posedge clk)
begin
    q <= mem[ADDR];
end

initial begin
    $readmemh("one.txt", mem);
end

endmodule

module ram_two(
    output logic [1:0] q,
    input logic [9:0] ADDR,
    input clk
);

logic [1:0] mem[32 * 32];
always_ff @ (posedge clk)
begin
    q <= mem[ADDR];
end

initial begin
    $readmemh("two.txt", mem);
end

endmodule

module ram_three(
    output logic [1:0] q,
    input logic [9:0] ADDR,
    input clk
);

logic [1:0] mem[32 * 32];
always_ff @ (posedge clk)
begin
    q <= mem[ADDR];
end

initial begin
    $readmemh("three.txt", mem);
end

endmodule
