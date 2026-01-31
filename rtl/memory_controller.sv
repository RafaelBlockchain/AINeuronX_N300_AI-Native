//===========================================================
// AINeuronX Memory Controller (RTL inicial)
// Gestiona requests a L2 y DRAM externa
//===========================================================
`timescale 1ns/1ps
module memory_controller #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire read_req,
    input  wire write_req,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg  ready
);

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_out <= 0;
            ready <= 0;
        end else begin
            ready <= 1; // simplificado
            if(read_req) data_out <= addr[DATA_WIDTH-1:0] + 1; // placeholder
        end
    end
endmodule

