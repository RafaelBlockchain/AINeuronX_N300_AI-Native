package flit_defs;
  parameter int FLIT_WIDTH = 64;

  typedef struct packed {
    logic [15:0] src_x;
    logic [15:0] src_y;
    logic [15:0] dst_x;
    logic [15:0] dst_y;
    logic [15:0] payload;
  } flit_t;
endpackage

