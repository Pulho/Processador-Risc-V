`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [4:0] Out;
    logic [5:0] cont;
    logic [63:0] immd;
    logic [63:0] inB;
    logic sg;
    logic [63:0] regA;
    logic [63:0] regB;
    logic [63:0] outAlu;
    logic [63:0] outAluOut;
    logic [63:0] shift;
    logic regWrite;

    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_Extend_shift(immd),
        .fio_muxWD_regBank(inB),
        .fio_menor_ExtendS(sg),
        .fio_MuxA_ALU(regA),
        .fio_MuxB_ALU(regB),
        .fio_ALU_ALUOut(outAlu),
        .fio_ALUOut_MuxALUOut(outAluOut),
        .fio_Shift_MuxB(shift),
        .fio_UC_RegBank(regWrite)
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
        $monitor($time,"clk-%b|stateOut - %b | reset - %b | regA - %b | regB - %b | sg-%b | rW-%b \n\t\t\t\t\t immd - %b | inB - %b \n\t\t\t\t\t outAlu - %b | outAluOut - %b\n\t\t\t\t\t shift - %b\n\n", clk, Out, rst, regA, regB, sg, regWrite, immd, inB, outAlu, outAluOut, shift);
    end
endmodule: simulacao