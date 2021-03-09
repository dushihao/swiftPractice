//: [Previous](@previous)

import Foundation

// 颜文字
let oneEmoji = "😂"
let oneCount = oneEmoji.count // 1

// 双向索引，而非随机访问
extension String {
    // 复杂度 O(n^2)
    var allPrefixes1: [Substring] {
        return (1...self.count).map(self.prefix)
    }
    
    // 复杂度 O(n)
    var allPrefixes2: [Substring] {
        return self.indices.map { self[...$0] }
    }
}

let hello = "hello"
hello.allPrefixes1 // ["h", "he", "hel", "hell", "hello"]
hello.allPrefixes2 // ["h", "he", "hel", "hell", "hello"]

//  https://swiftdoc.org/v5.1/protocol/collection/
/// 遍历一个集合
for i in hello.indices {
    print(hello[i])
}

//
//: [Next](@next)
