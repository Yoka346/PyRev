#pragma once
#include <cstdint>

namespace reversi
{
	uint64_t calc_flip_discs(const uint64_t& p, const uint64_t& o, const int8_t& coord);
}