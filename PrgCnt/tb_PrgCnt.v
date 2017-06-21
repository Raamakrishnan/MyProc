`timescale 1ns/100ps

`include "PrgCnt.v"
module tb_PrgCnt();
	reg clk;
	reg rst;
	reg [7:0] ld_add;
	reg ld;
	wire [7:0] add_out;

	prgcnt dut(.clk(clk), .rst(rst), .ld_add(ld_add), .ld(ld), .add_out(add_out));

	always
		#10 clk = ~clk;

	task loadAddress(
		input [7:0] add);
		begin
			@(negedge clk);
			$display("Loading address");
			ld_add = add;
			ld = 1'd1;
			@(negedge clk);
			ld = 1'd0;
			$display("loaded");
		end
	endtask

	initial begin
		$dumpfile("PrgCnt_wave.vcd");
		$dumpvars(0, dut);
		$display("starting sim");
		clk = 0;
		rst = 1;			//reset is active
		ld = 0;
		#20 rst <= 1'd0;		//out of reset after 20
		@(negedge clk);
		loadAddress(8'hA);		//load address
		#100 @(negedge clk);
		$display("reset");
		rst = 1;
		#20 rst = 0;
		#50 $display("Stopping sim");
		$finish;
	end

	//The monitor
	initial begin
		$monitor($time," clk = %b, rst = %b, ld = %b, ld_add = %h, add_out = %h", clk, rst, ld, ld_add, add_out);
	end

endmodule