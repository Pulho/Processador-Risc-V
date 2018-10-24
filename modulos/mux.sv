module mux(
	input logic [1:0] sel,
	input logic [63:0] e1,
	input logic [63:0] e2,
	input logic [63:0] e3,
	input logic [63:0] e4,
	output logic [63:0] f
);

always_comb begin
	case(sel)
		2'b00: begin
			f = e1;
		end

		2'b01: begin
			f = e2;
		end

		2'b10: begin
			f = e3;
		end

		2'b11: begin
			f = e4;
		end
	endcase 
end


endmodule: mux