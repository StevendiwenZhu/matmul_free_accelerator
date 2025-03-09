// A fake PE module for testing purposes. DO NOT USE.
module processing_element (
    input  logic                      clock,          // Clock signal
    input  logic                      reset_n,        // Asynchronous active-low reset
    input  logic                      enable,       // Enable signal for clock gating
    input logic weight_read, // Read enable signal for weight buffer
    input logic signed [1:0] weight_in,
    input logic signed [`IF_BITWIDTH-1:0] data_in,
    input logic signed [`IF_BITWIDTH-1:0] psum_in, // bitwidth of psum_in may have to be adjusted
    output logic signed [`OF_BITWIDTH-1:0] data_out
);

    // For now, direct connection to data_out for makefile test purposes
    assign data_out = psum_in + weight_in * data_in;

endmodule