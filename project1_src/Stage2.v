module Stage2(
    RegWrite_i_2,
    RegWrite_o_2,
    MemtoReg_i_2,
    MemtoReg_o_2,
    Memory_write_i_2,
    Memory_write_o_2,
    Memory_read_i_2,
    Memory_read_o_2,
    ALUSrc_i_2,
    ALUOp_i_2,
    RegDst_i_2,
    ALUSrc_o_2,
    ALUOp_o_2,
    RegDst_o_2,
    clk_i
);

input	RegWrite_i_2,MemtoReg_i_2,Memory_write_i_2,Memory_read_i_2,ALUSrc_i_2,RegDst_i_2;
input	[1:0]	ALU_Op_i_2;
input	clk_i;
output	RegWrite_o_2,MemtoReg_o_2,Memory_write_o_2,Memory_read_o_2,ALUSrc_o_2,RegDst_o_2;
output	[1:0]	ALUOp_o_2;

always @(posedge clk_i)begin
	assign	RegWrite_o_2 = RegWrite_i_2;
	assign	MemtoReg_o_2 = MemtoReg_i_2;	
	assign	Memory_write_o_2 = Memory_write_i_2;
	assign	Memory_read_o_2 = Memory_read_i_2;
	assign	ALUSrc_o_2 = ALUSrc_i_2;
	assign	RegDst_o_2 = RegDst_i_2;
	assign	ALUOp_o_2 <= ALUOp_i_;
end

endmodule