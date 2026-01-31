module tile_cmd_ctrl(
    input  logic clk,
    input  logic rst,

    input  logic dec_valid,
    input  logic [7:0] opcode,

    output logic do_compute,
    output logic do_route
);

    always_ff @(posedge clk) begin
        if (rst) begin
            do_compute <= 1'b0;
            do_route   <= 1'b0;
        end else if (dec_valid) begin
            do_compute <= (opcode < 8'h80);
            do_route   <= (opcode >= 8'h80);
        end
    end

endmodule
