#pragma once
#include <cstdint>
#include <iostream>

#include "constant.h"
#include "utils/bitmanip.h"

namespace reversi
{
    class __CoordinateIterator
    {
    public:
        __CoordinateIterator() : bits(0ULL) { }
        __CoordinateIterator(const uint64_t bits) : bits(bits) { }

        bool end() const { return !this->bits; }

        int8_t next()
        {
            auto coord = (int8_t)FIND_FIRST_SET(this->bits);
            this->bits &= (this->bits - 1);
            return coord;
        }

        int size() const {return std::popcount(this->bits); }

    private:
        uint64_t bits;
    };
}