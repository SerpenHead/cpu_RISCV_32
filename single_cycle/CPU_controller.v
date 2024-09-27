`timescale 1ns / 1ps
`include "defines.vh"
module CPU_controller(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [1:0] NPC_op,
    output reg RF_we,
    output reg [2:0] SEXT_op,
    output reg [3:0] ALU_op,
    output reg RAM_we,
    output reg [1:0] ALU_B_sel,
    output reg [2:0] RF_WD_sel,
    output reg PC_sel
);

always @(*) begin
    // Default values
    NPC_op = `NPC_op_NODOING;
    RF_we = 0;
    SEXT_op = `SEXT_op_NODING;
    ALU_op = `ALU_NODOING;
    RAM_we = 0;
    ALU_B_sel = `ALU_B_sel_NODOING;
    RF_WD_sel = `RF_WD_sel_NODOING;
    PC_sel = `PC_sel_NPC;

    case (opcode)
        7'b0110011: begin // R-type
            NPC_op = `NPC_op_PC_4;
            RF_we = 1;
            ALU_B_sel = `ALU_B_rD2;
            RF_WD_sel = `RF_WD_sel_ALU;
            PC_sel = `PC_sel_NPC;
            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0000000) ALU_op = `ALU_ADD;
                    else if (funct7 == 7'b0100000) ALU_op = `ALU_SUB;
                end
                3'b111: ALU_op = `ALU_AND;
                3'b110: ALU_op = `ALU_OR;
                3'b100: ALU_op = `ALU_XOR;
                3'b001: ALU_op = `ALU_SLL;
                3'b101: begin
                    if (funct7 == 7'b0000000) ALU_op = `ALU_SRL;
                    else if (funct7 == 7'b0100000) ALU_op = `ALU_SRA;
                end
            endcase
        end
        7'b0010011: begin // I-type
            NPC_op = `NPC_op_PC_4;
            RF_we = 1;
            SEXT_op = `SEXT_op_I;
            ALU_B_sel = `ALU_B_IMM;
            RF_WD_sel = `RF_WD_sel_ALU;
            PC_sel = `PC_sel_NPC;
            case (funct3)
                3'b000: ALU_op = `ALU_ADD;
                3'b111: ALU_op = `ALU_AND;
                3'b110: ALU_op = `ALU_OR;
                3'b100: ALU_op = `ALU_XOR;
                3'b001: ALU_op = `ALU_SLL;
                3'b101: begin
                    if (funct7 == 7'b0000000) ALU_op = `ALU_SRL;
                    else if (funct7 == 7'b0100000) ALU_op = `ALU_SRA;
                end
            endcase
        end
        7'b0000011: begin // lw
            NPC_op = `NPC_op_PC_4;
            RF_we = 1;
            SEXT_op = `SEXT_op_I;
            ALU_op = `ALU_ADD;
            ALU_B_sel = `ALU_B_IMM;
            RF_WD_sel = `RF_WD_sel_RDO;
            PC_sel = `PC_sel_NPC;
        end
        7'b1100111: begin // jalr
            NPC_op = `NPC_op_PC_4;
            RF_we = 1;
            SEXT_op = `SEXT_op_I;
            ALU_op = `ALU_ADD;
            ALU_B_sel = `ALU_B_IMM;
            RF_WD_sel = `RF_WD_sel_NPC;
            PC_sel = `PC_sel_ALU;
        end
        7'b0100011: begin // sw
            NPC_op = `NPC_op_PC_4;
            RF_we = 0;
            SEXT_op = `SEXT_op_S;
            ALU_op = `ALU_ADD;
            ALU_B_sel = `ALU_B_IMM;
            RAM_we = 1;
            PC_sel = `PC_sel_NPC;
        end
        7'b1100011: begin // B-type
            NPC_op = `NPC_op_BR;
            RF_we = 0;
            SEXT_op = `SEXT_op_B;
            ALU_B_sel = `ALU_B_rD2;
            PC_sel = `PC_sel_NPC;
            case (funct3)
                3'b000: ALU_op = `ALU_BEQ;
                3'b001: ALU_op = `ALU_BNE;
                3'b100: ALU_op = `ALU_BLT;
                3'b101: ALU_op = `ALU_BGE;
            endcase
        end
        7'b0110111: begin // lui
            NPC_op = `NPC_op_PC_4;
            RF_we = 1;
            SEXT_op = `SEXT_op_U;
            ALU_B_sel = `ALU_B_sel_NODOING;
            RF_WD_sel = `RF_WD_sel_SEXT;
            PC_sel = `PC_sel_NPC;
        end
        7'b1101111: begin // jal
            NPC_op = `NPC_op_OFFSET;
            RF_we = 1;
            SEXT_op = `SEXT_op_J;
            PC_sel = `PC_sel_NPC;
            RF_WD_sel = `RF_WD_sel_NPC;
        end
        default:begin
            NPC_op = `NPC_op_PC_4;
        end
            
    endcase
end

endmodule
