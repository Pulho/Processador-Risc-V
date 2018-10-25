module UnidadeControle(
	input logic clk, 
	input logic reset,
	input logic [6:0] OPcode,
	input logic [6:0] func7,
	input logic [2:0] func3,

	output logic [4:0] stateout,
	output logic [1:0] Shift,
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
	output logic PCWriteCondbge,
	output logic PCWriteCondblt,
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
logic [4:0] Crcbge = 5'b01111;
logic [4:0] Crcblt = 5'b10000;
logic [4:0] Srli = 5'b10001;
logic [4:0] Srai = 5'b10010;
logic [4:0] Slli = 5'b10011;
logic [4:0] Break = 5'b10100;
logic [4:0] Exeslti = 5'b10101;
logic [4:0] Jal = 5'b10110;//Precisa criar
logic [4:0] Crcjalr = 5'b10111;//Precisa criar
logic [4:0] Nop = 5'b11000;//Precisa criar
//logic [4:0] Jal = 5'b11001;//Precisa criar
//logic [4:0] Crcjalr = 5'b11010;//Precisa criar
//logic [4:0] Evlw = 5'b11011;//Precisa criar
//logic [4:0] Evlbu = 5'b11100;//Precisa criar
//logic [4:0] Evlh = 5'b11101;//Precisa criar
//logic [4:0] Nop = 5'b11110;//Precisa criar e colocar junto do case do addi




logic [4:0] state; 
logic [4:0] nextState;

assign stateout = state;

always_ff@(posedge clk, posedge reset) begin
	if(reset)begin
		state <= inicio;
	end else begin 
		state <= nextState;
	end
end

always_comb begin
	case(state)
		inicio: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = BInst;
		end
		
		BInst: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = IDecod;
		end

		IDecod: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
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
								3'b000: begin // add
									nextState = Exeadd;
								end
								3'b010: begin // slt
									nextState = Exeslt;
								end
								3'b111: begin // and
									nextState = Exeand;
								end
							endcase
						end

						7'b0100000: begin // sub
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
						3'b101: begin
							if(func7[5] == 1'b0) begin // Srli
								nextState = Srli;
							end 
							else begin // Srai
								nextState = Srai;
							end 
						end
						3'b001: begin // Slli
							nextState = Slli;
						end

						3'b010: begin //slti
							nextState = Exeslti;
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

				7'b0100011: begin //sd && sw && sh && sb
					nextState = Cem;
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

				7'b1100111: begin //bne && bge && blt && jalr
					case(func3)
						3'b000: begin // jalr
							nextState = Crcjalr;
						end
						3'b001: begin // bne
							nextState = Crcbne;
						end
						3'b101: begin // bge
							nextState = Crcbge;
						end
						3'b100: begin // blt
							nextState = Crcblt;
						end
						default: begin
							nextState = inicio;
						end
					endcase
				end

				7'b0110111: begin //lui
					nextState = Lui;
				end

				7'b1101111: begin //jal
					nextState = Jal;
				end

				7'b1110011: begin //break
					nextState = Break;
				end

				default: begin
					nextState = inicio;
				end
			endcase
		end

		Cem: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;;

			if(OPcode == 7'b0000011 || OPcode == 7'b0100011) begin
				nextState = Amld;
			end

			else if(OPcode == 7'b0010011) begin
				if(func3 == 3'b000) begin
					nextState = Cr;
				end
				else nextState = inicio;
			end
		end

		Amld: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;

			if(OPcode == 7'b0100011) begin
				nextState = Amsd;
				/*case(func3)
					3'b111: begin
						nextState = Amsd;
					end

					3'b010: begin //Sw
						nextState = Amsw;
					end
					
					3'b001: begin //Sh
						nextState = Amsh;
					end

					3'b000: begin //Sb
						nextState = Amsb;
					end	

					default: begin
						nextState = inicio;
					end
				endcase*/
			end
			else if(OPcode == 7'b0000011) begin
				nextState = Ev;
				/*case(func3)
					3'b011: begin // ld
						nextState = Evld;
					end

					3'b010: begin // lw
						nextState = Evlw;
					end

					3'b100: begin // lbu
						nextState = Evlbu;
					end

					3'b001: begin // lh
						nextState = Evlh;
					end

					default: begin
						nextState = inicio;
					end
				endcase*/
			end
			else begin
				nextState = inicio;
			end
		end

		Ev: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b1;
			nextState = inicio;
		end

		Amsd: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Exeadd: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = Cr;			
		end

		Exesub: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = Cr;	
		end

		Cr: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Crcbeq: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b1;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Crcbne: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b1;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Crcbge: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b1;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b1;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Crcblt: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b1;
			PCSource = 1'b1;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Lui: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Exeand: begin
			Shift = 2'b00;
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
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b1;
			LoadMDR = 1'b0;
			nextState = Cr;
		end

		Exeslt: begin
			Shift = 2'b00;
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b10;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b00;
			ALUFct = 3'b111;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Exeslti: begin
			Shift = 2'b00;
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b10;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b10;
			ALUFct = 3'b111;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Srli: begin
			Shift = 2'b01;
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b11;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Srai: begin
			Shift = 2'b10;
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b11;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Slli: begin
			Shift = 2'b00;
			Wrl = 1'b0;
			WrD = 1'b0;
			RegWrite = 1'b1;
			LoadIR = 1'b0;
			MemToReg = 2'b11;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			ALUFct = 3'b000;
			PCWrite = 1'b0;
			PCWriteCondbeq = 1'b0;
			PCWriteCondbne = 1'b0;
			PCWriteCondbge = 1'b0;
			PCWriteCondblt = 1'b0;
			PCSource = 1'b0;
			LoadRegA = 1'b0;
			LoadRegB = 1'b0;
			LoadAOut = 1'b0;
			LoadMDR = 1'b0;
			nextState = inicio;
		end

		Break: begin
			nextState = Break;
		end

		default: begin
			nextState = inicio;
		end
	endcase
end
endmodule: UnidadeControle
