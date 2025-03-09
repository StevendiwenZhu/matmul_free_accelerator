module testbench;
    parameter ARR_WIDTH = 8;
    parameter ADDR_DEPTH = 128;  // 7-bit address = 128 2-bit values
    
    // Testbench signals
    logic clk;
    logic reset_n;
    logic enable;
    logic wr_en;
    logic [7:0] in_data;
    logic [6:0] addr;
    logic signed [ARR_WIDTH-1:0][1:0] out;
    
    // Memory array to store expected values (2-bit signed values)
    logic signed [1:0] expected_data [ADDR_DEPTH-1:0][ARR_WIDTH-1:0];

    // Clock generation
    always begin
        #(`CLOCK_PERIOD/2);
        clk = ~clk;
    end

    // Instantiate the unit under test
    sram_weight_buffer_wide uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .wr_en(wr_en),
        .in_data(in_data),
        .addr(addr),
        .out(out)
    );

    // Function to generate valid 2-bit signed value (-1, 0, or 1)
    function logic [1:0] random_2bit_signed();
        bit [1:0] val;
        int rand_val = $random % 3;  // 0, 1, or 2
        case (rand_val)
            0: val = 2'b00;  //  0
            1: val = 2'b01;  //  1
            2: val = 2'b11;  // -1
        endcase
        return val;
    endfunction

    // Function to pack four 2-bit values into one byte
    function logic [7:0] pack_values(logic [1:0] val3, val2, val1, val0);
        return {val3, val2, val1, val0};
    endfunction

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

        // Write test pattern to all addresses
        $display("Writing test pattern to all addresses...");
        for (int base_addr = 0; base_addr < ADDR_DEPTH; base_addr += 4) begin
            // Generate four 2-bit values for one SRAM word
            logic [1:0] values [4];
            for (int i = 0; i < 4; i++) begin
                values[i] = random_2bit_signed();
                // Store expected values for later verification
                for (int j = 0; j < ARR_WIDTH; j++) begin
                    expected_data[base_addr + i][j] = values[i];
                end
            end

            // Pack values into 8-bit word and write to SRAM
            @(posedge clk);
            wr_en = 0;
            addr = base_addr[6:0];
            in_data = pack_values(values[3], values[2], values[1], values[0]);

            @(posedge clk);
            wr_en = 1;
        end

        // Read and verify all addresses
        $display("\nReading back and verifying data...");
        for (int address = 0; address < ADDR_DEPTH; address++) begin
            @(posedge clk);
            addr = address[6:0];
            
            @(posedge clk);  // Wait for read data
            
            // Verify all outputs
            for (int i = 0; i < ARR_WIDTH; i++) begin
                if (out[i] !== expected_data[address][i]) begin
                    $display("ERROR at address %d, output%0d: Expected %d, Got %d",
                            address, i, $signed(expected_data[address][i]), $signed(out[i]));
                end
            end
            
            // Print some sample values (every 16th address)
            if (address % 16 == 0) begin
                $display("Address %d:", address);
                for (int i = 0; i < ARR_WIDTH; i++) begin
                    $write("Out%0d: %d  ", i, $signed(out[i]));
                end
                $display("");
            end
        end

        // Test individual 2-bit value addressing
        $display("\nTesting individual 2-bit addressing...");
        @(posedge clk);
        wr_en = 0;
        addr = 7'd0;
        in_data = 8'b11_01_00_11;  // -1, 1, 0, -1 in 2's complement
        
        @(posedge clk);
        wr_en = 1;

        // Read each 2-bit value individually
        for (int i = 0; i < 4; i++) begin
            @(posedge clk);
            addr = i[6:0];
            @(posedge clk);
            $display("SubWord test - Address %0d: out[0]=%d", i, $signed(out[0]));
        end

        // End simulation
        #20;
        $display("\nTestbench completed");
        $finish;
    end


endmodule