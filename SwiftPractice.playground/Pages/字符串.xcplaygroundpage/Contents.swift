//: [Previous](@previous)

import Foundation

// 颜文字
let oneEmoji = "😂"
let oneCount = oneEmoji.count // 1

// 双向索引，而非随机访问
extension String {
    var allPrefixes: [Substring] {
        return (1...self.count).map(self.prefix)
    }
}

let hello = "hello"
hello.allPrefixes // ["h", "he", "hel", "hell", "hello"]
//: [Next](@next)
