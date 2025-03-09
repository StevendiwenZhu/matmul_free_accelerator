`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    // Parameters
    parameter WIDTH = FXP_N;    // Total width of the number
    parameter FBITS = FXP_R;    // Fractional bits

    // Testbench signals
    logic clk;
    logic start;
    logic reset_n;
    logic busy;
    logic valid;
    logic [WIDTH-1:0] rad;    // radicand
    logic [WIDTH-1:0] root;   // square root result
    logic [WIDTH-1:0] rem;    // remainder
    real real_rad;           // real value of radicand
    real real_root;          // real value of result
    int cycle_count;

    // Instantiate the module under test
    fxp_sqrt #(
        .WIDTH(WIDTH),
        .FBITS(FBITS)
    ) fxp_sqrt0 (
        .clk(clk),
        .start(start),
        .reset_n(reset_n),
        .busy(busy),
        .valid(valid),
        .rad(rad),
        .root(root),
        .rem(rem)
    );

    // Generate clock signal
    always begin
        #(`CLOCK_PERIOD) clk = ~clk; // 10 ns clock period
    end

    // Task to print the testbench status
    task print_status();
    begin
        fixed_to_real_signed(rad, real_rad);
        fixed_to_real_signed(root, real_root);
        $display("Time: %0t ns", $time);
        $display("radicand: %0f, sqrt: %0f, valid: %0b, cycles: %0d",
            real_rad, real_root, valid, cycle_count);
        $display("remainder: %h", rem);
        $display("--------------------------------------");
    end
    endtask

    // Task to run a single test case
    task run_test(input real real_number);
        logic [WIDTH-1:0] fixed_number;
    begin
        real_to_fixed_signed(real_number, fixed_number);
        rad = fixed_number;
        start = 1;
        cycle_count = 0; // Reset cycle count
        @(negedge clk);
        start = 0;

        // Wait for the calculation to finish and count cycles
        while (!valid) begin
            @(posedge clk);
            cycle_count++;
        end
        @(negedge clk);
        print_status();
    end
    endtask

    // Test sequence
    initial begin
        // Dump signals to a VCD file
        $dumpfile("fxp_sqrt_tb.vcd");
        $dumpvars(0, testbench.fxp_sqrt0);

        // Initialize inputs
        clk = 0;
        start = 0;
        rad = 0;
        reset_n = 0;

        // Wait a few clock cycles before starting
        repeat(2) @(negedge clk);

        reset_n = 1;

        // Run test cases
        run_test(16.0);     // Perfect square
        run_test(2.0);      // Irrational result
        run_test(0.0);      // Zero case
        run_test(4.0);      // Another perfect square
        run_test(10.0);     // Non-perfect square
        run_test(0.25);     // Fractional number
        run_test(100.0);    // Larger number
        run_test(0.0625);   // Small fractional number

        $finish;
    end

    // // Optional: Add checking for invalid negative inputs
    // always @(rad) begin
    //     if (rad[WIDTH-1] == 1'b1) begin // Check if input is negative
    //         $display("Warning: Negative input %h detected at time %0t", rad, $time);
    //     end
    // end

endmodule



// ORIGINAL TESTBENCH:
// module sqrt_tb();

//     parameter CLK_PERIOD = 10;
//     parameter WIDTH = 16;
//     parameter FBITS = 8;
//     parameter SF = 2.0**-8.0;  // Q8.8 scaling factor is 2^-8

//     logic clk;
//     logic start;             // start signal
//     logic busy;              // calculation in progress
//     logic valid;             // root and rem are valid
//     logic [WIDTH-1:0] rad;   // radicand
//     logic [WIDTH-1:0] root;  // root
//     logic [WIDTH-1:0] rem;   // remainder

//     fxp_sqrt #(.WIDTH(WIDTH), .FBITS(FBITS)) sqrt_inst (.*);

//     always #(CLK_PERIOD / 2) clk = ~clk;

//     initial begin
//         $monitor("\t%d:\tsqrt(%f) = %b (%f) (rem = %b) (V=%b)",
//                     $time, $itor(rad*SF), root, $itor(root*SF), rem, valid);
//     end

//     initial begin
//                 clk = 1;

//         #100    rad = 16'b1110_1000_1001_0000;  // 232.56250000
//                 start = 1;
//         #10     start = 0;

//         #120    rad = 16'b0000_0000_0100_0000;  // 0.25
//                 start = 1;
//         #10     start = 0;

//         #120    rad = 16'b0000_0010_0000_0000;  // 2.0
//                 start = 1;
//         #10     start = 0;
//         #120    $finish;
//     end
// endmodule