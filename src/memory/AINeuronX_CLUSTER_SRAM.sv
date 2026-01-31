module AINeuronX_CLUSTER_SRAM #(
    parameter DW = 128,
    parameter ADDR_W = 16,
    parameter BANKS = 8,
    parameter DEPTH = 4096   // palabras por banco
)(
    input  logic clk,
    input  logic rst_n,

    // Read
    input  logic rd_valid,
    input  logic [ADDR_W-1:0] rd_addr,
    output logic rd_ready,
    output logic rd_valid_out,
    output logic [DW-1:0] rd_data,

    // Write
    input  logic wr_valid,
    input  logic [ADDR_W-1:0] wr_addr,
    input  logic [DW-1:0] wr_data,
    output logic wr_ready
);

    localparam BANK_W = $clog2(BANKS);

    logic [DW-1:0] mem [BANKS-1:0][DEPTH-1:0];

    logic [BANK_W-1:0] rd_bank, wr_bank;
    logic [$clog2(DEPTH)-1:0] rd_idx, wr_idx;

    assign rd_bank = rd_addr[BANK_W-1:0];
    assign wr_bank = wr_addr[BANK_W-1:0];

    assign rd_idx  = rd_addr[ADDR_W-1:BANK_W];
    assign wr_idx  = wr_addr[ADDR_W-1:BANK_W];

    assign rd_ready = 1'b1;
    assign wr_ready = 1'b1;

    // WRITE
    always_ff @(posedge clk) begin
        if (wr_valid)
            mem[wr_bank][wr_idx] <= wr_data;
    end

    // READ (1-cycle latency)
    always_ff @(posedge clk) begin
        if (rd_valid)
            rd_data <= mem[rd_bank][rd_idx];
    end

    always_ff @(posedge clk) begin
        rd_valid_out <= rd_valid;
    end

endmodule
