module SystolicArray #(
    parameter WIDTH          = 16,  // Bit width of the data
    parameter HIDDEN_SIZE    = 4,   // hidden_size parameter
    parameter CONTEXT_LENGTH = 4    // context_length parameter
)(
    input  logic                                          clk,
    input  logic                                          rst_n,
    input  logic signed [WIDTH-1:0]                       X_in [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0], // Input matrix X
    input  logic signed [1:0]                             W_in [HIDDEN_SIZE-1:0][HIDDEN_SIZE-1:0],    // Ternary weights W
    output logic signed [2*WIDTH-1:0]                     Y_out [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0]  // Output matrix Y
);

    // Internal signals for connecting PEs
    logic signed [WIDTH-1:0]   a_wire [HIDDEN_SIZE-1:0][CONTEXT_LENGTH][HIDDEN_SIZE];
    logic signed [1:0]         w_wire [HIDDEN_SIZE][HIDDEN_SIZE-1:0];
    logic signed [2*WIDTH-1:0] psum   [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0];

    genvar i, j, k;

    // Initialize weight wires
    generate
        for (i = 0; i < HIDDEN_SIZE; i++) begin : init_wires
            for (j = 0; j < HIDDEN_SIZE; j++) begin : init_w
                assign w_wire[i][j] = W_in[i][j];
            end
        end
    endgenerate

    // Instantiate PEs and connect them
    generate
        for (i = 0; i < HIDDEN_SIZE; i++) begin : pe_row_gen
            for (j = 0; j < CONTEXT_LENGTH; j++) begin : pe_col_gen
                for (k = 0; k < HIDDEN_SIZE; k++) begin : pe_depth_gen
                    if (k == 0) begin
                        // First PE in depth, get input from X_in
                        PE #(.WIDTH(WIDTH)) pe_inst (
                            .clk(clk),
                            .rst_n(rst_n),
                            .a_in(X_in[i][j]),
                            .w_in(w_wire[i][k]),
                            .a_out(a_wire[i][j][k+1]),
                            .w_out(),  // w_out not used beyond first depth

