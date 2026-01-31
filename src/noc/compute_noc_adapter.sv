module compute_noc_adapter #(
    parameter int CMD_W  = 64,
    parameter int FLIT_W = 128
)(
    input  logic clk,
    input  logic rst_n,

    input  logic              cmd_valid,
    output logic              cmd_ready,
    input  logic [CMD_W-1:0]  cmd,

    output logic              noc_valid,
    input  logic              noc_ready,
    output logic [FLIT_W-1:0] noc_flit
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            noc_valid <= 1'b0;
            noc_flit  <= '0;
        end else begin
            if (cmd_valid && cmd_ready) begin
                noc_valid <= 1'b1;
                noc_flit  <= {{(FLIT_W-CMD_W){1'b0}}, cmd};
            end else if (noc_valid && noc_ready) begin
                noc_valid <= 1'b0;
            end
        end
    end

    assign cmd_ready = !noc_valid || noc_ready;

endmodule

