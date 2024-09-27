`timescale 1ns / 1ps
`include "defines.vh"

module NPC(
    input  wire [31:0] offset,
    input  wire [31:0] PC,
    input  wire [1:0] NPC_op,
    input  wire br,
    output reg [31:0] npc
);
    always @(*) begin
        case (NPC_op)
            `NPC_op_PC_4: begin
                npc = PC + 4;
            end
            `NPC_op_OFFSET: begin
                npc = PC + offset;
            end
            `NPC_op_BR: begin
                if (br) begin
                    npc = PC + offset;
                end else begin
                    npc = PC + 4;
                end
            end
            default: begin
                npc = PC;
            end
        endcase
    end
    

endmodule
