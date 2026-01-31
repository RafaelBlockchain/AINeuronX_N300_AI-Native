module compute_top (
    input logic clk,
    input logic rst_n,

    input  logic        op_valid,
    output logic        op_ready,
    input  logic [3:0]  op_opcode,
    input  logic [2:0]  op_fmt,
    input  logic [7:0]  op_tile_cfg,

    output logic        mem_req_valid,
    input  logic        mem_req_ready,
    output logic [63:0] mem_addr,
    input  logic [255:0] mem_rdata,

    output logic        wb_valid,
    input  logic        wb_ready,
    output logic [63:0] wb_addr,
    output logic [255:0] wb_data,

    output logic done,
    output logic stall
);

    tensor_top tensor (
        .*  // interfaces frozen
    );

endmodule

