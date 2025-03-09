/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has parameters and typedefs               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`ifndef __SYS_DEFS_SVH__
`define __SYS_DEFS_SVH__

// NOTE: moved this into sys_defs.svh, don't add to any other files
// have all files `include "sys_defs.svh" from now on (why weren't we doing this before?)
// `timescale 1ns/100ps
`timescale 1ns/1ps


// Synthesis testing definition for parameterized modules tested at multiple sizes
// see lab 6 CAM for example usage
`ifdef SYNTH_TEST
`define INSTANCE(mod) mod``_svsim
`else
`define INSTANCE(mod) mod
`endif

parameter CONTEXT_LENGTH = 16;
parameter ARR_WIDTH = 8; // Width of systolic array (also defines the vector unit width)
parameter FXP_N = 16; // Fixed point total bitwidth (excluding sign bit)
parameter FXP_R = 6; // Fixed point number of fractional bits

// CLOCK_PERIOD also defined in synth.tcl. MAKE SURE THIS IS THE SAME WHEN RUNNING
`define CLOCK_PERIOD 10

`define IF_BITWIDTH 8
`define OF_BITWIDTH 8

//////////////////////////////////////////////
//
// Memory/testbench attribute definitions
//
//////////////////////////////////////////////

// typedef enum {STATE1, STATE2, STATE3} STATE;

// --- Testbench Settings ---
// define an enum for different testbench modes
typedef enum {
    TB_POWER_IDLE,
    TB_POWER_PERF,
    TB_CORRECTNESS
} TB_MODES;

// parameter TB_MODES TB_MODE = TB_POWER_IDLE;
// parameter TB_MODES TB_MODE = TB_POWER_PERF;
parameter TB_MODES TB_MODE = TB_CORRECTNESS;

// Top level module FSM
typedef enum logic [3:0] {
    IDLE             = 4'b0000,
    LOAD_XT          = 4'b0001,
    RMSNORM_XT_1     = 4'b0010, // Also fetch Wc, Wf matrices during this state
    MATMUL_CT        = 4'b0011,
    MATMUL_FT        = 4'b0100,
    VEC_UNIT_1       = 4'b0101, // Also fetch Wg during this state
    MATMUL_GT        = 4'b0110,
    VEC_UNIT_2       = 4'b0111, // Also fetch Wo during this state
    RMSNORM_XT_2     = 4'b1000,
    MATMUL_OT        = 4'b1001,
    READ_OUT         = 4'b1010
} top_state_t;


`endif // __SYS_DEFS_SVH__
