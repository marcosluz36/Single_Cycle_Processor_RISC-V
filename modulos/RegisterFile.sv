module RegisterFile(
	input        clk, rst, we3,
	input  [4:0] wa3, ra1, ra2,
	input  [31:0] wd3,
	output [31:0] rd1, rd2,
	output [31:0] x0, x1, x2, x3,
	output [31:0] x4, x5, x6, x7
);

reg [31:0] register[31:0];

assign rd1 = register[ra1];
assign rd2 = register[ra2];

assign x0 = register[5'd0];
assign x1 = register[5'd1];
assign x2 = register[5'd2];
assign x3 = register[5'd3];
assign x4 = register[5'd4];
assign x5 = register[5'd5];
assign x6 = register[5'd6];
assign x7 = register[5'd7];


always_ff @ (posedge clk or negedge rst) begin
	if (!rst) begin
		for (int i = 0; i < 32; i++)
			register[i] <= 32'd0;
	end
			
	else if (we3 && wa3 > 0)
		register[wa3] = wd3;
end

endmodule
