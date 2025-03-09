/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : V-2023.12-SP5
// Date      : Fri Dec  6 17:45:51 2024
/////////////////////////////////////////////////////////////


module sram_ifmap_buffer ( clk, reset_n, enable, wr_en, in_data, addr, out );
  input [7:0] in_data;
  input [6:0] addr;
  output [7:0] out;
  input clk, reset_n, enable, wr_en;
  wire   n_1_net_;

  input_buffer_inst input_buffer_inst0 ( .CE(clk), .WEB(wr_en), .OEB(1'b0), 
        .CSB(n_1_net_), .A(addr), .I(in_data), .O(out) );
  INVX0_RVT U2 ( .A(enable), .Y(n_1_net_) );
endmodule

