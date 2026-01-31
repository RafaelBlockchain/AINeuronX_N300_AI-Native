#include "../include/scheduler.h"
#include <cassert>

int main() {
    Scheduler sched(2,2);
    sched.add_task({0,0,true});
    sched.add_task({1,1,false});
    sched.execute();

    assert(true); // placeholder: pruebas futuras más precisas
    return 0;
}

