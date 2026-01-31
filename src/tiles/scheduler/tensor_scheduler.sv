`timescale 1ns/1ps

module tensor_scheduler #(
    parameter FIFO_DEPTH = 4
)(
    input  logic clk,
    input  logic rst_n,

    // ===== Enqueue interface =====
    input  logic        enq_valid,
    input  logic [3:0]  enq_opcode,
    input  logic [7:0]  enq_m,
    input  logic [7:0]  enq_n,
    input  logic [7:0]  enq_k,
    output logic        enq_ready,

    // ===== To Tensor Core Wrapper =====
    output logic        tc_valid,
    output logic [3:0]  tc_opcode,
    output logic [7:0]  tc_m,
    output logic [7:0]  tc_n,
    output logic [7:0]  tc_k,
    input  logic        tc_ready,

    // ===== Completion =====
    input  logic        tc_done
);

    // ============================================================
    // FIFO storage
    // ============================================================
    typedef struct packed {
        logic [3:0] opcode;
        logic [7:0] m, n, k;
    } tc_inst_t;

    tc_inst_t fifo [0:FIFO_DEPTH-1];

    logic [$clog2(FIFO_DEPTH):0] rd_ptr, wr_ptr;
    logic [$clog2(FIFO_DEPTH+1)-1:0] count;

    assign enq_ready = (count < FIFO_DEPTH);

    // ============================================================
    // FIFO enqueue
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            count  <= '0;
        end else if (enq_valid && enq_ready) begin
            fifo[wr_ptr] <= '{enq_opcode, enq_m, enq_n, enq_k};
            wr_ptr <= wr_ptr + 1;
            count  <= count + 1;
        end
    end

    // ============================================================
    // FSM
    // ============================================================
    typedef enum logic [1:0] {
        S_IDLE,
        S_ISSUE,
        S_WAIT
    } sched_state_t;

    sched_state_t state;

    // ============================================================
    // Issue logic
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S_IDLE;
            rd_ptr   <= '0;
            tc_valid <= 1'b0;
        end else begin
            case (state)

                S_IDLE: begin
                    tc_valid <= 1'b0;
                    if (count != 0)
                        state <= S_ISSUE;
                end

                S_ISSUE: begin
                    tc_valid  <= 1'b1;
                    tc_opcode <= fifo[rd_ptr].opcode;
                    tc_m      <= fifo[rd_ptr].m;
                    tc_n      <= fifo[rd_ptr].n;
                    tc_k      <= fifo[rd_ptr].k;

                    if (tc_ready) begin
                        tc_valid <= 1'b0;
                        rd_ptr   <= rd_ptr + 1;
                        count    <= count - 1;
                        state    <= S_WAIT;
                    end
                end

                S_WAIT: begin
                    if (tc_done)
                        state <= S_IDLE;
                end

            endcase
        end
    end

endmodule
