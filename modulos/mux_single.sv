module mux_single(
	input logic sel,
	input logic [63:0] e1,
	input logic [63:0] e2,
	output logic [63:0] f
);

always_comb begin
	case(sel)
		1'b0: begin
			f = e1;
		end

		1'b1: begin
			f = e2;
		end
	endcase 
end

endmodule: mux_single