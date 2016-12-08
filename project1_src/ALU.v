module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o
);

input			[31:0] data1_i,data2_i;
input			[2:0]  ALUCtrl_i;
output			[31:0] data_o;

assign data_o=(ALUCtrl_i==3'b000)? data1_i+data2_i: //0 for add
			  (ALUCtrl_i==3'b001)? data1_i-data2_i: //1 for sub
			  (ALUCtrl_i==3'b010)? data1_i&data2_i: //2 for and
			  (ALUCtrl_i==3'b011)? data1_i|data2_i: //3 for  or
			  (ALUCtrl_i==3'b100)? data1_i*data2_i: //4 for mult
			  32'd0;
endmodule