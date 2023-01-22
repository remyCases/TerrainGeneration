import matrix
import tables
import random/xorshift

var countTable = initCountTable[uint]()
var sumNeighboors: uint = 0

proc neighboorDecisionBySum*[N](square: var Square[N, uint], 
squareNeighboor: var Square[N, uint], index: uint) =
    sumNeighboors = 0
    for neighIndex in square.neighboors(index):
        sumNeighboors += square[neighIndex]
    squareNeighboor[index] = if sumNeighboors >= 3: 2 elif sumNeighboors >= 1: 1 else: 0

proc neighboorDecisionByCat*[N](generator: var Xorshift128Plus, square: var Square[N, uint], 
squareNeighboor: var Square[N, uint], index: uint) =
    for neighIndex in square.neighboors(index):
        let valueNeighboor: uint = square[neighIndex]
        sumNeighboors += 1
        countTable.inc(valueNeighboor)

    let u = generator.random()
    var highValue: float64 = 0.0
    for k, v in countTable.pairs():
        highValue += float64(v) / float64(sumNeighboors)
        if u < highValue:
            squareNeighboor[index] = k
            break

    countTable.clear()
    sumNeighboors = 0