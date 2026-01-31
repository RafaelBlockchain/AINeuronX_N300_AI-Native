module compute_tile_top (
    input  logic clk,
    input  logic rst_n,

    input  logic tensor_req,
    input  logic vector_req,
    input  logic dma_req,

    input  logic [1:0]  vec_opcode,
    input  logic [31:0] vec_a,
    input  logic [31:0] vec_b,

    output logic [31:0] vec_result,
    output logic        vec_valid
);

    logic g_tensor, g_vector, g_dma;

    scheduler_policy scheduler (
        .clk(clk),
        .rst_n(rst_n),
        .tensor_req(tensor_req),
        .vector_req(vector_req),
        .dma_req(dma_req),
        .grant_tensor(g_tensor),
        .grant_vector(g_vector),
        .grant_dma(g_dma)
    );

    vector_core_top vector_core (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(g_vector),
        .opcode(vec_opcode),
        .src_a(vec_a),
        .src_b(vec_b),
        .valid_out(vec_valid),
        .result(vec_result)
    );

    // Tensor core permanece como wrapper (decisión previa)

endmodule
