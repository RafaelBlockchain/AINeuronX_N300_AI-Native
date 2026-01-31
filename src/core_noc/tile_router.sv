module tile_router #(
    parameter int FLIT_W = 64
)(
    input  logic clk,
    input  logic rst_n,

    input  logic [FLIT_W-1:0] in_flit,
    input  logic              in_valid,
    input  logic              in_vc,      // 0 = control, 1 = data

    output logic [FLIT_W-1:0] out_flit,
    output logic              out_valid
);

    // Simple priority: VC0 > VC1
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
        end else begin
            if (in_valid) begin
                out_flit  <= in_flit;
                out_valid <= 1'b1;
            end else begin
                out_valid <= 1'b0;
            end
        end
    end

endmodule
