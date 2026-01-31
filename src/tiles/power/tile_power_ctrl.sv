`timescale 1ns/1ps

module tile_power_ctrl #(
    parameter int TILE_ID = 0
)(
    input  logic clk,
    input  logic rst_n,

    // ===== Runtime / Policy Interface =====
    input  logic        req_active,
    input  logic        req_turbo,
    input  logic        req_idle,

    // ===== Thermal / Safety =====
    input  logic        thermal_alert,
    input  logic        thermal_critical,

    // ===== Metrics =====
    input  logic [15:0] util_level,      // 0–1000 (permille)

    // ===== Control Outputs =====
    output logic        clk_enable,
    output logic [1:0]  dvfs_level,
    output logic        power_gate,

    // ===== Status =====
    output logic [2:0]  power_state
);

    // ===============================
    // Power States
    // ===============================
    localparam logic [2:0]
        PWR_OFF      = 3'd0,
        PWR_IDLE     = 3'd1,
        PWR_ACTIVE   = 3'd2,
        PWR_TURBO    = 3'd3,
        PWR_THROTTLE = 3'd4;

    logic [2:0] next_state;

    // ===============================
    // State Register
    // ===============================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            power_state <= PWR_OFF;
        else
            power_state <= next_state;
    end

    // ===============================
    // State Transition Logic
    // ===============================
    always_comb begin
        next_state = power_state;

        case (power_state)

            PWR_OFF: begin
                if (req_active)
                    next_state = PWR_ACTIVE;
            end

            PWR_IDLE: begin
                if (thermal_critical)
                    next_state = PWR_THROTTLE;
                else if (req_active)
                    next_state = PWR_ACTIVE;
            end

            PWR_ACTIVE: begin
                if (thermal_critical)
                    next_state = PWR_THROTTLE;
                else if (req_turbo && util_level > 16'd700)
                    next_state = PWR_TURBO;
                else if (req_idle)
                    next_state = PWR_IDLE;
            end

            PWR_TURBO: begin
                if (thermal_alert)
                    next_state = PWR_ACTIVE;
                else if (thermal_critical)
                    next_state = PWR_THROTTLE;
            end

            PWR_THROTTLE: begin
                if (!thermal_alert && !thermal_critical)
                    next_state = PWR_IDLE;
            end

            default:
                next_state = PWR_OFF;
        endcase
    end

    // ===============================
    // Output Control Logic
    // ===============================
    always_comb begin
        // Defaults
        clk_enable = 1'b0;
        dvfs_level = 2'd0;
        power_gate = 1'b1;

        case (power_state)

            PWR_OFF: begin
                clk_enable = 1'b0;
                power_gate = 1'b1;
                dvfs_level = 2'd0;
            end

            PWR_IDLE: begin
                clk_enable = 1'b1;
                power_gate = 1'b0;
                dvfs_level = 2'd0;
            end

            PWR_ACTIVE: begin
                clk_enable = 1'b1;
                power_gate = 1'b0;
                dvfs_level = 2'd1;
            end

            PWR_TURBO: begin
                clk_enable = 1'b1;
                power_gate = 1'b0;
                dvfs_level = 2'd2;
            end

            PWR_THROTTLE: begin
                clk_enable = 1'b1;
                power_gate = 1'b0;
                dvfs_level = 2'd0;
            end

        endcase
    end

endmodule
