module dmem(
	input wire clk,
	input wire [WIDTH - 1:0] add,
	inout wire [8:0] data,
	input wire en,
	input wire wr_rd_n);

	parameter WIDTH = 8;

	reg [8:0] mem [WIDTH - 1:0];
	reg [8:0] data_r;

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