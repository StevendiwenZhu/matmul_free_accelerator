module PE #(
    parameter WIDTH = 16  // Bit width
)(
    input  logic                      clock,
    input  logic                      rst,
    input  logic signed [WIDTH-1:0]   x_in,   // Input data x_j
    input  logic signed [1:0]         w_in,   // Ternary weight W_fij (-1, 0, +1)
    output logic signed [WIDTH-1:0]   x_out,
    output logic signed [1:0]         w_out,
    output logic signed [2*WIDTH-1:0] psum  // Partial sum output
);

    logic signed [WIDTH-1:0]   x_reg;
    logic signed [1:0]         w_reg;   // Stores ternary weight
    logic signed [2*WIDTH-1:0] psum_reg; // Double bitwidth to hold the psum
    logic signed [WIDTH-1:0]   mul_result;

    // Ternary multiplication operation
    always_comb begin
        case (w_in)
            2'd1:   mul_result = x_in;          // W_fij = +1
            2'd0:   mul_result = '0;            // W_fij = 0
            2'd3:   mul_result = -x_in;         // W_fij = -1 (represented as 2'd3 in 2's complement)
            default: mul_result = '0;
        endcase
    end

    always_ff @(posedge clock) begin
        if (rst) begin
            x_reg    <= '0;
            w_reg    <= '0;
            psum_reg <= '0;
        end else begin
            x_reg    <= x_in;
            w_reg    <= w_in;
            psum_reg <= psum_reg + mul_result;
        end
    end

    assign x_out = x_reg;
    assign w_out = w_reg;
    assign psum  = psum_reg;

endmodule


module SystolicArray #(
    parameter WIDTH = 16,  // Bit width of the data
    parameter HIDDEN_SIZE    = 4,
    parameter CONTEXT_LENGTH = 4
)(
    input  logic                               clock,
    input  logic                               rst,
    input  logic signed [CONTEXT_LENGTH-1:0][WIDTH-1:0] X_in,    // Input data x_j
    input  logic signed [HIDDEN_SIZE-1:0][1:0] W_in,             // Ternary weights W_fij
    output logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][2*WIDTH-1:0] Y_out
);

    // Internal signals for connecting PEs
    logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][WIDTH-1:0]   x_wire;
    logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][1:0]         w_wire;
    logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][2*WIDTH-1:0] psum;

    logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][WIDTH-1:0]   x_wire_buffer;
    logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][1:0]         w_wire_buffer;

    always_comb begin
        for (int a = 0; a < HIDDEN_SIZE; a++) begin
            for (int b = 0; b < CONTEXT_LENGTH; b++) begin
                x_wire_buffer[a][b] = (a == 0) ? X_in[b] : x_wire[a-1][b];
                w_wire_buffer[a][b] = (b == 0) ? W_in[a] : w_wire[a][b-1];
            end
        end
    end

    genvar i, j;

    // Instantiate PEs and connect them
    generate
        for (i = 0; i < HIDDEN_SIZE; i++) begin // row_gen
            for (j = 0; j < CONTEXT_LENGTH; j++) begin // col_gen
                PE #(.WIDTH(WIDTH)) pe_inst (
                    .clock(clock),
                    .rst(rst),
                    .x_in(x_wire_buffer[i][j]),
                    .w_in(w_wire_buffer[i][j]),
                    .x_out(x_wire[i][j]),
                    .w_out(w_wire[i][j]),
                    .psum(psum[i][j])
                );
            end
        end
    endgenerate

    // Collect the output partial sums from each PE
    for (i = 0; i < HIDDEN_SIZE; i++) begin
        for (j = 0; j < CONTEXT_LENGTH; j++) begin
            assign Y_out[i][j] = psum[i][j];
        end
    end

endmodule
