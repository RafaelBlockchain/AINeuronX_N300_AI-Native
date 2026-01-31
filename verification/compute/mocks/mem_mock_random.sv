module mem_mock_random (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        req_valid,
    output logic        req_ready,
    input  logic [63:0] addr,
    output logic [255:0] rdata
);

    import "DPI-C" function int rand();

    int latency;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            req_ready <= 1'b1;
            rdata     <= '0;
        end else begin
            latency  = rand() % 10;
            req_ready<= (latency < 7); // backpressure aleatorio

            if (req_valid && req_ready)
                rdata <= {4{addr ^ latency}};
        end
    end

endmodule

