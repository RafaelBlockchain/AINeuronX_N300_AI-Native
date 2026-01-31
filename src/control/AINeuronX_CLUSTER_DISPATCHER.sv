module AINeuronX_CLUSTER_DISPATCHER (
    input  logic clk,
    input  logic rst_n,

    // Command interface
    input  logic        cmd_valid,
    input  logic [1:0]  cmd_op,     // 0=LOAD,1=COMPUTE,2=STORE
    input  logic [31:0] cmd_addr,
    input  logic [15:0] cmd_size,
    output logic        cmd_ready,

    // Control outputs
    output logic load_en,
    output logic compute_en,
    output logic store_en,

    output logic busy
);

    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        COMPUTE,
        STORE
    } state_t;

    state_t state, next;

    assign cmd_ready = (state == IDLE);
    assign busy = (state != IDLE);

    always_ff @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next;
    end

    always_comb begin
        load_en    = 1'b0;
        compute_en = 1'b0;
        store_en   = 1'b0;
        next = state;

        case (state)
            IDLE: begin
                if (cmd_valid) begin
                    case (cmd_op)
                        2'd0: next = LOAD;
                        2'd1: next = COMPUTE;
                        2'd2: next = STORE;
                    endcase
                end
            end

            LOAD: begin
                load_en = 1'b1;
                next = IDLE;
            end

            COMPUTE: begin
                compute_en = 1'b1;
                next = IDLE;
            end

            STORE: begin
                store_en = 1'b1;
                next = IDLE;
            end
        endcase
    end

endmodule
