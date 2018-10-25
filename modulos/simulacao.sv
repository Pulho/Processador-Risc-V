`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [4:0] Out;
    logic [5:0] cont;
    logic [63:0] aAlu;
    logic [63:0] bAlu;
    logic Sg;
    logic [63:0] mux;


    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_muxWD_regBank(mux),
        .fio_MuxA_ALU(aAlu),
        .fio_MuxB_ALU(bAlu),
        .fio_menor_ExtendS(Sg)

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
        $monitor($time,"stateOut - %b | Sg - %b | mux - %b\n\t\t\t\taAlu - %b | bAlu - %b\n\n", Out, Sg, mux, aAlu, bAlu);
    end
endmodule: simulacao