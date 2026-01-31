import ax_isa_defs::*;

module ax_runtime_ctrl (
    input  logic clk,
    input  logic rst_n,

    input  ax_instr_t instr,
    input  logic      instr_valid,

    output logic tensor_req,
    output logic vector_req,
    output logic dma_req
);

    always_comb begin
        tensor_req = 0;
        vector_req = 0;
        dma_req    = 0;

        if (instr_valid) begin
            case (instr.domain)
                DOMAIN_TENSOR: tensor_req = 1;
                DOMAIN_VECTOR: vector_req = 1;
                DOMAIN_DMA:    dma_req    = 1;
                default: ;
            endcase
        end
    end

endmodule
