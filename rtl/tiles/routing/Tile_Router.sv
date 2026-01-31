module Tile_Router #(
    parameter CMD_W = 64
)(
    input  logic clk,
    input  logic rst,

    input  logic route_valid,
    input  logic [CMD_W-1:0] route_cmd,

    output logic noc_valid,
    output logic [CMD_W-1:0] noc_cmd
);

    always_ff @(posedge clk) begin
        if (rst) begin
            noc_valid <= 1'b0;
        end else begin
            noc_valid <= route_valid;
            noc_cmd   <= route_cmd;
        end
    end

endmodule
