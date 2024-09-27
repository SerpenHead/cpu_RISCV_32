`timescale 1ns / 1ps
`include "defines.vh"

module RF_WD_sel(
    input  wire [31: 0] FROM_ALU,
    input  wire [31: 0] FROM_PC,
    input  wire [31: 0] FROM_SEXT,
    input  wire [31: 0] FROM_RDO,
    input  wire [2: 0] RF_WD_sel,
    output reg [31: 0] WD
);

    always @(*) begin
        case (RF_WD_sel)
            `RF_WD_sel_ALU: WD = FROM_ALU;
            `RF_WD_sel_NPC: WD = FROM_PC + 4;
            `RF_WD_sel_SEXT: WD = FROM_SEXT;
            `RF_WD_sel_RDO: WD = FROM_RDO;
            default: WD = 32'b0;
        endcase
    end

endmodule
