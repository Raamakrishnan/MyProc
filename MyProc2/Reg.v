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
	input wire r_en,
	input wire [`REG_ADDR_LEN - 1:0] rc,
	input wire [`WIDTH -1 :0] dataC,
	input wire w_en
);

	reg [`WIDTH - 1:0] RegFile [`NUM_REGS - 1:0];

	always @(posedge clk) begin
		if (w_en && CheckRegNo(rc)) begin
			if(rc != 0)
				RegFile[rc] <= dataC;
		end
	end

	always @(negedge clk) begin
		if (r_en && CheckRegNo(ra) && CheckRegNo(rb)) begin
			if(ra != 0)
				dataA <= RegFile[ra];
			else 
				dataA <= 'd0;
			if(rb != 0)
				dataB <= RegFile[rb];
			else 
				dataB <= 'd0;
		end
	end

	function CheckRegNo(
		input no);
		begin
			if(no <= `NUM_REGS - 1)
				CheckRegNo = 'd1;
			else 
				CheckRegNo = 'd0;
		end
	endfunction
endmodule