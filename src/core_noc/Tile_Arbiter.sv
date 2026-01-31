module Tile_Arbiter #(
    parameter PORTS = 5
)(
    input  logic             clk,
    input  logic             rst_n,
    input  logic [PORTS-1:0] req,
    output logic [PORTS-1:0] grant
);

    logic [$clog2(PORTS)-1:0] rr_ptr;
    integer i;
    logic granted;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rr_ptr <= 0;
        else if (|grant)
            rr_ptr <= rr_ptr + 1;
    end

    always_comb begin
        grant   = '0;
        granted = 0;

        for (i = 0; i < PORTS; i = i + 1) begin
            int idx;
            idx = (rr_ptr + i) % PORTS;

            if (!granted && req[idx]) begin
                grant[idx] = 1'b1;
                granted   = 1'b1;
            end
        end
    end

endmodule
