//: [Previous](@previous)

import Foundation

// https://www.bilibili.com/medialist/detail/ml953506914?type=1
// swift lazy initialization
struct Person {
    init() {
        print("I'm a person")
    }
}

struct Home {
    // lazy var var hanmeimei
    var hanmeimei: Person = {
        let p = Person()
        return p
    }()
}

let home = Home()

let tom = { () -> Person in
    let p = Person()
    return p
}
let realTom = tom()

let john = { () -> Person in
    let p = Person()
    return p
}()

// 等价于
let anotherJohn : Person = {
    let p = Person()
    return p
}()

func add(numA: Int, numB: Int) -> Int { return numA + numB }
let varAdd = add
add(numA: 1, numB: 2)
varAdd(2, 6)

let anotherAdd: (Int, Int) -> Int = { (numA, numB) in
    return numA + numB
}

anotherAdd(2, 6)

//: [Next](@next)
