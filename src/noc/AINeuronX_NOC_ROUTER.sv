module AINeuronX_NOC_ROUTER #(
    parameter DW = 16
)(
    input  logic clk,
    input  logic rst_n,

    // Local (core)
    input  logic        l_valid,
    input  logic [DW-1:0] l_data,
    output logic        l_ready,

    // North
    input  logic        n_valid,
    input  logic [DW-1:0] n_data,
    output logic        n_ready,

    // South
    input  logic        s_valid,
    input  logic [DW-1:0] s_data,
    output logic        s_ready,

    // East
    input  logic        e_valid,
    input  logic [DW-1:0] e_data,
    output logic        e_ready,

    // West
    input  logic        w_valid,
    input  logic [DW-1:0] w_data,
    output logic        w_ready,

    // Output (simplificado: broadcast interno)
    output logic        out_valid,
    output logic [DW-1:0] out_data
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            out_valid <= 0;
            out_data  <= '0;
        end else begin
            // Prioridad simple (se mejora luego)
            if (l_valid) begin
                out_valid <= 1;
                out_data  <= l_data;
            end else if (n_valid) begin
                out_valid <= 1;
                out_data  <= n_data;
            end else if (s_valid) begin
                out_valid <= 1;
                out_data  <= s_data;
            end else if (e_valid) begin
                out_valid <= 1;
                out_data  <= e_data;
            end else if (w_valid) begin
                out_valid <= 1;
                out_data  <= w_data;
            end else begin
                out_valid <= 0;
            end
        end
    end

    assign l_ready = !out_valid;
    assign n_ready = !out_valid;
    assign s_ready = !out_valid;
    assign e_ready = !out_valid;
    assign w_ready = !out_valid;

endmodule
