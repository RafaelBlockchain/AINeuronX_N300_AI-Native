//===========================================================
// NVLink / PCIe Link (simulación)
//===========================================================
`timescale 1ns/1ps
module nvlink_pcie_link #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg  valid_out
);
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin data_out <= 0; valid_out <= 0; end
        else begin data_out <= data_in; valid_out <= 1; end
    end
endmodule

