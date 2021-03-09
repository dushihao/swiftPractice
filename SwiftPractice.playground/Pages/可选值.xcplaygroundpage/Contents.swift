//: [Previous](@previous)

import Foundation

// 双重可选值
var x = Int("123")

let stringNumbers = ["1", "2", "three"]
let maybeInts = stringNumbers.map { Int($0) } // [Optional(1), Optional(2), nil]

/**
 *
var iterator = maybeInts.makeIterator()
while let maybeInt = iterator.next() {
    print(maybeInt, terminator:"") // error
}
 */

for case let i? in maybeInts {
    print(i, terminator:"")
}

// 因为可选值是链接的，如果你要处理的是双重嵌套的可选值，并且想要使用 ?? 操作符的话，你需要特别小心 a ?? b ?? c 和 (a ?? b) ?? c 的区别。前者是合并操作的链接，而后者是先解包括号内的内容，然后再处理外层：
let s1: String?? = nil // nil
(s1 ?? "inner") ?? "outer" // inner
let s2: String?? = .some(nil) // Optional(nil)
s2 ?? "inner"
(s2 ?? "inner") ?? "outer" // outer”
 

// 可选值 map
let bodyTemperature: Double? = 37.0
let bloodGlucose: Double? = nil
let blood = bloodGlucose.map { $0 * $0 }

let characters: [Character] = ["a", "b", "c"]
let firstChar = characters.first.map { String($0) }

//let stringNumbers = ["1", "2", "3", "foo"]
let y = stringNumbers.first.map { Int($0) } // Optional(Optional(1))
let z = stringNumbers.first.flatMap { Int($0) } // Optional(1)

// 隐式可选值行为
var a: String! = "string"
a?.isEmpty // Optional(false)

//: [Next](@next)
