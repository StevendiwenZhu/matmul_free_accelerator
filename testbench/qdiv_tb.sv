`include "test_utils.svh"
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:48:08 12/29/2013
// Design Name:   qdiv
// Module Name:   G:/Tran3005/TestDiv.v
// Project Name:  Trancendental
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: qdiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestDiv;

	// Inputs
	reg [FXP_N-1:0] i_dividend;
	reg [FXP_N-1:0] i_divisor;
	reg i_start;
	reg i_clk;
    reg i_reset_n;
    reg i_enable;

	// Outputs
	wire [FXP_N-1:0] o_quotient_out;
	wire o_complete;
	wire o_overflow;

	int cycle_count;
	real real_dividend, real_divisor, real_quotient;

	// Instantiate the Unit Under Test (UUT)
	qdiv #(
		.Q(FXP_R),
		.N(FXP_N)
	) uut (
		.i_dividend(i_dividend), 
		.i_divisor(i_divisor), 
		.i_start(i_start), 
		.i_clk(i_clk), 
        .i_reset_n(i_reset_n),
        .i_enable(i_enable),
		.o_quotient_out(o_quotient_out), 
		.o_complete(o_complete), 
		.o_overflow(o_overflow)
	);

    always begin
        # (`CLOCK_PERIOD / 2) i_clk = ~i_clk;
    end

    task run_n_cycles(int n);
        for (int i = 0; i < n; i = i + 1) begin
            @(negedge i_clk);
        end
    endtask

    // Task to print the testbench status
    task print_status();
        begin
            fixed_to_real_signed(i_dividend, real_dividend);
            fixed_to_real_signed(i_divisor, real_divisor);
            fixed_to_real_signed(o_quotient_out, real_quotient);
            
            $display("Time: %0t ns", $time);
            $display("a: %0f, b: %0f, out: %0f, comp: %0b, ovfl: %0b, cycles: %0d", 
                     real_dividend, real_divisor, real_quotient, o_complete, o_overflow, cycle_count);
            $display("--------------------------------------");
        end
    endtask

	task reset_all();
		i_start = 0;
		i_reset_n = 0;
		@(negedge i_clk);
		i_reset_n = 1;
	endtask

    // Task to run a single test case
    task run_test(input real real_num, input real real_denom);
        reg [FXP_N-1:0] fixed_num, fixed_denom;
        begin
            real_to_fixed_signed(real_num, fixed_num);
            real_to_fixed_signed(real_denom, fixed_denom);

            i_dividend = fixed_num;
            i_divisor = fixed_denom;
            i_start = 0;
			i_reset_n = 0;
			i_enable = 0;
            cycle_count = 0;
            @(negedge i_clk);
            i_start = 1;
			i_enable = 1;
			i_reset_n = 1;

			run_n_cycles(1); // run at least one cycle since complete needs some time

            // Wait for the calculation to finish and count cycles
            while (!o_complete) begin
                @(posedge i_clk);
                cycle_count++;
            end

            print_status();
        end
    endtask

	initial begin
        // $monitor("Time:%4.0f clock:%0b i_dividend:%b i_divisor:%b i_start:%b o_complete:%b o_quotient_out:%b o_overflow:%b",
                // $time, i_clk, i_dividend, i_divisor, i_start, o_complete, o_quotient_out, o_overflow);
		// Initialize Inputs
		i_dividend = 23456;
		i_divisor = -1000;
		i_start = 0;
		i_clk = 0;
        i_reset_n = 0;
        i_enable = 0;

		run_n_cycles(1);

        i_start = 1;
        i_enable = 1;
        i_reset_n = 1;

        run_n_cycles(50);
		print_status();

        // Run test cases
        run_test(20.0, 5.0);        // Normal case
        run_test(-20.0, 5.0);       // Negative numerator
        run_test(20.0, -5.0);       // Negative denominator
        run_test(-20.0, -5.0);      // Both numerator and denominator negative
        run_test(0.0, 5.0);         // Zero numerator
        run_test(1.0, 1.0);         // Basic case
        run_test(-1.0, 1.0);        // Negative numerator
        run_test(10.0, 3.0);        // Fractional result
        run_test(-10.0, -3.0);      // Negative fractional result

        $finish;
	end
        
		// always @(posedge i_clk) begin
		// 	if (count == 47) begin
		// 		count <= 0;
		// 		i_start <= 1'b1;
		// 		end
		// 	else begin				
		// 		count <= count + 1;
		// 		i_start <= 1'b0;
		// 		end
		// 	end

		// always @(count) begin
		// 	if (count == 47) begin
		// 		if ( i_divisor > 32'h1FFFFFFF ) begin
		// 			i_divisor <= 1;
		// 			i_dividend = (i_dividend << 1) + 3;
		// 			end
		// 		else
		// 			i_divisor = (i_divisor << 1) + 1;
		// 		end
		// 	end
			
	// always @(posedge o_complete)
		// $display ("%b,%b,%b, %b", i_dividend, i_divisor, o_quotient_out, o_overflow);		//	Monitor the stuff we care about

endmodule
