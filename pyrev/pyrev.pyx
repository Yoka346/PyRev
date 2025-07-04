from libc.stdint cimport int8_t, int32_t, uint64_t
from libcpp cimport bool as cbool
from libcpp.bit cimport popcount

import numpy as np
cimport numpy as np

BoardCoordinate = np.int8
DiscColor = np.int8
SquareOwner = np.int8

PASS_COORD = np.int8(64)
NULL_COORD = np.int8(65)

BLACK: DiscColor = np.int8(0)
WHITE: DiscColor = np.int8(1)
NULL_COLOR: DiscColor = np.int8(2)

PLAYER: SquareOwner = np.int8(0)
OPPONENT: SquareOwner = np.int8(1)
NULL_OWNER: SquareOwner = np.int8(2)

BOARD_SIZE = np.int32(8)
NUM_SQUARES = BOARD_SIZE * BOARD_SIZE

A1 = np.int8(0)
B1 = np.int8(1)
C1 = np.int8(2)
D1 = np.int8(3)
E1 = np.int8(4)
F1 = np.int8(5)
G1 = np.int8(6)
H1 = np.int8(7)
A2 = np.int8(8)
B2 = np.int8(9)
C2 = np.int8(10)
D2 = np.int8(11)
E2 = np.int8(12)
F2 = np.int8(13)
G2 = np.int8(14)
H2 = np.int8(15)
A3 = np.int8(16)
B3 = np.int8(17)
C3 = np.int8(18)
D3 = np.int8(19)
E3 = np.int8(20)
F3 = np.int8(21)
G3 = np.int8(22)
H3 = np.int8(23)
A4 = np.int8(24)
B4 = np.int8(25)
C4 = np.int8(26)
D4 = np.int8(27)
E4 = np.int8(28)
F4 = np.int8(29)
G4 = np.int8(30)
H4 = np.int8(31)
A5 = np.int8(32)
B5 = np.int8(33)
C5 = np.int8(34)
D5 = np.int8(35)
E5 = np.int8(36)
F5 = np.int8(37)
G5 = np.int8(38)
H5 = np.int8(39)
A6 = np.int8(40)
B6 = np.int8(41)
C6 = np.int8(42)
D6 = np.int8(43)
E6 = np.int8(44)
F6 = np.int8(45)
G6 = np.int8(46)
H6 = np.int8(47)
A7 = np.int8(48)
B7 = np.int8(49)
C7 = np.int8(50)
D7 = np.int8(51)
E7 = np.int8(52)
F7 = np.int8(53)
G7 = np.int8(54)
H7 = np.int8(55)
A8 = np.int8(56)
B8 = np.int8(57)
C8 = np.int8(58)
D8 = np.int8(59)
E8 = np.int8(60)
F8 = np.int8(61)
G8 = np.int8(62)
H8 = np.int8(63)
PASS_COORD = np.int8(64)
NULL_COORD = np.int8(65)


def disc_color_to_str(color: DiscColor) -> str:
	if color == NULL_COLOR:
		return "Null"
	return "Black" if color == BLACK else "White"


def to_opponent_color(color: DiscColor):
	return DiscColor(color ^ WHITE)


def parse_coord_str(s: str) -> BoardCoordinate:
	s = s.strip().lower()

	if s == "pass" or s == "pa":
		return 64

	if s[0] < 'a' or s[0] > chr(ord('a') + 7) or s[1] < '1' or s[1] > '8':
		return NULL_COORD

	x = ord(s[0]) - ord('a')
	y = int(s[1:2]) - 1

	return BoardCoordinate(x + y * 8)


def coord_to_str(coord: BoardCoordinate) -> str:
	if coord == PASS_COORD:
		return "pass"

	x, y = coord % 8, coord // 8
	return str(f"{chr(ord('A') + x)}{y + 1}")


cdef extern from "cpp/config.h":
	cdef void __print_intrin()


def print_intrin():
	__print_intrin()


cdef extern from "cpp/constant.h" namespace "reversi":
	cdef int8_t __mirror_coord_horizontal(int8_t coord)
	cdef int8_t __mirror_coord_verical(int8_t coord)
	cdef int8_t __mirror_coord_diag_a1h8(int8_t coord)
	cdef int8_t __mirror_coord_diag_a8h1(int8_t coord) 
	cdef int8_t __rotate_coord_clockwise(int8_t coord) 


def mirror_coord_horizontal(coord):
	return __mirror_coord_horizontal(coord)

def mirror_coord_verical(coord):
	return __mirror_coord_verical(coord)

def mirror_coord_diag_a1a8(coord):
	return __mirror_coord_diag_a1h8(coord)

def mirror_coord_diag_a8h1(coord):
	return __mirror_coord_diag_a8h1(coord)

def rotate_coord_clockwise(coord):
	return __rotate_coord_clockwise(coord)


cdef extern from "cpp/bitboard.h" namespace "reversi":
	cdef cppclass __Bitboard:
		uint64_t player
		uint64_t opponent

		__Bitboard() except +
		__Bitboard(uint64_t player, uint64_t opponent) except +
		uint64_t player_masked(uint64_t mask) const 
		uint64_t opponent_masked(uint64_t mask) const 
		uint64_t discs()
		uint64_t empties()
		int32_t player_disc_count()
		int32_t opponent_disc_count()
		int32_t disc_count()
		int32_t empty_count()
		uint64_t calc_player_mobility()
		uint64_t calc_opponent_mobility()
		uint64_t calc_flip_discs(const int8_t& coord)
		int32_t get_square_owner_at(int8_t coord) const
		void put_player_disc_at(int8_t coord)
		void put_opponent_disc_at(int8_t coord)
		void remove_disc_at(int8_t coord)
		void update(const int8_t& coord, const uint64_t& flip)
		void undo(const int8_t& coord, const uint64_t& flip)
		void swap()
		void mirror_vertical()
		void mirror_horizontal()
		void mirror_diag_a1h8()
		void mirror_diag_a8h1()
		void rotate_clockwise()
		uint64_t calc_hash_code() const


cdef extern from "cpp/coordinate_iterator.h" namespace "reversi":
	cdef cppclass __CoordinateIterator:
		__CoordinateIterator()
		__CoordinateIterator(const uint64_t bits) except +
		cbool end() const 
		int8_t next()
		int size() const

	
cdef class BoardCoordinateIterator:
	cdef __CoordinateIterator __this

	def __cinit__(self, bits):
		self.__this = __CoordinateIterator(bits)

	def __iter__(self):
		return self

	def __next__(self):
		if self.__this.end():
			raise StopIteration()
		return BoardCoordinate(self.__this.next())

	def __len__(self):
		return self.__this.size()


cdef class Position:
	cdef __Bitboard __bb
	cdef int8_t __side_to_move

	def __cinit__(self, bb: tuple[np.uint64, np.uint64]=None, side_to_move=BLACK):
		if bb is None:
			self.clear()
		else:
			self.__bb = __Bitboard(bb[0], bb[1])
			self.__side_to_move = side_to_move
		
	def clear(self):
		cdef uint64_t player
		cdef uint64_t opponent

		player = np.int64(1) << parse_coord_str("E4") | np.int64(1) << parse_coord_str("D5")
		opponent = np.int64(1) << parse_coord_str("D4") | np.int64(1) << parse_coord_str("E5")
		self.__bb = __Bitboard(player, opponent)
		self.__side_to_move = BLACK

	@property
	def bitboard(self) -> tuple[np.uint64, np.uint64]:
		return np.uint64(self.__bb.player), np.uint64(self.__bb.opponent)

	@property
	def side_to_move(self) -> DiscColor:
		return DiscColor(self.__side_to_move)

	@property
	def empty_square_count(self) -> int:
		return self.__bb.empty_count()

	@property
	def player_disc_count(self) -> int:
		return self.__bb.player_disc_count()

	@property
	def opponent_disc_count(self) -> int:
		return self.__bb.opponent_disc_count()

	@property
	def disc_count(self) -> int:
		return self.__bb.disc_count()

	def get_player_masked_bitboard(self, mask: np.uint64) -> np.uint64:
		self.__bb.player_masked(mask)

	def get_opponent_masked_bitboard(self, mask: np.uint64) -> np.uint64:
		self.__bb.opponent_masked(mask)

	def get_masked_bitboard_of(self, color: DiscColor, mask: np.uint64) -> np.uint64:
		if color == self.__side_to_move:
			return self.__bb.player_masked(mask)
		else:
			return self.__bb.opponent_masked(mask)

	def get_disc_count_of(self, color: DiscColor) -> int:
		if color == self.__side_to_move:
			return self.__bb.player_disc_count()

		if color == to_opponent_color(self.__side_to_move):
			return self.__bb.opponent_disc_count()
			
		return 0

	def copy_to(self, dest: Position):
		dest.__bb = __Bitboard(self.__bb.player, self.__bb.opponent)
		dest.__side_to_move = self.__side_to_move

	def copy(self):
		pos = Position()
		self.copy_to(pos)
		return pos

	def mirror_vertical(self):
		self.__bb.mirror_vertical()

	def mirror_horizontal(self):
		self.__bb.mirror_horizontal()

	def mirror_diag_a1h8(self):
		self.__bb.mirror_diag_a1h8()

	def mirror_diag_a8h1(self):
		self.__bb.mirror_diag_a8h1()

	def rotate_clockwise(self):
		self.__bb.rotate_clockwise()

	def get_square_owner_at(self, coord: BoardCoordinate) -> SquareOwner:
		return SquareOwner(self.__bb.get_square_owner_at(coord))

	def get_square_color_at(self, coord: BoardCoordinate) -> DiscColor:
		owner = self.get_square_owner_at(coord)
		if owner == NULL_OWNER:
			return NULL_OWNER
		return self.__side_to_move if owner == PLAYER else to_opponent_color(self.__side_to_move)

	def get_player_disc_coords(self) -> BoardCoordinateIterator:
		return BoardCoordinateIterator(self.__bb.player)

	def get_opponent_disc_coords(self) -> BoardCoordinateIterator:
		return BoardCoordinateIterator(self.__bb.opponent)

	def get_empty_square_coords(self) -> BoardCoordinateIterator:
		return BoardCoordinateIterator(self.__bb.empties())

	def __eq__(self, rhs: Position) -> bool:
		return self.__side_to_move == rhs.__side_to_move and self.__bb.player == rhs.__bb.player and self.__bb.opponent == rhs.__bb.opponent

	def __str__(self) -> str:
		s = ["  "]
		for i in range(BOARD_SIZE):
			s.append(chr(ord('A') + i))
			s.append(" ")

		cdef uint64_t p = self.__bb.player
		cdef uint64_t o = self.__bb.opponent
		cdef int8_t side_to_move = self.__side_to_move
		cdef uint64_t mask = 1
		for y in range(BOARD_SIZE):
			s.append("\n")
			s.append(str(y + 1))
			s.append(" ")
			for _ in range(BOARD_SIZE):
				if p & mask:
					if side_to_move == BLACK:
						s.append("*")
					else:
						s.append("O")
				elif o & mask:
					if side_to_move == BLACK:
						s.append("O")
					else:
						s.append("*")
				else:
					s.append("-")

				s.append(" ")
				
				mask <<= 1
		
		return "".join(s)

	def put_player_disc_at(self, coord: BoardCoordinate):
		self.__bb.put_player_disc_at(coord)

	def put_opponent_disc_at(self, coord: BoardCoordinate):
		self.__bb.put_player_disc_at(coord)

	def remove_disc_at(self, coord: BoardCoordinate):
		self.__bb.remove_disc_at(coord)

	def is_gameover(self) -> bool:
		return popcount(self.__bb.calc_player_mobility()) == 0 \
		and popcount(self.__bb.calc_opponent_mobility()) == 0

	def get_score(self):
		return self.__bb.player_disc_count() - self.__bb.opponent_disc_count()

	def get_score_from(self, color: DiscColor):
		score = self.get_score()
		return score if self.__side_to_move == color else -score

	def can_pass(self) -> bool:
		return popcount(self.__bb.calc_player_mobility()) == 0 \
		and popcount(self.__bb.calc_opponent_mobility()) != 0

	def is_legal(self, coord: BoardCoordinate) -> bool:
		cdef uint64_t moves = self.__bb.calc_player_mobility()
		cdef int32_t c = coord
		cdef uint64_t x = 1ULL << c
		return bool(moves & x)

	def do_pass(self):
		self.__side_to_move = to_opponent_color(self.__side_to_move)
		self.__bb.swap()

	def get_legal_moves(self) -> BoardCoordinateIterator:
		return BoardCoordinateIterator(self.__bb.calc_player_mobility())

	def calc_flip_discs(self, coord: BoardCoordinate):
		return np.int64(self.__bb.calc_flip_discs(coord))

	def do_move(self, coord: BoardCoordinate, flip):
		self.__bb.update(coord, flip)
		self.__side_to_move = to_opponent_color(self.__side_to_move)

	def do_move_at(self, coord: BoardCoordinate):
		if coord == PASS_COORD:
			if not self.can_pass():
				return False
			self.do_pass()

		cdef uint64_t moves = self.__bb.calc_player_mobility()
		cdef int32_t c = coord
		cdef uint64_t x = 1ULL << c
		if not (moves & x):
			return False

		self.do_move(coord, self.calc_flip_discs(coord))
		return True

	def calc_hash_code(self) -> np.uint64:
		return np.uint64(self.__bb.calc_hash_code())
	