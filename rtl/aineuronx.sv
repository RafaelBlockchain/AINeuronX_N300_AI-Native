// =====================================================
// AINEURONX_CORE.SV – Core vectorizado industrial
// Pipeline 3 etapas + backpressure + golden-ready
// =====================================================
`timescale 1ns/1ps

module aineuronx_core #(
    parameter int DATA_WIDTH = 16,
    parameter int VECTOR_WIDTH = 4
)(
    input  logic                          clk,
    input  logic                          rst_n,

    input  logic                          valid_in,
    input  logic                          select_precision,
    input  logic                          prefetch_enable,

    input  logic [DATA_WIDTH-1:0]         input_a [VECTOR_WIDTH-1:0],
    input  logic [DATA_WIDTH-1:0]         input_b [VECTOR_WIDTH-1:0],

    output logic                          ready_out,
    output logic [DATA_WIDTH-1:0]         output_data [VECTOR_WIDTH-1:0]
);

    // -------------------------------------------------
    // Señales internas del pipeline
    // -------------------------------------------------
    typedef struct packed {
        logic [DATA_WIDTH-1:0] a;
        logic [DATA_WIDTH-1:0] b;
        logic select;
        logic valid;
    } stage_t;

    stage_t stage0 [VECTOR_WIDTH-1:0];
    stage_t stage1 [VECTOR_WIDTH-1:0];
    stage_t stage2 [VECTOR_WIDTH-1:0];

    // Ready real → backpressure continuo
    assign ready_out = !stage0[0].valid; // si pipeline libre

    // -------------------------------------------------
    // Etapa 0 – captura input
    // -------------------------------------------------
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            for (int i = 0; i < VECTOR_WIDTH; i++) begin
                stage0[i] <= '{a:0, b:0, select:0, valid:0};
                stage1[i] <= '{a:0, b:0, select:0, valid:0};
                stage2[i] <= '{a:0, b:0, select:0, valid:0};
                output_data[i] <= '0;
            end
        end else begin
            // -----------------------------
            // Stage0: captura si valid + prefetch + ready
            // -----------------------------
            for (int i = 0; i < VECTOR_WIDTH; i++) begin
                if (valid_in && prefetch_enable && ready_out) begin
                    stage0[i].a     <= input_a[i];
                    stage0[i].b     <= input_b[i];
                    stage0[i].select<= select_precision;
                    stage0[i].valid <= 1'b1;
                end else begin
                    stage0[i].valid <= 1'b0;
                end
            end

            // -----------------------------
            // Stage1: proceso (ADD/SUB)
            // -----------------------------
            for (int i = 0; i < VECTOR_WIDTH; i++) begin
                stage1[i] <= stage0[i];
                if (stage0[i].valid) begin
                    stage2[i].a      <= stage0[i].a;
                    stage2[i].b      <= stage0[i].b;
                    stage2[i].select <= stage0[i].select;
                    stage2[i].valid  <= stage0[i].valid;
                end
            end

            // -----------------------------
            // Stage2: output final
            // -----------------------------
            for (int i = 0; i < VECTOR_WIDTH; i++) begin
                if (stage2[i].valid) begin
                    if (stage2[i].select)
                        output_data[i] <= stage2[i].a + stage2[i].b;
                    else
                        output_data[i] <= stage2[i].a - stage2[i].b;
                end else begin
                    output_data[i] <= '0;
                end
            end
        end
    end

endmodule
