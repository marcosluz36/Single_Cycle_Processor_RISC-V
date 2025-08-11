module ControlUnit(
	input      [6:0] Op,
	input      [2:0] Funct3,
	input      [6:0] Funct7,
	output reg       ResultSrc,
	output reg       MemWrite,
	output reg [2:0] ULAControl,
	output reg       ULASrc,
	output reg [1:0] ImmSrc,
	output reg       RegWrite,
	output reg       Branch
);

localparam R_TYPE = 7'b011_0011,    S_TYPE = 7'b010_0011,     B_TYPE = 7'b110_0011,
			  I_TYPE_LW = 7'b000_0011, I_TYPE_ULA = 7'b001_0011, I_TYPE_JALR = 7'b110_0111;
          
localparam ADD = 4'b000_0,  SUB = 4'b000_1,  AND = 4'b111_0,
            OR = 4'b110_0,  SLT = 4'b010_0,  ADDI = 4'b000_x,
			   LW = 4'b010_x,   SW = 4'b010_x,  JALR = 4'b000_x;

wire [3:0] functMSB = {Funct3, Funct7[5]};			
				
always_comb
	case(Op)
		R_TYPE: begin
			RegWrite  <= 1'b1;
			ImmSrc    <= 2'bx;
			ULASrc    <= 1'b0;
			MemWrite  <= 1'b0;
			ResultSrc <= 1'b0;
			Branch <= 1'b0;
			
			case(functMSB)
				ADD: 
					ULAControl <= 3'b000;	
				SUB: 
					ULAControl <= 3'b001;
				AND: 
					ULAControl <= 3'b010;
				 OR: 
					ULAControl <= 3'b011;
				SLT: 
					ULAControl <= 3'b101;
				default: 
					ULAControl <= 3'b100;
			endcase
		end
		
		I_TYPE_LW: begin
			RegWrite   <= 1'b1;
			ImmSrc     <= 2'b00;
			ULASrc     <= 1'b1;
			ULAControl <= 3'b000;
			MemWrite   <= 1'b0;
			ResultSrc  <= 1'b1;
			Branch     <= 1'b0;
		end

		I_TYPE_ULA: begin
			RegWrite   <= 1'b1;
			ImmSrc     <= 2'b00;
			ULASrc     <= 1'b1;
			ULAControl <= 3'b000;
			MemWrite   <= 1'b0;
			ResultSrc  <= 1'b0;
			Branch     <= 1'b0;
		end
		
		I_TYPE_JALR: begin
			RegWrite   <= 1'b1;
			ImmSrc     <= 2'b00;
			ULASrc     <= 1'b1;
			ULAControl <= 3'b000;
			MemWrite   <= 1'b0;
			ResultSrc  <= 1'b0;
			Branch     <= 1'b1;
		end
		
	   S_TYPE: begin	
			RegWrite   <= 1'b0;
			ImmSrc     <= 2'b01;
			ULASrc     <= 1'b1;
			ULAControl <= 3'b000;
			MemWrite   <= 1'b1;
			ResultSrc  <= 1'bx;
			Branch <= 1'b0;
		end
		
		B_TYPE: begin
			RegWrite   <= 1'b0;
			ImmSrc     <= 2'b10;
			ULASrc     <= 1'b1;
			ULAControl <= 3'b000;
			MemWrite   <= 1'b0;
			ResultSrc  <= 1'bx;
			Branch     <= 1'b1;
		end
		
		default begin
			RegWrite   <= 1'b0;
			ImmSrc     <= 2'bx;
			ULASrc     <= 1'bx;
			ULAControl <= 3'b100;
			MemWrite   <= 1'b0;
			ResultSrc  <= 1'bx;
			Branch     <= 1'b0;
		end
	endcase
endmodule