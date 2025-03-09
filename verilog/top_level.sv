module top_level (
    input logic clk,
    input logic rst_n,
    input logic enable,
    input logic [6:0] mem_in_addr, 
    input logic [ARR_WIDTH-1:0][7:0] mem_in_data,
    input logic mem_in_valid,
    output logic output_valid,
    output logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_out
);

    // ------------- CONTROLLER FSM ---------------
    top_state_t current_state, next_state;


    // Counter for tracking memory operations and computations
    logic [6:0] addr_ctr;
    logic [6:0] comp_ctr;
    logic [5:0] rmsnorm_cycle_ctr;  // Counts up to 41 cycles per row

    // Control signals
    logic load_enable, rmsnorm_enable, sa_enable, vec_enable;
    logic [1:0] sram_sel;  // Select which SRAM to write to
    logic vec_unit_mode;   // 0 or 1 depending on the vector unit operation

    // State transition logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            addr_ctr <= '0;
            comp_ctr <= '0;
            rmsnorm_cycle_ctr <= '0;
        end else begin
            current_state <= next_state;
            
            // Counter logic
            if (load_enable || sa_enable || vec_enable) begin
                addr_ctr <= (addr_ctr == 7'd127) ? '0 : addr_ctr + 1;
            end
            
            if (rmsnorm_enable) begin
                rmsnorm_cycle_ctr <= (rmsnorm_cycle_ctr == 6'd40) ? '0 : rmsnorm_cycle_ctr + 1;
                if (rmsnorm_cycle_ctr == 6'd40) begin
                    addr_ctr <= (addr_ctr == 7'd127) ? '0 : addr_ctr + 1;
                end
            end
        end
    end


    // Next-state and output logic
    always_comb begin
        // Default values
        next_state = current_state;
        load_enable = 0;
        rmsnorm_enable = 0;
        sa_enable = 0;
        vec_enable = 0;
        sram_sel = 2'b00;
        vec_unit_mode = 0;
        output_valid = 0;
        
        case (current_state)
            IDLE: begin
                if (enable) begin
                    next_state = LOAD_XT;
                end
            end
            
            LOAD_XT: begin
                load_enable = 1;
                if (addr_ctr == 7'd127 && mem_in_valid) begin
                    next_state = RMSNORM_XT_1;
                end
            end
            
            RMSNORM_XT_1: begin
                rmsnorm_enable = 1;
                // Load weight matrices while RMSNorm is computing
                if (addr_ctr < 7'd64) begin
                    sram_sel = 2'b01;  // Load to first weight SRAM
                end else begin
                    sram_sel = 2'b10;  // Load to second weight SRAM
                end
                
                if (addr_ctr == 7'd127 && rmsnorm_cycle_ctr == 6'd40) begin
                    next_state = MATMUL_CT;
                end
            end
            
            MATMUL_CT: begin
                sa_enable = 1;
                if (addr_ctr == 7'd127) begin
                    next_state = MATMUL_FT;
                end
            end
            
            MATMUL_FT: begin
                sa_enable = 1;
                if (addr_ctr == 7'd127) begin
                    next_state = VEC_UNIT_1;
                end
            end
            
            VEC_UNIT_1: begin
                vec_enable = 1;
                vec_unit_mode = 0;
                if (addr_ctr == 7'd127) begin
                    next_state = MATMUL_GT;
                end
            end
            
            MATMUL_GT: begin
                sa_enable = 1;
                if (addr_ctr == 7'd127) begin
                    next_state = VEC_UNIT_2;
                end
            end
            
            VEC_UNIT_2: begin
                vec_enable = 1;
                vec_unit_mode = 1;
                if (addr_ctr == 7'd127) begin
                    next_state = RMSNORM_XT_2;
                end
            end
            
            RMSNORM_XT_2: begin
                rmsnorm_enable = 1;
                // Load next weight matrix while RMSNorm is computing
                if (addr_ctr < 7'd64) begin
                    sram_sel = 2'b10;  // Load to second weight SRAM
                end
                
                if (addr_ctr == 7'd127 && rmsnorm_cycle_ctr == 6'd40) begin
                    next_state = MATMUL_OT;
                end
            end
            
            MATMUL_OT: begin
                sa_enable = 1;
                if (addr_ctr == 7'd127) begin
                    next_state = READ_OUT;
                end
            end
            
            READ_OUT: begin
                output_valid = 1;
                if (addr_ctr == 7'd127) begin
                    next_state = IDLE;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

    // ------------- END CONTROLLER FSM ---------------

    // ------ SRAMs -----------


    logic act_sram_wr_en;
    logic [ARR_WIDTH-1:0][7:0] act_sram_in_data;
    logic [ARR_WIDTH-1:0][7:0] act_sram_out_data;
    sram_matrix_buffer_wide activation_sram(
        .clk(clk),
        .reset_n(rst_n),
        .enable(enable),
        .wr_en(act_sram_wr_en),
        .in_data(act_sram_in_data),
        .addr(addr_ctr),
        .out(act_sram_out_data)
    );

    logic int_sram_wr_en;
    logic [ARR_WIDTH-1:0][7:0] int_sram_in_data;
    logic [ARR_WIDTH-1:0][7:0] int_sram_out_data;
    sram_matrix_buffer_wide intermediate_sram(
        .clk(clk),
        .reset_n(rst_n),
        .enable(enable),
        .wr_en(int_sram_wr_en),
        .in_data(int_sram_in_data),
        .addr(addr_ctr),
        .out(int_sram_out_data)
    );

    logic rec_sram_wr_en;
    logic [ARR_WIDTH-1:0][7:0] rec_sram_in_data;
    logic [ARR_WIDTH-1:0][7:0] rec_sram_out_data;
    sram_matrix_buffer_wide recurrence_sram(
        .clk(clk),
        .reset_n(rst_n),
        .enable(enable),
        .wr_en(rec_sram_wr_en),
        .in_data(rec_sram_in_data),
        .addr(addr_ctr),
        .out(rec_sram_out_data)
    );

    logic weight_sram_cg_wr_en;
    logic [ARR_WIDTH-1:0][7:0] weight_sram_cg_in_data;
    logic [ARR_WIDTH-1:0][7:0] weight_sram_cg_out_data;
    sram_weight_buffer_wide weight_sram_wc_wg(
        .clk(clk),
        .reset_n(rst_n),
        .enable(enable),
        .wr_en(weight_sram_cg_wr_en),
        .in_data(weight_sram_cg_in_data),
        .addr(addr_ctr),
        .out(weight_sram_cg_out_data)
    );

    logic weight_sram_fo_wr_en;
    logic [ARR_WIDTH-1:0][7:0] weight_sram_fo_in_data;
    logic [ARR_WIDTH-1:0][7:0] weight_sram_fo_out_data;
    sram_weight_buffer_wide weight_sram_wf_wo(
        .clk(clk),
        .reset_n(rst_n),
        .enable(enable),
        .wr_en(weight_sram_fo_wr_en),
        .in_data(weight_sram_fo_in_data),
        .addr(addr_ctr),
        .out(weight_sram_fo_out_data)
    );


    // ------ END SRAMs --------


    // ------ RMSNorm Unit -----

    // RMSNorm control and status signals
    logic rmsnorm_start;
    logic rmsnorm_done;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rmsnorm_input;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rmsnorm_scaling;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] rmsnorm_output;
    
    rms_norm_sf rms_norm_unit(
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .start(rmsnorm_start),
        .input_arr(rmsnorm_input),
        .scaling_arr(rmsnorm_scaling),
        .output_arr(rmsnorm_output),
        .done(rmsnorm_done)
    );

    assign rmsnorm_scaling = '{default: 1 << 6}; // RMSNorm scaling is a hyperparameter. use 1 for simplicity

    // RMSNorm control logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rmsnorm_start <= 0;
        end else begin
            case (current_state)
                RMSNORM_XT_1, RMSNORM_XT_2: begin
                    // Start RMSNorm when we have new data to process
                    if (rmsnorm_cycle_ctr == 0) begin
                        rmsnorm_start <= 1;
                    end else begin
                        rmsnorm_start <= 0;
                    end
                end
                default: rmsnorm_start <= 0;
            endcase
        end
    end

    // ------ Systolic Array -----
    logic signed [CONTEXT_LENGTH-1:0][15:0] sys_arr_X_in;
    logic signed [ARR_WIDTH-1:0][1:0] sys_arr_W_in;
    logic signed [ARR_WIDTH-1:0][CONTEXT_LENGTH-1:0][2*8-1:0] sys_arr_Y_out;
    SystolicArray_w_buffer #(8, ARR_WIDTH, CONTEXT_LENGTH) systolic_array_inst (
        .clock(clk),
        .rst(!rst_n),
        .X_in(sys_arr_X_in),
        .W_in(sys_arr_W_in),
        .Y_out(sys_arr_Y_out)
    );


    // ------ Vector Unit ------
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] sa_row_2_vec;
    logic signed [ARR_WIDTH-1:0][FXP_N-1:0] vec_unit_out;
    vector_unit vec_unit (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .mode(vec_unit_mode),
        .sa_row_in(sa_row_2_vec),
        .int_row_in(int_sram_out_data),
        .rec_row_in(rec_sram_out_data),
        .vec_out(vec_unit_out)
    );

    // ---- Routing Logic
        // Systolic array input connection logic
    always_comb begin
        // Default assignments
        sys_arr_X_in = '0;
        sys_arr_W_in = '0;
        
        if (sa_enable) begin
            case (current_state)
                MATMUL_CT, MATMUL_FT, MATMUL_GT, MATMUL_OT: begin
                    // Input activation data from activation SRAM
                    sys_arr_X_in = act_sram_out_data;
                    
                    // Select weight matrix based on current operation
                    case (current_state)
                        MATMUL_CT, MATMUL_GT: sys_arr_W_in = weight_sram_cg_out_data;
                        MATMUL_FT, MATMUL_OT: sys_arr_W_in = weight_sram_fo_out_data;
                        default: sys_arr_W_in = '0;
                    endcase
                end
                default: begin
                    sys_arr_X_in = '0;
                    sys_arr_W_in = '0;
                end
            endcase
        end
    end

    // RMSNorm input connection
    always_comb begin
        rmsnorm_input = '0;
        if (rmsnorm_enable) begin
            case (current_state)
                RMSNORM_XT_1: rmsnorm_input = act_sram_out_data;
                RMSNORM_XT_2: rmsnorm_input = vec_unit_out;
                default: rmsnorm_input = '0;
            endcase
        end
    end

    // Systolic array to vector unit connection
    always_comb begin
        sa_row_2_vec = '0;
        if (vec_enable) begin
            case (current_state)
                VEC_UNIT_1, VEC_UNIT_2: sa_row_2_vec = systolic_array_inst.Y_out[addr_ctr];
                default: sa_row_2_vec = '0;
            endcase
        end
    end

    // Connect vector output for final read
    assign vec_out = (current_state == READ_OUT) ? systolic_array_inst.Y_out[addr_ctr] : '0;

    // -------- SRAM Logic
    // SRAM write enable logic
    assign act_sram_wr_en = (current_state == LOAD_XT) || 
                           (current_state == RMSNORM_XT_1 && rmsnorm_cycle_ctr == 6'd40) ||
                           (current_state == RMSNORM_XT_2 && rmsnorm_cycle_ctr == 6'd40);
    
    assign int_sram_wr_en = (current_state == MATMUL_CT && sa_enable);
    assign rec_sram_wr_en = (current_state == VEC_UNIT_1 && vec_enable);
    assign weight_sram_cg_wr_en = (current_state inside {RMSNORM_XT_1, RMSNORM_XT_2} && sram_sel == 2'b01);
    assign weight_sram_fo_wr_en = (current_state inside {RMSNORM_XT_1, RMSNORM_XT_2} && sram_sel == 2'b10);

    // Data routing logic
    always_comb begin
        // Default connections
        act_sram_in_data = '0;
        int_sram_in_data = '0;
        rec_sram_in_data = '0;
        weight_sram_cg_in_data = '0;
        weight_sram_fo_in_data = '0;
        
        case (current_state)
            LOAD_XT: begin
                act_sram_in_data = mem_in_data;
            end
            
            RMSNORM_XT_1, RMSNORM_XT_2: begin
                if (rmsnorm_cycle_ctr == 6'd40) begin
                    act_sram_in_data = rms_norm_unit.output_arr;
                end
                if (sram_sel == 2'b01) begin
                    weight_sram_cg_in_data = mem_in_data;
                end else if (sram_sel == 2'b10) begin
                    weight_sram_fo_in_data = mem_in_data;
                end
            end
            
            MATMUL_CT: begin
                int_sram_in_data = systolic_array_inst.Y_out[addr_ctr];
            end
            
            VEC_UNIT_1: begin
                rec_sram_in_data = vec_unit_out;
            end
        endcase
    end

endmodule

