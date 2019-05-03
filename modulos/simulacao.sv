`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [4:0] Estado;
    logic [6:0] cont;
    logic [63:0] WriteDataReg;
    logic [63:0] aAlu;
    logic [63:0] bAlu;
    logic [63:0] PC;
    logic [63:0] Alu;
    logic [63:0] AluOut;
    logic [63:0] MDR;
    logic [63:0] WriteDataMem;
    logic [31:0] inst;
    logic [63:0] EPC;
    logic causa;
    logic [63:0] Adress;
    logic Wr;
    logic RegWrite;
    logic IRWrite;
    logic [63:0] MemData;
    logic [4:0] WriteRegister;


    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Estado),
        .fio_Stype_memDados(WriteDataMem),
        .fio_muxWD_regBank(WriteDataReg),
        .fio_MuxA_ALU(aAlu),
        .fio_MuxB_ALU(bAlu),
        .fio_ALU_ALUOut(Alu),
        .fio_MuxALUOut_PC(PC),
        .fio_ALUOut_MuxALUOut(AluOut),
        .fio_RegMemData_Mux(MDR),
        .fio_UC_causa(causa),
        .fio_memInst_regInst(inst),
        .saidaEPC(EPC),
        .adress(Adress),
        .fio_UC_WrD(Wr),
        .fio_UC_RegBank(RegWrite),
        .fio_UC_RegInst(IRWrite),
        .fio_MemData_RegMemData(MemData),
        .fio_regInst117_WriteReg(WriteRegister)
    ); 

    initial begin 
        rst = 1'b0;
        #(CLKPERIOD)
        rst = 1'b1;
        #(CLKPERIOD)
        #(CLKPERIOD)
        rst = 1'b0;
    end

    always #(CLKDELAY) clk = ~clk;
                
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            cont<= 0;
        end else begin
            if( cont == 7'b1111111 ) $finish;
            else cont <= cont + 7'b0000001;
        end 
    end
    
    initial begin
        clk = 1'b1;
        $monitor($time,"stateOut - %b | regCausa - %b | causa - %b | inst - %b\n", Estado, EPC, causa, inst);
    end
endmodule: simulacao