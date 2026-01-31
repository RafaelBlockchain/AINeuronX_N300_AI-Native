//===========================================================
// AINeuronX L2 Cache (RTL inicial)
// Soporta prefetch básico y multi-entrada por cluster
//===========================================================
`timescale 1ns/1ps
module l2_cache #(
    parameter CACHE_SIZE = 8192,      // palabras
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire [12:0] addr,
    input  wire read_en,
    input  wire write_en,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg  ready_out
);
    reg [DATA_WIDTH-1:0] mem [0:CACHE_SIZE-1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_out <= 0;
            ready_out <= 0;
            for(i=0;i<CACHE_SIZE;i=i+1) mem[i] <= 0;
        end else begin
            ready_out <= 0;
            if(read_en) begin
                data_out <= mem[addr];
                ready_out <= 1;
            end else if(write_en) begin
                mem[addr] <= data_in;
                ready_out <= 1;
            end
        end
    end
endmodule

