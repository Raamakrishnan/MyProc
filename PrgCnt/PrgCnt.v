module prgcnt(
	input wire clk,
	input wire rst,
	input wire [7:0] ld_add,
	input wire ld,
	output wire [7:0] add_out);

	reg [7:0] count;

	assign add_out = count;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			count <= 8'd0;
		end
		else if (ld) begin
			count <= ld_add;
		end
		else begin
			count = count + 4;	//for 32 byte next instruction
		end
	end

endmodule