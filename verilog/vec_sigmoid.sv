`include "sys_defs.svh"

// A combinational vector sigmoid unit.
module vec_sigmoid (
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr, // Note N includes sign bit here!
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sigmoid_out
);

    genvar i;
    generate
        for (i = 0; i < ARR_WIDTH; i++) begin
            sigmoid_unit #(
                .N(FXP_N),
                .R(FXP_R)
            ) sigmoid_unit_inst (
                .x(input_arr[i]),
                .y(sigmoid_out[i])
            );
        end
    endgenerate


endmodule