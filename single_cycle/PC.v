`timescale 1ns / 1ps
`include "defines.vh"

module PC(
    input  wire clk,
    input  wire reset,
    input  wire [31:0] din,
    output wire [31:0] pc,
    output wire [31:0] pc_out
);
   
    reg [31:0] pc_reg;
  
    assign pc = pc_reg;
    assign pc_out = pc_reg;
   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= -4;
        end else begin
            pc_reg <= din;
        end
    end

endmodule
