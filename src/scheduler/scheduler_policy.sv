module scheduler_policy (
    input  logic clk,
    input  logic rst_n,

    input  logic tensor_req,
    input  logic vector_req,
    input  logic dma_req,

    output logic grant_tensor,
    output logic grant_vector,
    output logic grant_dma
);

    logic rr_toggle;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rr_toggle <= 1'b0;
        else if (vector_req && !tensor_req)
            rr_toggle <= ~rr_toggle;
    end

    always_comb begin
        grant_tensor = 0;
        grant_vector = 0;
        grant_dma    = 0;

        if (tensor_req) begin
            grant_tensor = 1;
        end else if (vector_req) begin
            grant_vector = 1;
        end else if (dma_req) begin
            grant_dma = 1;
        end
    end

endmodule
