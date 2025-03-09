`include "sys_defs.svh"
`timescale 1ns/1ps

module testbench;
    // Declare testbench variables
    logic clock;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_1;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_2;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sum_out;

    vec_add vec_add0 (
        .in_1(in_1),
        .in_2(in_2),
        .sum_out(sum_out)
    );

    always begin
        #(`CLOCK_PERIOD/2);
        clock = ~clock;
    end

    task print_vectors();
        begin
            $display("Time: %0t ns", $time);
            
            // Print Input Vector 1
            $write("Input Vector 1: ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                $write("%0d ", $signed(in_1[i]));
            end
            $display(); // End line

            // Print Input Vector 2
            $write("Input Vector 2: ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                $write("%0d ", $signed(in_2[i]));
            end
            $display(); // End line

            // Print Output Vector
            $write("Output Vector  : ");
            for (int i = 0; i < ARR_WIDTH; i++) begin
                $write("%0d ", $signed(sum_out[i]));
            end
            $display(); // End line

            $display("--------------------------------------");
        end
    endtask

    task run_test_case(
        input signed [ARR_WIDTH-1:0][FXP_N-1:0] test_in_1,
        input signed [ARR_WIDTH-1:0][FXP_N-1:0] test_in_2
    );
        begin
            in_1 = test_in_1;
            in_2 = test_in_2;
            @(negedge clock);
            print_vectors();
        end
    endtask


    task run_n_cycles(int n);
        for (int i = 0; i < n; i = i + 1) begin
            @(negedge clock);
            // Print the time and vector inputs/outputs
            print_vectors();
        end
    endtask

    time idle_start_time;
    time idle_end_time;
    time perf_start_time;
    time perf_end_time;

    // Test sequence
    initial begin
        // Dump signals to vcd file
        $dumpfile("vec_add_tb.vcd");
        $dumpvars(0, testbench.vec_add0);

        // $monitor("Time:%4.0f clock:%0b",
        //         $time, clock);

        // Initialize inputs
        clock = 0;
        in_1 = '{default: 0};
        in_2 = '{default: 0};

        run_n_cycles(1);

        if (TB_MODE == TB_POWER_IDLE) begin
            idle_start_time = $time;
            run_n_cycles(10);
            idle_end_time = $time;
            // Display the start and end times of idle
            $display("Idle start time: %0f ns\nIdle end time: %0f ns\n", idle_start_time, idle_end_time);
        end else if (TB_MODE == TB_POWER_PERF) begin
            perf_start_time = $time;
            // TODO: Add performance test logic
            run_n_cycles(10);
            perf_end_time = $time;
            // Display the start and end times of performance
            $display("Performance start time: %0f ns\nPerformance end time: %0f ns\n", perf_start_time, perf_end_time);
        end else begin
            // Correctness mode
            in_1 = '{1, 2, 3, 4}; // Example values
            in_2 = '{4, 3, 2, 1}; // Example values
            run_n_cycles(1);


            // Test 1: Positive numbers
            run_test_case('{10, 20, 30, 40}, '{1, 2, 3, 4});

            // Test 2: Negative numbers
            run_test_case('{-10, -20, -30, -40}, '{-1, -2, -3, -4});

            // Test 3: Mixed signs
            run_test_case('{10, -20, 30, -40}, '{-1, 2, -3, 4});

            // Test 4: Edge cases (max positive and min negative)
            // PROBLEMATIC: No overflow logic currently implemented
            run_test_case('{(1 <<< FXP_N-1)-1, -(1 <<< FXP_N-1), 0, -1}, '{1, -1, (1 <<< FXP_N-1)-1, -(1 <<< FXP_N-1)});

            // Test 5: Overflow check (values that will saturate)
            // PROBLEMATIC: No overflow logic currently implemented
            run_test_case('{(1 <<< FXP_N-1)-2, -(1 <<< FXP_N-1)+1, 0, -1}, '{3, -3, (1 <<< FXP_N-1)-1, -(1 <<< FXP_N-1)});

            // Test 6: All zeros
            run_test_case('{0, 0, 0, 0}, '{0, 0, 0, 0});

            // Test 7: Alternating large positive and negative
            run_test_case('{(1 <<< FXP_N-1)-1, -(1 <<< FXP_N-1), (1 <<< FXP_N-1)-1, -(1 <<< FXP_N-1)}, 
                        '{-(1 <<< FXP_N-1), (1 <<< FXP_N-1)-1, -(1 <<< FXP_N-1), (1 <<< FXP_N-1)-1});

        end
        
        $finish;

    end
endmodule
