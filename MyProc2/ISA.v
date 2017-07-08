//ISA definitions
//v2.0 for MyProc2

//define fields of instruction
`define OPCODE  IR[31:26]
`define rd 		IR[25:21]
`define rs		IR[20:16]
`define rt		IR[15:11]
`define shamt	IR[10:6]
`define imm 	IR[15:0]
`define tgt		IR[25:0]

//define instructions
`define NOP 	'd0

//R Type
`define R_TYPE	`ADD, `SUB, `AND, `OR, `XOR, `SLL, `SRL, `SRA, `SLLV, `SRLV, `SRAV, `SLT

`define ADD 	'd1
`define SUB 	'd2
`define AND 	'd3
`define OR		'd4
`define XOR 	'd5

`define SLL		'd6
`define SRL		'd7
`define SRA		'd8
`define SLLV	'd9
`define SRLV	'd10
`define SRAV	'd11

`define SLT		'd23

//I Type
`define I_TYPE `ADDI, `ORI, `ANDI, `LUI, `LDI

`define ADDI	'd12
`define ORI		'd13
`define ANDI	'd14
`define LUI		'd15
`define LDI		'd16

`define LW		'd17
`define LH		'd18
`define LD 		'd19
`define SW		'd20
`define SH		'd21
`define SD		'd22

// Branch
`define Branch	`BEQ, `BNE, `BGTZ, `BLTZ, `BGEZ, `BLEZ, `JR, `JALR

`define BEQ		'd24
`define BNE		'd25
`define BGTZ	'd26
`define BLTZ	'd27
`define BGEZ	'd28
`define BLEZ	'd29

`define JR		'd30
`define JALR	'd31

// J Type
`define J_TYPE	`J, `JAL
`define J 		'd32
`define JAL 	'd33

`define HALT 	'd63