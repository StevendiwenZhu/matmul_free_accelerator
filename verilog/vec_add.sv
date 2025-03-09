`include "sys_defs.svh"

// A combinational vector addition unit that performs element-wise addition.
module vec_add (
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_1,
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_2,
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sum_out
);

    // For each input in the module
    always_comb begin
        for (int i = 0; i < ARR_WIDTH; i++) begin
            sum_out[i] = in_1[i] + in_2[i];
        end
        // TODO: Add saturation if out of bounds.
        // (Only add this if our software assumes that we deal with this... SW HW needs to be on the same page whether this is done in HW or not)
    end

endmodule