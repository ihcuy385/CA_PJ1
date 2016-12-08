module Stage4(
	clk_i,
	RegWrite_i_4,
	MemtoReg_i_4,
	RegWrite_o_4,
	MemtoReg_o_4
);

input	RegWrite_i_4,MemtoReg_i_4;
output	RegWrite_o_4,MemtoReg_o_4;
input	clk_i;

always @(posedge clk_i) begin
	assign	RegWrite_o_4 = RegWrite_i_4;
	assign	MemtoReg_o_4 = MemtoReg_i_4;
end

endmodule
