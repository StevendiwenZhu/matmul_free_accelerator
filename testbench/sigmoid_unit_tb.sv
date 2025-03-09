`include "test_utils.svh"
`timescale 1ns/1ps

module sigmoid_pwl_tb;

    // Parameters for fixed-point representation
    parameter FXP_N = 16;  // Total bit width
    parameter FXP_R = 6;   // Number of fractional bits

    // Test range and number of test points
    parameter real TEST_MIN = -8.0;  // Minimum test range in real format
    parameter real TEST_MAX = 8.0;   // Maximum test range in real format
    parameter int NUM_TESTS = 20;    // Number of equally spaced test points

    // DUT inputs and outputs
    logic signed [FXP_N-1:0] x;  // Input to the DUT
    logic signed [FXP_N-1:0] y;  // Output from the DUT

    // Instantiate the DUT
    sigmoid_unit #(
        .N(FXP_N),
        .R(FXP_R)
    ) dut (
        .x(x),
        .y(y)
    );

    // Variables for testing
    real x_real;   // Input value in real format
    real y_real;   // Output value in real format
    real step_size;  // Step size for generating test values

    initial begin
        // Calculate step size
        step_size = (TEST_MAX - TEST_MIN) / (NUM_TESTS - 1);

        // Print test header
        $display("%-20s %-20s %-20s %-20s", "Input (Fixed)", "Input (Real)", "Output (Fixed)", "Output (Real)");

        // Iterate over the predefined range with equally spaced test points
        for (int i = 0; i < NUM_TESTS; i++) begin
            // Generate the real input value
            x_real = TEST_MIN + i * step_size;

            // Convert real input to fixed-point
            real_to_fixed_signed(x_real, x);

            #(`CLOCK_PERIOD);  // Small delay to simulate combinational logic

            // Convert fixed-point output to real
            fixed_to_real_signed(y, y_real);

            // Print the results
            $display("%-20d %-20f %-20d %-20f", x, x_real, y, y_real);
        end

        // End simulation
        $finish;
    end

endmodule
