module scoreboard (
    input  logic clk,
    input  logic reset,

    input  logic issue_scalar,
    input  logic issue_vector,
    input  logic issue_tensor,
    input  logic issue_dma,

    input  logic done_vector,
    input  logic done_tensor,
    input  logic done_dma,

    output logic stall
);
    logic vector_busy, tensor_busy, dma_busy;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            vector_busy <= 0;
            tensor_busy <= 0;
            dma_busy    <= 0;
        end else begin
            if (issue_vector) vector_busy <= 1;
            if (issue_tensor) tensor_busy <= 1;
            if (issue_dma)    dma_busy    <= 1;

            if (done_vector) vector_busy <= 0;
            if (done_tensor) tensor_busy <= 0;
            if (done_dma)    dma_busy    <= 0;
        end
    end

    assign stall = vector_busy | tensor_busy | dma_busy;
endmodule
