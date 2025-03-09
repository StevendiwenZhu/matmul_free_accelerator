module testbench;
    parameter ADDR_DEPTH = 128;
    
    // Testbench signals
    logic clk;
    logic reset_n;
    logic enable;
    logic wr_en;
    logic [ARR_WIDTH-1:0][7:0] in_data;
    logic [6:0] addr;
    logic signed [ARR_WIDTH-1:0][7:0] out;
    
    // Memory array to store expected values
    logic [7:0] expected_data [ARR_WIDTH-1:0][ADDR_DEPTH-1:0];

    // Clock generation
    always begin
        #(`CLOCK_PERIOD/2);
        clk = ~clk;
    end

    // Instantiate the unit under test
    sram_matrix_buffer_wide uut (
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
        in_data = '{default: '0};
        addr = 7'b0;

        // Reset sequence
        #10 reset_n = 1;
        #10 enable = 0;

        // Write random data to all addresses
        $display("Writing random data to all addresses...");
        for (int address = 0; address < ADDR_DEPTH; address++) begin
            @(posedge clk);
            wr_en = 0;
            addr = address[6:0];
            
            // Generate random data for each SRAM
            for (int i = 0; i < ARR_WIDTH; i++) begin
                // Generate random signed value between -128 and 127
                in_data[i] = $random;
                // Store for verification
                expected_data[i][address] = in_data[i];
            end

            @(posedge clk);
            wr_en = 1;
        end

        // Read and verify all addresses
        $display("\nReading back and verifying data...");
        for (int address = 0; address < ADDR_DEPTH; address++) begin
            @(posedge clk);
            addr = address[6:0];
            
            @(posedge clk);  // Wait for read data
            
            // Verify data from all SRAMs
            for (int i = 0; i < ARR_WIDTH; i++) begin
                if (out[i] !== expected_data[i][address]) begin
                    $display("ERROR at address %d, SRAM%0d: Expected %d, Got %d",
                            address, i, expected_data[i][address], out[i]);
                end
            end
            
            // Print some sample values (every 16th address)
            if (address % 16 == 0) begin
                $display("Address %d:", address);
                for (int i = 0; i < ARR_WIDTH; i++) begin
                    $write("SRAM%0d: %d  ", i, out[i]);
                end
                $display("");
            end
        end

        // End simulation
        #20;
        $display("\nTestbench completed");
        $finish;
    end


endmodule