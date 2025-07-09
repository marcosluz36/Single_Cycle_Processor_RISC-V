module Registrador(
	input            clk,
	input            rst,
	input            en,
	input      [3:0] in,
	output reg [3:0] out
);

always_ff @(posedge clk or negedge rst)
	if (!rst)
		out <= 4'h0;
	else
      out <= en ? in : out;
		
endmodule