`include "sys_defs.svh"
`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    logic clock;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr;
    logic signed [FXP_N-1:0] mean_out;
    
    // Instantiate DUT
    vec_mean dut (
        .input_arr(input_arr),
        .mean_out(mean_out)
    );

    // Clock generation
    always begin
        #(`CLOCK_PERIOD / 2) clock = ~clock;
    end

    real mean_real;
    real correct_real;
    // Print vectors and their real equivalents
    task print_vectors();
        begin
            $display("Time: %0t ns", $time);

            // Print Input Vector
            $write("Input Vector: ");
            correct_real = 0;
            for (int i = 0; i < ARR_WIDTH; i++) begin
                real real_val;
                fixed_to_real_signed(input_arr[i], real_val);
                correct_real = correct_real + real_val;
                $write("%0f ", real_val);
            end
            $display();

            // Print Output
            $write("Output Mean  : ");
            fixed_to_real_signed(mean_out, mean_real);
            $write("%0f", mean_real);
            correct_real = correct_real / ARR_WIDTH;
            $write(", Correct Mean : %0f", correct_real);
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

            // Print the results
            print_vectors();
        end
    endtask
    
    // Test stimulus
    initial begin
        clock = 0;

        // Test case 1: All 1's
        for (int i = 0; i < ARR_WIDTH; i++)
            input_arr[i] = (1 << FXP_R); // 1.0 in fixed point
        #10;
        $display("Test 1 - Mean of all 1's: %f", 
                 $signed(mean_out) * 1.0 / (1 << FXP_R));
        print_vectors();
        
        // Test case 2: Increasing sequence
        for (int i = 0; i < ARR_WIDTH; i++)
            input_arr[i] = ((i + 1) << FXP_R); // 1.0, 2.0, 3.0, etc.
        #10;
        $display("Test 2 - Mean of sequence: %f", 
                 $signed(mean_out) * 1.0 / (1 << FXP_R));
        print_vectors();
        @(negedge clock);

        // Run test cases with real inputs
        run_real_test_case('{2.5, -3.5, 4.5, -5.5});
        run_real_test_case('{-15.0, -22.5, -37.5, -45.0});
        run_real_test_case('{10.0, 20.0, 30.0, 40.0});
        run_real_test_case('{2.0, 4.0, 6.0, 8.0});
        run_real_test_case('{1.0, -2.0, 3.0, -4.0});
        run_real_test_case('{0.1, -0.2, 0.3, -0.4});
        run_real_test_case('{0.25, 0.5, 0.75, 1.0});
        run_real_test_case('{0.0625, 0.1875, 0.25, 0.375});
        
        $finish;
    end
    
endmodule