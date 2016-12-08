moudule Stage3(
	clk_i,
	RegWrite_i_3,
	MemtoReg_i_3,
	Memory_write_i_3,
	Memory_read_i_3,
	RegWrite_o_3,
	MemtoReg_o_3,
	Memory_write_o_3,
	Memory_read_o_3
);

input	clk_i,RegWrite_i_3,MemtoReg_i_3,Memory_write_i_3,Memory_read_i_3;
output	RegWrite_o_3,MemtoReg_o_3,Memory_write_o_3,Memory_read_o_3;

always @(posedge clk_i) begin
	assign	RegWrite_o_3 = RegWrite_i_3;
	assign	MemtoReg_o_3 = MemtoReg_i_3;	
	assign	Memory_write_o_3 = Memory_write_i_3;
	assign	Memory_read_o_3 = Memory_read_i_3;
end

endmodule