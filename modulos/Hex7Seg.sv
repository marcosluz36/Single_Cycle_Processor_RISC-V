module Hex7Seg(
	input      [3:0] in,
	output reg [0:6] out
);

always_comb
	case(in)
		4'h0: out <= 7'b000_0001;
		4'h1: out <= 7'b100_1111;
		4'h2: out <= 7'b001_0010;
		4'h3: out <= 7'b000_0110;
		4'h4: out <= 7'b100_1100; 
		4'h5: out <= 7'b010_0100;
		4'h6: out <= 7'b010_0000;
		4'h7: out <= 7'b000_1111;
		4'h8: out <= 7'b000_0000;
		4'h9: out <= 7'b000_0100;
		4'hA: out <= 7'b000_1000;
		4'hB: out <= 7'b110_0000;
		4'hC: out <= 7'b011_0001;
		4'hD: out <= 7'b100_0010;
		4'hE: out <= 7'b011_0000;
		4'hF: out <= 7'b011_1000;
		default: out <= 7'b010_0011;
	endcase
	
endmodule