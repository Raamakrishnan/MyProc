`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

//32 bit registers - 32 Nos.

module Reg_mod(
	input wire clk,    // Clock
	input wire [`REG_ADDR_LEN - 1:0] ra,
	input wire [`REG_ADDR_LEN - 1:0] rb,
	output reg [`WIDTH - 1:0] dataA,
	output reg [`WIDTH - 1:0] dataB,
	output reg st_A,	// output strobe
	output reg st_B,	// output strobe
	input wire r_en_A,
	input wire r_en_B,
	input wire [`REG_ADDR_LEN - 1:0] rc,
	input wire [`WIDTH -1 :0] dataC,
	input wire w_en
);

	reg [`WIDTH - 1:0] RegFile [`NUM_REGS - 1:0];

	always @(posedge clk) begin
		if (w_en) begin
			if(rc != 0)
				RegFile[rc] <= dataC;
		end
	end

	always @(negedge clk) begin
		if (r_en_A) begin
			st_A = 0;
			if(ra != 0)
				dataA = RegFile[ra];
			else 
				dataA = 'd0;
			st_A = 1;
		end
	end

	always @(negedge clk) begin
		if (r_en_B) begin
			st_B = 0;
			if(rb != 0)
				dataB = RegFile[rb];
			else 
				dataB = 'd0;
			st_B = 1;
		end
	end
endmodule