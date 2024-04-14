#pragma once
#include "constant.h"
#include "mobility.h"
#include "flip.h"

#include "utils/array.h"
#include "utils/unroller.h"

namespace reversi
{
    struct __Bitboard
    {
    private:
        static constexpr size_t HASH_RANK_LEN_0 = 16;
        static constexpr size_t HASH_RANK_LEN_1 = 256;

        // 局面のハッシュ値を求める際に用いる乱数表. 盤面のランクがキーとなっている.
        // ランクとはチェス用語で盤面の水平方向のライン.
        static utils::Array<uint64_t, HASH_RANK_LEN_0, HASH_RANK_LEN_1> HASH_RANK;

    public:
        uint64_t player;
        uint64_t opponent;

        static void init_hash_rank(utils::Array<uint64_t, __Bitboard::HASH_RANK_LEN_1>* hash_rank);

		__Bitboard() : player(0ULL), opponent(0ULL) { }
        __Bitboard(uint64_t player, uint64_t opponent) : player(player), opponent(opponent) {  }
		uint64_t discs() const { return this->player | this->opponent; }
		uint64_t empties() const { return ~discs(); }
		int32_t player_disc_count() const { return std::popcount(this->player); }
		int32_t opponent_disc_count() const { return std::popcount(this->opponent); }
		int32_t disc_count() const { return std::popcount(discs()); }
		int32_t empty_count() const { return std::popcount(empties()); }
		uint64_t calc_player_mobility() const { return calc_mobility(this->player, this->opponent); }
		uint64_t calc_opponent_mobility() const { return calc_mobility(this->opponent, this->player); }
		uint64_t calc_flip_discs(const int8_t& coord) const { return reversi::calc_flip_discs(this->player, this->opponent, coord); }
		int32_t get_square_owner_at(int8_t coord) const { return 2 - 2 * ((this->player >> coord) & 1) - ((this->opponent >> coord) & 1);}

        void put_player_disc_at(int8_t coord)
		{
			uint64_t bit = COORD_TO_BIT[coord];
			this->player |= bit;

			if (this->opponent & bit)
				this->opponent ^= bit;
		}

		void put_opponent_disc_at(int8_t coord)
		{
			uint64_t bit = COORD_TO_BIT[coord];
			this->opponent |= bit;

			if (this->player & bit)
				this->player ^= bit;
		}

		void remove_disc_at(int8_t coord)
		{
			uint64_t bit = COORD_TO_BIT[coord];
			if (this->player & bit)
				this->player ^= bit;

			if (this->opponent & bit)
				this->opponent ^= bit;
		}

		void update(const int8_t& coord, const uint64_t& flip)
		{
			uint64_t player = this->player;
			this->player = this->opponent ^ flip;
			this->opponent = player | (COORD_TO_BIT[coord] | flip);
		}

		void undo(const int8_t& coord, const uint64_t& flip)
		{
			uint64_t player = this->player;
			this->player = this->opponent ^ (COORD_TO_BIT[coord] | flip);
			this->opponent = player | flip;
		}

		void swap()
		{
			uint64_t tmp = this->player;
			this->player = this->opponent;
			this->opponent = tmp;
		}

		uint64_t calc_hash_code() const
		{
			auto p = reinterpret_cast<const uint8_t*>(this);
			auto h0 = 0ULL;
			auto h1 = 0ULL;
			utils::LoopUnroller<8>()(
				[&](const int32_t i)
				{
					const auto j = static_cast<size_t>(i) << 1;
                    h0 ^= HASH_RANK[j][p[j]];
                    h1 ^= HASH_RANK[j + 1][p[j + 1]];
				});
			return h0 ^ h1;
		}
    };
}