`include "params.v"
`define INCLUDE_PARAMS

`include "ISA.v"
`define INCLUDE_ISA

// include modules
`include "IMem.v"
`define INCLUDE_IF_MOD
`include "IF.v"

`include "Int_Reg_1.v"

`include "Reg.v"

`define INCLUDE_ID_MOD
`include "ID.v"

module Proc (
	input clk,    	// Clock
	input rst_n,	// Asynchronous reset active low
	output halt
);

	// wires for IF to IF-ID
	wire [`WIDTH - 1:0] IR_IF_to_Int_Reg;
	wire [`WIDTH - 3:0] PC_IF_to_Int_Reg;

	// wires for ID to IF-ID
	wire [`WIDTH - 1:0] IR_Int_Reg_to_ID;
	wire [`WIDTH - 3:0] PC_Int_Reg_to_ID;

	IF_mod IF(.clk(clk), .rst_n(rst_n), .IR(IR_IF_to_Int_Reg), .PC(PC_IF_to_Int_Reg));

	Int_Reg_1_mod Int_Reg_IF_ID(.clk(clk), .IR_in(IR_IF_to_Int_Reg), .PC_in(PC_IF_to_Int_Reg), 
		.IR_out(IR_Int_Reg_to_ID), .PC_out(PC_Int_Reg_to_ID));

	// wires for Reg to ID

	
	Reg_mod Reg(.clk(clk));

	ID_mod ID(.clk(clk), .PC_in(PC_Int_Reg_to_ID), .IR_in(IR_Int_Reg_to_ID));



endmodule