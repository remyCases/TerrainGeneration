import system/iterators
import std/strformat

type
    Direction* = enum
        north, west, east, south
    Coord* = object
        x: uint
        y: uint
    Square*[N, T: Ordinal] = object
        nCol: uint
        nRow: uint
        data: ref array[N, T]

proc initSquare*[N, T](nCol, nRow: uint, data: ref array[N, T]): Square[N, T] =
    result = Square[N, T](nCol: nCol, nRow: nRow, data: data)

proc toCoord*[N, T](square: Square[N, T], i: uint): Coord =
    let y: uint = i div square.nRow
    result = Coord(x: i - y * square.nRow, y: y)

proc toTuple*[N, T](square: Square[N, T], i: uint): tuple =
    let y: uint = i div square.nRow
    result = (i - y * square.nRow, y)

proc neighboor*[N, T](square: Square[N, T], i: uint, d: Direction): uint =
    case d:
    of north:
        result = if i > square.nCol - 1: i - square.nCol else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")
    of west:
        result = if (i mod square.nCol) != 0: i - 1 else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")
    of east:
        result = if (i mod square.nCol) != square.nCol - 1: i + 1 else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")
    of south:
        result = if i < (square.nRow - 1) * square.nCol: i + square.nCol else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")

proc neighboor*[N, T](square: Square, c: Coord, d: Direction): Coord =
    case d:
    of north:
        result = if c.y > 0: (c.x, c.y - 1) else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")
    of west:
        result = if c.x > 0: (c.x - 1, c.y) else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")
    of east:
        result = if c.x < square.nCol - 1: (c.x + 1, c.y) else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")
    of south:
        result = if c.y < square.nRow - 1: (c.x, c.y + 1) else: raise newException(ArithmeticDefect, fmt"{d} is OutofBound")

proc neighboors*[N, T](square: Square[N, T], i: uint): seq[uint] =
    result = newSeq[uint]()
    for d in [north, west, east, south]:
        try:
            result.add(square.neighboor(i, d))
        except ArithmeticDefect:
            continue

proc neighboors*[N, T](square: Square[N, T], c: Coord): seq[Coord] =
    result = newSeq(0)
    for d in [north, west, east, south]:
        try:
            result.append(square.neighboor(c, d))
        except ArithmeticDefect:
            continue

proc `[]=`*[N, T](square: var Square[N, T], i: uint, val: T) =
    square.data[i] = val

proc `[]=`*[N, T](square: var Square[N, T], c: Coord, val: T) =
    square.data[c.y * square.nCol + c.x] = val

proc `[]=`*[N, T](square: var Square[N, T], x, y: uint, val: T) =
    square.data[y * square.nCol + x] = val

proc `[]`*[N, T](square: var Square[N, T], i: uint): T =
    result = square.data[i]

proc `[]`*[N, T](square: var Square[N, T], c: Coord): T =
    result = square.data[c.y * square.nCol + c.x]

proc `[]`*[N, T](square: var Square[N, T], x, y: uint): T =
    result = square.data[y * square.nCol + x]

proc `+=`*[N, T](des: var Square[N, T], src: var Square[N, T]) =
    for index, value in des.mpairs():
        value += src[index]

iterator mitems*[N, T](square: var Square[N, T]): var T =
    for x in square.data[].mitems():
        yield x

iterator pairs*[N, T](square: var Square[N, T]): tuple[key: uint, val: T] =
    when square.data[].len > 0:
        var i = low(N)
        while true:
            yield (uint(i), square.data[i])
            if i >= high(N): break
            inc(i)

iterator mpairs*[N, T](square: var Square[N, T]): tuple[key: uint, val: var T] =
    when square.data[].len > 0:
        var i = low(N)
        while true:
            yield (uint(i), square.data[i])
            if i >= high(N): break
            inc(i)

proc `$`*[N, T](square: Square[N, T]): string =
    result = ""
    let col = square.nCol
    let row = square.nRow

    for y in 0..<col:
        for x in 0..<row:
            result &= $(square.data[y * col + x])
        result &= "\n"