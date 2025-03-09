module vec_mean (
    input  logic signed [ARR_WIDTH-1:0][FXP_N-1:0] input_arr,
    output logic signed [FXP_N-1:0] mean_out
);

    // Calculate number of stages needed
    localparam STAGES = $clog2(ARR_WIDTH);
    
    // Declare arrays for intermediate results
    logic signed [FXP_N+STAGES-1:0] stage_results [STAGES:0][ARR_WIDTH-1:0];
    // logic signed [FXP_N-1:0] stage_results [STAGES:0][ARR_WIDTH-1:0];
    
    // First stage - sign extend the inputs
    always_comb begin
        for (int i = 0; i < ARR_WIDTH; i++) begin
            stage_results[0][i] = {{STAGES{input_arr[i][FXP_N-1]}}, input_arr[i]};
            // stage_results[0][i] = input_arr[i];
        end
    end
    
    // Generate the averaging tree
    genvar stage, pair;
    generate
        for (stage = 0; stage < STAGES; stage++) begin : stage_gen
            localparam PAIRS = ARR_WIDTH >> (stage + 1);
            
            for (pair = 0; pair < PAIRS; pair++) begin : pair_gen
                always_comb begin
                    // Add pair and divide by 2
                    logic signed [FXP_N+STAGES-1:0] sum;
                    sum = stage_results[stage][pair*2] + stage_results[stage][pair*2 + 1];
                    // Round towards zero
                    stage_results[stage + 1][pair] = sum >>> 1;
                end
            end
        end
    endgenerate
    
    // Final output assignment
    assign mean_out = stage_results[STAGES][0][FXP_N-1:0];

    // Verify ARR_WIDTH is a power of 2
    initial begin
        assert ((ARR_WIDTH & (ARR_WIDTH - 1)) == 0) 
        else $error("ARR_WIDTH must be a power of 2");
        
        assert (FXP_N > FXP_R) 
        else $error("FXP_N must be greater than FXP_R");
    end

endmodule