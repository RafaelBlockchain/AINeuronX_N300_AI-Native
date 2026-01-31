module noc_qos #(
    parameter PRIORITY_WIDTH = 2
)(
    input  logic [PRIORITY_WIDTH-1:0] prio_in,
    input  logic                      valid_in,
    output logic                      grant
);

    always_comb begin
        grant = valid_in && (prio_in != 0);
    end

endmodule
