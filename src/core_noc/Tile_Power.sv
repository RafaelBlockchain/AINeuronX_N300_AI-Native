`timescale 1ns/1ps

// File: src/core_noc/Tile_Power.sv
module Tile_Power (
    input  logic clk_in,
    input  logic rst_n,
    input  logic tile_active,   // activa o apaga tile
    output logic clk_out
);

    // Clock gating simple
    assign clk_out = clk_in & tile_active;

endmodule
