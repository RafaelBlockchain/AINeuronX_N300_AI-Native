`timescale 1ns/1ps
module TB_NOC_Full;

    parameter DW = 8;
    parameter SIZE_X = 32; // ancho NoC
    parameter SIZE_Y = 32; // alto NoC
    parameter PORTS = 5;

    logic clk;
    logic rst_n;
    logic [SIZE_X*SIZE_Y-1:0] tile_active;

    // ===== Clock =====
    initial clk = 0;
    always #5 clk = ~clk;

    // ===== Reset =====
    initial begin
        rst_n = 0;
        tile_active = {SIZE_X*SIZE_Y{1'b1}}; // todos activos
        #20 rst_n = 1;
    end

    // ===== Tile arrays =====
    logic [DW-1:0] n_data  [0:SIZE_X-1][0:SIZE_Y-1];
    logic [DW-1:0] s_data  [0:SIZE_X-1][0:SIZE_Y-1];
    logic [DW-1:0] e_data  [0:SIZE_X-1][0:SIZE_Y-1];
    logic [DW-1:0] w_data  [0:SIZE_X-1][0:SIZE_Y-1];
    logic [DW-1:0] l_data  [0:SIZE_X-1][0:SIZE_Y-1];

    logic n_valid[0:SIZE_X-1][0:SIZE_Y-1];
    logic s_valid[0:SIZE_X-1][0:SIZE_Y-1];
    logic e_valid[0:SIZE_X-1][0:SIZE_Y-1];
    logic w_valid[0:SIZE_X-1][0:SIZE_Y-1];
    logic l_valid[0:SIZE_X-1][0:SIZE_Y-1];

    logic n_ready[0:SIZE_X-1][0:SIZE_Y-1];
    logic s_ready[0:SIZE_X-1][0:SIZE_Y-1];
    logic e_ready[0:SIZE_X-1][0:SIZE_Y-1];
    logic w_ready[0:SIZE_X-1][0:SIZE_Y-1];
    logic l_ready[0:SIZE_X-1][0:SIZE_Y-1];

    // ===== Tile instances =====
    genvar x,y;
    generate
        for (x=0; x<SIZE_X; x=x+1) begin: gen_x
            for (y=0; y<SIZE_Y; y=y+1) begin: gen_y
                Tile_Router #(
                    .DW(DW),
                    .X_ID(x),
                    .Y_ID(y)
                ) tile (
                    .clk(clk),
                    .rst_n(rst_n),
                    .n_data(n_data[x][y]), .s_data(s_data[x][y]),
                    .e_data(e_data[x][y]), .w_data(w_data[x][y]), .l_data(l_data[x][y]),
                    .n_valid(n_valid[x][y]), .s_valid(s_valid[x][y]),
                    .e_valid(e_valid[x][y]), .w_valid(w_valid[x][y]), .l_valid(l_valid[x][y]),
                    .n_out(), .s_out(), .e_out(), .w_out(), .l_out(),
                    .n_ready(n_ready[x][y]), .s_ready(s_ready[x][y]),
                    .e_ready(e_ready[x][y]), .w_ready(w_ready[x][y]), .l_ready(l_ready[x][y]),
                    .tile_active(tile_active[x*SIZE_Y+y])
                );
            end
        end
    endgenerate

    // ===== Traffic generator =====
    initial begin
        forever @(posedge clk) begin
            for (int x=0; x<SIZE_X; x++) begin
                for (int y=0; y<SIZE_Y; y++) begin
                    n_data[x][y] = $urandom % 256;
                    s_data[x][y] = $urandom % 256;
                    e_data[x][y] = $urandom % 256;
                    w_data[x][y] = $urandom % 256;
                    l_data[x][y] = $urandom % 256;

                    n_valid[x][y] = $urandom % 2;
                    s_valid[x][y] = $urandom % 2;
                    e_valid[x][y] = $urandom % 2;
                    w_valid[x][y] = $urandom % 2;
                    l_valid[x][y] = $urandom % 2;
                end
            end
        end
    end

    // ===== Metrics collection =====
    logic [31:0] total_mac_ops = 0;
    logic [31:0] total_noc_packets = 0;
    logic [31:0] total_stall_cycles = 0;

    // roofline metrics (ejemplo simple)
    always @(posedge clk) begin
        total_mac_ops      <= total_mac_ops + 0; // placeholder
        total_noc_packets  <= total_noc_packets + 0;
        total_stall_cycles <= total_stall_cycles + 0;
    end

endmodule
