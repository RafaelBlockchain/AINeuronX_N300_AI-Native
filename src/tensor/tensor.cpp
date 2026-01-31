#include <vector>
#include <iostream>

class Tensor {
public:
    Tensor(size_t size) : data(size, 0.0f) {}

    float& operator[](size_t i) {
        return data[i];
    }

    size_t size() const {
        return data.size();
    }

private:
    std::vector<float> data;
};

int main() {
    Tensor t(4);
    for (size_t i = 0; i < t.size(); ++i)
        t[i] = static_cast<float>(i);

    for (size_t i = 0; i < t.size(); ++i)
        std::cout << t[i] << " ";

    return 0;
}
