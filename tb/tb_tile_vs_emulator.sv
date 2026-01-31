module tb_tile_vs_emulator;

    logic clk;
    logic reset;
    logic [31:0] instr;
    logic instr_valid;
    logic [31:0] cycle;
    logic stall;

    tile_top DUT (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .instr_valid(instr_valid),
        .cycle(cycle),
        .stall(stall)
    );

    /* Clock */
    always #5 clk = ~clk;

    /* Simple program (binario ISA v1.0) */
    logic [31:0] program [0:4];
    integer pc;

    initial begin
        program[0] = 32'h04123000; // SC_ADD
        program[1] = 32'h10000000; // V_ADD
        program[2] = 32'h20000000; // T_MATMUL
        program[3] = 32'h30000000; // DMA_LOAD
        program[4] = 32'h00000000; // NOP
    end

    initial begin
        clk = 0;
        reset = 1;
        instr_valid = 0;
        instr = 0;
        cycle = 0;
        pc = 0;

        #20 reset = 0;

        repeat (200) begin
            @(posedge clk);
            cycle <= cycle + 1;

            if (!stall && pc < 5) begin
                instr <= program[pc];
                instr_valid <= 1;
                pc <= pc + 1;
            end else begin
                instr_valid <= 0;
            end
        end

        $finish;
    end

endmodule
