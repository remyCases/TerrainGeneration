import random/xorshift
import math

proc poissonXorshiftInverseSampling*(generator: var Xorshift128Plus, lambda_param: float64): uint64 =
    if lambda_param > 50000.0:
        raise newException(ArithmeticDefect, "lambda is too high, risk of underflow. Use an other algorithm")

    result = 0
    var p = exp(- lambda_param)
    var s = p

    let u = generator.random()
    while u > s:
        result = result + 1
        p = p * lambda_param / (float64)result
        s = s + p

proc poissonXorshiftSampling*(generator: var Xorshift128Plus, lambda_param: float64): uint64 =
    let  L = exp(- lambda_param)
    var 
        k = 1
        p = generator.random()
    while p > L:
        k = k + 1
        p = p * generator.random() 
    return (uint64)(k - 1)