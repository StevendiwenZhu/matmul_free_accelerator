module vec_div (
    input logic clk,    
    input logic rst,    
    input logic start,  
    output logic busy,  
    output logic done,  
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_1,
    input logic signed [ARR_WIDTH-1:0][FXP_N-1:0] in_2,
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] out,
    output logic dbz,   
    output logic ovf    
);

    // Internal signals for division modules
    logic signed [FXP_N-1:0] div_in_1 [ARR_WIDTH-1:0];
    logic signed [FXP_N-1:0] div_in_2 [ARR_WIDTH-1:0];
    logic signed [FXP_N-1:0] div_out [ARR_WIDTH-1:0];
    // Convert unpacked arrays to packed for signals we need to reduce
    logic [ARR_WIDTH-1:0] div_start;
    logic [ARR_WIDTH-1:0] div_done;
    logic [ARR_WIDTH-1:0] div_busy;
    logic [ARR_WIDTH-1:0] div_valid;
    logic [ARR_WIDTH-1:0] div_dbz;
    logic [ARR_WIDTH-1:0] div_ovf;

    // Output registers
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] out_r;
    logic dbz_r;
    logic ovf_r;

    // Instantiate fxp_div for each vector element
    genvar i;
    generate
        for (i = 0; i < ARR_WIDTH; i++) begin : div_units
            fxp_div #(
                .WIDTH(FXP_N),
                .FBITS(FXP_R)
            ) fxp_div_inst (
                .clk(clk),
                .rst(rst),
                .start(div_start[i]),
                .busy(div_busy[i]),
                .done(div_done[i]),
                .valid(div_valid[i]),
                .dbz(div_dbz[i]),
                .ovf(div_ovf[i]),
                .a(div_in_1[i]),
                .b(div_in_2[i]),
                .val(div_out[i])
            );

            // Connect inputs directly
            always_ff @(posedge clk) begin
                if (rst) begin
                    div_in_1[i] <= '0;
                    div_in_2[i] <= '0;
                end else if (start) begin
                    div_in_1[i] <= in_1[i];
                    div_in_2[i] <= in_2[i];
                end
            end
        end
    endgenerate

    // State machine states
    typedef enum logic [1:0] {
        ST_IDLE,
        ST_DIV,
        ST_WAIT_VALID,
        ST_DONE
    } state_t;

    state_t state;
    
    // Synthesis-friendly reduction operations
    logic all_done, all_valid;
    logic any_dbz, any_ovf;
    
    always_comb begin
        // Now working with packed arrays, these operations are synthesizable
        all_done = &div_done;
        all_valid = &div_valid;
        any_dbz = |div_dbz;
        any_ovf = |div_ovf;
    end

    // Main state machine with integrated output capture logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= ST_IDLE;
            busy <= 0;
            done <= 0;
            dbz_r <= 0;
            ovf_r <= 0;
            div_start <= '0;
            out_r <= '0;
        end else begin
            done <= 0; // Default state

            case (state)
                ST_IDLE: begin
                    if (start) begin
                        busy <= 1;
                        dbz_r <= 0;
                        ovf_r <= 0;
                        div_start <= {ARR_WIDTH{1'b1}};  // Set all start signals
                        state <= ST_DIV;
                    end
                end

                ST_DIV: begin
                    div_start <= '0;  // Clear all start signals
                    if (all_done) begin
                        state <= ST_WAIT_VALID;
                    end
                end

                ST_WAIT_VALID: begin
                    if (all_valid) begin
                        // Capture outputs here
                        for (int j = 0; j < ARR_WIDTH; j++) begin
                            out_r[j] <= div_dbz[j] ? '0 : div_out[j];
                        end
                        dbz_r <= any_dbz;
                        ovf_r <= any_ovf;
                        state <= ST_DONE;
                    end
                end

                ST_DONE: begin
                    busy <= 0;
                    done <= 1;
                    state <= ST_IDLE;
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

    // Output assignments
    assign out = out_r;
    assign dbz = dbz_r;
    assign ovf = ovf_r;

endmodule