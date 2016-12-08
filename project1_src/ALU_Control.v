module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input			[5:0] funct_i;
input			[1:0]ALUOp_i;
output			[2:0]ALUCtrl_o;

assign ALUCtrl_o=(ALUOp_i==2'b01)? 3'b000:
				 (ALUOp_i==2'b10)? 3'b011:
				 (ALUOp_i==2'b11)? 3'b001:
				 (funct_i==6'b100000)? 3'b000:
				 (funct_i==6'b100010)? 3'b001:
				 (funct_i==6'b100100)? 3'b010:
				 (funct_i==6'b100101)? 3'b011:
				 (funct_i==6'b011000)? 3'b100:
				 3'b101;
endmodule