`timescale 1ns / 1ps
`include "defines.vh"

module PC_sel(
    input  wire PC_sel,
    input  wire [31: 0] npc,
    input  wire [31: 0] ALU_C,
    output reg [31: 0] pc_din
);

    always @(*) begin
        case (PC_sel)
            `PC_sel_ALU: begin
                pc_din = ALU_C;
            end
            `PC_sel_NPC: begin
                pc_din = npc;
            end
            default: begin
                pc_din = 32'b0;
            end
        endcase
    end

endmodule
