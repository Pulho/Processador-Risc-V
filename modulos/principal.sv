module principal(
	input logic clk,
	input logic reset,
	output logic [4:0] stateOut,
	//output logic fio_menor_ExtendS,
	output logic [63:0] fio_Stype_memDados,
	output logic [63:0] fio_muxWD_regBank,
	output logic [63:0] fio_MuxA_ALU,
	output logic [63:0] fio_MuxB_ALU,
	output logic [63:0] fio_ALU_ALUOut,
	output logic [63:0] fio_ALUOut_MuxALUOut,
	output logic [63:0] fio_MuxALUOut_PC,
	output logic [63:0] fio_RegMemData_Mux,
	output logic fio_UC_flagCausa,
	output logic fio_UC_causa,
	output logic [31:0] fio_memInst_regInst,
	output logic saida,
	output logic [63:0] saidaEPC,
	output logic [63:0] fio_MemData_RegMemData,
	output logic fio_UC_WrD,
	output logic fio_UC_RegBank,
	output logic fio_UC_RegInst,
	output logic [4:0] fio_regInst117_WriteReg,
	output logic [63:0] adress
);
	
	logic fio_UC_memInst;
	//logic fio_UC_RegInst;
	//logic fio_UC_RegBank;
	logic fio_UC_LDA;
	logic fio_UC_LDB;
	logic fio_UC_ALUOut;
	logic fio_UC_MuxALUOut;
	//logic fio_UC_WrD;
	logic fio_UC_LoadMDR;
	logic fio_UC_PCWriteCondbeq;
	logic fio_UC_PCWriteCondbne;
	logic fio_UC_PCWriteCondbge;
	logic fio_UC_PCWriteCondblt;
	logic fio_UC_PCWrite;
	// logic fio_UC_flagCausa;
	// logic fio_UC_causa;
	logic fio_zero;
	logic fio_igual;
	logic fio_maior;
	logic [1:0] fio_UC_Shift;
	logic [1:0] fio_UC_MuxA;
	logic [1:0] fio_UC_MuxB;
	logic [2:0] fio_UC_ALU;
	logic [63:0] fio_Shift_RegBank;
	//logic [63:0] fio_RegMemData_Mux;
	//logic [63:0] fio_MuxALUOut_PC;
	//logic [63:0] fio_MemData_RegMemData;
	logic [63:0] fio_RegBank_A;
	logic [63:0] fio_RegBank_B;
	logic [63:0] fio_A_MuxA;
	logic [63:0] fio_B_MuxB;
	//logic [63:0] fio_Stype_memDados;
	//logic [63:0] fio_ALU_ALUOut;
	logic [63:0] fio_PC_memInst;
	// logic [63:0] fio_muxWD_regBank;
	//logic [63:0] fio_ALUOut_MuxALUOut;
	//logic [63:0] fio_MuxA_ALU;
	//logic [63:0] fio_MuxB_ALU;
	logic [63:0] fio_Extend_shift;
	logic [63:0] fio_Shift_MuxB;
	logic [2:0] fio_memToReg_muxWD;
	// logic [31:0] fio_memInst_regInst;
	logic [31:0] fio_regInst_UC;
	logic [4:0] fio_regInst1915_reg1;
	logic [4:0] fio_regInst2420_reg2;
	//logic [4:0] fio_regInst117_WriteReg;
	logic LoadPC;
	logic fio_menor_ExtendS;
	logic fio_muxInstr;
	logic [63:0] fio_muxMEM;

	register EPC(
		.clk(clk),
		.reset(reset),
		.regWrite(fio_UC_flagCausa),
		.DadoIn(fio_PC_memInst),
		.DadoOut(saidaEPC)
	);

	mux_single mux_Instr(
		.sel(fio_muxInstr),
		.e1(fio_PC_memInst),
		.e2(64'b0000000000000000000000000000000000000000000000000000000011111110),
		.f(fio_muxMEM)
	);

	register RegCausa (
		.clk(clk),
		.reset(reset),
		.regWrite(fio_UC_flagCausa),
		.DadoIn(fio_UC_causa),
		.DadoOut(saida)
	);

	register PC(
		.clk(clk),
		.reset(reset),
		.regWrite(LoadPC),
		.DadoIn(fio_MuxALUOut_PC),
		.DadoOut(fio_PC_memInst)
	);
	
	Memoria32 memInst(
		.Clk(clk),
		.raddress(fio_muxMEM[31:0]),
		.waddress(),
		.Datain(),
		.Dataout(fio_memInst_regInst),
		.Wr(fio_UC_memInst)
	);

	Instr_Reg_RISC_V reg_Inst(
		.Clk(clk),
		.Reset(reset),
		.Load_ir(fio_UC_RegInst),
		.Entrada(fio_memInst_regInst),
		.Instr19_15(fio_regInst1915_reg1),
		.Instr24_20(fio_regInst2420_reg2),
		.Instr11_7(fio_regInst117_WriteReg),
		.Instr6_0(),
		.Instr31_0(fio_regInst_UC)
	);
	
	UnidadeControle controle(
		.clk(clk),
		.reset(reset),
		.Instr(fio_regInst_UC),
		.OPcode(fio_regInst_UC[6:0]),
		.func7(fio_regInst_UC[31:25]),
		.func3(fio_regInst_UC[14:12]),
		.stateout(stateOut),
		.Shift(fio_UC_Shift),
		.Wrl(fio_UC_memInst),
		.WrD(fio_UC_WrD),
		.RegWrite(fio_UC_RegBank),
		.LoadIR(fio_UC_RegInst),
		.MemToReg(fio_memToReg_muxWD),
		.ALUSrcA(fio_UC_MuxA),
		.ALUSrcB(fio_UC_MuxB),
		.ALUFct(fio_UC_ALU),
		.PCWrite(fio_UC_PCWrite),
		.PCWriteCondbeq(fio_UC_PCWriteCondbeq),
		.PCWriteCondbne(fio_UC_PCWriteCondbne),
		.PCWriteCondbge(fio_UC_PCWriteCondbge),
		.PCWriteCondblt(fio_UC_PCWriteCondblt),
		.PCSource(fio_UC_MuxALUOut),
		.LoadRegA(fio_UC_LDA),
		.LoadRegB(fio_UC_LDB),
		.LoadAOut(fio_UC_ALUOut),
		.LoadMDR(fio_UC_LoadMDR),
		.flagCausa(fio_UC_flagCausa),
		.causa(fio_UC_causa),
		.muxInstr(fio_muxInstr)
	);
	
	bancoReg reg_bank(
		.clock(clk),
		.reset(reset),
		.write(fio_UC_RegBank),
		.regreader1(fio_regInst1915_reg1),
		.regreader2(fio_regInst2420_reg2),
		.regwriteaddress(fio_regInst117_WriteReg),
		.datain(fio_muxWD_regBank),
		.dataout1(fio_RegBank_A),
		.dataout2(fio_RegBank_B)
	);
/*
	mux mux_Write_data(
		.sel(fio_memToReg_muxWD),
		.e1(fio_ALUOut_MuxALUOut),
		.e2(fio_RegMemData_Mux),
		.e3(fio_Extend_shift),
		.e4(fio_Shift_RegBank),
		.f(fio_muxWD_regBank)
	);
*/
	muxEspecial mux_Write_data(
		.sinalMenor(fio_menor_ExtendS),
		.sel(fio_memToReg_muxWD),
		.e1(fio_ALUOut_MuxALUOut),
		.e2(fio_RegMemData_Mux),
		.e3(fio_Extend_shift),
		.e4(fio_Shift_RegBank),
		.e5(fio_PC_memInst),
		.inst(fio_regInst_UC),
		.f(fio_muxWD_regBank)
	);

	register A(
		.clk(clk),
		.reset(reset),
		.regWrite(fio_UC_LDA),
		.DadoIn(fio_RegBank_A),
		.DadoOut(fio_A_MuxA)		
	);

	mux mux_A(
		.sel(fio_UC_MuxA),
		.e1(fio_PC_memInst),
		.e2(fio_A_MuxA),
		.e3(fio_Extend_shift),
		.e4(/*GND*/),
		.f(fio_MuxA_ALU)
	);

	register B(
		.clk(clk),
		.reset(reset),
		.regWrite(fio_UC_LDB),
		.DadoIn(fio_RegBank_B),
		.DadoOut(fio_B_MuxB) 
	);

	mux mux_B(
		.sel(fio_UC_MuxB),
		.e1(fio_B_MuxB),
		.e2(64'b0000000000000000000000000000000000000000000000000000000000000100),
		.e3(fio_Extend_shift),
		.e4(fio_Shift_MuxB),
		.f(fio_MuxB_ALU)
	);

	register ALUOut(
		.clk(clk),
		.reset(reset),
		.regWrite(fio_UC_ALUOut),
		.DadoIn(fio_ALU_ALUOut),
		.DadoOut(fio_ALUOut_MuxALUOut) 
	);

	ula64 ULA(
		.A(fio_MuxA_ALU),
		.B(fio_MuxB_ALU),
		.Seletor(fio_UC_ALU),
		.S(fio_ALU_ALUOut),	
		.Overflow(),
		.Negativo(),
		.z(fio_zero),
		.Igual(fio_igual),
		.Maior(fio_maior),
		.Menor(fio_menor_ExtendS)
	);

	mux_single mux_ALUOut(
		.sel(fio_UC_MuxALUOut),
		.e1(fio_ALU_ALUOut),
		.e2(fio_ALUOut_MuxALUOut),
		.f(fio_MuxALUOut_PC)
	);

	ExtendSg extensor_sinal(
		.menorSinal(fio_menor_ExtendS),
		.in(fio_regInst_UC),
		.out(fio_Extend_shift)
	);

	Deslocamento immediate_shift(
		.Shift(2'b00),
		.Entrada(fio_Extend_shift),
		.N(6'b000001),
		.Saida(fio_Shift_MuxB)
	);

	Deslocamento shift(
		.Shift(fio_UC_Shift),
		.Entrada(fio_A_MuxA),
		.N(fio_regInst_UC[25:20]),
		.Saida(fio_Shift_RegBank)
	); 

	Memoria64 memData(
		.raddress(fio_ALUOut_MuxALUOut),
		.waddress(fio_ALUOut_MuxALUOut),
		.Clk(clk),
		.Datain(fio_Stype_memDados),
		.Dataout(fio_MemData_RegMemData),
		.Wr(fio_UC_WrD)
	);

	Store s_type(
		.func3(fio_regInst_UC[14:12]),
		.regLD(fio_MemData_RegMemData),
		.regBase(fio_B_MuxB),
		.regWR(fio_Stype_memDados)
	);

	/*
	register RegMemData(
		.clk(clk),
		.reset(reset),
		.regWrite(fio_UC_LoadMDR),
		.DadoIn(fio_MemData_RegMemData),
		.DadoOut(fio_RegMemData_Mux)
	);
	*/
	regInst RegMem(
		.regWrite(fio_UC_LoadMDR),
		.DadoIn(fio_MemData_RegMemData),
		.DadoOut(fio_RegMemData_Mux)
	);
	
always_comb begin

	LoadPC <= ((fio_zero & fio_UC_PCWriteCondbeq) | (fio_UC_PCWriteCondbne & !fio_zero) | (fio_UC_PCWriteCondbge & fio_maior) | (fio_UC_PCWriteCondbge & fio_igual) | (fio_UC_PCWriteCondblt & fio_menor_ExtendS) | fio_UC_PCWrite);
	adress <= fio_ALUOut_MuxALUOut;
end


endmodule: principal