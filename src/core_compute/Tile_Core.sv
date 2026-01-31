`timescale 1ns/1ps

module Tile_Core #(
    parameter FLIT_W       = 64,
    parameter CORE_ID      = 0,
    parameter TRAFFIC_MODE = 1   // 0=UNIFORM, 1=HOTSPOT, 2=BURST
)(
    input  logic clk,
    input  logic rst_n,

    // =============================
    // NoC TX
    // =============================
    output logic [FLIT_W-1:0] noc_tx_flit,
    output logic              noc_tx_valid,
    input  logic              noc_tx_ready,

    // =============================
    // NoC RX
    // =============================
    input  logic [FLIT_W-1:0] noc_rx_flit,
    input  logic              noc_rx_valid,
    output logic              noc_rx_ready,

    input  logic core_active
);

    // =============================
    // Internal state
    // =============================
    logic [31:0] counter;
    logic [7:0]  dst_x, dst_y;

    // =============================
    // Destination selection
    // =============================
    always_comb begin
        case (TRAFFIC_MODE)
            0: begin // UNIFORM (self-based)
                dst_x = CORE_ID[3:0];
                dst_y = CORE_ID[7:4];
            end
            1: begin // HOTSPOT (0,0)
                dst_x = 8'd0;
                dst_y = 8'd0;
            end
            2: begin // BURST (diagonal pressure)
                dst_x = CORE_ID[3:0];
                dst_y = CORE_ID[3:0];
            end
            default: begin
                dst_x = 8'd0;
                dst_y = 8'd0;
            end
        endcase
    end

    // =============================
    // TX traffic generator
    // =============================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter      <= 0;
            noc_tx_valid <= 0;
            noc_tx_flit  <= '0;
        end else if (core_active) begin
            counter <= counter + 1;

            // Default: drop valid once accepted
            if (noc_tx_valid && noc_tx_ready)
                noc_tx_valid <= 0;

            case (TRAFFIC_MODE)
                0, 1: begin
                    // UNIFORM / HOTSPOT
                    if (counter[4:0] == 0) begin // cada 32 ciclos
                        noc_tx_valid <= 1;
                        noc_tx_flit  <= {
                            dst_x,
                            dst_y,
                            CORE_ID[15:0],
                            counter
                        };
                    end
                end

                2: begin
                    // BURST: 8 flits seguidos cada 16 ciclos
                    if (counter[3:0] < 4'd8) begin
                        noc_tx_valid <= 1;
                        noc_tx_flit  <= {
                            dst_x,
                            dst_y,
                            CORE_ID[15:0],
                            counter
                        };
                    end
                end
            endcase
        end
    end

    // =============================
    // RX handling (always ready)
    // =============================
    assign noc_rx_ready = 1'b1;

endmodule
