import numpy as np

BoardCoordinate = np.int8
DiscColor = np.int8
SquareOwner = np.int8


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


def disc_color_to_str(color: DiscColor) -> str: ...
def to_opponent_color(color: DiscColor) -> DiscColor: ...
def parse_coord_str(s: str) -> BoardCoordinate: ...
def coord_to_str(coord: BoardCoordinate) -> str: ...


class BoardCoordinateIterator:
    def __cinit__(self, bits) -> None: ...
    def __iter__(self) -> BoardCoordinateIterator: ...
    def __next__(self) -> BoardCoordinate: ...
    def __len__(self) -> int: ...

class Position:
    def __cinit__(self) -> None: ...
    def clear(self) -> None: ...

    @property
    def side_to_move(self) -> DiscColor: ...

    @property
    def empty_square_count(self) -> int: ...

    @property
    def player_disc_count(self) -> int: ...

    @property
    def opponent_disc_count(self) -> int: ...

    @property
    def disc_count(self) -> int: ...

    def get_disc_count_of(self, color: DiscColor) -> int: ...
    def copy_to(self, dest: Position) -> None: ...
    def copy(self) -> None: ...
    def get_square_owner_at(self, coord: BoardCoordinate) -> SquareOwner: ...
    def get_square_color_at(self, coord: BoardCoordinate) -> DiscColor: ...
    def get_player_disc_coords(self) -> BoardCoordinateIterator: ...
    def get_opponent_disc_coords(self) -> BoardCoordinateIterator: ...
    def get_empty_square_coords(self) -> BoardCoordinateIterator: ...
    def __eq__(self, rhs: object) -> bool: ...
    def __str__(self) -> str: ...
    def put_player_disc_at(self, coord: BoardCoordinate) -> None: ...
    def put_opponent_disc_at(self, coord: BoardCoordinate) -> None: ...
    def remove_disc_at(self, coord: BoardCoordinate) -> None: ...
    def is_gameover(self) -> bool: ...
    def get_score(self) -> int: ...
    def get_score_from(self, color: DiscColor) -> int: ...
    def can_pass(self) -> bool: ...
    def is_legal(self, coord: BoardCoordinate) -> bool: ...
    def do_pass(self) -> bool: ...
    def get_legal_moves(self) -> BoardCoordinateIterator: ...
    def calc_flip_discs(self, coord: BoardCoordinate) -> np.int64: ...
    def do_move(self, coord: BoardCoordinate, flip: np.int64) -> None: ...
    def do_move_at(self, coord: BoardCoordinate) -> bool: ...
    def calc_hash_code(self) -> np.uint64: ...