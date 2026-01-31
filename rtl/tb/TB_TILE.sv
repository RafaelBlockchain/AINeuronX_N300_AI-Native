`timescale 1ns/1ps

module TB_TILE;

    parameter CMD_W = 64;

    /* =========================
       Clock / Reset
       ========================= */
    logic clk;
    logic rst;

    always #5 clk = ~clk;   // 100 MHz

    /* =========================
       NoC interface
       ========================= */
    logic             noc_in_valid;
    logic [CMD_W-1:0] noc_in_cmd;

    logic             noc_out_valid;
    logic [CMD_W-1:0] noc_out_cmd;

    /* =========================
       DUT
       ========================= */
    Tile_Top #(
        .TILE_ID(0),
        .CMD_W(CMD_W)
    ) dut (
        .clk          (clk),
        .rst          (rst),
        .noc_in_valid (noc_in_valid),
        .noc_in_cmd   (noc_in_cmd),
        .noc_out_valid(noc_out_valid),
        .noc_out_cmd  (noc_out_cmd)
    );

    /* =========================
       Task: send command
       ========================= */
    task send_cmd(input [CMD_W-1:0] cmd);
        begin
            @(posedge clk);
            noc_in_valid <= 1'b1;
            noc_in_cmd   <= cmd;
            @(posedge clk);
            noc_in_valid <= 1'b0;
            noc_in_cmd   <= '0;
        end
    endtask

    /* =========================
       Test sequence
       ========================= */
    initial begin
        $display("==== TB_TILE START ====");

        clk = 0;
        rst = 1;
        noc_in_valid = 0;
        noc_in_cmd   = 0;

        repeat (5) @(posedge clk);
        rst = 0;

        /* -------------------------
           Compute instruction
           opcode < 0x80
           ------------------------- */
        $display("[TB] Sending COMPUTE instruction");
        send_cmd({
            8'h01,     // opcode
            8'h01,     // src0
            8'h02,     // src1
            8'h03,     // dst
            32'd0
        });

        repeat (5) @(posedge clk);

        /* -------------------------
           Route instruction
           opcode >= 0x80
           ------------------------- */
        $display("[TB] Sending ROUTE instruction");
        send_cmd({
            8'h90,     // opcode
            8'hAA,
            8'hBB,
            8'hCC,
            32'd0
        });

        repeat (10) @(posedge clk);

        $display("==== TB_TILE END ====");
        $finish;
    end

    /* =========================
       Monitors
       ========================= */
    always @(posedge clk) begin
        if (noc_out_valid) begin
            $display("[TB] NoC OUT CMD: %h", noc_out_cmd);
        end
    end

endmodule
