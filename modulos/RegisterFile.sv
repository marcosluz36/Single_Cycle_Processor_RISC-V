module RegisterFile(
	input        clk, rst, we3,
	input  [2:0] wa3, ra1, ra2,
	input  [7:0] wd3,
	output [7:0] rd1, rd2
);

reg [7:0] register[7:0];

assign rd1 = register[ra1];
assign rd2 = register[ra2];

always_ff @ (posedge clk or negedge rst) begin
	if (!rst) begin
		for (int i = 0; i < 8; i++)
			register[i] <= 8'd0;
	end
			
	else if (we3 && wa3 > 0)
		register[wa3] = wd3;
end

endmodule