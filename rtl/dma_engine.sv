//===========================================================
// DMA Engine (RTL inicial)
// Transferencias L2 ↔ Cluster
//===========================================================
`timescale 1ns/1ps
module dma_engine #(
    parameter DATA_WIDTH = 16,
    parameter BLOCK_SIZE = 64
    
)(
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire [DATA_WIDTH-1:0] mem_data_in,
    output reg  [DATA_WIDTH-1:0] mem_data_out,
    output reg  done
);
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin done <= 0; mem_data_out <= 0; end
        else if(start) begin
            for(i=0;i<BLOCK_SIZE;i=i+1) mem_data_out <= mem_data_in + DATA_WIDTH'(i);
            done <= 1;
        end else done <= 0;
    end
endmodule

