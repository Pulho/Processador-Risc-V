`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [4:0] Out;
    logic [5:0] cont;
    logic [63:0] stype;
    logic [63:0] regLD;
    logic [63:0] regB;
    logic [31:0] Instr;
    logic [63:0] outAlu;
    logic [63:0] outAluOut;
    logic [63:0] inB;

    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_muxWD_regBank(inB),
        .fio_Stype_memDados(stype),
        .fio_B_MuxB(regB),
        .fio_regInst_UC(Instr),
        .fio_ALUOut_MuxALUOut(outAluOut),
        .fio_MemData_RegMemData(regLD)
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
            if( cont == 6'b111111 ) $finish;
            else cont <= cont + 6'b000001;
        end 
    end
    
    initial begin
        clk = 1'b1;
        $monitor($time,"stateOut - %b | AluOut - %b\nstype - %b | regB - %b\nfunc3 - %b | inB - %b\n\nregLD - %b\n", Out, outAluOut, stype, regB, Instr[14:12], inB, regLD);
    end
endmodule: simulacao