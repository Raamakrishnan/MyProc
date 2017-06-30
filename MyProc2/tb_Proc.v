`include "Proc.v"

// Trace
`define TRACE_REG
`define TRACE_PIPELINE

module tb_Proc ();

	reg clk;
	reg rst_n;
	wire halt;

	always
		#5 clk = ~clk;

	Proc Proc(.clk(clk), .rst_n(rst_n), .halt(halt));

	initial begin
		clk = 0;
		$display("Starting Sim");
		rst_n = 1;
		rst_n = 0;	// negedge to reset
	end

	always @(halt) begin
		$display($time ,"End of sim");
		$finish;
	end

endmodule