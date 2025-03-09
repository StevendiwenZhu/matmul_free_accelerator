module fxp_sqrt #(
    parameter WIDTH=FXP_N,  // width of radicand
    parameter FBITS=FXP_R   // fractional bits (for fixed point)
    ) (
    input wire logic clk,
    input wire logic start,             // start signal
    input wire logic reset_n,
    output     logic busy,              // calculation in progress
    output     logic valid,             // root and rem are valid
    input wire logic [WIDTH-1:0] rad,   // radicand
    output     logic [WIDTH-1:0] root,  // root
    output     logic [WIDTH-1:0] rem    // remainder
    );

    logic [WIDTH-1:0] x, x_next;    // radicand copy
    logic [WIDTH-1:0] q, q_next;    // intermediate root (quotient)
    logic [WIDTH+1:0] ac, ac_next;  // accumulator (2 bits wider)
    logic [WIDTH+1:0] test_res;     // sign test result (2 bits wider)

    logic [WIDTH-1:0] root_next, rem_next;
    logic busy_next, valid_next;

    localparam ITER = (WIDTH+FBITS) >> 1;  // iterations are half radicand+fbits width
    logic [$clog2(ITER)-1:0] it, it_next;            // iteration counter

    always_comb begin
        x_next = x;
        q_next = q;
        ac_next = ac;
        root_next = root;
        rem_next = rem;
        busy_next = busy;
        valid_next = valid;

        test_res = ac - {q, 2'b01};
        if (test_res[WIDTH+1] == 0) begin  // test_res ≥0? (check MSB)
            {ac_next, x_next} = {test_res[WIDTH-1:0], x, 2'b0};
            q_next = {q[WIDTH-2:0], 1'b1};
        end else begin
            {ac_next, x_next} = {ac[WIDTH-1:0], x, 2'b0};
            q_next = q << 1;
        end

        if (start) begin
            busy_next = 1;
            valid_next = 0;
            it_next = 0;
            q_next = 0;
            {ac_next, x_next} = {{WIDTH{1'b0}}, rad, 2'b0};

        end else if (busy) begin
            if (it == $unsigned(ITER-1)) begin
                busy_next = 0;
                valid_next = 1;
                root_next = q_next;
                rem_next = ac_next[WIDTH+1:2];
            end else begin
                it_next = it + 1;
            end

        end
    end

    always_ff @(posedge clk) begin
        if (!reset_n) begin
            busy <= 0;
            valid <= 0;
            root <= 0;
            rem <= 0;
            x <= 0;
            q <= 0;
            ac <= 0;
            it <= 0;
        end else begin
            busy <= busy_next;
            valid <= valid_next;
            root <= root_next;
            rem <= rem_next;
            x <= x_next;
            q <= q_next;
            ac <= ac_next;
            it <= it_next;
        end
    end
endmodule
