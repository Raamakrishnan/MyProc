`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

// Data Memory
module IMem(
	input wire rst_n,
	input wire [`WIDTH - 3:0] add, // last 2 bits are always 0 for aligned memory access
	output reg [`WIDTH - 1:0] data
	);

	reg [7:0] mem [`IMEM_LEN - 1:0];

	// load instructions on reset
	always @(negedge rst_n) begin
		$readmemh("d", mem, 0, 71);
	end

	reg exten_add;

	always @(*) begin
		// extend last 2 bits of address
		exten_add = {add, 1'b0, 1'b0};
		data <= {mem[exten_add], mem[exten_add], mem[exten_add], mem[exten_add]};
	end
endmodule