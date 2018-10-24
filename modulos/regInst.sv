module regInst(
			input regWrite,
            input logic [63:0] DadoIn,
            output logic [63:0] DadoOut
        );	

	always_comb begin
		if( regWrite == 1'b1 ) DadoOut = DadoIn;
		else DadoOut = 64'b0000000000000000000000000000000000000000000000000000000000000000;
	end

endmodule: regInst