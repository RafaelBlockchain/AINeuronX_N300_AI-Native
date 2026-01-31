`timescale 1ns/1ps

module tile_scratchpad #(
    parameter DATA_WIDTH = 16,
    parameter BANKS      = 8,
    parameter DEPTH      = 4096
)(
    input  logic clk,
    input  logic rst_n,

    // === Port 0: Tensor Core ===
    input  logic        p0_req,
    input  logic        p0_we,
    input  logic [15:0] p0_addr,
    input  logic [DATA_WIDTH-1:0] p0_wdata,
    output logic        p0_ready,
    output logic [DATA_WIDTH-1:0] p0_rdata,

    // === Port 1: DMA / NoC ===
    input  logic        p1_req,
    input  logic        p1_we,
    input  logic [15:0] p1_addr,
    input  logic [DATA_WIDTH-1:0] p1_wdata,
    output logic        p1_ready,
    output logic [DATA_WIDTH-1:0] p1_rdata,

    // === Port 2: Scalar ===
    input  logic        p2_req,
    input  logic        p2_we,
    input  logic [15:0] p2_addr,
    input  logic [DATA_WIDTH-1:0] p2_wdata,
    output logic        p2_ready,
    output logic [DATA_WIDTH-1:0] p2_rdata
);

    logic [2:0] req;
    logic [2:0] grant;

    assign req = {p2_req, p1_req, p0_req};

    tile_spad_arbiter arb (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant)
    );

    logic [2:0] bank_sel;
    logic [12:0] offset;

    always_comb begin
        if (grant[0]) begin
            bank_sel = p0_addr[15:13];
            offset   = p0_addr[12:0];
        end else if (grant[1]) begin
            bank_sel = p1_addr[15:13];
            offset   = p1_addr[12:0];
        end else begin
            bank_sel = p2_addr[15:13];
            offset   = p2_addr[12:0];
        end
    end

    logic [DATA_WIDTH-1:0] bank_rdata [0:BANKS-1];

    genvar i;
    generate
        for (i = 0; i < BANKS; i++) begin : BANKS_GEN
            tile_spad_bank #(
                .DATA_WIDTH(DATA_WIDTH),
                .DEPTH(DEPTH)
            ) bank (
                .clk(clk),
                .we((grant[0] & p0_we & (bank_sel == i)) |
                    (grant[1] & p1_we & (bank_sel == i)) |
                    (grant[2] & p2_we & (bank_sel == i))),
                .addr(offset),
                .wdata(grant[0] ? p0_wdata :
                       grant[1] ? p1_wdata : p2_wdata),
                .rdata(bank_rdata[i])
            );
        end
    endgenerate

    assign p0_ready = grant[0];
    assign p1_ready = grant[1];
    assign p2_ready = grant[2];

    assign p0_rdata = bank_rdata[bank_sel];
    assign p1_rdata = bank_rdata[bank_sel];
    assign p2_rdata = bank_rdata[bank_sel];

endmodule
