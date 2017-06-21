//ISA definitions

//define fields of instruction
`define OPCODE  IR[31:24]
`define rd 		IR[23:20]
`define rs		IR[19:16]
`define rt		IR[15:12]
`define shamt	IR[11:8]
`define imm 	IR[15:0]
`define tgt		IR[25:0]

//define instructions
`define NOP 	'd0
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

`define MOV		'd34
`define SWAP	'd35

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

`define BEQ		'd24
`define BNE		'd25
`define BGTZ	'd26
`define BLTZ	'd27
`define BGEZ	'd28
`define BLEZ	'd29

`define JR		'd30
`define JALR	'd31

`define J 		'd32
`define JAL 	'd33

`define HALT 'd255