`include "params.v"
`define INCLUDE_PARAMS

`include "ISA.v"
`define INCLUDE_ISA

// include modules
`include "IMem.v"
`define INCLUDE_IF_MOD
`include "IF.v"

`include "IF_ID.v"

`include "Reg.v"

`define INCLUDE_ID_MOD
`include "ID.v"

`include "ID_EXE.v"

`define INCLUDE_EXE_MOD
`include "EXE.v"

`include "EXE_MEM.v"

`include "DMem.v"
`define INCLUDE_MEM_MOD
`include "MEM.v"

module Proc (
	input clk,    	// Clock
	input rst_n,	// Asynchronous reset active low
	output halt
);

	// wires for IF to IF-ID
	wire [`WIDTH - 1:0] IR_IF_ID1;
	wire [`WIDTH - 3:0] PC_IF_ID1;

	// wires for ID to IF-ID
	wire [`WIDTH - 1:0] IR_IF_ID2;
	wire [`WIDTH - 3:0] PC_IF_ID2;

	IF IF(.clk(clk), .rst_n(rst_n), .IR(IR_IF_ID1), .PC(PC_IF_ID1));

	IF_ID IF_ID(.clk(clk), .IR_in(IR_IF_ID1), .PC_in(PC_IF_ID1), 
		.IR_out(IR_IF_ID2), .PC_out(PC_IF_ID2));

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

	Reg Reg(.clk(clk), .ra(Rd1_addr), .dataA(Rd1_data), .r_en_A(Rd1_en), .st_A(Rd1_st),
		.rb(Rd2_addr), .dataB(Rd2_data), .r_en_B(Rd2_en), .st_B(Rd2_st),
		.rc(Wt_addr), .dataC(Wt_data), .w_en(Wt_en));

	// wires for ID to ID-EXE
	wire [`WIDTH - 3:0] PC_ID_EXE1;
	wire [`WIDTH - 1:0] IR_ID_EXE1;
	wire [`WIDTH - 1:0] X_ID_EXE1;
	wire [`WIDTH - 1:0] Y_ID_EXE1;

	// wires for ID-EXE to EXE
	wire [`WIDTH - 3:0] PC_ID_EXE2;
	wire [`WIDTH - 1:0] IR_ID_EXE2;
	wire [`WIDTH - 1:0] X_ID_EXE2;
	wire [`WIDTH - 1:0] Y_ID_EXE2;

	ID ID(.clk(clk), .PC_in(PC_IF_ID2), .IR_in(IR_IF_ID2), 								// pipeline in
		.Rd1_addr(Rd1_addr), .Rd1_data(Rd1_data), .Rd1_en(Rd1_en), .Rd1_st(Rd1_st),		// register ports
		.Rd2_addr(Rd2_addr), .Rd2_data(Rd2_data), .Rd2_en(Rd2_en), .Rd2_st(Rd2_st),
		.PC_out(PC_ID_EXE1), .IR_out(IR_ID_EXE1), .X(X_ID_EXE1), .Y(Y_ID_EXE1));		// pipeline out

	ID_EXE ID_EXE(.clk(clk), .PC_in(PC_ID_EXE1), .IR_in(IR_ID_EXE1), .X_in(X_ID_EXE1), .Y_in(Y_ID_EXE1),	//pipeline in
		.PC_out(PC_ID_EXE2), .IR_out(IR_ID_EXE2), .X_out(X_ID_EXE2), .Y_out(Y_ID_EXE2));	// pipeline out

	// wires for EXE to EXE-MEM
	wire [`WIDTH - 3:0] PC_EXE_MEM1;
	wire [`WIDTH - 1:0] IR_EXE_MEM1;
	wire [`WIDTH - 1:0] Z_EXE_MEM1;
	wire [`WIDTH - 1:0] Addr_EXE_MEM1;

	// wires for EXE-MEM to MEM
	wire [`WIDTH - 3:0] PC_EXE_MEM2;
	wire [`WIDTH - 1:0] IR_EXE_MEM2;
	wire [`WIDTH - 1:0] Z_EXE_MEM2;
	wire [`WIDTH - 1:0] Addr_EXE_MEM2;	

	EXE EXE(.clk(clk), .PC_in(PC_ID_EXE2), .IR_in(IR_ID_EXE2), .X(X_ID_EXE2), .Y(Y_ID_EXE2), 	// pipeline in
		.PC_out(PC_EXE_MEM1), .IR_out(IR_EXE_MEM1), .Z(Z_EXE_MEM1), .Addr(Addr_EXE_MEM1) 		// pipeline out
		);

	EXE_MEM EXE_MEM(.clk(clk), .PC_in(PC_EXE_MEM1), .IR_in(IR_EXE_MEM1), .Z_in(Z_EXE_MEM1), .Addr_in(Addr_EXE_MEM1), // pipeline in
		.PC_out(PC_EXE_MEM2), .IR_out(IR_EXE_MEM2), .Z_out(Z_EXE_MEM2), .Addr_out(Addr_EXE_MEM2));

	MEM MEM(.clk(clk), .PC_in(PC_EXE_MEM2), .IR_in(IR_EXE_MEM2), .Z_in(Z_EXE_MEM2), .Addr(Addr_EXE_MEM2)); 	// pipeline out);



endmodule