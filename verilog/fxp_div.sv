module fxp_div #(
    parameter WIDTH=FXP_N,    // width of numbers in bits
    parameter FBITS=FXP_R     // fractional bits within WIDTH
    ) (
    input  wire logic clk,    
    input  wire logic rst,    
    input  wire logic start,  
    output logic busy,   
    output logic done,   
    output logic valid,  
    output logic dbz,    
    output logic ovf,    
    input  wire logic signed [WIDTH-1:0] a,   
    input  wire logic signed [WIDTH-1:0] b,   
    output logic signed [WIDTH-1:0] val  
    );

    // Parameters and local variables
    localparam WIDTHU = WIDTH - 1;
    localparam FBITSW = (FBITS == 0) ? 1 : FBITS;
    localparam SMALLEST = {1'b1, {WIDTHU{1'b0}}};
    localparam ITER = WIDTHU + FBITS;

    // State definition
    typedef enum logic [2:0] {
        ST_IDLE  = 3'b000,
        ST_INIT  = 3'b001,
        ST_CALC  = 3'b010,
        ST_ROUND = 3'b011,
        ST_SIGN  = 3'b100
    } state_t;

    // Registers
    state_t state_r, next_state;
    logic [$clog2(ITER):0] count_r;
    logic [WIDTHU-1:0] au_r, bu_r;
    logic [WIDTHU-1:0] quo_r, quo_next;
    logic [WIDTHU:0] acc_r, acc_next;
    logic sig_diff_r;
    logic busy_r;
    logic valid_r;
    logic dbz_r;
    logic ovf_r;
    logic signed [WIDTH-1:0] val_r;

    // Combinational signals
    logic a_sign, b_sign;
    logic start_div;
    logic div_overflow;
    
    // Sign extraction
    assign a_sign = a[WIDTH-1];
    assign b_sign = b[WIDTH-1];
    
    // Division overflow detection
    assign div_overflow = (count_r == WIDTHU-1) && (quo_next[WIDTHU-1:WIDTHU-FBITSW] != 0);
    
    // Start condition
    assign start_div = start && !busy_r && !dbz_r && !ovf_r;

    // Division algorithm
    always_comb begin
        acc_next = acc_r;
        quo_next = quo_r;
        
        if (state_r == ST_CALC) begin
            if (acc_r >= {1'b0, bu_r}) begin
                acc_next = acc_r - bu_r;
                {acc_next, quo_next} = {acc_next[WIDTHU-1:0], quo_r, 1'b1};
            end else begin
                {acc_next, quo_next} = {acc_r, quo_r} << 1;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state_r;
        
        case (state_r)
            ST_IDLE: begin
                if (start_div) begin
                    if (b == '0)
                        next_state = ST_IDLE;
                    else if (a == SMALLEST || b == SMALLEST)
                        next_state = ST_IDLE;
                    else
                        next_state = ST_INIT;
                end
            end
            ST_INIT:  next_state = ST_CALC;
            ST_CALC: begin
                if (div_overflow)
                    next_state = ST_IDLE;
                else if (count_r == ITER-1)
                    next_state = ST_ROUND;
            end
            ST_ROUND: next_state = ST_SIGN;
            ST_SIGN:  next_state = ST_IDLE;
            default:  next_state = ST_IDLE;
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state_r <= ST_IDLE;
            count_r <= '0;
            au_r <= '0;
            bu_r <= '0;
            acc_r <= '0;
            quo_r <= '0;
            sig_diff_r <= '0;
            busy_r <= '0;
            valid_r <= '0;
            dbz_r <= '0;
            ovf_r <= '0;
            val_r <= '0;
        end else begin
            state_r <= next_state;
            
            case (state_r)
                ST_IDLE: begin
                    if (start_div) begin
                        if (b == '0) begin
                            dbz_r <= 1'b1;
                            valid_r <= 1'b0;
                        end else if (a == SMALLEST || b == SMALLEST) begin
                            ovf_r <= 1'b1;
                            valid_r <= 1'b0;
                        end else begin
                            busy_r <= 1'b1;
                            dbz_r <= 1'b0;
                            ovf_r <= 1'b0;
                            valid_r <= 1'b0;
                            au_r <= a_sign ? (-a[WIDTHU-1:0]) : a[WIDTHU-1:0];
                            bu_r <= b_sign ? (-b[WIDTHU-1:0]) : b[WIDTHU-1:0];
                            sig_diff_r <= a_sign ^ b_sign;
                        end
                    end else begin
                        dbz_r <= 1'b0;
                        ovf_r <= 1'b0;
                    end
                end
                
                ST_INIT: begin
                    count_r <= '0;
                    acc_r <= '0;
                    quo_r <= '0;
                    {acc_r, quo_r} <= {{WIDTHU{1'b0}}, au_r, 1'b0};
                end
                
                ST_CALC: begin
                    if (div_overflow) begin
                        busy_r <= 1'b0;
                        ovf_r <= 1'b1;
                    end else begin
                        count_r <= count_r + 1'b1;
                        acc_r <= acc_next;
                        quo_r <= quo_next;
                    end
                end
                
                ST_ROUND: begin
                    if (quo_next[0] && (quo_r[0] || |acc_next[WIDTHU:1])) begin
                        quo_r <= quo_r + 1'b1;
                    end
                end
                
                ST_SIGN: begin
                    busy_r <= 1'b0;
                    valid_r <= 1'b1;
                    if (quo_r != '0) begin
                        val_r <= sig_diff_r ? {1'b1, -quo_r} : {1'b0, quo_r};
                    end else begin
                        val_r <= '0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign busy = busy_r;
    assign done = (state_r != next_state) && (next_state == ST_IDLE);
    assign valid = valid_r;
    assign dbz = dbz_r;
    assign ovf = ovf_r;
    assign val = val_r;

endmodule