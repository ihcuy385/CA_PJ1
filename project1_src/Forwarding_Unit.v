module Forwarding_Unit
(
    Regdst_i_WB,
    Regdst_i_M,
    RSaddr_i,
    RTaddr_i,
    Stage4_Regwrite_i,
    Stage3_RegWrite_i,
    mux7_o,
    mux6_o
);

input        Stage4_Regwrite_i, Stage3_RegWrite_i;
input  [4:0] RSaddr_i, RTaddr_i, Regdst_i_WB, Regdst_M;
output [1:0] mux7_o, mux6_o;

//RS
assign mux6_o = ((Stage3_Regwrite_i == 1) && (Regdst_i_M != 0) && (Regdst_i_M == RSaddr_i))? 2'b10://EX-hazard
                ((Stage4_Regwrite_i == 1) && (Regdst_i_WB != 0) && (Regdst_i_M != RSaddr_i) && (Regdst_i_WB == RSaddr_i))? 2'b01:
                2'b00;
//RT
assign mux7_o = ((Stage3_Regwrite_i == 1) && (Regdst_i_M != 0) && (Regdst_i_M == RTaddr_i))? 2'b10://EX-hazard
                ((Stage4_Regwrite_i == 1) && (Regdst_i_WB != 0) && (Regdst_i_M != RTaddr_i) && (Regdst_i_WB == RTaddr_i))? 2'b01:
                2'b00;               
                
endmodule
