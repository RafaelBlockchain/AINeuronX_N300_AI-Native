`timescale 1ns/1ps

module tile_dma #(
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

    // ===== Scratchpad Interface =====
    output logic        sp_req,
    output logic        sp_we,
    output logic [15:0] sp_addr,
    output logic [DATA_WIDTH-1:0] sp_wdata,
    input  logic        sp_ready,
    input  logic [DATA_WIDTH-1:0] sp_rdata
);

    typedef enum logic [1:0] {
        IDLE,
        ACCESS,
        RESP
    } dma_state_t;

    dma_state_t state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else begin
            case (state)
                IDLE:    if (noc_valid) state <= ACCESS;
                ACCESS: if (sp_ready)  state <= RESP;
                RESP:   state <= IDLE;
            endcase
        end
    end

    always_comb begin
        noc_ready = 1'b0;
        noc_rdata = '0;

        sp_req    = 1'b0;
        sp_we     = 1'b0;
        sp_addr   = noc_addr;
        sp_wdata  = noc_wdata;

        case (state)
            ACCESS: begin
                sp_req = 1'b1;
                sp_we  = noc_we;
            end
            RESP: begin
                noc_ready = 1'b1;
                noc_rdata = sp_rdata;
            end
        endcase
    end

endmodule
