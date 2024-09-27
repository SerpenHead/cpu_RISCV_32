`timescale 1ns / 1ps
`include "defines.vh"

module ALU(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALU_op,
    output reg [31:0] C,
    output reg f
);

always @(*) begin
    // Default values
    C = 0;
    f = 0;

    case (ALU_op)
        `ALU_ADD: begin
            // c = A + B, f = 0
            C = A + B;
        end
        `ALU_SUB: begin
            // c = A - B, f = 0
            C = A - B;
        end
        `ALU_AND: begin
            // c = A & B, f = 0
            C = A & B;
        end
        `ALU_OR: begin
            // c = A | B, f = 0
            C = A | B;
        end
        `ALU_XOR: begin
            // c = A ^ B, f = 0
            C = A ^ B;
        end
        `ALU_SLL: begin
            // c = A << B, f = 0
            C = A << B[4:0];
        end
        `ALU_SRL: begin
            // c = A >> B, f = 0
            C = A >> B[4:0];
        end
        `ALU_SRA: begin
            // c = A >>> B, f = 0
            C = $signed(A) >>> B[4:0];
        end
        `ALU_BEQ: begin
            // if A = B, f = 1;
            if (A == B) begin
                f = 1;
            end
        end
        `ALU_BNE: begin
            // if A != B, f = 1;
            if (A != B) begin
                f = 1;
            end
        end
        `ALU_BLT: begin
            // if A < B, f = 1;
            if ($signed(A) < $signed(B)) begin
                f = 1;
            end
        end
        `ALU_BGE: begin
            // if A >= B, f = 1;
            if ($signed(A) >= $signed(B)) begin
                f = 1;
            end
        end
        default: begin
            f = 0;
            C = 0;
        end
    endcase
end

endmodule
