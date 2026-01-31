#pragma once
#include <vector>

struct Task {
    int cluster_id;
    int subarray_id;
    bool fp16; // true = FP16, false = FP8
};

class Scheduler {
public:
    Scheduler(int num_clusters, int subarrays_per_cluster);
    void add_task(Task t);
    void execute(); // placeholder: enviar tareas a RTL simulada
private:
    int clusters;
    int subarrays;
    std::vector<Task> task_queue;
};

