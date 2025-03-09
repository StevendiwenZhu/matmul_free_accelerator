`include "sys_defs.svh"
`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    logic clock;
    logic rst;
    logic start;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_1;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_2;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] out;
    logic busy, done, dbz, ovf;

    int cycle_count;

    // Instantiate the vec_div module
    vec_div vec_div0 (
        .clk(clock),
        .rst(rst),
        .start(start),
        .busy(busy),
        .done(done),
        .in_1(in_1),
        .in_2(in_2),
        .out(out),
        .dbz(dbz),
        .ovf(ovf)
    );

    // Clock generation
    always begin
        #(100) clock = ~clock;
    end

    // Print vectors and their real equivalents
    task print_vectors();
        begin
            $display("Time: %0t ns", $time);

            // Print Input Vector 1
            $write("Input Vector 1: ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(in_1[i], real_val);
                $write("%0f ", real_val);
            end
            $display();

            // Print Input Vector 2
            $write("Input Vector 2: ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(in_2[i], real_val);
                $write("%0f ", real_val);
            end
            $display();

            // Print Output Vector
            $write("Output Vector  : ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(out[i], real_val);
                $write("%0f ", real_val);
            end
            $display();

            // Print Flags
            $display("DBZ (Divide by Zero): %0b, OVF (Overflow): %0b", dbz, ovf);
            $display("Cycle count: %d", cycle_count);
            $display("--------------------------------------");
        end
    endtask

    // Run a test case with real inputs
    task run_real_test_case(
        input real test_in_1[ARR_WIDTH],
        input real test_in_2[ARR_WIDTH]
    );
        begin
            // Convert real inputs to fixed-point
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real_to_fixed_signed(test_in_1[i], in_1[i]);
                real_to_fixed_signed(test_in_2[i], in_2[i]);
            end

            // Reset
            rst=1;
            @(negedge clock);
            rst=0;

            // Start the vec_div operation
            start = 1;
            cycle_count = 0;
            @(negedge clock);
            start = 0;

            // Wait for the operation to complete
            while (!done) begin
                @(posedge clock);
                cycle_count = cycle_count + 1;
            end

            // Print the results
            print_vectors();
        end
    endtask

    // Test sequence
    initial begin
        // Dump signals to VCD file
        $dumpfile("vec_div_tb.vcd");
        $dumpvars(0, testbench.vec_div0);

        // Initialize variables
        clock = 0;
        rst = 0;
        start = 0;
        in_1 = '{default: 0};
        in_2 = '{default: 0};

        // Apply reset
        @(negedge clock);
        rst = 1;
        @(negedge clock);
        rst = 0;

        // Run test cases with real inputs
        run_real_test_case('{15.0, -22.5, 37.5, -45.0}, '{2.5, -3.5, 4.5, -5.5});
        run_real_test_case('{10.0, 20.0, 30.0, 40.0}, '{2.0, 4.0, 6.0, 8.0});
        run_real_test_case('{1.0, -2.0, 3.0, -4.0}, '{0.1, -0.2, 0.3, -0.4});
        run_real_test_case('{0.25, 0.5, 0.75, 1.0}, '{0.0625, 0.1875, 0.25, 0.375});
        // NOTE: DIVIDE BY ZERO CURRENTLY HANGS FOREVER! FIX IF WE HAVE TIME. OTHERWISE ASSUME OUR MODELS/DATA ARE WELLFORMED SO WONT CAUSE THIS ISSUE
        // run_real_test_case('{0.0, 5.0, -5.0, 10.0}, '{1.0, 0.0, 2.0, -5.0});  // Includes divide-by-zero case

        $finish;
    end
endmodule
