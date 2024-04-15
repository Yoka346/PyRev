# PyRev
Pythonから利用可能なリバーシ(オセロ)のライブラリです。局面管理、合法手列挙と裏返る石の高速な計算に対応しています。このライブラリを用いることで、Python(CPython)のみでリバーシの局面データを実装するよりも遥かに高速なリバーシの思考エンジンを開発できます。

## インストール
以下のコマンドを実行する前に、C/C++のコンパイラをインストールしてください。特にWindowsであれば、MSVCのcl.exeにパスを通しておいてください。

### Cythonのインストール
```
pip install cython
```

### NumPyのインストール
```
pip install numpy
```

### PyRevのインストール
```
pip install git+https://github.com/Yoka346/PyRev
```

Cythonがインストールされているのにも関わらず、PyRevのインストールの際に"No module named 'Cython'"というエラーが発生する場合があります。
その場合は以下のコマンドを実行し、pip、setuptools、wheelのアップデートをしてください。

```
pip install --upgrade pip setuptools wheel
```

```
pip install --upgrade cython
```

## 各種定数及び基本的な型

### BoardCoordinate型
盤面座標を表す整数値の型です。実体はnumpy.int8型であり、盤面座標は以下の順番で振られています。
盤面座標に限らず、多くの定数はできる限り小さいサイズの型で表現しています。思考エンジン開発においては、探索アルゴリズムを実装する際に、メモリ上に着手座標などの情報を大量に保持する場合(e.g. 置換表)があり、できる限り小さいデータ型を用いた方が有利だからです。

```
| 0| 1| 2| 3| 4| 5| 6| 7|
| 8| 9|10|11|12|13|14|15|
|16|17|18|19|20|21|22|23|
|24|25|26|27|28|29|30|31|
|32|33|34|35|36|37|38|39|
|40|41|42|43|44|45|46|47|
|48|49|50|51|52|53|54|55|
|56|57|58|59|60|61|62|63|

PASS_COORD = 64
NULL_COORD = 65
```

PASS_COORDはパスを表す特殊座標、NULL_COORDは無効な座標を表す特殊座標です。

また、各座標には、アルファベットと数字で表現される2次元座標が以下のように対応しています。

```
    A  B  C  D  E  F  G  H
1 | 0| 1| 2| 3| 4| 5| 6| 7|
2 | 8| 9|10|11|12|13|14|15|
3 |16|17|18|19|20|21|22|23|
4 |24|25|26|27|28|29|30|31|
5 |32|33|34|35|36|37|38|39|
6 |40|41|42|43|44|45|46|47|
7 |48|49|50|51|52|53|54|55|
8 |56|57|58|59|60|61|62|63|
```

これらの2次元座標をコード内でも利用できるように、全ての2次元座標は定数として定義されています。

```python
A1 = np.int8(0)
B1 = np.int8(1)
C1 = np.int8(2)
D1 = np.int8(3)
.
.
.
F8 = np.int8(61)
G8 = np.int8(62)
H8 = np.int8(63)
```

また、盤面座標は、parse_coord_str関数とcoord_to_str関数を用いて、文字列 <-> 盤面座標の相互変換を行うことができます。

```python
import pyrev

print(pyrev.F5)
print(pyrev.coord_to_str(pyrev.F5))
print(pyrev.parse_coord_str("F5"))
print(pyrev.parse_coord_str("f5"))


"""
result

37
F5
37
37
"""
```

### DiscColor型
Discとは、リバーシにおける石のことであり、その色を表現する型がDiscColor型です。実体はnumpy.int8型です。
それぞれの石の色は以下のように定義されています。

```python
BLACK: DiscColor = np.int8(0)
WHITE: DiscColor = np.int8(1)
NULL_COLOR: DiscColor = np.int8(2)
```

NULL_COLORは無効な色を表現する特殊値です。

DiscColorは、disc_color_to_str関数によって文字列に変換できます。
また、BLACK <-> WHITE間の変換は、to_opponent_color関数で行うことができます。ただし、to_opponent_color関数にNULL_COLORを与えた際の動作は未定義です。

```python
import pyrev

print(pyrev.disc_color_to_str(pyrev.BLACK))
print(pyrev.disc_color_to_str(pyrev.WHITE))

opp = pyrev.to_opponent_color(pyrev.BLACK)
print(pyrev.disc_color_to_str(opp))

opp = pyrev.to_opponent_color(pyrev.WHITE)
print(pyrev.disc_color_to_str(opp))

opp = pyrev.to_opponent_color(pyrev.NULL_COLOR) # undefined!

        
"""
result

Black
White
White
Black
"""
```

### SquareOwner型
Squareはマスを意味し、SquareOwnerはマスの所有者を表現する型です。SqureOwnerの実体はnumpy.int8型です。マスの所有者とは、そのマスに置かれている石の手番を意味し、現在の手番の石が置かれている場合はPLAYER、相手の石が置かれている場合はOPPONENTが所有者となります。空きマスの所有者はNULL_OWNERです。DiscColor以外にわざわざSquareOwnerを用意している理由は、石の色は大事ではないが、そのマスにある石が現在の手番の石なのか相手の石なのかは知りたいという状況が往々にしてあるためです。また、本ライブラリの実装上、あるマスにある石の色を確認するよりも、そのマスの所有者を確認する方が、条件分岐無しにチェックすることができ僅かに高速です。

```python
PLAYER: SquareOwner = np.int8(0)
OPPONENT: SquareOwner = np.int8(1)
NULL_OWNER: SquareOwner = np.int8(2)
```

## BoardCoordinateIteratorクラス
本ライブラリにおいて、合法手の座標リストや裏返る石の座標リストは、Pythonのlistではなく、64bit整数によって表現されます。例えば、64bit整数のLSBからみてm, n, k番目のビットが1であるとき、
その64bit整数で表現されるリストには、座標m, n, kが格納されていることを意味します。 
BoardCoordinateIteratorクラスは、このように64bit整数で表現された座標リストから、BoardCoordinate型の座標を列挙します。

```python
import pyrev
from pyrev import BoardCoordinateIterator
import numpy as np

bits = np.int64(0xf) # 下位4bitのみが1
for coord in BoardCoordinateIterator(bits):
    print(pyrev.coord_to_str(coord))


"""
result

A1
B1
C1
D1
"""
```

Pythonのlistに格納したい場合は、以下のようにlistコンストラクタにBoardCoordinateIteratorオブジェクトを渡します。

```python
coords = list(BoardCoordinateIterator(bits))
```


