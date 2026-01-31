module dma_engine #(
    parameter int ADDR_W = 32
)(
    input  logic clk,
    input  logic rst_n,

    input  logic        dma_start,
    input  logic [ADDR_W-1:0] src_addr,
    input  logic [ADDR_W-1:0] dst_addr,

    output logic        dma_complete
);

    typedef enum logic [1:0] {
        IDLE,
        BUSY,
        DONE
    } dma_state_t;

    dma_state_t state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            dma_complete <= 1'b0;
        end else begin
            dma_complete <= 1'b0;

            case (state)
                IDLE: begin
                    if (dma_start)
                        state <= BUSY;
                end

                BUSY: begin
                    // transferencia simulada
                    state <= DONE;
                end

                DONE: begin
                    dma_complete <= 1'b1;
                    state        <= IDLE;
                end
            endcase
        end
    end

endmodule
