module tensor_top (
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

    logic [13:0] v;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            v <= '0;
        else if (!stall)
            v <= {v[12:0], op_valid & op_ready};
    end

    assign stall    = v[13] & ~wb_ready;
    assign op_ready = ~stall;

    assign mem_req_valid = v[2];
    assign mem_addr      = 64'h1000;

    assign wb_valid = v[13];
    assign wb_addr  = 64'h2000;
    assign wb_data  = mem_rdata;

    assign done = wb_valid & wb_ready;

endmodule
