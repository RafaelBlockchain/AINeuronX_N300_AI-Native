#include <vector>
#include <iostream>

class Vector {
public:
    Vector(size_t size) : v(size, 0) {}

    void add(const Vector& other) {
        for (size_t i = 0; i < v.size(); ++i)
            v[i] += other.v[i];
    }

    void print() const {
        for (auto x : v)
            std::cout << x << " ";
        std::cout << std::endl;
    }

private:
    std::vector<int> v;
};

int main() {
    Vector a(4), b(4);
    b.add(a);
    b.print();
    return 0;
}
