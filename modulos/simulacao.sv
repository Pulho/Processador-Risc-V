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

    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_Extend_shift(immd),
        .fio_muxWD_regBank(inB),
        .fio_menor_ExtendS(sg),
        .fio_MuxA_ALU(regA),
        .fio_MuxB_ALU(regB)
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
        $monitor($time,"stateOut - %b | cont - %b | reset - %b | immd - %b | inB - %b | sg-%b \n\t\t\t regA - %b | regB - %b", Out, cont, rst, immd, inB, sg, regA, regB);
    end
endmodule: simulacao