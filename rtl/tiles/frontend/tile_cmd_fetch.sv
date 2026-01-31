module tile_cmd_fetch #(
    parameter CMD_W = 64
)(
    input  logic clk,
    input  logic rst,

    input  logic noc_valid,
    input  logic [CMD_W-1:0] noc_cmd,

    output logic valid,
    output logic [CMD_W-1:0] cmd
);

    always_ff @(posedge clk) begin
        if (rst) begin
            valid <= 1'b0;
        end else begin
            valid <= noc_valid;
            cmd   <= noc_cmd;
        end
    end

endmodule
