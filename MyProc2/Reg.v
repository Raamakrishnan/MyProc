`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

//32 bit registers - 32 Nos.

module Reg(
	input wire clk,    // Clock
	input wire [`REG_ADDR_LEN - 1:0] ra,
	input wire [`REG_ADDR_LEN - 1:0] rb,
	output reg [`WIDTH - 1:0] dataA,
	output reg [`WIDTH - 1:0] dataB,
	output reg st_A,	// output strobe
	output reg st_B,	// output strobe
	input wire r_en_A,
	input wire r_en_B,
	input wire [`REG_ADDR_LEN - 1:0] rc,
	input wire [`WIDTH -1 :0] dataC,
	input wire w_en,
	input wire [1:0] w_mode //w_mode: 0-word, 1-halfword, 2-byte
);

	reg [`WIDTH - 1:0] RegFile [`NUM_REGS - 1:0];

	always @(posedge clk) begin
		if (w_en) begin
			if(rc != 0) begin
				case(w_mode)
					0:	RegFile[rc] <= dataC;
					1:	RegFile[rc] <= {16'b0, dataC[15:0]};
					2:	RegFile[rc] <= {24'b0, dataC[7:0]};
				endcase
			end
		end
	end

	always @(negedge clk) begin
		if (r_en_A) begin
			st_A = 0;
			if(ra != 0)
				dataA = RegFile[ra];
			else 
				dataA = 'd0;
			st_A = 1;
		end
	end

	always @(negedge clk) begin
		if (r_en_B) begin
			st_B = 0;
			if(rb != 0)
				dataB = RegFile[rb];
			else 
				dataB = 'd0;
			st_B = 1;
		end
	end

`ifdef TRACE_REG
	integer i,j,k;
	always @(posedge clk) begin
		k=0;
		for(i=0;i<32;i=i+4)
		begin
			//$write("R[%d] = ", k);
			for(j=0;j<4;j=j+1)
				begin
					$write("R[%d] = %h\t", k, RegFile[k]);
					k = k + 1;
				end
			$write("\n");
		end
	end
`endif

endmodule