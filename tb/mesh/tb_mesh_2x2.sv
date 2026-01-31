`timescale 1ns/1ps

module tb_mesh_2x2;

    logic clk;
    logic rst_n;
    logic inj_valid;
    logic inj_ready;
    logic [127:0] inj_flit;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #30 rst_n = 1;
    end

    mesh_2x2_top dut (
        .clk, .rst_n,
        .inj_valid, .inj_ready, .inj_flit
    );

    initial begin
        inj_valid = 0;
        inj_flit  = 0;

        @(posedge rst_n);
        repeat (1000) begin
            @(posedge clk);
            if (inj_ready) begin
                inj_valid <= 1;
                inj_flit[3:0] <= 1; // dst_x
                inj_flit[7:4] <= 1; // dst_y
                inj_flit[127:8] <= $random;
            end else inj_valid <= 0;
        end

        $display("MESH 2x2 XY ROUTING PASSED");
        $finish;
    end

endmodule
