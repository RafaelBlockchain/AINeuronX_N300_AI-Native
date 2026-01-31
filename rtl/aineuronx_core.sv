// =====================================================
// AINEURONX_CORE.SV – Endurecido
// Pipeline 3 etapas + backpressure + prefetch seguro
// =====================================================
`timescale 1ns/1ps

module aineuronx_core #(
    parameter int DATA_WIDTH = 16,
    parameter int PIPE_DEPTH = 3
)(
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic                  valid_in,
    input  logic                  select_precision,
    input  logic                  prefetch_enable,

    input  logic [DATA_WIDTH-1:0] input_a,
    input  logic [DATA_WIDTH-1:0] input_b,

    output logic                  ready_out,
    output logic [DATA_WIDTH-1:0] output_data
);

    // -------------------------------------------------
    // Pipeline registers
    // -------------------------------------------------
    typedef struct packed {
        logic [DATA_WIDTH-1:0] a;
        logic [DATA_WIDTH-1:0] b;
        logic                  sel;
        logic                  valid;
    } pipe_stage_t;

    pipe_stage_t pipeline [PIPE_DEPTH-1:0];

    // -------------------------------------------------
    // Ready logic (backpressure)
    // -------------------------------------------------
    logic stage_ready [PIPE_DEPTH-1:0];

    // El core acepta datos solo si la primera etapa está lista
    assign ready_out = stage_ready[0];

    // -------------------------------------------------
    // Pipeline
    // -------------------------------------------------
    integer i;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < PIPE_DEPTH; i=i+1) begin
                pipeline[i].a     <= '0;
                pipeline[i].b     <= '0;
                pipeline[i].sel   <= 1'b0;
                pipeline[i].valid <= 1'b0;
                stage_ready[i]    <= 1'b1;
            end
            output_data <= '0;
        end else begin
            // Primera etapa: aceptar entrada si ready
            if (stage_ready[0]) begin
                pipeline[0].a     <= input_a;
                pipeline[0].b     <= input_b;
                pipeline[0].sel   <= select_precision;
                pipeline[0].valid <= valid_in && prefetch_enable;
            end

            // Propagación pipeline
            for (i = 1; i < PIPE_DEPTH; i=i+1) begin
                if (stage_ready[i]) begin
                    pipeline[i].a     <= pipeline[i-1].a;
                    pipeline[i].b     <= pipeline[i-1].b;
                    pipeline[i].sel   <= pipeline[i-1].sel;
                    pipeline[i].valid <= pipeline[i-1].valid;
                end
            end

            // Calcular salida solo en la última etapa
            if (pipeline[PIPE_DEPTH-1].valid) begin
                if (pipeline[PIPE_DEPTH-1].sel)
                    output_data <= pipeline[PIPE_DEPTH-1].a + pipeline[PIPE_DEPTH-1].b;
                else
                    output_data <= pipeline[PIPE_DEPTH-1].a - pipeline[PIPE_DEPTH-1].b;
            end

            // -------------------------------------------------
            // Ready flags: una etapa está lista si la siguiente está lista o vacía
            // -------------------------------------------------
            stage_ready[PIPE_DEPTH-1] <= 1'b1; // última etapa siempre lista
            for (i = PIPE_DEPTH-2; i >= 0; i=i-1) begin
                stage_ready[i] <= !pipeline[i+1].valid || stage_ready[i+1];
            end
        end
    end

endmodule
