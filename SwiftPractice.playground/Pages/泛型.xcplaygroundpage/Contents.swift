//: [Previous](@previous)

import Foundation

// 运算符重载

/// 幂运算 优先级高于乘法运算
precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator **: ExponentiationPrecedence
func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

func **(lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)
}

2.0 ** 3.0

/// 重载整型
func **<I: BinaryInteger>(lhs: I, rhs: I) -> I {
    let result = Double(Int64(lhs)) ** Double(Int64(rhs))
    return I(result)
}

// 需要将一个参数显示声明为整数类型
let intResult: Int =  2 ** 3


// 泛型约束
/// 实现 isSubSet(of:)

/// O(mn)
extension Sequence where Element: Equatable {
    func isSubSet(of other: [Element]) -> Bool {
        for element in self {
            // O(n)
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence where Element: Hashable {
    // O(m)
    func isSubSet(of other: [Element]) -> Bool {
        let otherSet = Set(other)
        for element in self {
            // O(1)
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
    
    /// 只需要满足 Sequence 就可以
    func isSubSet<S: Sequence>(of other: S) -> Bool where S.Element == Element {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

let oneToThree = [1,2,3]
let FiveToOne = [5,4,3,2,1]
oneToThree.isSubSet(of: FiveToOne)

[1,2,3].isSubSet(of: 1...10) // true


// 使用闭包对行为进行参数话
extension Sequence {
    func isSubSet<S: Sequence>(of other: S, by areEquivalent: (Element, S.Element) -> Bool) -> Bool {
        for element in self {
            guard other.contains(where: { areEquivalent(element, $0) }) else {
                return false
            }
        }
        return true
    }
}

[[1,2]].isSubSet(of: [[1,2] as [Int], [1,3], [1,4]]) { $0 == $1 } // true
[1,2] as [Int] == [1,2]

[1,2].isSubSet(of: ["1", "2", "3"]) { String($0) == $1} // true


// 对集合进行范型操作
/// 二分查找
//  >> 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
extension RandomAccessCollection {
    public func binarySearch(for value: Element,
                             areInIncreasingOrder: (Element, Element) -> Bool) -> Index?
    {
        guard !isEmpty else { return nil }
        var left = startIndex
        var right = index(before: endIndex)
        while left <= right {
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]
            if areInIncreasingOrder(candidate, value) {
                left = index(after: mid)
            } else if areInIncreasingOrder(value, candidate) {
                right = index(before: mid)
            } else {
                // 由于 isOrderedBefore 的要求，
                // 如果两个元素互无顺序关系，那么它们一定相等
                return mid
            }
        }
        // 未找到
        return nil
    }
}


// 集合随机排列
// >> 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
extension BinaryInteger {
    static func arc4random_uniform(_ upper_bound: Self) -> Self {
        precondition(
            upper_bound > 0 && UInt32(upper_bound) < UInt32.max,
            "arc4random_uniform only callable up to \(UInt32.max)")
        return Self(Darwin.arc4random_uniform(UInt32(upper_bound)))
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    mutating func shuffle() {
        var i = startIndex
        let beforeEndIndex = index(before: endIndex)
        while i < beforeEndIndex {
            let dist = distance(from: i, to: endIndex)
            let randomDistance = Int.arc4random_uniform(dist)
            let j = index(i, offsetBy: randomDistance)
            self.swapAt(i, j)
            formIndex(after: &i)
        }
    }
}
extension Sequence {
    func shuffled() -> [Element] {
        var clone = Array(self)
        clone.shuffle()
        return clone
    }
}
var numbers = Array(1...10)
numbers.shuffle()
numbers // 随机数组


//  使用范型进行代码设计


//: [Next](@next)
