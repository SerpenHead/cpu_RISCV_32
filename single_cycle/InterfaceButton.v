`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 20:59:58
// Design Name: 
// Module Name: InterfaceButton
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InterfaceButton(
    input [4:0] btn,
    output [31:0] data
    
    );
    assign data = {27'h7ffffff, btn};
endmodule
