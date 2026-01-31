module AINeuronX_TILE_METRICS (
    input  logic clk,
    input  logic rst_n,

    input  logic mac_fire,
    input  logic noc_send,
    input  logic stall,

    output logic [31:0] mac_ops,
    output logic [31:0] noc_packets,
    output logic [31:0] stall_cycles
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            mac_ops       <= 0;
            noc_packets   <= 0;
            stall_cycles  <= 0;
        end else begin
            if (mac_fire)     mac_ops++;
            if (noc_send)     noc_packets++;
            if (stall)        stall_cycles++;
        end
    end

endmodule
