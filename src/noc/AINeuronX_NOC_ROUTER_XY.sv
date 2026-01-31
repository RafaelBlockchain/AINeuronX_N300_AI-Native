module AINeuronX_NOC_ROUTER_XY #(
    parameter DW = 16,
    parameter X_ID = 0,
    parameter Y_ID = 0
)(
    input  logic clk,
    input  logic rst_n,

    // Local injection
    input  logic        l_valid,
    input  logic [DW-1:0] l_data,
    output logic        l_ready,

    // Neighbors
    input  logic        n_valid, s_valid, e_valid, w_valid,
    input  logic [DW-1:0] n_data, s_data, e_data, w_data,
    output logic        n_ready, s_ready, e_ready, w_ready,

    // Output
    output logic        out_valid,
    output logic [DW-1:0] out_data
);

    // Header format:
    // [15:12] DEST_X
    // [11:8 ] DEST_Y
    // [7:0  ] PAYLOAD

    logic [3:0] dest_x, dest_y;

    always_comb begin
        out_valid = 0;
        out_data  = '0;

        n_ready = 0;
        s_ready = 0;
        e_ready = 0;
        w_ready = 0;
        l_ready = 0;

        // Priority: Local > N > S > E > W
        if (l_valid) begin
            dest_x = l_data[15:12];
            dest_y = l_data[11:8];
            out_valid = 1;
            out_data  = l_data;
            l_ready   = 1;
        end
        else if (n_valid) begin
            out_valid = 1;
            out_data  = n_data;
            n_ready   = 1;
        end
        else if (s_valid) begin
            out_valid = 1;
            out_data  = s_data;
            s_ready   = 1;
        end
        else if (e_valid) begin
            out_valid = 1;
            out_data  = e_data;
            e_ready   = 1;
        end
        else if (w_valid) begin
            out_valid = 1;
            out_data  = w_data;
            w_ready   = 1;
        end
    end

endmodule
