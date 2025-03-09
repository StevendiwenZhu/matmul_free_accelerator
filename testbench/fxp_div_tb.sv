`include "test_utils.svh"
`timescale 1ns/1ps

module fxp_div_tb;
    // Declare testbench variables
    logic clock;
    logic rst;
    logic start;
    logic signed [FXP_N-1:0] a, b;
    logic signed [FXP_N-1:0] val;
    logic busy, done, valid, dbz, ovf;
    real real_a, real_b, real_val;
    int cycle_count;

    // Instantiate the module under test (MUT)
    fxp_div #(
        .WIDTH(FXP_N),
        .FBITS(FXP_R)
    ) uut (
        .clk(clock),
        .rst(rst),
        .start(start),
        .busy(busy),
        .done(done),
        .valid(valid),
        .dbz(dbz),
        .ovf(ovf),
        .a(a),
        .b(b),
        .val(val)
    );

    // Generate clock signal
    always begin
        #(500 / 2) clock = ~clock; // 10 ns clock period
    end

    // Task to print the testbench status
    task print_status();
        begin
            fixed_to_real_signed(a, real_a);
            fixed_to_real_signed(b, real_b);
            fixed_to_real_signed(val, real_val);
            
            $display("Time: %0t ns", $time);
            $display("a: %0f, b: %0f, val: %0f, dbz: %0b, ovf: %0b, valid: %0b, cycles: %0d", 
                     real_a, real_b, real_val, dbz, ovf, valid, cycle_count);
            $display("--------------------------------------");
        end
    endtask

    // Task to run a single test case
    task run_test(input real real_num, input real real_denom);
        logic signed [FXP_N-1:0] fixed_num, fixed_denom;
        begin
            real_to_fixed_signed(real_num, fixed_num);
            real_to_fixed_signed(real_denom, fixed_denom);

            a = fixed_num;
            b = fixed_denom;
            start = 1;
            cycle_count = 0;  // Reset cycle count
            @(negedge clock);
            start = 0;

            // Wait for the calculation to finish and count cycles
            while (!done) begin
                @(posedge clock);
                cycle_count++;
            end

            @(negedge clock);
            print_status();
        end
    endtask

    task run_n_cycles(int n);
        for (int i = 0; i < n; i = i + 1) begin
            @(negedge clock);
        end
    endtask

    // Test sequence
    initial begin
        // Dump signals to a VCD file
        $dumpfile("fxp_div_tb.vcd");
        $dumpvars(0, fxp_div_tb);

        // Initialize inputs
        clock = 0;
        rst = 0;
        start = 0;
        a = 100;
        b = 100;

        // Reset the DUT
        @(negedge clock);
        rst = 1;
        @(negedge clock);
        rst = 0;
        start = 1;
        run_n_cycles(50);

        print_status();

        // Run test cases
        run_test(20.0, 5.0);        // Normal case
        run_test(-20.0, 5.0);       // Negative numerator
        run_test(20.0, -5.0);       // Negative denominator
        run_test(-20.0, -5.0);      // Both numerator and denominator negative
        run_test(0.0, 5.0);         // Zero numerator
        // run_test(20.0, 0.0);        // Divide by zero
        run_test(1.0, 1.0);         // Basic case
        run_test(-1.0, 1.0);        // Negative numerator
        run_test(10.0, 3.0);        // Fractional result
        run_test(-10.0, -3.0);      // Negative fractional result

        $finish;
    end
endmodule
