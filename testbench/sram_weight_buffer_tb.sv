module sram_weight_buffer_tb;

    // Testbench signals
    logic clk;
    logic reset_n;
    logic enable;
    logic wr_en;  // Active-low write enable
    logic [7:0] in_data;
    logic [3:0] addr;
    logic signed [7:0] out;

    always begin
        #(`CLOCK_PERIOD/2 );
        clk = ~clk;
    end

    // DUT instantiation
    sram_weight_buffer uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .wr_en(wr_en),
        .in_data(in_data),
        .addr(addr),
        .out(out)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        enable = 1;
        wr_en = 1; // Default to inactive (write disabled)
        in_data = 8'b0;
        addr = 4'b0;

        // Reset sequence
        #10 reset_n = 1;
        #10 enable = 0;

        // Write data to a specific address
        @(posedge clk);
        wr_en = 0; // Active-low write enable
        addr = 4'd3;
        in_data = 8'sd55;

        @(posedge clk);
        wr_en = 1; // Deactivate write

        // Read back the data from the same address
        @(posedge clk);
        addr = 4'd3;

        @(posedge clk);
        // Check the output
        $display("Read data from addr %d: %d", addr, out);

        // Write to another address
        @(posedge clk);
        wr_en = 0; // Active-low write enable
        addr = 4'd7;
        in_data = 8'sd127;

        @(posedge clk);
        wr_en = 1; // Deactivate write

        // Read back from the new address
        @(posedge clk);
        addr = 4'd7;

        @(posedge clk);
        // Check the output
        $display("Read data from addr %d: %d", addr, out);

        // End simulation
        #20;
        $finish;
    end
endmodule
