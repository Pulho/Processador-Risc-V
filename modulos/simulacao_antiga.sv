`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [3:0] Out;
    logic [3:0] cont;

    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out)
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
            cont <= cont + 4'b0001;
        end
    end
    
    initial begin
        clk = 1'b1;
        $monitor($time,"stateOut - %b, cont - %b, reset - %b, clk - %b", Out, cont, rst, clk); 
        if( cont == 4'b1111 ) $finish;
    end
endmodule: simulacao

 