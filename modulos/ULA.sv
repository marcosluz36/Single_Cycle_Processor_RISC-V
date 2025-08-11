module ULA(
	input  [31:0] srcA,
   input  [31:0] srcB,
	input  [2:0]  control,
   output [31:0] result, 
	output        z
);

localparam ADD = 3'd0, SUB = 3'd1, AND = 3'd2,
            OR = 3'd3, SLT = 3'd5;

always_comb
	case(control)
		ADD: result = srcA + srcB;	
		SUB: result = srcA - srcB;
		AND: result = srcA & srcB;
		 OR: result = srcA | srcB;
		SLT: result = srcA < srcB;
		default: result = 32'hDEADCAFE;
	endcase

assign z = (result == 32'd0) ? 1'b1 : 1'b0;

endmodule