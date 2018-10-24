module Extend_signal( input logic menorSinal, input logic [31:0] in, output logic [63:0] out );
logic adm;
logic [1:0] op;
logic [11:0] aux;
logic [12:0] aux1;
logic [31:0] aux2;
logic [31:0] auxout;

always_comb begin
	
	case(in[6:0])
		7'b0110011: begin //Tipo R (slt)
			adm = 1'b0;
		end
		7'b0010011: begin //addi
			aux[11:0] = in[31:20];
			op = 2'b00;
			adm = 1'b1;
		end
		7'b0000011: begin //ld
			aux[11:0] = in[31:20];
			op = 2'b00;
			adm = 1'b1;
		end
		7'b0100011: begin //sd
			aux[4:0] = in[11:7];
			aux[11:5] = in[31:25];
			op = 2'b00;
			adm = 1'b1;
		end
		7'b1100011: begin //beq
			aux1[0] = 1'b0;
			aux1[4:1] = in[11:8];
			aux1[10:5] = in[30:25];
			aux1[11] = in[7];
			aux1[12] = in[31];
			op = 2'b01;
			adm = 1'b1;
		end
		7'b1100111: begin //bne
			aux1[0] = 1'b0;
			aux1[4:1] = in[11:8];
			aux1[10:5] = in[30:25];
			aux1[11] = in[7];
			aux1[12] = in[31];
			op = 2'b01;
			adm = 1'b1;
		end
		7'b0110111: begin //lui
			aux2[11:0] = 12'b000000000000;
			aux2[31:12] = in[31:12];
			op = 2'b10;
			adm = 1'b1;
		end
		default: begin
			aux[11:0] = 12'b000000000000;
			adm = 1'b0;
		end
	endcase

	if( adm == 1'b1 ) begin
		if(op == 2'b00) begin
			if(aux[11] == 1'b0) begin
				auxout = (32'b00000000000000000000000000000000 + aux);
			end
			else if(aux[11] == 1'b1) begin
				auxout = (32'b11111111111111111111000000000000 + aux);
			end
		end
		else if(op == 2'b01) begin
			if(aux1[12] == 1'b0) begin
				auxout = (32'b00000000000000000000000000000000 + aux1);
			end
			else if(aux1[12] == 1'b1) begin
				auxout = (32'b11111111111111111110000000000000 + aux1);
			end
		end
		else if(op == 2'b10) begin
			auxout = (32'b00000000000000000000000000000000 + aux2);
		end
		
		if(auxout[31] == 1'b0) begin
			out = (64'b0000000000000000000000000000000000000000000000000000000000000000 + auxout);
		end else if(in[31] == 1'b1) begin
			out = (64'b1111111111111111111111111111111100000000000000000000000000000000 + auxout);
		end
	end else if( adm == 1'b0 ) begin
		if(menorSinal == 1'b1) out = (64'b0000000000000000000000000000000000000000000000000000000000000001);
		else out = (64'b0000000000000000000000000000000000000000000000000000000000000000);
	end
end
endmodule: Extend_signal