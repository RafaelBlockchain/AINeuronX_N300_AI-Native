`timescale 1ns/1ps

module tensor_core_wrapper #(
    parameter int DATA_WIDTH = 16,
    parameter int TILE_ID    = 0
)(
    input  logic clk,
    input  logic rst_n,

    // ===== Control Interface (desde scheduler) =====
    input  logic        tc_valid,
    input  logic [3:0]  tc_opcode,     // matmul, conv, etc
    input  logic [7:0]  tc_m,
    input  logic [7:0]  tc_n,
    input  logic [7:0]  tc_k,
    output logic        tc_ready,

    // ===== Memory Interface (Tile Scratchpad) =====
    output logic        mem_req,
    output logic [31:0] mem_addr,
    input  logic [DATA_WIDTH-1:0] mem_rdata,
    input  logic        mem_ready,

    // ===== Result Interface =====
    output logic        result_valid,
    output logic [DATA_WIDTH-1:0] result_data
);

    // ============================================================
    // FSM States
    // ============================================================
    typedef enum logic [2:0] {
        IDLE,
        FETCH,
        EXECUTE,
        WRITEBACK,
        DONE
    } tc_state_t;

    tc_state_t state, next_state;

    // ============================================================
    // State Register
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ============================================================
    // FSM Control
    // ============================================================
    always_comb begin
        next_state   = state;
        tc_ready     = 1'b0;
        mem_req      = 1'b0;
        mem_addr     = 32'd0;
        result_valid = 1'b0;
        result_data  = '0;

        case (state)

            IDLE: begin
                tc_ready = 1'b1;
                if (tc_valid)
                    next_state = FETCH;
            end

            FETCH: begin
                mem_req  = 1'b1;
                mem_addr = 32'h0000_0000; // placeholder
                if (mem_ready)
                    next_state = EXECUTE;
            end

            EXECUTE: begin
                // Tensor Core real se conectará aquí
                next_state = WRITEBACK;
            end

            WRITEBACK: begin
                result_valid = 1'b1;
                result_data  = mem_rdata; // placeholder
                next_state   = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;

        endcase
    end

endmodule
