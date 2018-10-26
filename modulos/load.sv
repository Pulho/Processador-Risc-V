module Load(input logic [2:0] func3, input logic [63:0] regBase, output logic [63:0] regWR);

always_comb begin
	case (func3)
		3'b011: begin // ld
      regWR <= regBase; //regDestino = mem[rs1 + imm]
		end

    3'b010: begin // lw regDestino[31:0] = mem[rs1 + imm] (Extender sinal)
      regWR[31:0] <= regBase[31:0];
      if( regBase[31] == 1'b0 ) begin
        regWR[63:32] <= 32'b00000000000000000000000000000000;
      end else if( regBase[31] == 1'b1 ) begin
        regWR[63:32] <= 32'b11111111111111111111111111111111;
      end
		end

    3'b100: begin // lbu (complementa com 0)
      RegWR[63:8] <= 56'b00000000000000000000000000000000000000000000000000000000;
      regWR[7:0] <= regBase[7:0];
      //Complementar 0
		end

    3'b001: begin // lh regDestino[15:0] = mem[rs1 + imm] (Extender sinal)
      regWR[15:0] <= regBase[15:0];
      if( regBase[15] == 1'b0 ) begin
        regWR[63:32] <= 32'b000000000000000000000000000000000000000000000000;
      end else if( regBase[15] == 1'b1 ) begin
        regWR[63:32] <= 32'b111111111111111111111111111111111111111111111111;
      end
		end

		default : regWR <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
	endcase
end
  
endmodule: Load