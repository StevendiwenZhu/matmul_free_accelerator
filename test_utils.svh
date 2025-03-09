`ifndef __TEST_UTILS_SVH__
`define __TEST_UTILS_SVH__

`include "sys_defs.svh"

task automatic fixed_to_real_unsigned;
    input  logic [FXP_N-1:0] fixed_val;  // Unsigned fixed-point input
    output real real_val;                // Output real value

    begin
        // Convert fixed-point to real by dividing by 2^FXP_R
        real_val = real'(fixed_val) / real'(1 << FXP_R);
    end
endtask

task automatic fixed_to_real_signed;
    input  logic signed [FXP_N-1:0] fixed_val; // Signed fixed-point input
    output real real_val;                    // Output real value

    begin
        // Convert fixed-point to real by dividing by 2^FXP_R
        real_val = real'(fixed_val) / real'(1 << FXP_R);
    end
endtask

task automatic real_to_fixed_signed;
    input  real real_value;                  // Input real number
    output logic signed [FXP_N-1:0] fixed_point_value; // Output signed fixed-point value

    real scaling_factor;
    real scaled_value;
    begin
        // Calculate the scaling factor (2^FXP_R)
        scaling_factor = 1.0 * (1 << FXP_R);

        // Scale the real value to fixed-point
        scaled_value = real_value * scaling_factor;

        // Round to nearest integer and cast to signed fixed-point
        fixed_point_value = $rtoi(scaled_value);

        // Clip to fit within the range of signed FXP_N+1 bits
        if (fixed_point_value > (1 << FXP_N) - 1)
            fixed_point_value = (1 << FXP_N) - 1;
        else if (fixed_point_value < -(1 << FXP_N))
            fixed_point_value = -(1 << FXP_N);
    end
endtask


task automatic real_to_fixed_unsigned;
    input  real real_value;              // Input real number
    output logic [FXP_N-1:0] fixed_point_value; // Output unsigned fixed-point value

    real scaling_factor;
    real scaled_value;
    begin
        // Calculate the scaling factor (2^FXP_R)
        scaling_factor = 1.0 * (1 << FXP_R);

        // Scale the real value to fixed-point
        scaled_value = real_value * scaling_factor;

        // Round to nearest integer and cast to unsigned fixed-point
        fixed_point_value = $rtoi(scaled_value);

        // Clip to fit within the range of unsigned FXP_N bits
        if (fixed_point_value > (1 << FXP_N) - 1)
            fixed_point_value = (1 << FXP_N) - 1;
        else if (fixed_point_value < 0)
            fixed_point_value = 0;
    end
endtask

// Task to generate a random test vector of size ARR_WIDTH
task automatic generate_random_vector(
    output real test_in[ARR_WIDTH],
    input real min_val = -10.0,
    input real max_val = 10.0,
    input int seed = 42
);
begin
    int seed_temp = seed;
    
    for (int i = 0; i < ARR_WIDTH; i++) begin
        // Generate random number between 0 and 1
        real rand_val = $dist_uniform(seed_temp, 0, 1000) / 1000.0;
        
        // Scale to desired range
        test_in[i] = min_val + (max_val - min_val) * rand_val;
    end
end
endtask


`endif // __TEST_UTILS_SVH__
