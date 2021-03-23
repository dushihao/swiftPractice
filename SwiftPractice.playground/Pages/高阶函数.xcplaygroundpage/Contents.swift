//: [Previous](@previous)

import Foundation

let numbers = [1, 2, 3, 4]

let arr:[String] = []
//let s = arr[0] // error

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


// 源码地址：https://github.com/apple/swift/blob/main/stdlib/public/core/SequenceAlgorithms.swift
// 参考博客：[swift开发：map和flatMap使用](https://www.jianshu.com/p/3415844efdd9)
let mapArray = [[[1,2], [2,3], [3,4]], [4, 5, 6]]
let arr1 = Array(mapArray.map{$0}.joined())
print(arr1)

/**
  * Optional 的map flatMap 实现
/// If `self == nil`, returns `nil`.
/// Otherwise, returns `f(self!)`.
public func map<U>(@noescape f: (Wrapped) throws -> U)
rethrows -> U? {
    switch self {
    case .Some(let y):
        return .Some(try f(y))
    case .None:
        return .None
    }
}

/// Returns `nil` if `self` is `nil`,
/// `f(self!)` otherwise.
@warn_unused_result
public func flatMap<U>(@noescape f: (Wrapped) throws -> U?)
rethrows -> U? {
    switch self {
    case .Some(let y):
        return try f(y)
    case .None:
        return .None
    }
}
 */

var arrMax = [1, 2, 4]
let resArrMax = arrMax.first.flatMap {
    arrMax.reduce($0) { (a, b) -> Int in
        if a >= b {
            return a
        } else {
            return b
        }
    }
}

let arrMax1 = [Int]()
let resArrMax1 = arrMax1.first.flatMap { arrMax.reduce($0, max) }

print(resArrMax!, resArrMax1)

//: [Next](@next)
