`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_MEM_MOD
	`include "DMem.v"
`endif

`ifndef INCLUDE_ISA
	`include "ISA.v"
`endif

module MEM (
	input wire clk,    // Clock
	
	// pipeline inputs
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	input wire [`WIDTH - 1:0] Z_in,
	input wire [`WIDTH - 1:0] Addr,

	// pipeline outputs
	output wire [`WIDTH - 1:0] IR_out,
	output wire [`WIDTH - 3:0] PC_out,
	output wire [`WIDTH - 1:0] Z_out

	// mem trace
`ifdef TRACE_MEM
	,input wire Print
`endif
);

	wire [5:0] OpCode;
	assign OpCode = IR_in[31:26];

	reg [`WIDTH - 1:0] addr;
	wire [`WIDTH - 1:0] data;
	reg [`WIDTH - 1:0] data_reg;
	reg data_v;
	reg wr;
	reg rd;
	wire rd_st;
	reg [1:0] mode;

	reg [`WIDTH - 1:0] Z_reg;

	assign data = (data_v == 1)? data_reg : 32'hZ;
	assign PC_out = PC_in;
	assign IR_out = IR_in;
	assign Z_out = (rd == 1)? data : Z_in;

	DMem DMem(.add(addr), .data(data), .wr(wr), .rd(rd), .rd_st(rd_st), .mode(mode)
`ifdef TRACE_MEM
	, .Print(Print)
`endif
	);

	always @(IR_in or PC_in) begin
		rd = 0;
		wr = 0;
		case(OpCode)
			`LW: begin
				mode = 0;
				ReadMem();
			end
			`LH: begin
				mode = 1;
				ReadMem();
			end
			`LD: begin
				mode = 2;
				ReadMem();
			end
			`SW:begin
				mode = 0;
				WriteMem();
			end
			`SH: begin
				mode = 1;
				WriteMem();
			end
			`SD: begin
				mode = 2;
				WriteMem();
			end
		endcase
	end

	// always @(posedge rd_st) begin
	// 	Z_reg = data;
	// end

	task ReadMem();
		begin
			addr = Addr;
			rd = 1;
		end
	endtask

	task WriteMem();
		begin
			data_reg = Z_in;
			data_v = 1;
			addr = Addr;
			wr = 1;
		end
	endtask


endmodule