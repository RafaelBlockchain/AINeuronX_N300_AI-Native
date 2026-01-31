module tile_core_control (
    input  logic clk,
    input  logic rst_n,

    input  logic instr_barrier,
    input  logic barrier_release,

    output logic barrier_arrive,
    output logic core_stall
);

    typedef enum logic [1:0] {
        RUN,
        WAIT_BARRIER
    } state_t;

    state_t state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= RUN;
            barrier_arrive <= 1'b0;
            core_stall     <= 1'b0;
        end else begin
            barrier_arrive <= 1'b0;

            case (state)
                RUN: begin
                    if (instr_barrier) begin
                        barrier_arrive <= 1'b1;
                        core_stall     <= 1'b1;
                        state          <= WAIT_BARRIER;
                    end
                end

                WAIT_BARRIER: begin
                    core_stall <= 1'b1;
                    if (barrier_release) begin
                        core_stall <= 1'b0;
                        state      <= RUN;
                    end
                end
            endcase
        end
    end

endmodule
