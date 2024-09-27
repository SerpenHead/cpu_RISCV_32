`timescale 1ns / 1ps
module ADR_CODING(
    input  wire [31: 0] inst,
    output wire [6: 0] opcode,
    output wire [2: 0] func3,
    output wire [6: 0] func7,
    output wire [31: 7] sext_inst,
    output wire [4: 0] rR1,
    output wire [4: 0] rR2,
    output wire [4: 0] wR
    );
    assign opcode = inst[6: 0];
    assign func3 = inst[14: 12];
    assign func7 = inst[31: 25];
    assign sext_inst = inst[31: 7];
    assign rR1 = inst[19: 15];
    assign rR2 = inst[24: 20];
    assign wR = inst[11: 7];
endmodule
