`include "tile_if.sv"

module aineuronx_top (
  input logic clk,
  input logic rst_n
);

  parameter int NUM_TILES = 3;

  tile_if_pkg::tile_status_t TC_STATUS [NUM_TILES];
  tile_if_pkg::tile_type_t   TC_TYPE   [NUM_TILES];

  tile_tensor  t0 (.clk(clk), .rst_n(rst_n), .TC_STATUS(TC_STATUS[0]), .TC_TYPE(TC_TYPE[0]));
  tile_vector  t1 (.clk(clk), .rst_n(rst_n), .TC_STATUS(TC_STATUS[1]), .TC_TYPE(TC_TYPE[1]));
  tile_control t2 (.clk(clk), .rst_n(rst_n), .TC_STATUS(TC_STATUS[2]), .TC_TYPE(TC_TYPE[2]));

  noc_mesh noc (.total_flits());

endmodule
