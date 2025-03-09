module SystolicArray_tb;
    parameter WIDTH = 16;
    parameter N     = 4;

    logic                               clk;
    logic                               rst_n;
    logic signed [WIDTH-1:0]            X_in [N-1:0][2*N-1:0];
    logic signed [1:0]                  W_in [N-1:0][N-1:0];
    logic signed [2*WIDTH-1:0]          Y_out [N-1:0][N-1:0];

    for (int i = 0; i < 2*N; i++) begin
        SystolicArray #(
            .WIDTH(WIDTH),
            .HIDDEN_SIZE(N),
            .CONTEXT_LENGTH(N)
        ) systolic_array_inst (
            .clk(clk),
            .reset(reset),
            .X_in(X_in),
            .W_in(W_in),
            .Y_out(Y_out)
        );
    end
    
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst_n = 0;
/* X_in =
5, -2, 7, 9
3, 10, -4, 5,
0, 1, 4, -7,
3, 5, -9, 2 
*/
        X_in  = '{
            '{16'sd5, 16'sd0, 16'sd0, 16'sd0},
            '{16'sd3, -16'sd2, 16'sd0, 16'sd0},
            '{16'sd0, 16'sd10, 16'sd7, 16'sd0},
            '{16'sd3, 16'sd1, -16'sd4, 16'sd9},
            '{16'sd0, 16'sd5, 16'sd4, 16'sd5},
            '{16'sd0, 16'sd0, -16'sd9, -16'sd7},
            '{16'sd0, 16'sd0, 16'sd0, 16'sd2}
        }; // Example input data x_j

        // Initialize ternary weights W_fij
        // For example, let's define weights as:
        // W_in = [[+1,  0, -1, +1],
        //         [ 0, +1, -1,  0],
        //         [-1, -1, +1, +1],
        //         [+1,  0,  0, -1]];
        W_in = '{
            '{2'd1, 2'd0, 2'd3, 2'd1},
            '{2'd0, 2'd1, 2'd3, 2'd0},
            '{2'd3, 2'd3, 2'd1, 2'd1},
            '{2'd1, 2'd0, 2'd0, 2'd3}
        };

        // Reset the system
        #10;
        rst_n = 1;

        // Apply inputs and observe outputs
        // Add your test cases here

        #100;
        $finish;
    end

endmodule
