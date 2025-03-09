`timescale 1ns/1ps

module testbench;
    // Declare testbench variables
    logic clock;
    logic reset_n;
    logic enable;
    logic weight_read;
    logic signed [1:0] weight_in;
    logic signed [`IF_BITWIDTH-1:0] data_in;
    logic signed [`IF_BITWIDTH-1:0] psum_in;
    logic signed [`OF_BITWIDTH-1:0] data_out;

    processing_element processing_element0 (
        .clock(clock),
        .reset_n(reset_n),
        .enable(enable),
        .weight_read(weight_read),
        .weight_in(weight_in),
        .data_in(data_in),
        .psum_in(psum_in),
        .data_out(data_out)
    );

    always begin
        #(`CLOCK_PERIOD/2 );
        clock = ~clock;
    end

    task run_n_cycles(int n);
        for (int i = 0; i < n; i = i + 1) begin
            @(negedge clock);
        end
    endtask

    time idle_start_time;
    time idle_end_time;
    time perf_start_time;
    time perf_end_time;

    // Test sequence
    initial begin
        // Dump signals to vcd file
        $dumpfile("processing_element_tb.vcd");
        $dumpvars(0, testbench.processing_element0);

        $monitor("Time:%4.0f clock:%0b reset_n:%0b enable:%0b weight_read:%0b weight_in:%d data_in:%d data_out:%d",
                $time, clock, reset_n, enable, weight_read, weight_in, data_in, data_out);

        // Initialize inputs
        clock = 0;
        reset_n = 0;
        enable = 0;
        weight_read = 0;
        weight_in = 0;
        data_in = 0;
        psum_in = 0;

        run_n_cycles(1);
        reset_n = 1;
        run_n_cycles(1);

        if (TB_MODE == TB_POWER_IDLE) begin
            idle_start_time = $time;
            enable = 1;
            run_n_cycles(10);
            idle_end_time = $time;
            // Display the start and end times of idle
            $display("Idle start time: %0f ns\nIdle end time: %0f ns\n", idle_start_time, idle_end_time);
        end else if (TB_MODE == TB_POWER_PERF) begin
            perf_start_time = $time;
            enable = 1;
            // TODO: Add performance test logic
            run_n_cycles(10);
            perf_end_time = $time;
            // Display the start and end times of performance
            $display("Performance start time: %0f ns\nPerformance end time: %0f ns\n", perf_start_time, perf_end_time);
        end else begin
            // Correctness mode
            // TODO: Add correctness test logic
            enable = 1;
            weight_in = -1;
            data_in = 1;
            psum_in = 1;
            run_n_cycles(1);
            weight_in = 0;
            data_in = 2;
            psum_in = 3;
            run_n_cycles(1);
            weight_in = 1;
            data_in = 3;
            psum_in = 5;
            run_n_cycles(1);
            weight_in = 1;
            data_in = 120;
            psum_in = -10;
            run_n_cycles(1);
            weight_in = -1;
            data_in = 121;
            psum_in = 12;
            run_n_cycles(1);
            weight_in = 1;
            data_in = -122;
            psum_in = -2;
            run_n_cycles(1);
        end
        
        $finish;

    end
endmodule
