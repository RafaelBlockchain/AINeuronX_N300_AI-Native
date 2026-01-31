`timescale 1ns/1ps

module tile_dvfs_if (
    input  logic        clk,
    input  logic        rst_n,

    // ===== Control from Power FSM =====
    input  logic [1:0]  dvfs_level,
    input  logic        dvfs_req,

    // ===== Handshake with Clock / Voltage System =====
    input  logic        dvfs_ack,

    // ===== Outputs to Clock / Voltage Domain =====
    output logic [1:0]  dvfs_mode,
    output logic        dvfs_update,
    output logic        dvfs_stable
);

    // ===============================
    // Internal State
    // ===============================
    logic [1:0] active_mode;
    logic       pending;

    // ===============================
    // State Register
    // ===============================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active_mode <= 2'd0;
            pending     <= 1'b0;
        end else begin
            if (dvfs_req && (dvfs_level != active_mode)) begin
                pending <= 1'b1;
            end

            if (pending && dvfs_ack) begin
                active_mode <= dvfs_level;
                pending     <= 1'b0;
            end
        end
    end

    // ===============================
    // Outputs
    // ===============================
    always_comb begin
        dvfs_mode   = active_mode;
        dvfs_update = pending;
        dvfs_stable = ~pending;
    end

endmodule
