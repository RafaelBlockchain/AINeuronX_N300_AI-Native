module AINeuronX_GLOBAL_MEM_IF #(
    parameter DW = 128,
    parameter ADDR_W = 32,
    parameter LATENCY = 32
)(
    input  logic clk,
    input  logic rst_n,

    // Request
    input  logic        req_valid,
    input  logic        req_write,
    input  logic [ADDR_W-1:0] req_addr,
    input  logic [DW-1:0] req_wdata,
    output logic        req_ready,

    // Response
    output logic        resp_valid,
    output logic [DW-1:0] resp_rdata,

    // NoC injection
    output logic        noc_valid,
    output logic [DW-1:0] noc_data,
    input  logic        noc_ready
);

    typedef struct packed {
        logic        write;
        logic [ADDR_W-1:0] addr;
        logic [DW-1:0] data;
    } mem_req_t;

    mem_req_t pipe [0:LATENCY-1];
    logic [LATENCY-1:0] vld;

    integer i;

    assign req_ready = ~vld[0];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            vld <= '0;
        end else begin
            if (req_valid & req_ready) begin
                pipe[0] <= '{req_write, req_addr, req_wdata};
                vld[0]  <= 1'b1;
            end

            for (i = 1; i < LATENCY; i++) begin
                pipe[i] <= pipe[i-1];
                vld[i]  <= vld[i-1];
            end
        end
    end

    // Response / injection
    assign resp_valid = vld[LATENCY-1];
    assign resp_rdata = pipe[LATENCY-1].data;

    assign noc_valid = resp_valid;
    assign noc_data  = resp_rdata;

endmodule
