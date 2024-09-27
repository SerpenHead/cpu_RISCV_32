module reg32file (
    input wire clk,              // 时钟信号
    input wire reset,            // 重置信号
    input wire we,               // 写使能信号
    input wire [4:0] rR1, // 读地址1
    input wire [4:0] rR2, // 读地址2
    input wire [4:0] wR, // 写地址
    input wire [31:0] wD,// 写数据
    output wire [31:0] rD1,// 读数据1
    output wire [31:0] rD2 // 读数据2
);

// 32个32位寄存器
reg [31:0] registers [31:0];

// 读操作
assign rD1 = registers[rR1];
assign rD2 = registers[rR2];

// 写操作
always @(posedge clk or posedge reset) begin
    if (reset) begin
        registers[0]  <= 32'b0;
        registers[1]  <= 32'b0;
        registers[2]  <= 32'b0;
        registers[3]  <= 32'b0;
        registers[4]  <= 32'b0;
        registers[5]  <= 32'b0;
        registers[6]  <= 32'b0;
        registers[7]  <= 32'b0;
        registers[8]  <= 32'b0;
        registers[9]  <= 32'b0;
        registers[10] <= 32'b0;
        registers[11] <= 32'b0;
        registers[12] <= 32'b0;
        registers[13] <= 32'b0;
        registers[14] <= 32'b0;
        registers[15] <= 32'b0;
        registers[16] <= 32'b0;
        registers[17] <= 32'b0;
        registers[18] <= 32'b0;
        registers[19] <= 32'b0;
        registers[20] <= 32'b0;
        registers[21] <= 32'b0;
        registers[22] <= 32'b0;
        registers[23] <= 32'b0;
        registers[24] <= 32'b0;
        registers[25] <= 32'b0;
        registers[26] <= 32'b0;
        registers[27] <= 32'b0;
        registers[28] <= 32'b0;
        registers[29] <= 32'b0;
        registers[30] <= 32'b0;
        registers[31] <= 32'b0;


    end else if (we) begin
        if(wR)
        registers[wR] <= wD; // 写数据到指定寄存器
    end
end

endmodule
