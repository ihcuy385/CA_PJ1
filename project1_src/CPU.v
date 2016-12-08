module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire                [31:0] inst_addr,inst;
wire                [31:0] ALU_output,mux5_output,mux7_output,Sign_Extend_output;          
wire                [4:0]  mux8_output;
wire                Stage3_RegWrite_output,Stage4_RegWrite_output;

Control Control(
    .Op_i           (inst[31:26]),
    .RegDst_o       (Stage2.RegDst_i_2),
    .ALUOp_o        (Stage2.ALUOp_i_2), //0 for R-type ; 1 for I-type
    .ALUSrc_o       (Stage2.ALUSrc_i_2),
    .RegWrite_o     (Registers.RegWrite_i),
    .Memory_write_o (Data_Memory.Memory_write_i),
    .Memory_read_o  (Data_Memory.Memory_read_i),
    .MemtoReg_o     (mux5.select_i)
);



Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (PC.pc_i)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (mux8.data_o), 
    .RDdata_i   (mux5_output),
    .RegWrite_i (Stage4_RegWrite_output), 
    .RSdata_o   (ALU.data1_i), 
    .RTdata_o   (mux7.data1_i) 
);


MUX5 mux8(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (Stage2.RegDst_o_2),
    .data_o     (mux8_output)
);



MUX32 mux4(
    .data1_i    (mux7_output),
    .data2_i    (Sign_Extend_output),
    .select_i   (Stage2.ALUSrc_o_2),
    .data_o     (ALU.data2_i)
);



Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (Sign_Extend_output)
);

  

ALU ALU(
    .data1_i    (mux6.data_o),
    .data2_i    (mux4.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (ALU_output)
);



ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Stage2.ALUOp_o_2),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

Data_Memory Data_Memory(
    .address_i      (ALU_output),
    .Memory_write_i (Stage3.Memory_write_o_3),
    .Memory_read_i  (Stage3.Memory_read_o_3),
    .write_data_i   (mux7_output),
    .read_data_o    (mux5.data1_i)
);

MUX32 mux5(
    .data1_i(Data_Memory.read_data_o),//0
    .data2_i(ALU_output),//1
    .select_i(Stage4.MemtoReg_o_4),
    .data_o(mux5_output)
);

MUX32v3 mux6(
    .data1_i(Registers.RSdata_o),
    .data2_i(mux5_output),
    .data3_i(ALU_output),
    .select_i(Forwarding_Unit.mux6_o),
    .data_o(ALU.data1_i)
);

MUX32v3 mux7(
    .data1_i(Registers.RTdata_o),
    .data2_i(mux5_output),
    .data3_i(ALU_output),
    .select_i(Forwarding_Unit.mux7_o),
    .data_o(mux7_output)
);

Forwarding_Unit(
    .regdst_i_WB(mux8_output),
    .regdst_i_M(mux8_output),
    .RSaddr_i(inst[25:21]),
    .RTaddr_i(inst[20:16]),
    .Stage4_Regwrite_i(Stage4_RegWrite_output),
    .Stage3_RegWrite_i(Stage3_RegWrite_output),
    .mux7_o(mux7.select_i),
    .mux6_o(mux6.select_i)
);

Stage4(
    //WB
    .RegWrite_i_4(Stage3_RegWrite_output),
    .RegWrite_o_4(Stage4_RegWrite_output),
    .MemtoReg_i_4(Stage3.MemtoReg_o_3),
    .MemtoReg_o_4(mux5.select_i),
    //clk
    .clk_i(clk_i)
);

Stage3(
    //WB
    .RegWrite_i_3(Stage2.RegWrite_o_2),
    .RegWrite_o_3(Stage3_RegWrite_output),
    .MemtoReg_i_3(Stage2.MemtoReg_o_2),
    .MemtoReg_o_3(Stage4.MemtoReg_i_4),
    //M
    .Memory_write_i_3(Stage3.Memory_write_o_2),
    .Memory_write_o_3(Data_Memory.Memory_write_i),
    .Memory_read_i_3(Stage3.Memory_read_o_2),
    .Memory_read_o_3(Data_Memory.Memory_read_i).
    //clk
    .clk_i(clk_i)
);

Stage2(
    //WB
    .RegWrite_i_2(Control.RegWrite_o),
    .RegWrite_o_2(Stage3.RegWrite_i_3),
    .MemtoReg_i_2(Control.MemtoReg_o),
    .MemtoReg_o_2(Stage3.MemtoReg_i_3),
    //M
    .Memory_write_i_2(Control.Memory_write_o),
    .Memory_write_o_2(Stage3.Memory_write_i_3),
    .Memory_read_i_2(Control.Memory_read_o),
    .Memory_read_o_2(Stage3.Memory_read_i_3),
    //EX
    .ALUSrc_i_2(Control.ALUSrc_o),
    .ALUOp_i_2(Control.ALUOp_o),
    .RegDst_i_2(Control.RegDst_o),
    .ALUSrc_o_2(mux4.select_i),
    .ALUOp_o_2(ALU_Control.ALUOp_i),
    .RegDst_o_2(mux8.select_i),
    //clk
    .clk_i(clk_i)
);

endmodule