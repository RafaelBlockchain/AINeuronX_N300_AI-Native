`timescale 1ns/1ps
module Tile_Metrics(
    input  logic clk,
    input  logic rst_n,
    input  logic [4:0] mac_fire, noc_send, stall,
    output logic [31:0] mac_ops,
    output logic [31:0] noc_packets,
    output logic [31:0] stall_cycles
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mac_ops      <= 0;
            noc_packets  <= 0;
            stall_cycles <= 0;
        end else begin
            mac_ops      <= mac_ops + mac_fire;
            noc_packets  <= noc_packets + noc_send;
            stall_cycles <= stall_cycles + stall;
        end
    end

endmodule
