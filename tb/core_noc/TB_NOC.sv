`timescale 1ns/1ps
module TB_NOC;

    parameter DW = 8;

    logic clk;
    logic rst_n;
    logic tile_active;

    logic [DW-1:0] n_data, s_data, e_data, w_data, l_data;
    logic n_valid, s_valid, e_valid, w_valid, l_valid;
    logic [DW-1:0] n_out, s_out, e_out, w_out, l_out;
    logic n_ready, s_ready, e_ready, w_ready, l_ready;

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset
    initial begin
        rst_n = 0;
        tile_active = 1;
        #20 rst_n = 1;
    end

    // DUT
    Tile_Router dut(
        .clk(clk),
        .rst_n(rst_n),
        .n_data(n_data), .s_data(s_data), .e_data(e_data), .w_data(w_data), .l_data(l_data),
        .n_valid(n_valid), .s_valid(s_valid), .e_valid(e_valid), .w_valid(w_valid), .l_valid(l_valid),
        .n_out(n_out), .s_out(s_out), .e_out(e_out), .w_out(w_out), .l_out(l_out),
        .n_ready(n_ready), .s_ready(s_ready), .e_ready(e_ready), .w_ready(w_ready), .l_ready(l_ready),
        .tile_active(tile_active)
    );

    // Random traffic generator
    initial begin
        repeat (200) begin
            @(posedge clk);
            n_data = $urandom % 256;
            s_data = $urandom % 256;
            e_data = $urandom % 256;
            w_data = $urandom % 256;
            l_data = $urandom % 256;
            n_valid = $urandom % 2;
            s_valid = $urandom % 2;
            e_valid = $urandom % 2;
            w_valid = $urandom % 2;
            l_valid = $urandom % 2;
        end
    end

endmodule
