module sram_ifmap_buffer_tb;
    logic clk;
    logic reset_n;
    logic enable;
    logic wr_en;
    logic [7:0] in_data;
    logic [6:0] addr;
    logic signed [7:0] out;

    always begin
        #(`CLOCK_PERIOD/2 );
        clk = ~clk;
    end

    sram_ifmap_buffer uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .wr_en(wr_en),
        .in_data(in_data),
        .addr(addr),
        .out(out)
    );

    // Testbench initial block
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        enable = 1;
        wr_en = 1;
        in_data = 8'b0;
        addr = 7'b0;

        // Reset sequence
        #10 reset_n = 1;
        #10 enable = 0;

        // Write data to a specific address
        @(posedge clk);
        wr_en = 0;
        addr = 7'd5;
        in_data = 8'sd42;

        @(posedge clk);
        wr_en = 1;

        // Read back the data from the same address
        @(posedge clk);
        addr = 7'd5;

        @(posedge clk);
        // Check the output
        $display("Read data from addr %d: %d", addr, out);

        // End simulation
        #20;
        $finish;
    end
endmodule

