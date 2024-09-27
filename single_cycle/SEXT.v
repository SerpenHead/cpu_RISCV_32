`timescale 1ns / 1ps
`include "defines.vh"

module SEXT(
    input  wire [2:0] SEXT_op,
    input  wire [31:7] SEXT_inst,
    output reg [31:0] SEXT_output
);

    always @(*) begin
        case (SEXT_op)
            `SEXT_op_I: begin
                // I-type immediate: [31:20] sign extended
                SEXT_output = {{20{SEXT_inst[31]}}, SEXT_inst[31:20]};
            end
            `SEXT_op_B: begin
                // B-type immediate: [31] sign, [30:25] | [11:8] | [7] | 0
                SEXT_output = {{19{SEXT_inst[31]}}, SEXT_inst[31], SEXT_inst[7], SEXT_inst[30:25], SEXT_inst[11:8], 1'b0};
            end
            `SEXT_op_S: begin
                // S-type immediate: [31:25] | [11:7] sign extended
                SEXT_output = {{20{SEXT_inst[31]}}, SEXT_inst[31:25], SEXT_inst[11:7]};
            end
            `SEXT_op_U: begin
                // U-type immediate: [31:12] sign extended, lower 12 bits are zero
                SEXT_output = {SEXT_inst[31:12], 12'b0};
            end
            `SEXT_op_J: begin
                // J-type immediate: [31] sign, [19:12] | [20] | [30:21] | 0
                SEXT_output = {{11{SEXT_inst[31]}}, SEXT_inst[31], SEXT_inst[19:12], SEXT_inst[20], SEXT_inst[30:21], 1'b0};
            end
            default: begin
                // Default case for no operation or invalid SEXT_op
                SEXT_output = 32'b0;
            end
        endcase
    end

endmodule
