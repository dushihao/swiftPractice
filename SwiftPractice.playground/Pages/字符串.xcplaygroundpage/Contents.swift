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

// 字符串替换
/**
 字符串无法提供的一个类集合特性是：MutableCollection。该协议给集合除 get 之外，添加了一个通过下标进行单一元素 set 的特性。这并不是说字符串是不可变的——我们上面已经看到了，有好几种变化的方法。你无法完成的是使用下标操作符替换其中的一个字符。许多人直觉认为用下标操作符替换一个字符是即时发生的，就像数组 Array 里面的替换一样。但是，因为字符串里的字符长度是不定的，所以替换一个字符的时间和字符串的长度呈线性关系：替换一个元素的宽度会把其他所有元素在内存中的位置重新洗牌。而且，替换元素索引后面的元素索引在洗牌之后都变了，这也是跟人们的直觉相违背的。出于这些原因，你必须使用 replaceSubrange 进行替换，即使你变化只是一个元素。
 */

var greeting = "hello, word, fuck"
if let comma = greeting.lastIndex(of: ",") {
//    greeting = String(greeting[..<comma]) // Hello
    greeting.replaceSubrange(comma..., with: " again")
}
greeting


// 子字符串
/// 字符串分隔
extension Collection where Element: Equatable {
//    public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [SubSequence]
}

let poem = """
over the wintry
forest, winds howl in rage
with no leaves to blow.
"""

let lines = poem.split(separator: "\n") // ["over the wintry", "forest, winds howl in rage", "with no leaves to blow."]

/// 按词折行算法
extension String {
    func wrapper(after: Int = 70) -> String {
        var i = 0
        let lines = self.split(omittingEmptySubsequences: false) { (character) -> Bool in
            switch character {
            case "\n",
                 " " where i >= after:
                i = 0
                return true

            default:
                i = i+1
                return false
            }
        }
        return lines.joined(separator: "\n")
    }
}

let sentence = "The quick brown fox jumped over the lazy dog."
let sentenceWrap =  sentence.wrapper(after: 15)
print(sentenceWrap)

/// 接收多个分隔符的序列作为参数
extension Collection where Element: Equatable {
    func split<S: Sequence>(separators: S) -> [SubSequence]
    where Element == S.Element
    {
        return split {separators.contains($0)}
    }
}

"Hello, world! again! hello".split(separators: ",!")



// StringProtocol

/**
 “如果你想要扩展 String 为其添加新的功能，将这个扩展放在 StringProtocol 会是一个好主意，这可以保持 String 和 Substring API 的统一性”

 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
 */

let alaboString = "1,2,3,4,5"
let intArray = alaboString.split(separator: ",").compactMap { (sub) -> Int? in
    Int(sub)
}
alaboString.split(separator: ",").compactMap{
    Int($0)
}

// String 富文本的使用
/// 用到 NSAttributedString 和 NSMutableAttributedString


// CharacterSet

let favorateEmoji = CharacterSet("👩‍🚒👨‍🚒".unicodeScalars)
favorateEmoji.contains("🚒") // true

extension String {
    func words(with charset: CharacterSet = .alphanumerics) -> [Substring] {
        return self.unicodeScalars.split{
            !charset.contains($0)
        }.map(Substring.init) // map 接收了一个闭包 Substring.init: (Substring.UnicodeScalarView) throws -> T) rethrows -> [T]
    }
}

let code = "stuct Array<Element>: Collection {}"
code.words()


// 函数是一等功民
class Foo {
    var name = "laji"
    func hello() {
        print("hi \(name)~~~~~")
    }
}

let f = Foo()
let v = Foo.hello(f)  // () -> ()
v()


// 简单的正则表达式匹配器
/// 参考《swift 进阶》

// 文本输出流 略
 
// 字符串性能 略

//: [Next](@next)
