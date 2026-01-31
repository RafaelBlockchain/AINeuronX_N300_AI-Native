module noc_power_domain_ctrl (
    input  logic clk,
    input  logic rst_n,
    input  logic idle_region,
    output logic pwr_en,
    output logic iso_en,
    output logic ret_en
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwr_en <= 1'b1;
            iso_en <= 1'b0;
            ret_en <= 1'b0;
        end else if (idle_region) begin
            ret_en <= 1'b1;
            iso_en <= 1'b1;
            pwr_en <= 1'b0;
        end else begin
            pwr_en <= 1'b1;
            iso_en <= 1'b0;
            ret_en <= 1'b0;
        end
    end
endmodule

