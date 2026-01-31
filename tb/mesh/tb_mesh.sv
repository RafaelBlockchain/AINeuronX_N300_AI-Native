`timescale 1ns/1ps

module tb_mesh;

    localparam FLIT_W = 64;

    reg clk;
    reg rst_n;

    // -------------------------
    // Clock
    // -------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz
    end

    // -------------------------
    // Reset
    // -------------------------
    initial begin
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // -------------------------
    // DUT: Mesh NoC
    // -------------------------
    mesh_noc #(
        .N_X(8),
        .N_Y(8),
        .FLIT_W(FLIT_W)
    ) dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // -------------------------
    // Core conectado al tile 0
    // Puerto LOCAL = índice 0
    // -------------------------
    wire [FLIT_W-1:0] core_tx_flit;
    wire              core_tx_valid;
    wire              core_tx_ready;

    wire [FLIT_W-1:0] core_rx_flit;
    wire              core_rx_valid;
    wire              core_rx_ready;

    Tile_Core_Compute #(
        .FLIT_W(FLIT_W),
        .TX_COUNT(16)
    ) core0 (
        .clk(clk),
        .rst_n(rst_n),

        .noc_tx_flit(core_tx_flit),
        .noc_tx_valid(core_tx_valid),
        .noc_tx_ready(core_tx_ready),

        .noc_rx_flit(core_rx_flit),
        .noc_rx_valid(core_rx_valid),
        .noc_rx_ready(core_rx_ready)
    );

    // -------------------------
    // Conexión Core <-> NoC
    // Tile 0, puerto LOCAL (0)
    // -------------------------
    assign dut.in_flit [0][0]  = core_tx_flit;
    assign dut.in_valid[0][0]  = core_tx_valid;
    assign core_tx_ready       = dut.in_ready[0][0];

    assign core_rx_flit        = dut.out_flit [0][0];
    assign core_rx_valid       = dut.out_valid[0][0];
    assign dut.out_ready[0][0] = core_rx_ready;

    // -------------------------
    // Timeout de seguridad
    // -------------------------
    initial begin
        #5000;
        $display("❌ TIMEOUT: NoC test did not finish");
        $finish;
    end

endmodule
