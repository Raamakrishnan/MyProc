module Proc;

// Declare global parameters
parameter WIDTH = 32;
parameter NUMREG = 16;
parameter MEMSIZE = (1<<13);

// Declare storage elements in ISA
reg[7:0]		MEM[0:MEMSIZE-1];	//main memory
reg[WIDTH-1:0]	R[0:NUMREG-1];		//General purpose registers
reg[WIDTH-1:0]	PC;					//Program Counter
reg[WIDTH-1:0]	IR;					//Instruction register
reg 			RUN;				//Execute while Run=1
reg 			C;					//Carry Flag
reg 			V;					//Overflow flag
reg 			Z;					//Zero Flag
reg 			N;					//Negative Flag
`define 	ra 		NUMREG-1		//return address register is last register

// Declare internal registers for ALU operations
reg[WIDTH-1:0] 	op1;				//internal register for ALU
reg[WIDTH-1:0]	op2;				//internal register for ALU
reg[WIDTH:0]	res;				//internal register for ALU - extra bit for carry

// Define opcode and condition codes
`include "ISA.v"

// Trace conditions
`define TRACE_PC 1
`define TRACE_REG 1
`define TRACE_CC 1

// Main fetch-execute loop
reg[WIDTH-1:0] num_instrs;
initial begin
	$readmemh("d", MEM, 0, 71);
	RUN = 1;
	PC = 0;
	num_instrs = 0;
	while(RUN==1) begin
		num_instrs += 1;
		fetch;
		execute;
		print_trace;
	end
	$writememh("data.hex", MEM, 100, 110);
	$display("\nTotal instructions executed %d \n", num_instrs);
	$finish;
end

// Task and function definitions
task fetch;
	begin
		IR = readMem32(PC);
		PC += 4;
	end
endtask

task execute;
	begin
		case(`OPCODE)
			//R Type Arithmetic
			`ADD: 	begin
				op1 = R[`rs];
				op2 = R[`rt];
				res = op1 + op2;
				R[`rd] = res;
				setc(op1, op2, res, 0);
			end
			`SUB:	begin
				op1 = R[`rs];
				op2 = R[`rt];
				res = op1 - op2;
				R[`rd] = res;
				setc(op1, op2, res, 1);
			end
			`AND:	begin
				op1 = R[`rs];
				op2 = R[`rt];
				res = op1 & op2;
				R[`rd] = res;
				Z = ~|res;
			end
			`OR:	begin
				op1 = R[`rs];
				op2 = R[`rt];
				res = op1 | op2;
				R[`rd] = res;
				Z = ~|res;
			end
			`XOR:	begin
				op1 = R[`rs];
				op2 = R[`rt];
				res = op1 ^ op2;
				R[`rd] = res;
				Z = ~|res;
			end
			`SLL:	begin
				op1 = R[`rt];
				res = op1 << `shamt;
				R[`rd] = res;
				C = op1[WIDTH - `shamt - 1];
				Z = ~|res;
			end
			`SRL: begin
				op1 = R[`rt];
				res = op1 >> `shamt;
				R[`rd] = res;
				C = op1[`shamt];
				Z = ~|res;
			end
			`SRA: begin
				op1 = R[`rt];
				res = op1 >> 1;
				res = {op1[WIDTH-1], res[15:0]};
				R[`rd] = res;
				C = op1[0];
				Z = ~|res;
			end
			`SLLV: begin
				op1 = R[`rt];
				op2 = R[`rs];
				res = op1 << op2;
				R[`rd] = res;
				C = op1[WIDTH - op2 - 1];
				Z = ~|res;
			end
			`SRLV: begin
				op1 = R[`rt];
				op2 = R[`rs];
				res = op1 >> op2;
				R[`rd] = res;
				C = op1[op2];
				Z = ~|res;
			end
			`MOV:	R[`rd] = R[`rs];

			`SWAP:	begin
				op1 = R[`rd];
				op2 = R[`rs];
				R[`rd] = op2;
				R[`rs] = op1;
			end
			
			//I Type arithmetic
			`ADDI:	begin
				op1 = R[`rs];
				op2 = sext16(`imm);
				res = op1 + op2;
				R[`rd] = res;
				setc(op1, op2, res, 1);
			end			
			`ORI:	begin
				op1 = R[`rs];
				op2 = sext16(`imm);
				res = op1 | op2;
				R[`rd] = res;
				Z = ~|res;
			end
			`ANDI:	begin
				op1 = R[`rs];
				op2 = sext16(`imm);
				res = op1 & op2;
				R[`rd] = res;
				Z = ~|res;
			end

			//Load - Stores - I Type
			`LUI:	begin
				op1 = sext16(`imm);
				R[`rd] = op1 << 'd16;
			end
			`LDI:	begin
				R[`rd] = sext16(`imm);
				//R[`rd] = `imm;
			end
			`LW:	begin
				R[`rd] = readMem32(R[`rs] + `imm);
			end	
			`LH:	begin
				R[`rd] = readMem16(R[`rs] + `imm);
			end
			`LD:	begin
				R[`rd] = readMem8(R[`rs] + `imm);
			end
			`SW:	begin
				writeMem32(R[`rs] + `imm, R[`rd]);
			end
			`SH:	begin
				writeMem16(R[`rs] + `imm, R[`rd][15:0]);
			end
			`SD:	begin
				writeMem8(R[`rs] + `imm, R[`rd][7:0]);
			end

			`BEQ:	if ($signed(R[`rd]) == $signed(R[`rs]))
						PC = PC + sext16(`imm);
			`BNE:	if ($signed(R[`rd]) != $signed(R[`rs]))
						PC = PC + sext16(`imm);
			`BGTZ:	if ($signed(R[`rd]) > 0)
						PC = PC + sext16(`imm);
			`BLTZ:	if ($signed(R[`rd]) < 0)
						PC = PC + sext16(`imm);
			`BGEZ:	begin
				if ($signed(R[`rd]) >= 0)
						PC = PC + sext16(`imm);
				$display("%d", PC);
			end
			`BLEZ:	if ($signed(R[`rd]) <= 0)
						PC = PC + sext16(`imm);

			`JR:	begin
				op1 = R[`rd];
				op2 = sext16(`imm);
				PC = op1 + op2;
			end
			`JALR:	begin
				op1 = R[`rd];
				op2 = sext16(`imm);
				R[`ra] = PC;
				PC = op1 + op2;
			end

			`J:		PC = `tgt;
			`JAL:	begin
				R[`ra] = PC;
				PC = `tgt;
			end

			`NOP:;
			`HALT:	RUN = 0;
			default: begin
				$display("Undefined OpCode: %d", `OPCODE);
				RUN = 0;
			end
		endcase
	end
endtask

// Utility operations and functions

//function to read mem - big-endian
function [WIDTH-1:0] readMem32(
	input [WIDTH-1:0] addr);	//address to read
		readMem32 = {MEM[addr], MEM[addr+1], MEM[addr+2], MEM[addr+3]};
endfunction //end read_mem

function [15:0] readMem16(
	input [WIDTH-1:0] addr);	//address to read
		readMem16 = {MEM[addr], MEM[addr+1]};
endfunction

function [7:0] readMem8(
	input [WIDTH-1:0] addr);	//address to read
		readMem8 = MEM[addr];
endfunction

task writeMem32(
	input [WIDTH-1:0] addr,
	input [WIDTH-1:0] data);
		{MEM[addr], MEM[addr+1], MEM[addr+2], MEM[addr+3]} = data;
endtask

task writeMem16(
	input [WIDTH-1:0] addr,
	input [15:0] data);
		{MEM[addr], MEM[addr+1]} = data;
endtask

task writeMem8(
	input [WIDTH-1:0] addr,
	input [7:0] data);
		MEM[addr] = data;
endtask

//function to print trace
task print_trace;
	integer i,j,k;
	begin
	`ifdef TRACE_PC
	begin
		$display("Ins. No.= %d\tPC= %d\tOpCode=%d", num_instrs, PC, `OPCODE);
	end
	`endif

	`ifdef TRACE_REG
	begin
		k=0;
		for(i=0;i<16;i+=4)
		begin
			//$write("R[%d] = ", k);
			for(j=0;j<4;j++)
				begin
					$write("R[%d] = %h \t", k, R[k]);
					k +=1;
				end
			$write("\n");
		end
	end
	`endif

	`ifdef TRACE_CC
	begin
		$display("C = %b\tZ = %b\tN = %b\tV = %b", C, Z, N, V);
	end
	`endif
	end
endtask

task setc(
	input [WIDTH-1:0] op1, op2,
	input [WIDTH:0] res,
	input subt);
	begin
		C = res[WIDTH];
		Z = ~|res;
		N = res[WIDTH-1];
		V = ( res[WIDTH-1] & op1[WIDTH-1] & ~(subt ^ op2[WIDTH-1])) | (~res[WIDTH-1] & op1[WIDTH-1] & (subt ^ op2[WIDTH-1]));
	end
endtask

function [WIDTH-1:0] sext16(
	input [15:0] d_in);
	begin
		sext16[WIDTH-1:0] = {{(WIDTH-16){d_in[15]}}, d_in};
	end
endfunction

function [WIDTH-1:0] sext25(
	input [24:0] d_in);
	sext25[WIDTH-1:0] = {{(WIDTH-25){d_in[24]}}, d_in};
endfunction

endmodule