module fifo_sync #(parameter W=64, D=4)(
  input  logic clk, rst,
  input  logic wr_valid,
  input  logic [W-1:0] wr_data,
  output logic wr_ready,
  input  logic rd_ready,
  output logic rd_valid,
  output logic [W-1:0] rd_data
);
  logic [W-1:0] mem[D];
  logic [$clog2(D):0] wptr, rptr, count;

  assign wr_ready = (count < D);
  assign rd_valid = (count > 0);
  assign rd_data  = mem[rptr];

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      wptr <= 0; rptr <= 0; count <= 0;
    end else begin
      if (wr_valid && wr_ready) begin
        mem[wptr] <= wr_data;
        wptr <= wptr + 1;
        count <= count + 1;
      end
      if (rd_valid && rd_ready) begin
        rptr <= rptr + 1;
        count <= count - 1;
      end
    end
  end
endmodule
