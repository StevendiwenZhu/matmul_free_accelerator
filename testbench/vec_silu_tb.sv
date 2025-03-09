`include "sys_defs.svh"
`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    logic clock;
    logic rst;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] silu_out;

    // Instantiate the module
    vec_silu vec_silu0 (
        .clk(clock),
        .rst(rst),
        .vec_in(input_arr),
        .vec_out(silu_out)
    );

    // Clock generation
    always begin
        #(`CLOCK_PERIOD / 2) clock = ~clock;
    end

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
                fixed_to_real_signed(silu_out[i], real_val);
                $write("%0f ", real_val);
            end
            $display();

            $display("--------------------------------------");
        end
    endtask

    // Run a test case with real inputs
    task run_real_test_case(
        input real test_in[ARR_WIDTH]
    );
        begin
            // Convert real inputs to fixed-point
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real_to_fixed_signed(test_in[i], input_arr[i]);
            end

            @(negedge clock);
            @(negedge clock);

            // Print the results
            print_vectors();
        end
    endtask

    // Test sequence
    initial begin
        // Dump signals to VCD file
        $dumpfile("vec_sigmoid_tb.vcd");
        $dumpvars(0, testbench.vec_silu0);

        // Initialize variables
        clock = 0;
        rst = 1;
        input_arr = '{default: 0};

        @(negedge clock);
        rst = 0;
        @(negedge clock);

        // Run test cases with real inputs
        run_real_test_case('{15.0, -22.5, 37.5, -45.0});
        run_real_test_case('{2.5, -3.5, 4.5, -5.5});
        run_real_test_case('{10.0, 20.0, 30.0, 40.0});
        run_real_test_case('{2.0, 4.0, 6.0, 8.0});
        run_real_test_case('{1.0, -2.0, 3.0, -4.0});
        run_real_test_case('{0.1, -0.2, 0.3, -0.4});
        run_real_test_case('{0.25, 0.5, 0.75, 1.0});
        run_real_test_case('{0.0625, 0.1875, 0.25, 0.375});

        $finish;
    end
endmodule
