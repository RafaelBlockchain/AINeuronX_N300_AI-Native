module noc_dma_throttle (
    input  logic clk,
    input  logic rst_n,

    input  logic congested,
    input  logic dma_valid,
    output logic dma_allow
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            dma_allow <= 1'b1;
        else
            dma_allow <= !congested;
    end

endmodule
