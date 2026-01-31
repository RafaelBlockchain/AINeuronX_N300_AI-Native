module tile_metric_export #(
    parameter TILE_ID = 0
)(
    input  logic clk,
    input  logic rst,

    input  logic [31:0] instr_count,
    input  logic [31:0] route_count,
    input  logic [31:0] stall_count,

    output logic        metric_valid,
    output logic [95:0] metric_packet
);

    always_ff @(posedge clk) begin
        if (rst) begin
            metric_valid <= 0;
        end else begin
            metric_valid  <= 1'b1;
            metric_packet <= {
                8'(TILE_ID),
                instr_count,
                route_count,
                stall_count
            };
        end
    end

endmodule
