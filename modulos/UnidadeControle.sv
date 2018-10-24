module UnidadeControle(
	input logic clk, 
	input logic reset,
	input logic [6:0] OPcode,
	input logic [6:0] func7,
	input logic [2:0] func3,

	output logic [4:0] stateout,
	output logic Wrl,
	output logic WrD,
	output logic RegWrite,
	output logic LoadIR,
	output logic [1:0]MemToReg,
	output logic [1:0] ALUSrcA,
	output logic [1:0] ALUSrcB,
	output logic [2:0] ALUFct,
	output logic PCWrite,
	output logic PCWriteCondbeq,
	output logic PCWriteCondbne,
	output logic PCSource,
	output logic LoadRegA,
	output logic LoadRegB,
	output logic LoadAOut,
	output logic LoadMDR
);

logic [4:0] inicio = 5'b00000;
logic [4:0] BInst = 5'b00001;
logic [4:0] IDecod = 5'b00010; 
logic [4:0] Cem = 5'b00011;
logic [4:0] Amld = 5'b00100;
logic [4:0] Ev = 5'b00101;
logic [4:0] Amsd = 5'b00110;
logic [4:0] Exeadd = 5'b00111;
logic [4:0] Exesub = 5'b01000;
logic [4:0] Cr = 5'b01001;
logic [4:0] Crcbeq = 5'b01010;
logic [4:0] Crcbne = 5'b01011;
logic [4:0] Lui = 5'b01100;
logic [4:0] Exeand = 5'b01101;
logic [4:0] Exeslt = 5'b01110;
logic [4:0] Cslt = 5'b01111;

logic [3:0] state; 
logic [3:0] nextState;

always_ff@(posedge clk, posedge reset) begin
	if(reset)begin
		state <= inicio;
	end else begin 
		state <= nextState;
		stateout <= state;
	end
end

always_comb begin
	case(state)
		inicio: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = BInst;
		end
		
		BInst: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b1;
			MemToReg = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b01;
			ALUFct = 3'b001;
			PCWrite = 1'b1;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = IDecod;
		end

		IDecod: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b1;
			MemToReg = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b11;
			ALUFct = 3'b001;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b1;
			LoadRegB = 1'b1;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;

			case(OPcode)

				7'b0110011: begin //Tipo R
					case(func7)

						7'b0000000: begin
							case(func3)
								3'b000: begin
									nextState = Exeadd;
								end
								3'b010: begin
									nextState = Exeslt;
								end
								3'b111: begin
									nextState = Exeand;
								end
							endcase
						end

						7'b0100000: begin
							nextState = Exesub;
						end

						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b0010011: begin //addi
					case(func3)
						3'b000: begin
							nextState = Cem;
						end
						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b0000011: begin //ld
					case(func3)
						3'b011: begin
							nextState = Cem;
						end
						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b0100011: begin //sd
					case(func3)
						3'b111: begin
							nextState = Cem;
						end
						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b1100011: begin //beq
					case(func3)
						3'b000: begin
							nextState = Crcbeq;
						end
						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b1100111: begin //bne
					case(func3)
						3'b001: begin
							nextState = Crcbne;
						end
						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b0110111: begin //lui
					nextState = Lui;
				end

				default: begin
					nextState = inicio;
				end

			endcase

		end

		Cem: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b10;
			ALUFct = 3'b001;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;;

			if(OPcode == 7'b0000011) begin
				if(func3 == 3'b011) begin
					nextState = Amld;
				end
				else nextState = inicio;
			end

			else if(OPcode == 7'b0100011) begin
				if(func3 == 3'b111) begin
					nextState = Amsd;
				end
				else nextState = inicio;
			end

			else if(OPcode == 7'b0010011) begin
				if(func3 == 3'b000) begin
					nextState = Cr;
				end
				else nextState = inicio;
			end
		end

		Amld: begin
			Wrl = 1'b0;
			WrD = 1'b1;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = Ev;
		end

		Ev: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b01;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b1;
			nextState = inicio;
		end

		Amsd: begin
			Wrl = 1'b0;
			WrD = 1'b1;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Exeadd: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b001;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = Cr;			
		end

		Exesub: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b010;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = Cr;	
		end

		Cr: begin
			Wrl = 1'b0;
			WrD = 1'b1;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 2'b00;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Crcbeq: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b010;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b1;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b1;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Crcbne: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b010;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b1;
			PCSource = 1'b1;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Lui: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b10;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Exeand: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b011;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = Cr;
		end

		Exeslt: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b0;
			LoadIR = 1'b0;
			MemToReg = 2'b00;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b111;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = Cslt;
		end

		Cslt: begin
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b10;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		default: begin
			nextState = inicio;
		end
	endcase
end
endmodule: UnidadeControle
