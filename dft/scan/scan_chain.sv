module scan_chain #(
    parameter WIDTH = 64
)(
    input  logic              clk,
    input  logic              scan_enable,
    input  logic              scan_in,
    input  logic [WIDTH-1:0]  data_in,
    output logic              scan_out,
    output logic [WIDTH-1:0]  data_out
);

    logic [WIDTH-1:0] shift_reg;

    always_ff @(posedge clk) begin
        if (scan_enable) begin
            shift_reg <= {shift_reg[WIDTH-2:0], scan_in};
        end else begin
            shift_reg <= data_in;
        end
    end

    assign scan_out = shift_reg[WIDTH-1];
    assign data_out = shift_reg;

endmodule
