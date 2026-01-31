//===========================================================
// Power Model (RTL inicial)
// Estimación básica de consumo de clusters y cores
//===========================================================
`timescale 1ns/1ps
module power_model #(
    parameter N_CLUSTERS = 8
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [N_CLUSTERS-1:0] active_clusters,
    output reg  [31:0] power_watt
);
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) power_watt <= 0;
        else begin
            power_watt <= 0;
            for(i=0;i<N_CLUSTERS;i=i+1) power_watt <= power_watt + active_clusters[i]*10; // placeholder
        end
    end
endmodule

