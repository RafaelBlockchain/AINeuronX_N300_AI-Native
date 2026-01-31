module tile_cmd_decode #(
    parameter CMD_W = 64
)(
    input  logic clk,
    input  logic valid,
    input  logic [CMD_W-1:0] cmd,

    output logic dec_valid,
    output logic [7:0] opcode,
    output logic [7:0] src0,
    output logic [7:0] src1,
    output logic [7:0] dst
);

    always_ff @(posedge clk) begin
        dec_valid <= valid;
        opcode    <= cmd[63:56];
        src0      <= cmd[55:48];
        src1      <= cmd[47:40];
        dst       <= cmd[39:32];
    end

endmodule
