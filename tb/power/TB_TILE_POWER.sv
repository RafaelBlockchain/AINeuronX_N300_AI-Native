`timescale 1ns/1ps

module TB_TILE_POWER;

    // ============================================================
    // Clock / Reset
    // ============================================================
    logic clk;
    logic rst_n;

    initial clk = 0;
    always #5 clk = ~clk;

    // ============================================================
    // DUT Signals
    // ============================================================
    logic        req_active;
    logic        req_turbo;
    logic        req_idle;

    logic [1:0]  thermal_level;
    logic        thermal_valid;

    logic        dvfs_ack;

    logic        noc_in_valid;
    logic        noc_out_valid;

    // ============================================================
    // Instantiate DUT
    // ============================================================
    Tile_Top #(
        .TILE_ID(0)
    ) dut (
        .clk            (clk),
        .rst_n          (rst_n),
        .req_active     (req_active),
        .req_turbo      (req_turbo),
        .req_idle       (req_idle),
        .thermal_level  (thermal_level),
        .thermal_valid  (thermal_valid),
        .dvfs_ack       (dvfs_ack),
        .noc_in_valid   (noc_in_valid),
        .noc_out_valid  (noc_out_valid)
    );

    // ============================================================
    // DVFS ACK Model (simple)
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            dvfs_ack <= 1'b0;
        else
            dvfs_ack <= dut.dvfs_req; // immediate ACK model
    end

    // ============================================================
    // Test Sequence
    // ============================================================
    initial begin
        // Defaults
        rst_n          = 0;
        req_active     = 0;
        req_turbo      = 0;
        req_idle       = 0;
        thermal_level  = 2'd0;
        thermal_valid  = 0;
        noc_in_valid   = 0;

        // Reset
        #20;
        rst_n = 1;
        $display("[TB] Reset released");

        // ------------------------------------------------------------
        // OFF → ACTIVE
        // ------------------------------------------------------------
        #20;
        req_active = 1;
        $display("[TB] Request ACTIVE");

        #40;
        req_active = 0;

        // ------------------------------------------------------------
        // ACTIVE → TURBO
        // ------------------------------------------------------------
        #50;
        req_turbo = 1;
        $display("[TB] Request TURBO");

        #40;
        req_turbo = 0;

        // ------------------------------------------------------------
        // TURBO → THROTTLE (thermal critical)
        // ------------------------------------------------------------
        #40;
        thermal_level = 2'd3;
        thermal_valid = 1;
        $display("[TB] Thermal CRITICAL");

        #20;
        thermal_valid = 0;

        // ------------------------------------------------------------
        // THROTTLE → IDLE (thermal recovery)
        // ------------------------------------------------------------
        #100;
        thermal_level = 2'd0;
        thermal_valid = 1;
        $display("[TB] Thermal NORMAL");

        #20;
        thermal_valid = 0;

        // ------------------------------------------------------------
        // IDLE → OFF
        // ------------------------------------------------------------
        #40;
        req_idle = 1;
        $display("[TB] Request IDLE");

        #40;
        req_idle = 0;

        // ------------------------------------------------------------
        // End Simulation
        // ------------------------------------------------------------
        #100;
        $display("[TB] Test completed");
        $finish;
    end

    // ============================================================
    // Monitors
    // ============================================================
    always_ff @(posedge clk) begin
        if (rst_n) begin
            $display(
                "[MON] t=%0t | PWR_STATE=%0d | CLK_EN=%b | DVFS=%0d | THERM=%0d",
                $time,
                dut.power_state,
                dut.tile_clk_enable,
                dut.dvfs_level,
                dut.thermal_state
            );
        end
    end

endmodule
