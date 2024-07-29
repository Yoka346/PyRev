#pragma once
#include <cstdint>

namespace reversi
{
    struct __Move
    {
        int8_t coord;
        uint64_t flip;
    };
} 