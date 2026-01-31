module tile_router_v2 #(parameter W=64)(
  input  logic clk, rst,

  input  logic [4:0] in_valid,
  input  logic [4:0][W-1:0] in_data,
  output logic [4:0] in_ready,

  output logic [4:0] out_valid,
  output logic [4:0][W-1:0] out_data,
  input  logic [4:0] out_ready
);
  genvar i;
  generate
    for(i=0;i<5;i++) begin
      assign out_valid[i] = in_valid[i];
      assign out_data[i]  = in_data[i];
      assign in_ready[i]  = out_ready[i];
    end
  endgenerate
endmodule
