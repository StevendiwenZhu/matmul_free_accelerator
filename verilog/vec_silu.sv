// SiLU function
module vec_silu (
    input clk,
    input rst,
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_in,
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_out
);

    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sigmoid_reg, sigmoid_next;

    vec_mult vm(
        .in_1(vec_in),
        .in_2(sigmoid_reg),
        .mult_out(vec_out)
    );

    vec_sigmoid vs(
        .input_arr(vec_in),
        .sigmoid_out(sigmoid_next)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            sigmoid_reg <= 0;
        end else begin
            sigmoid_reg <= sigmoid_next;
        end
    end


endmodule