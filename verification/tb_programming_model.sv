module tb_programming_model;

    logic clk, rst_n;
    ax_instr_t instr;
    logic instr_valid;

    logic tensor_req, vector_req, dma_req;

    always #5 clk = ~clk;

    ax_runtime_ctrl dut (
        .clk(clk),
        .rst_n(rst_n),
        .instr(instr),
        .instr_valid(instr_valid),
        .tensor_req(tensor_req),
        .vector_req(vector_req),
        .dma_req(dma_req)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        instr_valid = 0;
        #20 rst_n = 1;

        instr.domain  = DOMAIN_VECTOR;
        instr.opcode  = V_ADD;
        instr_valid   = 1;
        #10;

        instr.domain  = DOMAIN_TENSOR;
        instr.opcode  = T_MMA;
        #10;

        instr.domain  = DOMAIN_DMA;
        instr.opcode  = D_COPY;
        #10;

        instr_valid = 0;
        #50;

        $finish;
    end

endmodule
