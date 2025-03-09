`include "sys_defs.svh"
`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    logic clk;
    logic rst_n;
    logic start;
    logic enable;
    logic mode;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sa_row_in;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] int_row_in;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rec_row_in;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_out;

    // Instantiate the module
    vector_unit vector_unit0(
        .clk(clk),
        .rst_n(rst_n),
        // .start(start),
        .enable(enable),
        .mode(mode),
        .sa_row_in(sa_row_in),
        .int_row_in(int_row_in),
        .rec_row_in(rec_row_in),
        .vec_out(vec_out)
    );

    // Clock generation
    always begin
        #(`CLOCK_PERIOD / 2) clk = ~clk;
    end

    task print_vector(logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_vec);
        begin
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(input_vec[i], real_val);
                $write("%0f ", real_val);
            end
            $display();
        end
    endtask

    // Print vectors and their real equivalents
    task print_vectors();
        begin
            $display("Time: %0t ns", $time);

            $write("Systolic Array Row In: ");
            print_vector(sa_row_in);

            $write("Intermediate SRAM Row In: ");
            print_vector(int_row_in);

            $write("Recurrence SRAM Row In: ");
            print_vector(rec_row_in);

            $write("Vector Row Out: ");
            print_vector(vec_out);

            // Print Flags
            // $display("Cycle count: %d", cycle_count);
            $display("--------------------------------------");
        end
    endtask

    // Run a test case with real inputs
    task run_real_test_case(
        input logic test_mode,
        input real test_in_1[ARR_WIDTH],
        input real test_in_2[ARR_WIDTH],
        input real test_in_3[ARR_WIDTH]
    );
        begin
            // Convert real inputs to fixed-point
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real_to_fixed_signed(test_in_1[i], sa_row_in[i]);
                real_to_fixed_signed(test_in_2[i], int_row_in[i]);
                real_to_fixed_signed(test_in_3[i], rec_row_in[i]);
            end

            // Start the operation
            // start = 1;
            enable = 1;
            // cycle_count = 0;
            mode = test_mode;
            @(negedge clk);
            // start = 0;

            // Print the results
            print_vectors();
        end
    endtask

    real test_random[ARR_WIDTH];
    time perf_start_time;
    time perf_end_time;
    // Test sequence
    initial begin
        // Dump signals to VCD file
        $dumpfile("vector_unit.vcd");
        $dumpvars(0, testbench.vector_unit0);

        // Initialize variables
        clk = 0;
        rst_n = 0;
        start = 0;
        enable = 0;
        sa_row_in = '{default: 0};
        int_row_in = '{default: 0};
        rec_row_in = '{default: 0};

        // Reset
        rst_n=0;
        @(negedge clk);
        rst_n=1;

        // Run test cases with real inputs
        // run_real_test_case(0, '{15.0, -22.5, 37.5, -45.0}, '{2.5, -3.5, 4.5, -5.5}, '{1.0, 1.0, 1.0, 1.0});
        // run_real_test_case(0, '{10.0, 20.0, 30.0, 40.0}, '{2.0, 4.0, 6.0, 8.0}, '{1.0, 1.0, 1.0, 1.0});
        // run_real_test_case(0, '{1.0, -2.0, 3.0, -4.0}, '{0.1, -0.2, 0.3, -0.4}, '{1.0, 1.0, 1.0, 1.0});
        // run_real_test_case(0, '{0.25, 0.5, 0.75, 1.0}, '{0.0625, 0.1875, 0.25, 0.375}, '{1.0, 1.0, 1.0, 1.0});
        // // NOTE: DIVIDE BY ZERO CURRENTLY HANGS FOREVER! FIX IF WE HAVE TIME. OTHERWISE ASSUME OUR MODELS/DATA ARE WELLFORMED SO WONT CAUSE THIS ISSUE
        // // run_real_test_case('{0.0, 5.0, -5.0, 10.0}, '{1.0, 0.0, 2.0, -5.0});  // Includes divide-by-zero case
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // // Run test cases with real inputs with mode 1
        // run_real_test_case(1, '{15.0, -22.5, 37.5, -45.0}, '{2.5, -3.5, 4.5, -5.5}, '{1.0, 1.0, 1.0, 1.0});
        // run_real_test_case(1, '{10.0, 20.0, 30.0, 40.0}, '{2.0, 4.0, 6.0, 8.0}, '{1.0, 1.0, 1.0, 1.0});
        // run_real_test_case(1, '{1.0, -2.0, 3.0, -4.0}, '{0.1, -0.2, 0.3, -0.4}, '{1.0, 1.0, 1.0, 1.0});
        // run_real_test_case(1, '{0.25, 0.5, 0.75, 1.0}, '{0.0625, 0.1875, 0.25, 0.375}, '{1.0, 1.0, 1.0, 1.0});

        $display("Testing with random numbers:");
        perf_start_time = $time;

        for (int i = 0; i < 60; i = i + 1) begin
            generate_random_vector(test_random);
            run_real_test_case(1, test_random, test_random, test_random);
        end

        perf_end_time = $time;
        // Display the start and end times of performance
        $display("Perf power measurement start time: %0f ns\nPerf end time: %0f ns\n", perf_start_time, perf_end_time);

        // 6-12ns

        $finish;
    end
endmodule
