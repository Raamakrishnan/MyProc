module alu (
	input clk,    // Clock
	input wire [7:0] opCode,
	input wire [15:0] opA,
	input wire [15:0] opB,
	output reg [15:0] opC,
	input wire [15:0] imm
);
	//R Instructions
	parameter ADD	=8'd1;
	parameter SUB	=8'd2;
	parameter AND	=8'd3;
	parameter OR	=8'd4;

	always @(posedge clk) begin
		case (opCode)
		//R Instructions
			AND:	opC <= opA + opB;
			SUB:	opC <= opA - opB;
			AND:	opC <= opA & opB;
			OR:		opC <= opA | opB;
			default:;
		endcase
	end
endmodule