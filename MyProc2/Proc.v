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

	// wires for Reg to ID - Read port 1
	wire [`WIDTH - 1:0] Rd1_data;
	wire [`REG_ADDR_LEN - 1:0] Rd1_addr;
	wire Rd1_en;
	wire Rd1_st;
	// Read port 2
	wire [`WIDTH - 1:0] Rd2_data;
	wire [`REG_ADDR_LEN - 1:0] Rd2_addr;
	wire Rd2_en;
	wire Rd2_st;
	// Write port
	wire [`WIDTH - 1:0] Wt_data;
	wire [`REG_ADDR_LEN - 1:0] Wt_addr;
	wire Wt_en;

	Reg_mod Reg(.clk(clk), .ra(Rd1_addr), .dataA(Rd1_data), .r_en_A(Rd1_en), .st_A(Rd1_st),
		.rb(Rd2_addr), .dataB(Rd2_data), .r_en_B(Rd2_en), .st_B(Rd2_st),
		.rc(Wt_addr), .dataC(Wt_data), .w_en(Wt_en));

	ID_mod ID(.clk(clk), .PC_in(PC_Int_Reg_to_ID), .IR_in(IR_Int_Reg_to_ID), 
		.Rd1_addr(Rd1_addr), .Rd1_data(Rd1_data), .Rd1_en(Rd1_en), .Rd1_st(Rd1_st),
		.Rd2_addr(Rd2_addr), .Rd2_data(Rd2_data), .Rd2_en(Rd2_en), .Rd2_st(Rd2_st));



endmodule