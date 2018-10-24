`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [4:0] Out;
    logic [5:0] cont;
    logic [63:0] write;
    logic [63:0] aAlu;
    logic [63:0] bAlu;
    logic [63:0] sAlu;
    logic sg;

    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_muxWD_regBank(write),
        .fio_MuxA_ALU(aAlu),
        .fio_MuxB_ALU(bAlu),
        .fio_ALU_ALUOut(sAlu)
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
        $monitor($time,"stateOut - %b | regBank - %b | aAlu - %b | bAlu - %b | sAlu - %b ", Out, write, aAlu, bAlu, sAlu);
    end
endmodule: simulacao