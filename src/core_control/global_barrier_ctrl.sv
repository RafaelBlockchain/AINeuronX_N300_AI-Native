module global_barrier_ctrl #(
    parameter int N_TILES = 16
)(
    input  logic                clk,
    input  logic                rst_n,

    input  logic [N_TILES-1:0]  barrier_arrive,
    output logic                barrier_release
);

    logic [N_TILES-1:0] arrived_mask;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            arrived_mask   <= '0;
            barrier_release <= 1'b0;
        end else begin
            arrived_mask <= arrived_mask | barrier_arrive;

            if (&arrived_mask) begin
                barrier_release <= 1'b1;
                arrived_mask    <= '0;   // reset for next barrier
            end else begin
                barrier_release <= 1'b0;
            end
        end
    end

endmodule
