module vc_allocator #(parameter VC=2)(
  input  logic [VC-1:0] req,
  output logic [VC-1:0] grant
);
  integer i;
  always_comb begin
    grant='0;
    for(i=0;i<VC;i++)
      if(req[i]) begin
        grant[i]=1;
        break;
      end
  end
endmodule
