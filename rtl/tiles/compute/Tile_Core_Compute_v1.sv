module Tile_Core_Compute #(
    parameter ADDR_W = 32
)(
    input  logic clk,
    input  logic rst,

    input  logic valid,
    input  logic [7:0] opcode,

    input  logic [ADDR_W-1:0] src0_addr,
    input  logic [ADDR_W-1:0] src1_addr,
    input  logic [ADDR_W-1:0] dst_addr,

    output logic done
);

    typedef enum logic [1:0] {
        IDLE,
        EXEC,
        DONE
    } state_t;

    state_t state;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (valid)
                        state <= EXEC;
                end

                EXEC: begin
                    // v1: modelo abstracto de ejecución tensorial
                    // Aquí irá systolic / vector / híbrido
                    state <= DONE;
                end

                DONE: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
