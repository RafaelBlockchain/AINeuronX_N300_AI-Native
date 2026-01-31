module tile_metrics #(
    parameter TILE_ID = 0
)(
    input  logic clk,
    input  logic rst,

    input  logic instr_exec,
    input  logic route_event,
    input  logic stall_event,

    output logic [31:0] instr_count,
    output logic [31:0] route_count,
    output logic [31:0] stall_count
);

    always_ff @(posedge clk) begin
        if (rst) begin
            instr_count <= 0;
            route_count <= 0;
            stall_count <= 0;
        end else begin
            if (instr_exec) instr_count <= instr_count + 1;
            if (route_event) route_count <= route_count + 1;
            if (stall_event) stall_count <= stall_count + 1;
        end
    end

endmodule

