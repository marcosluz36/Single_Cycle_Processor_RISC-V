module Mux_2x1 #(
	parameter N = 4
)(
	input  [N-1:0] i0,
	input  [N-1:0] i1,
	input          sel,
	output [N-1:0] out
);

assign out = sel ? i1 : i0;

endmodule