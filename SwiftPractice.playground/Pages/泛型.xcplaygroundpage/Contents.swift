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


// 使用范型进行代码设计 略。。。

// 泛型的工作方式
/*:
Swift 通过为泛型代码引入一层间接的中间层来解决这些问题。当编译器遇到一个泛型类型的值时，它会将其包装到一个容器中。这个容器有固定的大小，并存储这个泛型值。如果这个值超过容器的尺寸，Swift 将在堆上申请内存，并将指向堆上该值的引用存储到容器中去。

对于每个泛型类型的参数，编译器还维护了一系列一个或者多个所谓的目击表 (witness table)：其中包含一个值目击表，以及类型上每个协议约束一个的协议目击表。这些目击表 (也被叫做 vtable) 将被用来将运行时的函数调用动态派发到正确的实现去。

对于任意的泛型类型，总会存在值目击表，它包含了指向内存申请，复制和释放这些类型的基本操作的指针。这些操作对于像是 Int 这样的原始值类型来说[…]
 */

// 泛型特化
// 全模块优化
//: @_inlineable “原来的模块不需要将具体类型硬编码成一个列表，因为特化会在使用者的模块进行编译时才被施行”



//: [Next](@next)
