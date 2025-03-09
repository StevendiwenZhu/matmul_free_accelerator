`timescale 1ns / 1ps
module SystolicArray_tb;
    reg clock, rst;
    parameter WIDTH = 16;
    parameter HIDDEN_SIZE = 64;
    parameter CONTEXT_LENGTH = 128;

    // Packed arrays for weights, inputs, and outputs
    reg signed [HIDDEN_SIZE-1:0][1:0] W_mat;
    reg signed [CONTEXT_LENGTH-1:0][WIDTH-1:0] X_mat;
    logic signed [HIDDEN_SIZE-1:0][CONTEXT_LENGTH-1:0][2*WIDTH-1:0] out_mat;

    integer W_mat_file, X_mat_file;
    reg [255:0] line;

    always #10 clock = ~clock;

    task run_n_cycles(int n);
        begin
            repeat (n) begin
                @(posedge clock);
            end
        end
    endtask

    task input_X_W(int m);
        begin
            repeat (m) begin
                @(posedge clock);
                for (int i = 0; i < CONTEXT_LENGTH; i++) begin
                    X_mat[i] = $random;
                end
                for (int j = 0; j < HIDDEN_SIZE; j++) begin
                    W_mat[j] = $random;
                end
            end
        end
    endtask

    initial begin
        clock = 0;
        rst = 1;
        W_mat = '0;
        X_mat = '0;
        #1000;
        rst = 0;
        
        input_X_W(HIDDEN_SIZE);

        run_n_cycles(140);

        $finish;
    end

    SystolicArray_w_buffer #(
        .HIDDEN_SIZE(HIDDEN_SIZE),
        .CONTEXT_LENGTH(CONTEXT_LENGTH)
    ) SystolicArray0 (
        .clock(clock),
        .rst(rst),
        .W_in(W_mat),
        .X_in(X_mat),
        .Y_out(out_mat)
    );

    // Display output matrix
    always @(posedge clock) begin
        if (!rst) begin
            $display("Time: %0t | out_mat:", $time);
            for (int i = 0; i < HIDDEN_SIZE; i = i + 1) begin
                for (int j = 0; j < CONTEXT_LENGTH; j = j + 1) begin
                    $write(" %d", $signed(out_mat[i][j])); // Ensure signed interpretation
                    if (j < CONTEXT_LENGTH - 1) $write(",");
                end
                $write("\n");
            end
            $write("\n\n");
        end
    end


    // Write output matrix to file
    integer file;
    initial begin
        file = $fopen("out_mat.txt", "w");
        if (file) begin
            // Write header
            $fwrite(file, "Time (ns)");
            for (int i = 0; i < HIDDEN_SIZE; i = i + 1) begin
                for (int j = 0; j < CONTEXT_LENGTH; j = j + 1) begin
                    $fwrite(file, ", out_mat[%0d][%0d]", i, j);
                end
            end
            $fwrite(file, "\n");
        end else begin
            $display("Error: Unable to open output file 'out_mat.txt'.");
            $stop;
        end
    end

    always @(posedge clock) begin
        if (!rst) begin
            $fwrite(file, "%0t", $time);
            for (int i = 0; i < HIDDEN_SIZE; i = i + 1) begin
                for (int j = 0; j < CONTEXT_LENGTH; j = j + 1) begin
                    $fwrite(file, ", %d", $signed(out_mat[i][j])); // Ensure signed interpretation
                end
            end
            $fwrite(file, "\n");
        end
    end

    final begin
        $fclose(file);
    end
endmodule