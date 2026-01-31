// ============================================================================
// AINeuronX_N200_TILE
// Tile computacional replicable
// ============================================================================

module AINeuronX_N200_TILE #(
    parameter int LANES = 16,
    parameter int DW    = 16,
    parameter int RF_DEPTH = 64
)(
    input  logic clk,
    input  logic rst,

    // -------- NoC / Tile input --------
    input  logic             tile_valid,
    output logic             tile_ready,
    input  logic [DW-1:0]    tile_a [LANES],
    input  logic [DW-1:0]    tile_b [LANES],

    // -------- NoC / Tile output -------
    output logic             tile_out_valid,
    input  logic             tile_out_ready,
    output logic [DW*2-1:0]  tile_result [LANES]
);

    // =================================================
    // Local Register File
    // =================================================
    logic [DW-1:0] rf_a [RF_DEPTH][LANES];
    logic [DW-1:0] rf_b [RF_DEPTH][LANES];

    logic [$clog2(RF_DEPTH)-1:0] rd_ptr, wr_ptr;

    // Simple pointer logic (placeholder scheduler)
    always_ff @(posedge clk) begin
        if (rst) begin
            rd_ptr <= '0;
            wr_ptr <= '0;
        end else if (tile_valid & tile_ready) begin
            rf_a[wr_ptr] <= tile_a;
            rf_b[wr_ptr] <= tile_b;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // =================================================
    // CORE instantiation
    // =================================================
    logic core_in_valid, core_in_ready;
    logic core_out_valid, core_out_ready;

    logic [DW-1:0] core_a [LANES];
    logic [DW-1:0] core_b [LANES];
    logic [DW*2-1:0] core_result [LANES];

    assign core_a = rf_a[rd_ptr];
    assign core_b = rf_b[rd_ptr];

    assign core_in_valid = tile_valid;
    assign tile_ready    = core_in_ready;

    always_ff @(posedge clk) begin
        if (rst) begin
            rd_ptr <= '0;
        end else if (core_in_valid & core_in_ready) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    AINeuronX_N200_CORE core (
        .clk        (clk),
        .rst        (rst),
        .in_valid   (core_in_valid),
        .in_ready   (core_in_ready),
        .opcode     ('0), // placeholder
        .vec_a      (core_a),
        .vec_b      (core_b),
        .out_valid  (core_out_valid),
        .out_ready  (core_out_ready),
        .result     (core_result)
    );

    // =================================================
    // Writeback
    // =================================================
    assign core_out_ready  = tile_out_ready;
    assign tile_out_valid  = core_out_valid;
    assign tile_result     = core_result;

endmodule
