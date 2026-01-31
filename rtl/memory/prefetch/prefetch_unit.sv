module prefetch_unit #(
    parameter ADDR_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  req_valid,
    input  logic [ADDR_WIDTH-1:0] req_addr,
    output logic                  pf_valid,
    output logic [ADDR_WIDTH-1:0] pf_addr
);

    always_ff @(posedge clk) begin
        pf_valid <= req_valid;
        pf_addr  <= req_addr + 1;
    end

endmodule
