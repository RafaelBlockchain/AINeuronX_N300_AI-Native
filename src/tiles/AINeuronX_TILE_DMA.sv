module AINeuronX_TILE_DMA #(parameter LANES=16, DW=16)(
    input logic clk, rst,
    input logic mem_valid,
    output logic mem_ready,
    input logic [DW-1:0] mem_a [LANES],
    input logic [DW-1:0] mem_b [LANES],
    output logic l1_we,
    output logic [7:0] l1_addr,
    output logic [DW*LANES*2-1:0] l1_data
);
    always_ff @(posedge clk) begin
        if (rst) begin
            l1_addr <= 0;
            mem_ready <= 1;
            l1_we <= 0;
        end else if (mem_valid) begin
            l1_we <= 1;
            l1_addr <= l1_addr + 1;
            l1_data <= {mem_a, mem_b};
        end else l1_we <= 0;
    end
endmodule
