// Root Mean Square Normalization Module
module rms_norm(
    input logic clk,
    input logic rst_n,
    input logic enable,
    input logic start,
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr,
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] output_arr,
    output logic done
);
    // Step 1: Calculate the RMS Norm of the vector
    // Step 2: Normalize the vector by the RMS

    // Intermediate & Pipeline Signals
    logic signed [FXP_N-1:0] rms;
    logic rms_done;

    rms rms0(
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .start(start),
        .input_arr(input_arr),
        .rms_out(rms),
        .done(rms_done)
    );

    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rms_arr;

    // Create an array where all elements are the RMS
    always_comb begin
        for (int i = 0; i < ARR_WIDTH; i = i + 1) begin
            rms_arr[i] = rms;
        end
    end

    vec_div vec_div0(
        .clk(clk),
        .rst(!rst_n),
        .start(rms_done),
        .busy(),
        .done(done),
        .in_1(input_arr),
        .in_2(rms_arr),
        .out(output_arr),
        .dbz(),
        .ovf()
    );

endmodule