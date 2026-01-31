`timescale 1ns/1ps

module tile_compute #(
    parameter DATA_WIDTH = 16
)(
    input  logic clk,
    input  logic rst_n,

    // ===== Enqueue Tensor Instruction =====
    input  logic        enq_valid,
    input  logic [3:0]  enq_opcode,
    input  logic [7:0]  enq_m,
    input  logic [7:0]  enq_n,
    input  logic [7:0]  enq_k,
    output logic        enq_ready
);

    // ================= Scheduler ↔ Tensor =================
    logic        tc_valid;
    logic [3:0]  tc_opcode;
    logic [7:0]  tc_m, tc_n, tc_k;
    logic        tc_ready;
    logic        tc_done;

    // ================= Tensor ↔ Scratchpad =================
    logic        sp_req;
    logic        sp_we;
    logic [15:0] sp_addr;
    logic [DATA_WIDTH-1:0] sp_wdata;
    logic        sp_ready;
    logic [DATA_WIDTH-1:0] sp_rdata;

    // ================= Scheduler =================
    tensor_scheduler scheduler (
        .clk(clk),
        .rst_n(rst_n),

        .enq_valid(enq_valid),
        .enq_opcode(enq_opcode),
        .enq_m(enq_m),
        .enq_n(enq_n),
        .enq_k(enq_k),
        .enq_ready(enq_ready),

        .tc_valid(tc_valid),
        .tc_opcode(tc_opcode),
        .tc_m(tc_m),
        .tc_n(tc_n),
        .tc_k(tc_k),
        .tc_ready(tc_ready),

        .tc_done(tc_done)
    );

    // ================= Tensor Core Wrapper =================
    tensor_core_wrapper tensor (
        .clk(clk),
        .rst_n(rst_n),

        .tc_valid(tc_valid),
        .tc_opcode(tc_opcode),
        .tc_m(tc_m),
        .tc_n(tc_n),
        .tc_k(tc_k),
        .tc_ready(tc_ready),

        .mem_req(sp_req),
        .mem_addr(sp_addr),
        .mem_rdata(sp_rdata),
        .mem_ready(sp_ready),

        .result_valid(tc_done),
        .result_data()
    );

    // ================= Scratchpad =================
    tile_scratchpad scratchpad (
        .clk(clk),
        .rst_n(rst_n),

        // Port 0: Tensor
        .p0_req(sp_req),
        .p0_we(1'b0),
        .p0_addr(sp_addr),
        .p0_wdata('0),
        .p0_ready(sp_ready),
        .p0_rdata(sp_rdata),

        // Port 1: DMA (no conectado aún)
        .p1_req(1'b0),
        .p1_we(1'b0),
        .p1_addr('0),
        .p1_wdata('0),
        .p1_ready(),
        .p1_rdata(),

        // Port 2: Scalar (no conectado aún)
        .p2_req(1'b0),
        .p2_we(1'b0),
        .p2_addr('0),
        .p2_wdata('0),
        .p2_ready(),
        .p2_rdata()
    );

endmodule
