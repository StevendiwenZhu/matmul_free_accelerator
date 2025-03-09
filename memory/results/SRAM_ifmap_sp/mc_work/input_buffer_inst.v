/*********************************************************************
*  saed_mc : input_buffer_inst Verilog description                 *
*  ---------------------------------------------------------------   *
*  Filename      : /home/rlhou/eecs598-002/project/matmul-free-accelerator/memory/mc_work/input_buffer_inst.v                         *
*  SRAM name     : input_buffer_inst                                 *
*  Word width    : 8     bits                                        *
*  Word number   : 128                                               *
*  Adress width  : 7     bits                                        *
*  ---------------------------------------------------------------   *
*  Creation date : Thu December 05 2024                              *
*********************************************************************/

`timescale 1ns/100fs

`define numAddr 7
`define numWords 128
`define wordLength 8


module input_buffer_inst (A,CE,WEB,OEB,CSB,I,O);

input 				CE;
input 				WEB;
input 				OEB;
input 				CSB;

input 	[6:0] 		A;
input 	[7:0] 	I;
output 	[7:0] 	O;

reg    	[7:0]   	memory[127:0];
reg  	[7:0]	data_out1;
reg 	[7:0] 	O;

wire 				RE;
wire 				WE;


and u1 (RE, ~CSB,  WEB);
and u2 (WE, ~CSB, ~WEB);


always @ (posedge CE) 
	if (RE)
		data_out1 = memory[A];
	else 
	   if (WE)
		memory[A] = I;
		

always @ (data_out1 or OEB)
	if (!OEB) 
		O = data_out1;
	else
		O =  8'bz;

endmodule