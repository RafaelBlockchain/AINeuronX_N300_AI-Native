`timescale 1ns/1ps
import noc_types::*;

module tile_noc_adapter (
    input  logic clk,
    input  logic rst_n,

    // === Core side ===
    input  flit_t core_tx_flit,
    input  logic  core_tx_valid,
    output logic  core_tx_ready,

    output flit_t core_rx_flit,
    output logic  core_rx_valid,
    input  logic  core_rx_ready,

    // === Router LOCAL port ===
    output flit_t noc_in_flit,
    output logic  noc_in_valid,
    input  logic  noc_in_ready,

    input  flit_t noc_out_flit,
    input  logic  noc_out_valid,
    output logic  noc_out_ready
);

    // =============================
    // TX path (Core → NoC)
    // =============================
    assign noc_in_flit  = core_tx_flit;
    assign noc_in_valid = core_tx_valid;
    assign core_tx_ready = noc_in_ready;

    // =============================
    // RX path (NoC → Core)
    // =============================
    assign core_rx_flit  = noc_out_flit;
    assign core_rx_valid = noc_out_valid;
    assign noc_out_ready = core_rx_ready;

endmodule
