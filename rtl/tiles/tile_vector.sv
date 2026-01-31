`include "tile_if.sv"
module tile_vector (
  input  logic clk,
  input  logic rst_n,
  output tile_if_pkg::tile_status_t TC_STATUS,
  output tile_if_pkg::tile_type_t   TC_TYPE
);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) TC_STATUS <= tile_if_pkg::TILE_RESET;
    else        TC_STATUS <= tile_if_pkg::TILE_IDLE;
  end

  assign TC_TYPE = tile_if_pkg::TILE_VECTOR;
endmodule
