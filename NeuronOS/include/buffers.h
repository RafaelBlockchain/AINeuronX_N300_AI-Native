#pragma once
#include <vector>

class Buffer {
public:
    Buffer(int size);
    void write(int index, float value);
    float read(int index);
private:
    std::vector<float> data;
};

