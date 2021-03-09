//: [Previous](@previous)

import Foundation

let numbers = [1, 2, 3, 4]

let arr:[String] = []
let s = arr[0]

/// reduce
let numberSum = numbers.reduce(0) { (a, b) -> Int in  a + b }
let numberSum1 = numbers.reduce(0) {$0 + $1}
let numberSum2 = numbers.reduce(0, +)

/// filter
let bookAmount = ["harrypotter":100.00, "junglebook":999.00]
let results = bookAmount.filter { (key, value) -> Bool in value > 100 }

/// flatMap
// 计算数组中元素最大值
let complexNumbers = [[1,2,4], [3,4,5]]
let res = numbers.reduce(Int.min, {max($0, $1)})
let complexRes = complexNumbers.flatMap({$0}).reduce(Int.min, {max($0, $1)})
print(res, complexRes)


//: [Next](@next)
