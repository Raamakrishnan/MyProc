//16 bit registers - 16 Nos.

module Reg(
	input wire clk,    // Clock
	input wire rst_n,
	input wire [3:0] ra,
	input wire [3:0] rb,
	output reg [15:0] dataA,
	output reg [15:0] dataB,
	input wire r_en,
	input wire [3:0] rc,
	input wire [15:0] dataC,
	input wire w_en
);

	reg [15:0] RegFile [15:0];

	always @(posedge clk) begin
		if (w_en) begin
			RegFile[rc] <= dataC;
		end
		if (r_en) begin
			dataA <= RegFile[ra];
			dataB <= RegFile[rb];
		end
	end
endmodule