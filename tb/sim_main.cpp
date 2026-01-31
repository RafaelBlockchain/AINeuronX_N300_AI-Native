#include "verilated.h"
#include "verilated_vcd_c.h"

// Try including both possible TB headers
#include "VAINeuronX_N200_TB.h"
#include "VAINeuronX_ARRAY_TB.h"

// ======================================================
// Select TopType based on which header exists
// ======================================================
#ifdef _VAINeuronX_N200_TB_H_
    using TopType = VAINeuronX_N200_TB;
    const char* TOP_NAME = "N200_CORE_TB";
#elif defined(_VAINeuronX_ARRAY_TB_H_)
    using TopType = VAINeuronX_ARRAY_TB;
    const char* TOP_NAME = "ARRAY_TB";
#else
    #error "No valid Verilator TB header found"
#endif

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    // ================= Instantiate TB =================
    TopType* tb = new TopType;

    // ================= Enable tracing =================
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("wave.vcd");

    // ================= Simulation loop =================
    vluint64_t sim_time = 0;
    while (!Verilated::gotFinish()) {
        tb->eval();
        tfp->dump(sim_time);
        sim_time++;
    }

    // ================= Cleanup =================
    tfp->close();
    delete tb;
    delete tfp;

    VL_PRINTF("✔ Simulation finished (%s)\n", TOP_NAME);
    return 0;
}
