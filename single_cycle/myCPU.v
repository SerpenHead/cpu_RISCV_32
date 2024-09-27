`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
// PC



wire [31: 0] PC_out_pc;
wire [31: 0] PC_out_pc_out;
// NPC
wire [31: 0] NPC_out_npc;
`ifdef RUN_TRACE
//wire [15:0]  inst_addr,
   assign inst_addr = PC_out_pc[17:2] ;
`else
   assign inst_addr = PC_out_pc[15:2];
`endif
// ADR_CODING
wire [6: 0] ADR_CODING_out_opcode;
wire [2: 0] ADR_CODING_out_func3;
wire [6: 0] ADR_CODING_out_func7;
wire [31: 7] ADR_CODING_out_sext_inst;
wire [4: 0] ADR_CODING_out_rR1;
wire [4: 0] ADR_CODING_out_rR2;
wire [4: 0] ADR_CODING_out_wR;
//CPU_controller

wire [1: 0] CPU_controller_out_NPC_op;
wire CPU_controller_out_RF_we;
wire [2: 0] CPU_controller_out_SEXT_op;
wire [3: 0] CPU_controller_out_ALU_op;
wire CPU_controller_out_RAM_we;
wire [1: 0] CPU_controller_out_ALU_B_sel;
wire [2: 0] CPU_controller_out_RF_WD_sel;
wire CPU_controller_out_PC_sel;
// PC_sel

wire [31: 0] PC_sel_out_pcdin;



// SEXT

wire [31: 0] SEXT_out_SEXT_output;
//ALU

wire [31: 0] ALU_out_C;
wire AlU_out_f;
// ALU_B_sel
wire [31: 0] ALU_B_out;

// reg32file
wire [31: 0] rf_out_rD1;
wire [31: 0] rf_out_rD2;

// RF_WD_sel
wire [31: 0] RF_WD_sel_out_WD;



PC single_PC(.clk(cpu_clk), .reset(cpu_rst), .din(PC_sel_out_pcdin), .pc(PC_out_pc), .pc_out(PC_out_pc_out));
PC_sel single_PC_sel(.PC_sel(CPU_controller_out_PC_sel), .npc(NPC_out_npc), .ALU_C(ALU_out_C),.pc_din(PC_sel_out_pcdin));
NPC singleNPC(.offset(SEXT_out_SEXT_output), .PC(PC_out_pc_out), .NPC_op(CPU_controller_out_NPC_op), .br(AlU_out_f), .npc(NPC_out_npc));
// 64KB IROM

SEXT singleSEXT(.SEXT_op(CPU_controller_out_SEXT_op), 
                            .SEXT_inst(ADR_CODING_out_sext_inst), 
                            .SEXT_output(SEXT_out_SEXT_output));
ADR_CODING singleADR_CODING(.inst(inst), 
                            .opcode(ADR_CODING_out_opcode), 
                            .func3(ADR_CODING_out_func3), 
                            .func7(ADR_CODING_out_func7), 
                            .sext_inst(ADR_CODING_out_sext_inst), 
                            .rR1(ADR_CODING_out_rR1), 
                            .rR2(ADR_CODING_out_rR2), 
                            .wR(ADR_CODING_out_wR));
CPU_controller singleCPU_controller(.opcode(ADR_CODING_out_opcode), 
                            .funct3(ADR_CODING_out_func3), 
                            .funct7(ADR_CODING_out_func7), 
                            .NPC_op(CPU_controller_out_NPC_op), 
                            .RF_we(CPU_controller_out_RF_we), 
                            .SEXT_op(CPU_controller_out_SEXT_op), 
                            .ALU_op(CPU_controller_out_ALU_op), 
                            .RAM_we(CPU_controller_out_RAM_we), 
                            .ALU_B_sel(CPU_controller_out_ALU_B_sel), 
                            .RF_WD_sel(CPU_controller_out_RF_WD_sel), 
                            .PC_sel(CPU_controller_out_PC_sel));
ALU singleALU(.A(rf_out_rD1),.B(ALU_B_out),.ALU_op(CPU_controller_out_ALU_op),.f(AlU_out_f),.C(ALU_out_C));
ALU_B_sel singleALU_B_sel(.ALU_B_0(SEXT_out_SEXT_output), .ALU_B_1(rf_out_rD2), .ALU_B_sel_signal(CPU_controller_out_ALU_B_sel), .ALU_B(ALU_B_out));
reg32file singleRF(.clk(cpu_clk), .reset(cpu_rst), .we(CPU_controller_out_RF_we), .rR1(ADR_CODING_out_rR1), .rR2(ADR_CODING_out_rR2), .wR(ADR_CODING_out_wR), .wD(RF_WD_sel_out_WD), .rD1(rf_out_rD1), .rD2(rf_out_rD2));
RF_WD_sel singleRF_WD_sel(.FROM_ALU(ALU_out_C), .FROM_PC(PC_out_pc), .FROM_SEXT(SEXT_out_SEXT_output), .FROM_RDO(Bus_rdata), .RF_WD_sel(CPU_controller_out_RF_WD_sel), .WD(RF_WD_sel_out_WD));
assign Bus_we = CPU_controller_out_RAM_we;
assign Bus_wdata = rf_out_rD2;
assign Bus_addr = ALU_out_C;
// reg [31:0] PC0;
// reg        RegWEn0;
// reg [4:0]  rd0;
// reg [31:0] data0;
// always@(posedge cpu_clk ) begin
//     PC0 <= PC_out_pc;
//     RegWEn0 <= CPU_controller_out_RF_we;
//     rd0 <= ADR_CODING_out_wR;
//     data0 <= RF_WD_sel_out_WD;
// end
    
`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1;           // single cycle cpu: constant 1
    assign debug_wb_pc        = PC_out_pc;              // 此阶段的pc
    assign debug_wb_ena       = CPU_controller_out_RF_we;
    assign debug_wb_reg       = ADR_CODING_out_wR;
    assign debug_wb_value     = RF_WD_sel_out_WD;
`endif

endmodule
