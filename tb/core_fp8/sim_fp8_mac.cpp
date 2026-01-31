#include "VAINeuronX_FP8_MAC_TB.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    VAINeuronX_FP8_MAC_TB* tb = new VAINeuronX_FP8_MAC_TB;

    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("fp8_mac.vcd");

    tb->clk = 0;
    tb->rst_n = 0;
    tb->in_valid = 0;
    tb->clear_acc = 1;

    for (int i = 0; i < 500; i++) {
        tb->clk = !tb->clk;
        if (i == 2) tb->rst_n = 1;
        if (i > 2) {
            tb->in_valid = 1;
            tb->a_fp8 = rand() % 256;
            tb->b_fp8 = rand() % 256;
            tb->clear_acc = 0;
        }

        tb->eval();
        tfp->dump(i);
    }

    tfp->close();
    delete tb;
    return 0;
}
