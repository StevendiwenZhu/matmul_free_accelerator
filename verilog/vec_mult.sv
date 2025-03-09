`include "sys_defs.svh"

module vec_mult (
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_1,
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_2,
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] mult_out
);

    logic signed [ARR_WIDTH-1:0][2*FXP_N-1:0] product; // Wider result for intermediate multiplication

    always_comb begin
        for (int i = 0; i < ARR_WIDTH; i++) begin
            // Multiply fixed-point numbers (inputs extended to signed width)
            product[i] = $signed(in_1[i]) * $signed(in_2[i]); // Result is Q(2N, 2R)

            // Scale back to fixed-point format with signed arithmetic shift
            mult_out[i] = product[i] >>> FXP_R;
        end
    end

endmodule
