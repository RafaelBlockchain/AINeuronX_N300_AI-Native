module AINeuronX_MAC_MON (
    input logic clk,
    input logic mac_fire,
    output int mac_count
);
    always_ff @(posedge clk)
        if (mac_fire)
            mac_count++;
endmodule
