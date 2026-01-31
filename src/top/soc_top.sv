`include "noc_params.sv"

module soc_top(
  input logic clk,
  input logic rst
);
  mesh_noc noc (
    .clk(clk),
    .rst(rst)
  );
endmodule
