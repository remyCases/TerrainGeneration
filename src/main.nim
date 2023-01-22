import nimsvg
import matrix, distributions, cristallization
import random/xorshift
import std/strformat

const n = 50
const aera = n*n
const intensity = 0.01
const STEP = 50
const frameByStep = 3

var refA: ref array[aera, uint] = nil
new(refA)
var s = initSquare(n, n, refA)
var refN: ref array[aera, uint] = nil
new(refN)
var sNeighboor = initSquare(n, n, refN)

const seed = 1337
var xorshiftGenerator = initXorshift128Plus(seed)
let nCentroid1 = xorshiftGenerator.poissonXorshiftInverseSampling((float64)aera * intensity)
for i in 0..<nCentroid1:
    let index = (uint)xorshiftGenerator.randomInt(aera)
    s[index] = 1

let nCentroid2 = xorshiftGenerator.poissonXorshiftInverseSampling((float64)aera * intensity)
for i in 0..<nCentroid2:
    let index = (uint)xorshiftGenerator.randomInt(aera)
    s[index] = 2

var saved: seq[array[aera, uint]]
saved.add(refA[])

for step in 0..<STEP:
    for index, value in s.pairs():
        sNeighboor[index] = 0
        if value != 0: continue
        neighboorDecisionByCat(xorshiftGenerator, s, sNeighboor, index)
    s += sNeighboor
    saved.add(refA[])

let settings = animSettings("filenameBase", backAndForth=true)
settings.buildAnimation(frameByStep*(STEP+1)) do (i: int) -> Nodes:
  buildSvg:
    svg(width=10*n, height=10*n):
        for index, value in saved[i div frameByStep].pairs():
            let t = s.toTuple(uint(index))
            let x = t[0]
            let y = t[1]
            if value == 1:
                circle(cx=10*x, cy=10*y, r=2, stroke="#c0ca33", fill="#c0ca33", `fill-opacity`=0.5)
            elif value == 2:
                circle(cx=10*x, cy=10*y, r=2, stroke="#111122", fill="#111122", `fill-opacity`=0.5)