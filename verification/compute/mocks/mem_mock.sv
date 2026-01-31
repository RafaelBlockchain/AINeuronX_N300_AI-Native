module mem_mock (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        req_valid,
    output logic        req_ready,
    input  logic [63:0] addr,
    output logic [255:0] rdata
);

    parameter LATENCY = 4;

    logic [LATENCY-1:0] pipe;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pipe <= '0;
        else
            pipe <= {pipe[LATENCY-2:0], req_valid};
    end

    assign req_ready = 1'b1;

    always_ff @(posedge clk) begin
        if (pipe[LATENCY-1])
            rdata <= {4{addr}};
    end

endmodule

