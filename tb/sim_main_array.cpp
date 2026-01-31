#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VAINeuronX_ARRAY_2x2_TB.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    VAINeuronX_ARRAY_2x2_TB* tb = new VAINeuronX_ARRAY_2x2_TB;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("wave_array_2x2.vcd");

    vluint64_t sim_time = 0;

    while (!Verilated::gotFinish()) {
        tb->eval();
        tfp->dump(sim_time);
        sim_time++;
    }

    tfp->close();
    delete tb;
    delete tfp;

    printf("✔ ARRAY 2x2 simulation finished\n");
    return 0;
}
