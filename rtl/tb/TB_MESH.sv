`timescale 1ns/1ps

module TB_MESH;

    parameter CMD_W = 64;
    parameter NX = 2;
    parameter NY = 2;
    parameter NT = NX*NY;

    /* =========================
       Clock / Reset
       ========================= */
    logic clk;
    logic rst;

    always #5 clk = ~clk; // 100 MHz

    /* =========================
       NoC wires (simple broadcast / collect)
       ========================= */
    logic [NT-1:0]              noc_in_valid;
    logic [NT-1:0][CMD_W-1:0]   noc_in_cmd;

    logic [NT-1:0]              noc_out_valid;
    logic [NT-1:0][CMD_W-1:0]   noc_out_cmd;

    /* =========================
       Tiles
       ========================= */
    genvar i;
    generate
        for (i = 0; i < NT; i++) begin : TILE_ARRAY
            Tile_Top #(
                .TILE_ID(i),
                .CMD_W  (CMD_W)
            ) tile (
                .clk          (clk),
                .rst          (rst),
                .noc_in_valid (noc_in_valid[i]),
                .noc_in_cmd   (noc_in_cmd[i]),
                .noc_out_valid(noc_out_valid[i]),
                .noc_out_cmd  (noc_out_cmd[i])
            );
        end
    endgenerate

    /* =========================
       Simple NoC model (v0)
       - round-robin forward
       ========================= */
    integer rr_ptr;

    always_ff @(posedge clk) begin
        if (rst) begin
            rr_ptr <= 0;
            for (int t = 0; t < NT; t++) begin
                noc_in_valid[t] <= 1'b0;
                noc_in_cmd[t]   <= '0;
            end
        end else begin
            // clear inputs
            for (int t = 0; t < NT; t++) begin
                noc_in_valid[t] <= 1'b0;
            end

            // forward one outgoing cmd per cycle
            if (noc_out_valid[rr_ptr]) begin
                int dst;
                dst = noc_out_cmd[rr_ptr][15:8] % NT; // simple dst encoding
                noc_in_valid[dst] <= 1'b1;
                noc_in_cmd[dst]   <= noc_out_cmd[rr_ptr];
            end

            rr_ptr <= (rr_ptr + 1) % NT;
        end
    end

    /* =========================
       Task: inject command
       ========================= */
    task inject_cmd(
        input int tile_id,
        input [CMD_W-1:0] cmd
    );
        begin
            @(posedge clk);
            noc_in_valid[tile_id] <= 1'b1;
            noc_in_cmd[tile_id]   <= cmd;
            @(posedge clk);
            noc_in_valid[tile_id] <= 1'b0;
        end
    endtask

    /* =========================
       Test sequence
       ========================= */
    initial begin
        $display("==== TB_MESH 2x2 START ====");

        clk = 0;
        rst = 1;
        rr_ptr = 0;

        for (int t = 0; t < NT; t++) begin
            noc_in_valid[t] = 0;
            noc_in_cmd[t]   = 0;
        end

        repeat (5) @(posedge clk);
        rst = 0;

        /* -------------------------
           Inject compute on all tiles
           ------------------------- */
        for (int t = 0; t < NT; t++) begin
            $display("[TB] Inject COMPUTE to tile %0d", t);
            inject_cmd(t, {
                8'h01,           // opcode compute
                8'h01,           // src0
                8'h02,           // src1
                8'(t),            // dst
                32'd0
            });
        end

        repeat (10) @(posedge clk);

        /* -------------------------
           Inject routed traffic
           opcode >= 0x80
           ------------------------- */
        for (int t = 0; t < NT; t++) begin
            $display("[TB] Inject ROUTE from tile %0d", t);
            inject_cmd(t, {
                8'h90,           // opcode route
                8'(t),            // src0
                8'(t+1),          // src1
                8'h00,           // dst (encoded in [15:8])
                32'd0
            });
        end

        repeat (50) @(posedge clk);

        $display("==== TB_MESH END (no deadlock) ====");
        $finish;
    end

    /* =========================
       Monitors
       ========================= */
    always @(posedge clk) begin
        for (int t = 0; t < NT; t++) begin
            if (noc_out_valid[t]) begin
                $display("[TB][%0t] Tile %0d OUT %h",
                         $time, t, noc_out_cmd[t]);
            end
        end
    end

endmodule
