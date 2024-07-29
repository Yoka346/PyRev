#pragma once

#include "utils/array.h"

namespace reversi
{
	constexpr int32_t BOARD_SIZE = 8;
	constexpr int32_t SQUARE_NUM = BOARD_SIZE * BOARD_SIZE;
	constexpr int32_t MAX_MOVE_NUM = 34;
	constexpr int8_t PASS_COORD = 64;

	constexpr utils::Array<uint64_t, SQUARE_NUM + 1> COORD_TO_BIT(
		[](uint64_t* data, size_t len)
		{
			for (int32_t coord = 0; coord < SQUARE_NUM; coord++)
				data[coord] = 1ULL << coord;
			data[SQUARE_NUM] = 0ULL;
		});

	constexpr int8_t TO_HORIZONTAL_MIRROR_COORD[SQUARE_NUM] = 
	{
		7, 6, 5, 4, 3, 2, 1, 0,
		15, 14, 13, 12, 11, 10, 9, 8,
		23, 22, 21, 20, 19, 18, 17, 16,
		31, 30, 29, 28, 27, 26, 25, 24,
		39, 38, 37, 36, 35, 34, 33, 32,
		47, 46, 45, 44, 43, 42, 41, 40,
		55, 54, 53, 52, 51, 50, 49, 48,
		63, 62, 61, 60, 59, 58, 57, 56
	};

	constexpr int8_t TO_VERTICAL_MIRROR_COORD[SQUARE_NUM] = 
	{
		56, 57, 58, 59, 60, 61, 62, 63,
		48, 49, 50, 51, 52, 53, 54, 55,
		40, 41, 42, 43, 44, 45, 46, 47,
		32, 33, 34, 35, 36, 37, 38, 39,
		24, 25, 26, 27, 28, 29, 30, 31,
		16, 17, 18, 19, 20, 21, 22, 23,
		8, 9, 10, 11, 12, 13, 14, 15,
		0, 1, 2, 3, 4, 5, 6, 7
	};

	constexpr int8_t TO_DIAG_A1H8_MIRROR_COORD[SQUARE_NUM] =
	{
		0, 8, 16, 24, 32, 40, 48, 56,
		1, 9, 17, 25, 33, 41, 49, 57,
		2, 10, 18, 26, 34, 42, 50, 58,
		3, 11, 19, 27, 35, 43, 51, 59,
		4, 12, 20, 28, 36, 44, 52, 60,
		5, 13, 21, 29, 37, 45, 53, 61,
		6, 14, 22, 30, 38, 46, 54, 62,
		7, 15, 23, 31, 39, 47, 55, 63
	};

	static constexpr int8_t TO_DIAG_A8H1_MIRROR_COORD[SQUARE_NUM] =
	{
		63, 55, 47, 39, 31, 23, 15, 7,
		62, 54, 46, 38, 30, 22, 14, 6,
		61, 53, 45, 37, 29, 21, 13, 5,
		60, 52, 44, 36, 28, 20, 12, 4,
		59, 51, 43, 35, 27, 19, 11, 3,
		58, 50, 42, 34, 26, 18, 10, 2,
		57, 49, 41, 33, 25, 17, 9, 1,
		56, 48, 40, 32, 24, 16, 8, 0
	};

	constexpr int8_t TO_ROTATE_CLOCKWISE_COORD[SQUARE_NUM] =
	{
		7, 15, 23, 31, 39, 47, 55, 63,
		6, 14, 22, 30, 38, 46, 54, 62,
		5, 13, 21, 29, 37, 45, 53, 61,
		4, 12, 20, 28, 36, 44, 52, 60,
		3, 11, 19, 27, 35, 43, 51, 59,
		2, 10, 18, 26, 34, 42, 50, 58,
		1, 9, 17, 25, 33, 41, 49, 57,
		0, 8, 16, 24, 32, 40, 48, 56
	};

	inline int8_t __mirror_coord_horizontal(int8_t coord) { return TO_HORIZONTAL_MIRROR_COORD[coord]; }
	inline int8_t __mirror_coord_verical(int8_t coord) { return TO_VERTICAL_MIRROR_COORD[coord]; }
	inline int8_t __mirror_coord_diag_a1h8(int8_t coord) { return TO_DIAG_A1H8_MIRROR_COORD[coord]; }
	inline int8_t __mirror_coord_diag_a8h1(int8_t coord) { return TO_DIAG_A8H1_MIRROR_COORD[coord]; }
	inline int8_t __rotate_coord_clockwise(int8_t coord) { return TO_ROTATE_CLOCKWISE_COORD[coord]; }
}