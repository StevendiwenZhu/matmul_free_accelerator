`include "sys_defs.svh"
`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    logic clock;
    logic rst_n;
    logic enable;
    logic start;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] scaling_arr;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] output_arr;
    logic done;

    int cycle_count;
    
    // Instantiate DUT
    rms_norm_sf rms_norm_sf0 (
        .clk(clock),
        .rst_n(rst_n),
        .enable(enable),
        .start(start),
        .input_arr(input_arr),
        .scaling_arr(scaling_arr),
        .output_arr(output_arr),
        .done(done)
    );

    // Clock generation
    always begin
        #(`CLOCK_PERIOD / 2) clock = ~clock;
    end

    real rms_real;
    // Print vectors and their real equivalents
    task print_vectors();
        begin
            $display("Time: %0t ns", $time);

            // Print Input Vector
            $write("Input Vector: ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(input_arr[i], real_val);
                $write("%0f ", real_val);
            end
            $display();


            // Print Output Vector
            $write("Output Vector  : ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(output_arr[i], real_val);
                $write("%0f ", real_val);
            end
            $display();

            $write("Number of Cycles: %d", cycle_count);
            $display();

            $display("--------------------------------------");
        end
    endtask

    task reset_all();
        begin
            start = 0;
            rst_n = 0;
            @(negedge clock);
            rst_n = 1;

        end
    endtask

    task wait_until_done();
        begin
            cycle_count = 0;
            while (!done) begin
                @(negedge clock);
                cycle_count++;
            end
        end
    endtask

    // Run a test case with real inputs
    task run_real_test_case(
        input real test_in[ARR_WIDTH]
    );
        begin

            reset_all();

            // Convert real inputs to fixed-point
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real_to_fixed_signed(test_in[i], input_arr[i]);
            end

            cycle_count = 0;

            start = 1;
            @(negedge clock);
            start = 0;

            wait_until_done();

            // Print the results
            print_vectors();
        end
    endtask
    
    real test_random[ARR_WIDTH];
    time perf_start_time;
    time perf_end_time;
    // Test stimulus
    initial begin
        // Dump signals to VCD
        $dumpfile("rms_norm_sf_tb.vcd");
        $dumpvars(0, testbench.rms_norm_sf0);
        clock = 0;

        reset_all();

        enable = 1;

        // Test case 1: All 1's
        start = 1;
        for (int i = 0; i < ARR_WIDTH; i++) begin
            input_arr[i] = (1 << FXP_R); // 1.0 in fixed point
            scaling_arr[i] = (1 << (FXP_R - 1));
        end
        @(negedge clock);
        start = 0;
        wait_until_done();
        print_vectors();

        reset_all();
        
        // Use same scaling_arr as previous test case
        
        // Test case 2: Increasing sequence
        start = 1;
        for (int i = 0; i < ARR_WIDTH; i++)
            input_arr[i] = ((i + 1) << FXP_R); // 1.0, 2.0, 3.0, etc.
        @(negedge clock);
        start = 0;
        wait_until_done();
        print_vectors();
        @(negedge clock);

        // Run test cases with real inputs
        // run_real_test_case('{2.5, -3.5, 4.5, -5.5});
        // run_real_test_case('{-15.0, -22.5, -37.5, -45.0});
        // run_real_test_case('{10.0, 20.0, 30.0, 40.0});
        // run_real_test_case('{2.0, 4.0, 6.0, 8.0});
        // run_real_test_case('{1.0, -2.0, 3.0, -4.0});
        // run_real_test_case('{0.1, -0.2, 0.3, -0.4});
        // run_real_test_case('{0.25, 0.5, 0.75, 1.0});
        // run_real_test_case('{0.0625, 0.1875, 0.25, 0.375});

        $display("Testing with random numbers:");
        perf_start_time = $time;
        generate_random_vector(test_random);
        run_real_test_case(test_random);

        perf_end_time = $time;
        // Display the start and end times of performance
        $display("Perf power measurement start time: %0f ns\nPerf end time: %0f ns\n", perf_start_time, perf_end_time);
        
        $finish;
    end
    
endmodule