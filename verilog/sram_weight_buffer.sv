module sram_weight_buffer(
    input logic clk,
    input logic reset_n,
    input logic enable,
    input logic wr_en,
    input logic [7:0] in_data,
    input logic [3:0] addr,
    output logic signed [7:0] out
);

weight_buffer_sram_inst weight_buffer_sram_inst0(
    .CE(clk),
    .WEB(wr_en), // Write Enable - Active Low
    .OEB(0), // Output Enable - Active Low
    .CSB(enable), // Chip select - Active Low
    .A(addr), // Read/Write Address
    .I(in_data),
    .O(out)
);


endmodule