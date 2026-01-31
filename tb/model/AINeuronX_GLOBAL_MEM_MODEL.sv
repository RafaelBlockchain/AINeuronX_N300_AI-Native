module AINeuronX_GLOBAL_MEM_MODEL #(
    parameter LATENCY = 64,
    parameter BW_LIMIT = 256
)(
    input  logic clk,
    input  logic req_valid,
    output logic req_ready,
    output logic rsp_valid
);

    int latency_cnt;

    always_ff @(posedge clk) begin
        if (req_valid && req_ready) begin
            latency_cnt <= LATENCY;
            rsp_valid <= 0;
        end else if (latency_cnt > 0) begin
            latency_cnt <= latency_cnt - 1;
            if (latency_cnt == 1)
                rsp_valid <= 1;
        end else begin
            rsp_valid <= 0;
        end
    end

    assign req_ready = (latency_cnt == 0);
endmodule
