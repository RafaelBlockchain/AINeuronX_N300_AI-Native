module noc_output_arbiter_qos #(
    parameter int FLIT_W = 128
)(
    input  logic clk,
    input  logic rst_n,

    // VC inputs (ejemplo: 2 entradas)
    input  logic              in0_valid,
    input  logic [FLIT_W-1:0] in0_flit,
    output logic              in0_ready,

    input  logic              in1_valid,
    input  logic [FLIT_W-1:0] in1_flit,
    output logic              in1_ready,

    // Output
    output logic              out_valid,
    output logic [FLIT_W-1:0] out_flit,
    input  logic              out_ready
);

    logic rr; // round-robin interno

    wire [1:0] p0 = in0_flit[11:10];
    wire [1:0] p1 = in1_flit[11:10];

    function automatic logic higher_prio(input [1:0] a, b);
        higher_prio = (a > b);
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rr <= 1'b0;
        else if (out_valid && out_ready)
            rr <= ~rr;
    end

    always_comb begin
        out_valid = 0;
        out_flit  = '0;
        in0_ready = 0;
        in1_ready = 0;

        if (in0_valid && in1_valid) begin
            if (higher_prio(p0, p1)) begin
                if (out_ready) begin
                    out_valid = 1;
                    out_flit  = in0_flit;
                    in0_ready = 1;
                end
            end else if (higher_prio(p1, p0)) begin
                if (out_ready) begin
                    out_valid = 1;
                    out_flit  = in1_flit;
                    in1_ready = 1;
                end
            end else begin
                // misma prioridad → round robin
                if (rr && out_ready) begin
                    out_valid = 1;
                    out_flit  = in1_flit;
                    in1_ready = 1;
                end else if (out_ready) begin
                    out_valid = 1;
                    out_flit  = in0_flit;
                    in0_ready = 1;
                end
            end
        end else if (in0_valid && out_ready) begin
            out_valid = 1;
            out_flit  = in0_flit;
            in0_ready = 1;
        end else if (in1_valid && out_ready) begin
            out_valid = 1;
            out_flit  = in1_flit;
            in1_ready = 1;
        end
    end

endmodule

