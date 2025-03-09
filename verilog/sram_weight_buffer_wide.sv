module sram_weight_buffer_wide (
    input logic clk,
    input logic reset_n,
    input logic enable,
    input logic wr_en,
    input logic [7:0] in_data,
    input logic [6:0] addr,     // 7-bit address
    output logic signed [ARR_WIDTH-1:0][1:0] out  // Packed 2D array output
);
    // Each output has its own SRAM
    localparam NUM_SRAMS = ARR_WIDTH;
    
    // Internal signals
    logic [NUM_SRAMS-1:0][7:0] sram_outputs;  // Packed array for SRAM outputs
    
    // Address mapping:
    // - SRAM takes 4-bit address (0 to 15)
    // - Each SRAM word contains four 2-bit values
    // - addr[5:2] selects which byte in SRAM (4 bits)
    // - addr[1:0] selects which 2-bit pair from that byte
    // Note: addr[6] is unused as we have fewer addressable locations
    
    // Generate one SRAM per output
    genvar i;
    generate
        for (i = 0; i < NUM_SRAMS; i++) begin : sram_inst
            weight_buffer_sram_inst weight_buffer_sram_inst (
                .CE(clk),
                .WEB(wr_en),
                .OEB(1'b0),
                .CSB(enable),
                .A(addr[5:2]),  // 4-bit address for SRAM
                .I(in_data),    // Same input data goes to all SRAMs
                .O(sram_outputs[i])
            );
        end
    endgenerate

    // Output assignment logic
    always_comb begin
        // For each output
        for (int i = 0; i < ARR_WIDTH; i++) begin
            // Select the appropriate 2-bit pair based on addr[1:0]
            case (addr[1:0])
                2'b00: out[i] = sram_outputs[i][7:6];
                2'b01: out[i] = sram_outputs[i][5:4];
                2'b10: out[i] = sram_outputs[i][3:2];
                2'b11: out[i] = sram_outputs[i][1:0];
            endcase
        end
    end

endmodule