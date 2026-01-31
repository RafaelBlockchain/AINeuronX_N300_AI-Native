// src/core_noc/route_xy.sv
import noc_types::*;

function automatic logic [4:0] route_xy(
    input flit_t flit,
    input logic [XW-1:0] X_ID,
    input logic [YW-1:0] Y_ID
);
    logic [4:0] req;

    begin
        req = 5'b0;

        if (flit.dst_x > X_ID)
            req[3] = 1'b1; // EAST
        else if (flit.dst_x < X_ID)
            req[4] = 1'b1; // WEST
        else if (flit.dst_y > Y_ID)
            req[2] = 1'b1; // SOUTH
        else if (flit.dst_y < Y_ID)
            req[1] = 1'b1; // NORTH
        else
            req[0] = 1'b1; // LOCAL

        return req;
    end
endfunction
