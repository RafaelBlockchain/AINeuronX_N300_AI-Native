module noc_latency_monitor (
    input  logic clk,
    input  logic rst_n,

    input  logic              flit_valid,
    input  logic [127:0]      flit,

    output logic [31:0]       min_latency,
    output logic [31:0]       max_latency,
    output logic [31:0]       sum_latency,
    output logic [31:0]       sample_count
);

    wire [15:0] inject_ts = flit[31:16];
    logic [31:0] latency;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_latency  <= 32'hFFFF_FFFF;
            max_latency  <= 0;
            sum_latency  <= 0;
            sample_count <= 0;
        end else if (flit_valid) begin
            latency = $time - inject_ts;
            if (latency < min_latency) min_latency <= latency;
            if (latency > max_latency) max_latency <= latency;
            sum_latency  <= sum_latency + latency;
            sample_count <= sample_count + 1;
        end
    end

endmodule

