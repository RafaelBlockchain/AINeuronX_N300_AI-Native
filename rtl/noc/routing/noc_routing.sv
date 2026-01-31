module noc_routing #(
    parameter X_ID = 0,
    parameter Y_ID = 0,
    parameter ADDR_WIDTH = 16
)(
    input  logic [ADDR_WIDTH-1:0] dest,
    output logic north,
    output logic south,
    output logic east,
    output logic west,
    output logic local
);

    wire [ADDR_WIDTH/2-1:0] dx = dest[ADDR_WIDTH-1:ADDR_WIDTH/2];
    wire [ADDR_WIDTH/2-1:0] dy = dest[ADDR_WIDTH/2-1:0];

    always_comb begin
        north = south = east = west = local = 0;

        if (dx == X_ID && dy == Y_ID)
            local = 1;
        else if (dx > X_ID)
            east = 1;
        else if (dx < X_ID)
            west = 1;
        else if (dy > Y_ID)
            north = 1;
        else
            south = 1;
    end

endmodule
