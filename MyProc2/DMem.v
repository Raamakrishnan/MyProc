`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

//Data Memory
module DMem(
	input wire [`WIDTH - 1:0] add,
	inout wire [`WIDTH - 1:0] data,
	input wire wr,
	input wire rd,
	output reg rd_st,
	input wire [1:0] mode //mode: 0-word, 1-halfword, 2-byte
);

	reg [7:0] mem [`WIDTH - 1:0];
	reg [`WIDTH - 1:0] data_r;

	assign data = data_r;

	always @(posedge wr) begin
		case (mode)
			0: begin // word
				{mem[add], mem[add+1], mem[add+2], mem[add+3]} = data;
			end
			1: begin // half-word
				{mem[add], mem[add+1]} = data[15:0];
			end
			2: begin // byte
				mem[add] = data[7:0];
			end
		endcase
	end

	always @(posedge rd) begin
		rd_st = 0;
		case (mode)
			0: begin // word
				data_r = {mem[add], mem[add+1], mem[add+2], mem[add+3]};
			end
			1: begin // half-word
				data_r = {16'b0 ,mem[add], mem[add+1]};
			end
			2: begin // byte
				data_r = {24'b0, mem[add]};
			end
		endcase
		rd_st = 1;
	end

endmodule