`timescale 1ns/100ps
`include "imem.v"

module tb_imem ();
	reg clk;
	reg [7:0] add;
	//wire [31:0] data;
	reg r_en;
	reg w_en;
	reg [31:0] mem [0:15];
	
	wire [31:0] data_out;
	reg [31:0] data_in;
	
	reg [31:0] data_out_r;

	imem dut (.clk(clk), .add(add), .data_in(data_in), .data_out(data_out), .r_en(r_en), .w_en(w_en));

	integer i;
	
	//assign data = w_en ? data_out : 32'bz;

	//clock
	always
		#5 clk = ~clk;

	task loadData;
		begin
			$readmemh("data.hex", mem);
			w_en = 1;
			r_en = 0;
			for(add=0; add<8; add=add+1) begin
				@(negedge clk);
				data_in = mem[add];
				$display("mem ",mem[add]);	
				// $display($time," clk = %b, add = %h, data = %h, r_en = %b, w_en = %b", clk, add, data_out, r_en, w_en);
				//@(negedge clk);
			//	w_en = 0;
			end
		end
	endtask

	task readData;
		begin
			w_en = 0;
			r_en = 0;
			for(add=0;add<8;add=add+1) begin
				r_en = 1;
				@(posedge clk) data_out_r = data_out;
				//$display($time," clk = %b, add = %h, data = %h, r_en = %b, w_en = %b", clk, add, data_in, r_en, w_en);
				//@(negedge clk);
				r_en = 0;
			end

		end
	endtask

	initial begin
		//$dumpfile("IMem_wave.vcd");
		//$dumpvars(0, dut);
		$display("starting testbench for imem");
		clk = 0;
		$display("loading Data");
		loadData();
		$display("reading Data");
		readData();
		$display("sim complete");
		$finish;
	end

	// The monitor
	initial begin
		$monitor($time," tb clk = %b, add = %h, data_in = %h, data_out_r = %h, r_en = %b, w_en = %b", clk, add, data_in, data_out_r, r_en, w_en);
	end

endmodule