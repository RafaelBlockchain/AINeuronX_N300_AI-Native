`include "noc_params.sv"

module mesh_noc #(
  parameter X = noc_params::MESH_X,
  parameter Y = noc_params::MESH_Y,
  parameter W = noc_params::FLIT_WIDTH
)(
  input logic clk, rst
);
  genvar x,y;

  generate
    for(x=0;x<X;x++)
      for(y=0;y<Y;y++) begin : ROUTERS
        tile_router_v2 #(W) r (
          .clk(clk),
          .rst(rst),
          .in_valid('0),
          .in_data('0),
          .in_ready(),
          .out_valid(),
          .out_data(),
          .out_ready('1)
        );
      end
  endgenerate
endmodule
