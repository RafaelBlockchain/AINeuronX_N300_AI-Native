// src/core_noc/noc_types.sv
package noc_types;

parameter int DW = 32;      // payload
parameter int XW = 4;       // coord X
parameter int YW = 4;       // coord Y

typedef enum logic [1:0] {
    FLIT_DATA = 2'b00,
    FLIT_CTRL = 2'b01
} flit_type_t;

typedef struct packed {
    logic [DW-1:0] payload;
    logic [XW-1:0] dst_x;
    logic [YW-1:0] dst_y;
    flit_type_t    ftype;
    logic          qos;     // reservado (future adaptive / priority)
} flit_t;

endpackage
