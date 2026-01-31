`timescale 1ns/1ps

module tile_thermal (
    input  logic        clk,
    input  logic        rst_n,

    // ===== Thermal Inputs =====
    input  logic [1:0]  thermal_level,   // from sensor or estimator
    input  logic        sensor_valid,

    // ===== Outputs to Power Control =====
    output logic        thermal_alert,
    output logic        thermal_critical,

    // ===== Status =====
    output logic [1:0]  thermal_state
);

    // ===============================
    // State Register
    // ===============================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            thermal_state <= 2'd0;
        else if (sensor_valid)
            thermal_state <= thermal_level;
    end

    // ===============================
    // Decode Outputs
    // ===============================
    always_comb begin
        thermal_alert    = 1'b0;
        thermal_critical = 1'b0;

        case (thermal_state)
            2'd0: begin
                thermal_alert    = 1'b0;
                thermal_critical = 1'b0;
            end

            2'd1: begin
                thermal_alert    = 1'b1;
                thermal_critical = 1'b0;
            end

            2'd2: begin
                thermal_alert    = 1'b1;
                thermal_critical = 1'b0;
            end

            2'd3: begin
                thermal_alert    = 1'b1;
                thermal_critical = 1'b1;
            end

            default: begin
                thermal_alert    = 1'b0;
                thermal_critical = 1'b0;
            end
        endcase
    end

endmodule
