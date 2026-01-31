module compute_assert (
    input logic clk,
    input logic rst_n,
    input logic done,
    input logic stall
);

    property no_double_done;
        @(posedge clk) disable iff(!rst_n)
        done |-> ##1 !done;
    endproperty

    assert property(no_double_done);

endmodule

