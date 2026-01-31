module power_gating_cell (
    input  logic power_enable,
    output logic power_on
);

    always_comb begin
        power_on = power_enable;
    end

endmodule
