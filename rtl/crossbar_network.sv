//===========================================================
// Crossbar Network (RTL inicial)
// Multiplexa múltiples entradas y salidas entre clusters
//===========================================================
`timescale 1ns/1ps
module crossbar_network #(
    parameter N_IN = 8,
    parameter N_OUT = 8,
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [N_IN*DATA_WIDTH-1:0] data_in,
    output reg  [N_OUT*DATA_WIDTH-1:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) data_out <= 0;
        else data_out <= data_in; // simple broadcast
    end
endmodule

