module ClockDivider(
	input      clk_50,
	input      rst,
	output reg clk
);

reg [24:0] count;

always_ff @ (posedge clk_50 or negedge rst) begin
	if (!rst) begin
		count <= 25'd0;
		clk <= 1'b0;
	end
	
	else if (count == 24_999_999) begin
		count <= 1'b0;
		clk <= ~clk;
	end
		
	else 
		count <= count + 25'd1;
end

endmodule