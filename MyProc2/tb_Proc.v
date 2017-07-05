`timescale 1ns/100ps
// Trace
`define TRACE_REG
`define TRACE_PIPELINE
`define TRACE_MEM
`include "Proc.v"

module tb_Proc ();

	reg clk;
	reg rst_n;
	reg print;
	wire halt;

	always
		#5 clk = ~clk;

	Proc Proc(.clk(clk), .rst_n(rst_n), .halt(halt), .Print(print));

	initial begin
		clk = 0;
		$display("Starting Sim");
		print = 0;
		rst_n = 1;
		rst_n = 0;	// negedge to reset
	end

	always @(posedge halt) begin
		$display($time ," End of sim");
`ifdef TRACE_MEM
		print = 1;
`endif
		$stop;
	end

endmodule