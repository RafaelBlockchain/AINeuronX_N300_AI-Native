module noc_metrics_counter (
    input  logic clk,
    input  logic rst_n,

    input  logic valid,
    input  logic ready,

    output logic [31:0] flit_count,
    output logic [31:0] stall_count,
    output logic [31:0] busy_cycles
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flit_count  <= 0;
            stall_count <= 0;
            busy_cycles <= 0;
        end else begin
            if (valid) busy_cycles <= busy_cycles + 1;
            if (valid && ready) flit_count <= flit_count + 1;
            if (valid && !ready) stall_count <= stall_count + 1;
        end
    end

endmodule

