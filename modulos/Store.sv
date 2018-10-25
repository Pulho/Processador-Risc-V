module Store(input logic [2:0] func3, input logic [63:0] regLD, input logic[63:0] regBase, output logic [63:0] regWR);

always_comb begin
	case (func3)
		3'b111: begin
			
			regWR = regBase;
		end

		3'b010: begin
			regWR[31:0] = regBase[31:0];
			regWR[63:32] = regLD[63:32];
		end

		3'b001: begin
			regWR[15:0] = regBase[15:0];
			regWR[63:16] = regLD[63:16];
		end

		3'b000: begin
			regWR[7:0] = regBase[7:0];
			regWR[63:8] = regLD[63:8];
		end

		default : regWR = 64'b0000000000000000000000000000000000000000000000000000000000000000;
	endcase
end

endmodule: Store