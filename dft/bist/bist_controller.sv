module bist_controller #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 64
)(
    input  logic                  clk,
    input  logic                  start,
    output logic                  done,
    output logic                  fail,
    output logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] pattern
);

    logic running;

    always_ff @(posedge clk) begin
        if (start) begin
            running <= 1'b1;
            addr    <= '0;
            fail    <= 1'b0;
            done    <= 1'b0;
        end else if (running) begin
            addr <= addr + 1;
            if (addr == {ADDR_WIDTH{1'b1}}) begin
                running <= 1'b0;
                done    <= 1'b1;
            end
        end
    end

    assign pattern = {DATA_WIDTH{1'b1}};

endmodule
