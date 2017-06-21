`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

//Data Memory
module DMem(
	input wire clk,
	input wire [`WIDTH - 1:0] add,
	inout wire [7:0] data,
	input wire en,
	input wire wr_rd_n);

	reg [7:0] mem [`WIDTH - 1:0];
	reg [7:0] data_r;

	assign data = data_r;

	always @(posedge clk) begin
		if (en) begin
			if(wr_rd_n) begin
				mem[add] <= data;
			end
			else begin
				data_r <= mem[add];
			end
		end
	end
endmodule