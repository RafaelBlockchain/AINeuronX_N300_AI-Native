module tile_mem #(parameter W=64, DEPTH=256)(
  input  logic clk,
  input  logic we,
  input  logic [$clog2(DEPTH)-1:0] addr,
  input  logic [W-1:0] wdata,
  output logic [W-1:0] rdata
);
  logic [W-1:0] mem[DEPTH];

  always_ff @(posedge clk) begin
    if (we)
      mem[addr] <= wdata;
    rdata <= mem[addr];
  end
endmodule
