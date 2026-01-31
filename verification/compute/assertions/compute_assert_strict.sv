module compute_assert_strict (
    input logic clk,
    input logic rst_n,
    input logic op_valid,
    input logic op_ready,
    input logic done,
    input logic stall
);

    // Nunca emitir sin ready
    property no_issue_without_ready;
        @(posedge clk) disable iff(!rst_n)
        op_valid |-> op_ready;
    endproperty
    assert property(no_issue_without_ready);

    // Stall no debe borrar done
    property stall_preserves_done;
        @(posedge clk) disable iff(!rst_n)
        stall |-> !done;
    endproperty
    assert property(stall_preserves_done);

endmodule

