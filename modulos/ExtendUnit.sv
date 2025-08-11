module ExtendUnit(
	input  [31:7] imm,
	input  [1:0]  immSrc,
	output [31:0] immExt
);

localparam I_TYPE = 2'b00, S_TYPE = 2'b01, B_TYPE = 2'b10;

always_comb
	case(immSrc)
		I_TYPE: immExt <= {{20{imm[11]}}, imm[31:20]};
		
		S_TYPE: immExt <= {{20{imm[11]}}, imm[31:25], imm[11:7]};
		
		B_TYPE: immExt <= {{19{imm[11]}}, imm[7], imm[30:25], imm[11:8], 1'b0};
		
		default: immExt <= 32'bx;
	endcase
endmodule