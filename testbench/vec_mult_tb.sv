`include "sys_defs.svh"
`include "test_utils.svh"
`timescale 1ns/1ps

module testbench;
    logic clock;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_1;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_2;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] mult_out;

    vec_mult #(.ARR_WIDTH(ARR_WIDTH), .FXP_N(FXP_N), .FXP_R(FXP_R)) vec_mult0 (
        .in_1(in_1),
        .in_2(in_2),
        .mult_out(mult_out)
    );

    // Clock generation
    always begin
        #5 clock = ~clock;
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
                fixed_to_real_signed(mult_out[i], real_val);
                $write("%0f ", real_val);
            end
            $display();
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

            @(negedge clock);
            print_vectors();
        end
    endtask

    // Declare variables
    logic signed [FXP_N-1:0] fixed_val_signed;
    logic [FXP_N-1:0] fixed_val_unsigned;
    real real_val;

    // Test sequence
    initial begin
        // Dump signals to VCD file
        $dumpfile("vec_mult_tb.vcd");
        $dumpvars(0, testbench.vec_mult0);

        // Initialize variables
        clock = 0;
        in_1 = '{default: 0};
        in_2 = '{default: 0};

        // Test real inputs
        run_real_test_case('{1.5, -2.25, 3.75, -4.5}, '{2.5, -3.5, 4.5, -5.5});
        run_real_test_case('{0.25, 0.5, 0.75, 1.0}, '{0.0625, 0.1875, 0.25, 0.375});

        // // Signed Fixed to Real Conversion
        // fixed_val_signed = 16'sb0000000111000000; // Example fixed-point value with 4 fractional bits
        // fixed_to_real_signed(fixed_val_signed, real_val);
        // $display("Fixed Input (Signed): %d, Converted Real: %0f", fixed_val_signed, real_val);

        // fixed_val_signed = -16'sb0000000111000000; // Negative fixed-point value
        // fixed_to_real_signed(fixed_val_signed, real_val);
        // $display("Fixed Input (Signed): %d, Converted Real: %0f", fixed_val_signed, real_val);

        // // Unsigned Fixed to Real Conversion
        // fixed_val_unsigned = 16'b0000000111000000; // Unsigned fixed-point value
        // fixed_to_real_unsigned(fixed_val_unsigned, real_val);
        // $display("Fixed Input (Unsigned): %d, Converted Real: %0f", fixed_val_unsigned, real_val);

        // // Real to Signed Fixed Conversion
        // real_val = 7.5; // Example real value
        // real_to_fixed_signed(real_val, fixed_val_signed);
        // $display("Real Input: %0f, Converted Fixed (Signed): %d", real_val, fixed_val_signed);

        // real_val = -7.5; // Negative real value
        // real_to_fixed_signed(real_val, fixed_val_signed);
        // $display("Real Input: %0f, Converted Fixed (Signed): %d", real_val, fixed_val_signed);

        // // Real to Unsigned Fixed Conversion
        // real_val = 7.5; // Positive real value
        // real_to_fixed_unsigned(real_val, fixed_val_unsigned);
        // $display("Real Input: %0f, Converted Fixed (Unsigned): %d", real_val, fixed_val_unsigned);

        // real_val = 0.0; // Zero real value
        // real_to_fixed_unsigned(real_val, fixed_val_unsigned);
        // $display("Real Input: %0f, Converted Fixed (Unsigned): %d", real_val, fixed_val_unsigned);


        $finish;
    end
endmodule
