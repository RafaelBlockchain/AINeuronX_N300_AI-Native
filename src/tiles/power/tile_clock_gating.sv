`timescale 1ns/1ps

module tile_clock_gating (
    input  logic clk_in,
    input  logic rst_n,

    // ===== Global Enable (from power ctrl) =====
    input  logic tile_clk_enable,

    // ===== Domain Enables =====
    input  logic en_core,
    input  logic en_router,
    input  logic en_mem,
    input  logic en_metrics,

    // ===== Gated Clocks =====
    output logic clk_core,
    output logic clk_router,
    output logic clk_mem,
    output logic clk_metrics
);

    // =================================================
    // Latch-based clock gating (ICG-style)
    // =================================================
    logic lat_core;
    logic lat_router;
    logic lat_mem;
    logic lat_metrics;

    // Latches (transparent when clk_in is low)
    always_latch begin
        if (!rst_n) begin
            lat_core    <= 1'b0;
            lat_router  <= 1'b0;
            lat_mem     <= 1'b0;
            lat_metrics <= 1'b0;
        end else if (!clk_in) begin
            lat_core    <= tile_clk_enable & en_core;
            lat_router  <= tile_clk_enable & en_router;
            lat_mem     <= tile_clk_enable & en_mem;
            lat_metrics <= tile_clk_enable & en_metrics;
        end
    end

    // AND gate with master clock
    assign clk_core    = clk_in & lat_core;
    assign clk_router  = clk_in & lat_router;
    assign clk_mem     = clk_in & lat_mem;
    assign clk_metrics = clk_in & lat_metrics;

endmodule
