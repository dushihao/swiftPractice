//: [Previous](@previous)

import Foundation

// 一、 编写一个函数,反转字符串.例如,"0123456789" => "9876543210".要求如下:

/**
1. 不能使用循环和下标.
2. 不能使用数组.
3. 不能定义变量.
 */

func reverseString (input: String, output: String = "") -> String {
    if input.isEmpty {
        return output
    } else {
        let a = String(input[..<input.index(before: input.endIndex)])
        let b = output + String(input[input.index(before: input.endIndex)..<input.endIndex])
        return reverseString(input: a, output: b)
    }
}

var result = reverseString(input: "0123456789", output:"")


// 二、 重载 *

func * (lhs: String, rhs: Int) -> String {
    var result = lhs
    for _ in 2...rhs {
        result+=lhs
    }
    return result
}

"@" * 5


//: [Next](@next)
