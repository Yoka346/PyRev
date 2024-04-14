#include "bitboard.h"
#include "utils/random.h"

using namespace reversi;
using namespace utils;

void __Bitboard::init_hash_rank(utils::Array<uint64_t, HASH_RANK_LEN_1>* hash_rank)
{
    Random rand;
    for (int i = 0; i < HASH_RANK_LEN_0; i++)
        for (int j = 0; j < HASH_RANK_LEN_1; j++)
            hash_rank[i][j] = rand.next_64();
}