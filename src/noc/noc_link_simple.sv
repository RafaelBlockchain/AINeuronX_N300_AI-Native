module noc_link_simple #(
    parameter int FLIT_W = 128
)(
    input  logic clk,
    input  logic rst_n,

    input  logic              in_valid,
    output logic              in_ready,
    input  logic [FLIT_W-1:0] in_flit,

    output logic              out_valid,
    input  logic              out_ready,
    output logic [FLIT_W-1:0] out_flit
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
            out_flit  <= '0;
        end else begin
            if (in_valid && in_ready) begin
                out_valid <= 1'b1;
                out_flit  <= in_flit;
            end else if (out_valid && out_ready) begin
                out_valid <= 1'b0;
            end
        end
    end

    assign in_ready = !out_valid || out_ready;

endmodule

