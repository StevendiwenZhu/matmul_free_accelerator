module vector_unit (
    input logic clk,
    input logic rst_n,
    input logic enable,
    input logic mode, // Mode 0: Calculate Top Equation in top-right box of equations in Figure 2 of reference MatMul-free paper, Mode 1 calculates the equation below mode 0's equation
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sa_row_in, // Row of inputs from the systolic array
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] int_row_in, // Row of inputs from the Intermediate (Matrix) SRAM
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rec_row_in, // Row of inputs from the Recurrence (Matrix) SRAM
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_out
);
    // Further optimizations can be made by clock gating the SiLU, vec_mult_right, and vec_add0 when mode == 1

    // Pipeline Reg Stage 1
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sigmoid_pp1_reg, sigmoid_pp1_reg_next;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rec_row_pp1_reg, rec_row_pp1_reg_next;

    // Pipeline Reg Stage 2
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rec_row_pp2_reg, rec_row_pp2_reg_next;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sigmoid_pp2_reg, sigmoid_pp2_reg_next;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] one_minus_reg, one_minus_reg_next;

    // SiLU module has 2 pipeline stages within the module
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] silu_reg, silu_reg_next;

    // Pipeline Stage 3 Variables
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_mult_left;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_mult_right;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_add_final;

    // Pipeline Stage 1 Modules
    assign rec_row_pp1_reg_next = rec_row_in;

    vec_sigmoid vec_sigmoid0(
        .input_arr(sa_row_in),
        .sigmoid_out(sigmoid_pp1_reg_next)
    );

    vec_silu vec_silu0(
        .clk(clk),
        .rst(!rst_n),
        .vec_in(int_row_in),
        .vec_out(silu_reg_next)
    );

    // Pipeline Stage 2 Modules
    assign rec_row_pp2_reg_next = rec_row_pp1_reg;
    assign sigmoid_pp2_reg_next = sigmoid_pp1_reg;

    logic [ARR_WIDTH-1:0][FXP_N-1:0] one_array; // An array full of 1s

    always_comb begin
        for (int i = 0; i < ARR_WIDTH; i = i + 1) begin
            one_array[i] = 1 << FXP_R;
        end
    end

    vec_sub vec_sub0(
        .in_1(one_array),
        .in_2(sigmoid_pp1_reg),
        .sum_out(one_minus_reg_next)
    );

    // Pipeline Stage 3 Modules
    vec_mult vec_mult_left_inst(
        .in_1(rec_row_pp2_reg),
        .in_2(sigmoid_pp2_reg),
        .mult_out(vec_mult_left)
    );
    
    vec_mult vec_mult_right_inst(
        .in_1(one_minus_reg),
        .in_2(silu_reg),
        .mult_out(vec_mult_right)
    );

    vec_add vec_add0(
        .in_1(vec_mult_left),
        .in_2(vec_mult_right),
        .sum_out(vec_add_final)
    );

    assign vec_out = mode ? vec_mult_left : vec_add_final;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sigmoid_pp1_reg <= '{default:0};
            rec_row_pp1_reg <= '{default:0};
            rec_row_pp2_reg <= '{default:0};
            sigmoid_pp2_reg <= '{default:0};
            one_minus_reg <= '{default:0};
            silu_reg <= '{default:0};
        end else if (enable) begin
            sigmoid_pp1_reg <= sigmoid_pp1_reg_next;
            rec_row_pp1_reg <= rec_row_pp1_reg_next;
            rec_row_pp2_reg <= rec_row_pp2_reg_next;
            sigmoid_pp2_reg <= sigmoid_pp2_reg_next;
            one_minus_reg <= one_minus_reg_next;
            silu_reg <= silu_reg_next;
        end
    end
    
endmodule