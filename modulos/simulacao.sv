`timescale 1ps/1ps

module simulacao;
    localparam CLKPERIOD = 1000;
    localparam CLKDELAY = CLKPERIOD / 2;

    logic clk;
    logic rst;
    logic [3:0] Out;
    logic [5:0] cont;
    logic [63:0] Regs;
    logic [63:0] MemReg;
    logic [63:0] inMem;
    logic [63:0] inregBank;

    principal test (
        .clk(clk), 
        .reset(rst),       
        .stateOut(Out),
        .fio_MemData_RegMemData(MemReg),
        .fio_RegMemData_Mux(Regs),
        .fio_B_MuxB(inMem),
        .fio_muxWD_regBank(inregBank)
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
            else cont <= cont + 4'b0001;
        end 
    end
    
    initial begin
        clk = 1'b1;
        $monitor($time,"stateOut - %b | cont - %b | reset - %b | clk - %b| MemReg - %b -> %b | Reg -  %b | inBank - %b", Out, cont, rst, clk, inMem, MemReg, Regs, inregBank);
    end
endmodule: simulacao