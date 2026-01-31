#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VAINeuronX_N200_TB.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    VAINeuronX_N200_TB* tb = new VAINeuronX_N200_TB;

    // Enable tracing
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("wave.vcd");

    // Simulation loop
    vluint64_t sim_time = 0;
    while (!Verilated::gotFinish()) {
        tb->eval();
        tfp->dump(sim_time);

        // 🔴 FIX CLAVE: avanzar tiempo real de Verilator
        Verilated::timeInc(1);

        sim_time++;
    }

    tfp->close();
    delete tb;
    delete tfp;

    VL_PRINTF("✔ Simulation finished (N200_CORE_TB)\n");
    return 0;
}
