module noc_xy_router_vc #(
    parameter int FLIT_W = 128,
    parameter int X_ID   = 0,
    parameter int Y_ID   = 0
)(
    input  logic clk,
    input  logic rst_n,

    input  logic              in_valid,
    output logic              in_ready,
    input  logic [FLIT_W-1:0] in_flit,

    output logic e_valid, w_valid, n_valid, s_valid,
    input  logic e_ready, w_ready, n_ready, s_ready,
    output logic [FLIT_W-1:0] e_flit, w_flit, n_flit, s_flit
);

    wire [3:0] dst_x = in_flit[3:0];
    wire [3:0] dst_y = in_flit[7:4];
    wire [1:0] vc_id = in_flit[9:8];

    logic sel_e, sel_w, sel_n, sel_s;

    assign sel_e = (dst_x > X_ID);
    assign sel_w = (dst_x < X_ID);
    assign sel_n = (!sel_e && !sel_w && dst_y > Y_ID);
    assign sel_s = (!sel_e && !sel_w && dst_y < Y_ID);

    always_comb begin
        e_valid = 0; w_valid = 0; n_valid = 0; s_valid = 0;
        e_flit  = in_flit;
        w_flit  = in_flit;
        n_flit  = in_flit;
        s_flit  = in_flit;
        in_ready= 0;

        if (sel_e && e_ready) begin
            e_valid = in_valid;
            in_ready= e_ready;
        end else if (sel_w && w_ready) begin
            w_valid = in_valid;
            in_ready= w_ready;
        end else if (sel_n && n_ready) begin
            n_valid = in_valid;
            in_ready= n_ready;
        end else if (sel_s && s_ready) begin
            s_valid = in_valid;
            in_ready= s_ready;
        end
    end

endmodule

