// Annotate this macro before synthesis
// `define RUN_TRACE

// TODO: 在此处定义你的宏
// ALU_op
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR  4'b0011
`define ALU_XOR 4'b0100
`define ALU_SLL 4'b0101
`define ALU_SRL 4'b0110
`define ALU_SRA 4'b0111
`define ALU_BEQ 4'b1000
`define ALU_BNE 4'b1001
`define ALU_BLT 4'b1010
`define ALU_BGE 4'b1011
`define ALU_NODOING 4'b1111
// ALU_B_sel
`define ALU_B_IMM 2'b00
`define ALU_B_rD2 2'b01
`define ALU_B_sel_NODOING 2'b11
// NPC_op
`define NPC_op_PC_4 2'b00
`define NPC_op_OFFSET 2'b01
`define NPC_op_BR 2'b10
`define NPC_op_NODOING 2'b11
// PC_sel
`define PC_sel_NPC 1'b0
`define PC_sel_ALU 1'b1
// SEXT_op
`define SEXT_op_I 3'b001
`define SEXT_op_B 3'b010
`define SEXT_op_S 3'b011
`define SEXT_op_U 3'b100
`define SEXT_op_J 3'b101
`define SEXT_op_NODING 3'b111
// RF_WD_sel
`define RF_WD_sel_ALU 3'b001
`define RF_WD_sel_NPC 3'b010
`define RF_WD_sel_SEXT 3'b011
`define RF_WD_sel_RDO 3'b100
`define RF_WD_sel_NODOING 3'b111








// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
