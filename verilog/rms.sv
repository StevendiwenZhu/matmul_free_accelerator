// Root Mean Square Module - Calculates the RMS (does not perform normalization)
module rms(
    input logic clk,
    input logic rst_n,
    input logic enable,
    input logic start,
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr,
    output logic signed [FXP_N-1:0] rms_out,
    output logic done
);

    // Step 1: Perform element-wise square
    // Step 2: Calculate the mean of the vector
    // Step 3: Take the square root of the mean

    // Intermediate & Pipeline Signals
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_square, vec_square_next;
    logic signed [FXP_N-1:0] vec_mean, vec_mean_next;

    // Vector Square
    vec_mult vec_mult0(
        .in_1(input_arr),
        .in_2(input_arr),
        .mult_out(vec_square_next)
    );
    logic start_pp1, start_pp1_next;
    assign start_pp1_next = start;

    vec_mean vec_mean0(
        .input_arr(vec_square),
        .mean_out(vec_mean_next)
    );
    logic start_pp2, start_pp2_next;
    assign start_pp2_next = start_pp1;

    fxp_sqrt fxp_sqrt0(
        .clk(clk),
        .start(start_pp2),
        .reset_n(rst_n),
        .busy(),
        .valid(done),
        .rad(vec_mean),
        .root(rms_out),
        .rem()
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vec_square <= '{default: 0};
            vec_mean <= '{default: 0};
            start_pp1 <= 0;
            start_pp2 <= 0;
        end else if (enable) begin
            vec_square <= vec_square_next;
            vec_mean <= vec_mean_next;
            start_pp1 <= start_pp1_next;
            start_pp2 <= start_pp2_next;
        end
    end

endmodule