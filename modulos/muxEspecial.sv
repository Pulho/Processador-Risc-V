module muxEspecial(
	input logic sinalMenor,
	input logic [1:0] sel,
	input logic [63:0] e1,
	input logic [63:0] e2,
	input logic [63:0] e3,
	input logic [63:0] e4,
	input logic [31:0] inst,
	output logic [63:0] f
);

always_comb begin

	if( inst[6:0] == 7'b0010011) begin //slti

		if( inst[14:12] == 3'b010 ) begin

			if( sinalMenor == 1'b0 ) f = 64'b0000000000000000000000000000000000000000000000000000000000000000;
			else f = 64'b0000000000000000000000000000000000000000000000000000000000000001;
		end
	end

	if( inst[6:0] == 7'b0000011) begin //Loads

		case(inst[14:12])

			3'b011: begin	// ld -> rd = MEM[rs1 + imm]
				f = e2;
			end

			3'b010: begin	// lw -> rd[31:0] = MEM[rs1 + imm] (Extender sinal)

				f[31:0] = e2[31:0];
				if( e2[31] == 1'b0 ) begin
					f[63:32] = 32'b00000000000000000000000000000000;
				end else if( e2[31] == 1'b1 ) begin
					f[63:32] = 32'b11111111111111111111111111111111;
				end
			end

			3'b100: begin // lbu -> rd[7:0] = MEM[rs1 + imm] (completa com 0)

				f[7:0] = e2[7:0];
				f[63:8] = 56'b00000000000000000000000000000000000000000000000000000000;
			end

			3'b001: begin // lh -> rd[15:0] = MEM[rs1 + imm] (Extender sinal)

				f[15:0] = e2[15:0];
				if( e2[15] == 1'b0 ) begin
					f[63:16] = 48'b000000000000000000000000000000000000000000000000;
				end else if( e2[15] == 1'b1 ) begin
					f[63:16] = 48'b111111111111111111111111111111111111111111111111;
				end
			end

			default: begin
				f = 64'b0000000000000000000000000000000000000000000000000000000000000000;
			end
		endcase
	end

	else begin

		case(sel)

			2'b00: begin
				f = e1;
			end

			2'b01: begin
				f = e2;
			end

			2'b10: begin
				f = e3;
			end

			2'b11: begin
				f = e4;
			end
		endcase
	end
end


endmodule: muxEspecial