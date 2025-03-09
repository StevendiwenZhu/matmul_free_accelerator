module sram_matrix_buffer_wide (
    input logic clk,
    input logic reset_n,
    input logic enable,
    input logic wr_en,
    input logic [ARR_WIDTH-1:0][7:0] in_data,
    input logic [6:0] addr,
    output logic signed [ARR_WIDTH-1:0][7:0] out
);

    // Generate ARR_WIDTH instances of input_buffer
    genvar i;
    generate
        for (i = 0; i < ARR_WIDTH; i++) begin : sram_inst
            input_buffer_inst input_buffer_inst (
                .CE(clk),
                .WEB(wr_en),     // Write Enable - Active Low
                .OEB(1'b0),      // Output Enable - Active Low
                .CSB(enable),    // Chip select - Active Low
                .A(addr),        // Read/Write Address
                .I(in_data[i]),
                .O(out[i])
            );
        end
    endgenerate

endmodule