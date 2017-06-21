module imem(
	input wire clk,
	input wire [WIDTH - 1 : 0] add,
	input wire [31 : 0] data_in,
	output reg [31 : 0] data_out,
	input wire r_en,
	input wire w_en);
	
	parameter WIDTH = 8;

	reg [31:0] mem [0:15];
	//reg [31:0] data_out;
	//reg [31:0] data_in;
	reg r_en_r;

	//assign data = r_en ? data_out : 32'bz;

	always @(posedge clk) begin
		// $display("r_en=%b w_en=%b data=%h", r_en, w_en, data);
		if (r_en & !w_en) begin
			data_out = mem[add];
			$display(mem[add],r_en);
		end
	end

	always @(negedge clk) begin
		if(w_en & !r_en) begin
			mem[add] <= data_in;
			$display(mem[add]);
		end
	end

	initial begin
		$monitor($time, " dut clk=%b add=%h data_in=%h data_out=%h r_en=%b w_en=%b", clk, add, data_in, data_out, r_en, w_en);
	end

endmodule // imem	