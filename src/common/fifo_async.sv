module fifo_async #(parameter W=64)(
  input  logic wr_clk, rd_clk,
  input  logic wr_rst, rd_rst,
  input  logic wr_valid,
  input  logic [W-1:0] wr_data,
  output logic wr_ready,
  input  logic rd_ready,
  output logic rd_valid,
  output logic [W-1:0] rd_data
);
  logic full, empty;
  logic [W-1:0] buffer;

  assign wr_ready = !full;
  assign rd_valid = !empty;
  assign rd_data  = buffer;

  always_ff @(posedge wr_clk or posedge wr_rst) begin
    if (wr_rst) full <= 0;
    else if (wr_valid && wr_ready) full <= 1;
  end

  always_ff @(posedge rd_clk or posedge rd_rst) begin
    if (rd_rst) empty <= 1;
    else if (rd_valid && rd_ready) empty <= 1;
    else if (full) empty <= 0;
  end
endmodule
