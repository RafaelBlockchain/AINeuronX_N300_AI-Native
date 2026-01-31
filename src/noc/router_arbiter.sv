module router_arbiter #(parameter N=5)(
  input  logic clk, rst,
  input  logic [N-1:0] req,
  output logic [N-1:0] grant
);
  integer i;
  always_comb begin
    grant = '0;
    for (i=0;i<N;i++)
      if (req[i]) begin
        grant[i]=1;
        break;
      end
  end
endmodule
