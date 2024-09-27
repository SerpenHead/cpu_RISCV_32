`timescale 1ns / 1ps
`include "defines.vh"

module ALU_B_sel(
    input  wire [31:0] ALU_B_0,
    input  wire [31:0] ALU_B_1,
    input  wire [1:0] ALU_B_sel_signal,
    output reg [31:0] ALU_B
);

always @(*) begin
    case (ALU_B_sel_signal)
        `ALU_B_IMM: begin
            ALU_B = ALU_B_0;
        end
        `ALU_B_rD2: begin
            ALU_B = ALU_B_1;
        end
        default: begin
            ALU_B = 32'b0;
        end
    endcase
end

endmodule
