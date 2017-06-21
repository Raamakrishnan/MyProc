`include "params.v"
`define INCLUDE_PARAMS

`include "ISA.v"
`define INCLUDE_ISA

//include modules
`include "IMem.v"
`define INCLUDE_IF_MOD
`include "IF.v"


`include "Reg.v"

module Proc (
	input clk,    // Clock
	input rst_n  // Asynchronous reset active low
);

	IF_mod IF(.clk(clk), .rst_n(rst_n));

	Reg_mod Reg(.clk(clk));

endmodule