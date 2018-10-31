`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [4:0] Out;
    logic [6:0] cont;
    logic [63:0] regBank;
    logic [63:0] aAlu;
    logic [63:0] bAlu;
    logic [63:0] pcAlu;
    logic [63:0] aluOut;
    logic [63:0] outAluOut;
    logic [63:0] e2;
    logic [63:0] s_type;
    logic [31:0] inst;
    logic regCausa;
    logic causa;


    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_Stype_memDados(s_type),
        .fio_muxWD_regBank(regBank),
        .fio_MuxA_ALU(aAlu),
        .fio_MuxB_ALU(bAlu),
        .fio_ALU_ALUOut(aluOut),
        .fio_MuxALUOut_PC(pcAlu),
        .fio_ALUOut_MuxALUOut(outAluOut),
        .fio_RegMemData_Mux(e2),
        .fio_UC_causa(causa),
        .fio_memInst_regInst(inst),
        .saida(regCausa)
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
        $monitor($time,"stateOut - %b | regCausa - %b | causa - %b | inst - %b\n", Out, regCausa, causa, inst);
    end
endmodule: simulacao