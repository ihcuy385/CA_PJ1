module Control
(
	Op_i,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o,
	Memory_write_o,
	Memory_read_o,
	MemtoReg_o
);

input			[5:0] Op_i;
output			ALUSrc_o,RegWrite_o,RegDst_o;
output			[1:0] ALUOp_o;


assign			RegDst_o=(Op_i==6'b000000)?   1'b1:1'b0;
assign			RegWrite_o=(Op_i==6'b000000 
							|| Op_i==6'b001100 
							|| Op_i==6'b100011)? 1'b1:1'b0;
assign			ALUSrc_o=(Op_i==6'b000000)?   1'b0:1'b1;
assign			MemtoReg_o=(Op_i==6'b100011)? 1'b1:1'b0;
assign			Memory_write_o=(Op_i==6'b101011)? 1'b1:1'b0;
assign			Memory_read_o=(Op_i==6'b100011)? 1'b1:1'b0;
assign			ALUOp_o=(Op_i==6'b000000)? 2'b00://R-type
						(Op_i==6'b100011 || Op_i==6'b101011)? 2'b01://lw sw :ADD
						(Op_i==6'b001101)? 2'b10://ori :OR
						(Op_i==6'b000100)? 2'b11://beq :SUB
						2'b00;
endmodule