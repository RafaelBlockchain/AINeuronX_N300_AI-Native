module tile_noc_adapter #(parameter W=64)(
  input  logic clk, rst,

  input  logic tile_valid,
  input  logic [W-1:0] tile_data,
  output logic tile_ready,

  output logic noc_valid,
  output logic [W-1:0] noc_data,
  input  logic noc_ready,

  input  logic noc_in_valid,
  input  logic [W-1:0] noc_in_data,
  output logic noc_in_ready,

  output logic tile_out_valid,
  output logic [W-1:0] tile_out_data,
  input  logic tile_out_ready
);
  assign noc_valid   = tile_valid;
  assign noc_data    = tile_data;
  assign tile_ready  = noc_ready;

  assign tile_out_valid = noc_in_valid;
  assign tile_out_data  = noc_in_data;
  assign noc_in_ready   = tile_out_ready;
endmodule
