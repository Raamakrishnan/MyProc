//Dual-Port RAM - one port to write, other to read. 
//Default 1024 x 1 Byte = 1KB
module ram #(parameter AddressSize = 10, WordSize = 8)
	(
	input clk,    // Clock
	input [AddressSize - 1 : 0] add_r,
	output [WordSize - 1 : 0] data_r,
	input r_en,
	input [AddressSize - 1 : 0] add_w,
	input [WordSize - 1 : 0] data_w,
	input w_en
	);
	
	reg [WordSize - 1 : 0] mem [0 : (1<<AddressSize) - 1];
	
	always @(posedge clk) begin
		if(w_en) begin
			mem[add_w] = data_w;
		end
	end
//wrong	
	always @(negedge clk) begin
		if(r_en) begin
			mem[add_r] = data_r;
		end
	end
endmodule