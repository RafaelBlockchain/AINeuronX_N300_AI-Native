module noc_router_2x2 #(
    parameter int FLIT_W = 128
)(
    input  logic clk,
    input  logic rst_n,

    // Inputs
    input  logic              in0_valid,
    output logic              in0_ready,
    input  logic [FLIT_W-1:0] in0_flit,

    input  logic              in1_valid,
    output logic              in1_ready,
    input  logic [FLIT_W-1:0] in1_flit,

    // Outputs
    output logic              out0_valid,
    input  logic              out0_ready,
    output logic [FLIT_W-1:0] out0_flit,

    output logic              out1_valid,
    input  logic              out1_ready,
    output logic [FLIT_W-1:0] out1_flit
);

    logic rr_sel; // round robin pointer

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rr_sel <= 1'b0;
        else if ((out0_ready && out0_valid) || (out1_ready && out1_valid))
            rr_sel <= ~rr_sel;
    end

    always_comb begin
        // defaults
        out0_valid = 0;
        out1_valid = 0;
        out0_flit  = '0;
        out1_flit  = '0;
        in0_ready  = 0;
        in1_ready  = 0;

        // arbitration
        if (in0_valid || in1_valid) begin
            if (rr_sel) begin
                if (in1_valid && out1_ready) begin
                    out1_valid = 1;
                    out1_flit  = in1_flit;
                    in1_ready  = 1;
                end else if (in0_valid && out0_ready) begin
                    out0_valid = 1;
                    out0_flit  = in0_flit;
                    in0_ready  = 1;
                end
            end else begin
                if (in0_valid && out0_ready) begin
                    out0_valid = 1;
                    out0_flit  = in0_flit;
                    in0_ready  = 1;
                end else if (in1_valid && out1_ready) begin
                    out1_valid = 1;
                    out1_flit  = in1_flit;
                    in1_ready  = 1;
                end
            end
        end
    end

endmodule

