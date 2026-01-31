`timescale 1ns/1ps

module systolic_ctrl #(
    parameter int ROWS = 4,
    parameter int COLS = 4,
    parameter int K_DIM = 16
)(
    input  logic clk,
    input  logic rst_n,

    // Command interface
    input  logic start,
    output logic busy,
    output logic done,

    // Control to systolic array
    output logic valid_in,
    output logic clear_acc
);

    typedef enum logic [1:0] {
        IDLE,
        CLEAR,
        RUN,
        FINISH
    } state_t;

    state_t state, state_n;

    logic [$clog2(K_DIM+1)-1:0] k_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            k_cnt <= '0;
        end else begin
            state <= state_n;
            if (state == RUN)
                k_cnt <= k_cnt + 1'b1;
            else
                k_cnt <= '0;
        end
    end

    always_comb begin
        state_n   = state;
        valid_in = 1'b0;
        clear_acc= 1'b0;
        busy     = 1'b0;
        done     = 1'b0;

        case (state)
            IDLE: begin
                if (start)
                    state_n = CLEAR;
            end

            CLEAR: begin
                clear_acc = 1'b1;
                busy      = 1'b1;
                state_n   = RUN;
            end

            RUN: begin
                valid_in = 1'b1;
                busy     = 1'b1;
                if (k_cnt == K_DIM-1)
                    state_n = FINISH;
            end

            FINISH: begin
                done   = 1'b1;
                busy   = 1'b0;
                state_n = IDLE;
            end
        endcase
    end

endmodule
