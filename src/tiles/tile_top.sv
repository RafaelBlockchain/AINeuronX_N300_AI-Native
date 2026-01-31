`timescale 1ns/1ps

module tile_top #(
    parameter DATA_WIDTH = 16
)(
    input  logic clk,
    input  logic rst_n,

    // ===== NoC Interface =====
    input  logic        noc_valid,
    input  logic        noc_we,
    input  logic [15:0] noc_addr,
    input  logic [DATA_WIDTH-1:0] noc_wdata,
    output logic        noc_ready,
    output logic [DATA_WIDTH-1:0] noc_rdata,

    // ===== Tensor Enqueue (desde control) =====
    input  logic        enq_valid,
    input  logic [3:0]  enq_opcode,
    input  logic [7:0]  enq_m,
    input  logic [7:0]  enq_n,
    input  logic [7:0]  enq_k,
    output logic        enq_ready
);

    // ================= Scratchpad wires =================
    logic        sp_req_dma, sp_we_dma;
    logic [15:0] sp_addr_dma;
    logic [DATA_WIDTH-1:0] sp_wdata_dma;
    logic        sp_ready_dma;
    logic [DATA_WIDTH-1:0] sp_rdata_dma;

    logic        sp_req_tc;
    logic [15:0] sp_addr_tc;
    logic        sp_ready_tc;
    logic [DATA_WIDTH-1:0] sp_rdata_tc;

    // ================= Tile Compute =================
    tile_compute compute (
        .clk(clk),
        .rst_n(rst_n),

        .enq_valid(enq_valid),
        .enq_opcode(enq_opcode),
        .enq_m(enq_m),
        .enq_n(enq_n),
        .enq_k(enq_k),
        .enq_ready(enq_ready)
    );

    // ================= DMA =================
    tile_dma dma (
        .clk(clk),
        .rst_n(rst_n),

        .noc_valid(noc_valid),
        .noc_we(noc_we),
        .noc_addr(noc_addr),
        .noc_wdata(noc_wdata),
        .noc_ready(noc_ready),
        .noc_rdata(noc_rdata),

        .sp_req(sp_req_dma),
        .sp_we(sp_we_dma),
        .sp_addr(sp_addr_dma),
        .sp_wdata(sp_wdata_dma),
        .sp_ready(sp_ready_dma),
        .sp_rdata(sp_rdata_dma)
    );

    // ================= Scratchpad =================
    tile_scratchpad scratchpad (
        .clk(clk),
        .rst_n(rst_n),

        // Port 0: Tensor
        .p0_req(sp_req_tc),
        .p0_we(1'b0),
        .p0_addr(sp_addr_tc),
        .p0_wdata('0),
        .p0_ready(sp_ready_tc),
        .p0_rdata(sp_rdata_tc),

        // Port 1: DMA
        .p1_req(sp_req_dma),
        .p1_we(sp_we_dma),
        .p1_addr(sp_addr_dma),
        .p1_wdata(sp_wdata_dma),
        .p1_ready(sp_ready_dma),
        .p1_rdata(sp_rdata_dma),

        // Port 2: Scalar (libre)
        .p2_req(1'b0),
        .p2_we(1'b0),
        .p2_addr('0),
        .p2_wdata('0),
        .p2_ready(),
        .p2_rdata()
    );

endmodule
