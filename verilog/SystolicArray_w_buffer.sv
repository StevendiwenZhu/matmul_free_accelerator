`include "sys_defs.svh"

module SystolicArray_w_buffer #(
    parameter WIDTH = 16,  // Bit width of the data
    parameter HIDDEN_SIZE    = 2,
    parameter CONTEXT_LENGTH = 4
) (
    input  logic                               clock,
    input  logic                               rst,
    input  logic signed [CONTEXT_LENGTH-1:0][WIDTH-1:0] X_in,    // Input data x_j
    input  logic signed [HIDDEN_SIZE-1:0][1:0] W_in,             // Ternary weights W_fij
    output logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][2*WIDTH-1:0] Y_out
);

    logic signed [CONTEXT_LENGTH-1:0][CONTEXT_LENGTH-1:0][WIDTH-1:0] X_in_buffer;
    logic signed [HIDDEN_SIZE-1:0][HIDDEN_SIZE-1:0][1:0] W_in_buffer;  

    logic signed [CONTEXT_LENGTH-1:0][WIDTH-1:0] X_in_wire;
    logic signed [HIDDEN_SIZE-1:0][1:0] W_in_wire; 

    SystolicArray #(
        .WIDTH(WIDTH),
        .HIDDEN_SIZE(HIDDEN_SIZE),
        .CONTEXT_LENGTH(CONTEXT_LENGTH)
    ) sa (
        .clock(clock),
        .rst(rst),
        .X_in(X_in_wire),
        .W_in(W_in_wire),
        .Y_out(Y_out)
    );

    // Take the bottom-most element from each column
    // Largest-indexed element in each column is fed into the wires.
    always_comb begin
        for (int i = 0; i < CONTEXT_LENGTH; i++) begin
            X_in_wire[i] = X_in_buffer[i][i];
        end
        for (int j = 0; j < HIDDEN_SIZE; j++) begin
            W_in_wire[j] = W_in_buffer[j][j];
        end
    end

    always_ff @(posedge clock) begin
        if (rst) begin
            for (int a = 0; a < CONTEXT_LENGTH; a++) begin
                for (int b = 0; b <= a; b++) begin
                    X_in_buffer[b][a] <= '0;
                end
            end
            for (int a = 0; a < HIDDEN_SIZE; a++) begin
                for (int b = 0; b <= a; b++) begin
                    W_in_buffer[a][b] <= '0;
                end
            end
        end
        else begin
            // Insert new inputs along the diagonal
            for (int a = 0; a < CONTEXT_LENGTH; a++) begin
                X_in_buffer[0][a] <= X_in[a];
            end
            for (int b = 0; b < HIDDEN_SIZE; b++) begin
                W_in_buffer[b][0] <= W_in[b];
            end

            // Reverse the shifting direction:
            // Now data is passed from smaller index b to the next larger index (b+1)
            for (int a = 1; a < CONTEXT_LENGTH; a++) begin
                for (int b = 0; b < a; b++) begin 
                    X_in_buffer[b+1][a] <= X_in_buffer[b][a];
                end
            end

            for (int a = 1; a < HIDDEN_SIZE; a++) begin
                for (int b = 0; b < a; b++) begin 
                    W_in_buffer[a][b+1] <= W_in_buffer[a][b];
                end
            end
        end
    end

endmodule
