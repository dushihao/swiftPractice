//: [Previous](@previous)

import UIKit


//: ## 一、面向协议编程
protocol Drawing {
    mutating func addEllipse(rect: CGRect, fill: UIColor)
    mutating func addRectangle(rect: CGRect, fill: UIColor)
}

extension CGContext: Drawing {
    func addEllipse(rect: CGRect, fill: UIColor) {
        setFillColor(fill.cgColor)
        fillEllipse(in: rect)
    }
    
    func addRectangle(rect: CGRect, fill fillColor: UIColor) {
        setFillColor(fillColor.cgColor)
        fill(rect)
    }
}

/// SVG
struct XMLNode {
    var tag: String
    var attributes = [String: String]()
    var children = [XMLNode]()
}

struct SVG {
    var rootNode = XMLNode(tag: "SVG")
    mutating func appending(node: XMLNode) {
        rootNode.children.append(node)
    }
}

//  https://swift.gg/2016/10/11/swift-extensions-can-add-stored-properties/
// Any 与 AnyObject 区别：https://swifter.tips/any-anyobject/
func associatedObject<ValueType: Any>(base: Any, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType
{
    if let associated = objc_getAssociatedObject(base, key)
        as? ValueType { return associated }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

func associateObject<ValueType: Any>( base: Any, key: UnsafePointer<UInt8>, value: ValueType)
{
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

private var dicKey: UInt8 = 0
extension CGRect {
    var svgAttributes: Dictionary<String, String> {
        get {
            return associatedObject(base: self, key: &dicKey) { [String: String]() }
            
        }
        set {
            associateObject(base: self, key: &dicKey, value: newValue)
        }
    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

/// 为SVG添加扩展方法
extension SVG: Drawing {
    mutating func addEllipse(rect: CGRect, fill: UIColor) {
        var attributes: [String: String] = rect.svgAttributes
        attributes["fill"] = fill.hexString
        appending(node: XMLNode(tag: "ellipse", attributes: attributes))
    }
    
    mutating func addRectangle(rect: CGRect, fill: UIColor) {
        var attributes: [String: String] = rect.svgAttributes
        attributes["fill"] = fill.hexString
        appending(node: XMLNode(tag: "rect", attributes: attributes))
    }
}

var context: Drawing = SVG()
let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
let rect2 = CGRect(x: 0, y: 0, width: 50, height: 50)
context.addRectangle(rect: rect1, fill: .yellow)
context.addEllipse(rect: rect2, fill: .blue)
print(context)

//: ## 二、协议扩展
extension Drawing {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
        let diameter = radius * 2
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: diameter, height: diameter)
        let rect =  CGRect(origin: origin, size: size)
        addEllipse(rect: rect, fill: fill)
    }
}

extension SVG {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
        var attributes: [String:String] = [
            "cx": "\(center.x)",
            "cy": "\(center.y)",
            "r": "\(radius)",
        ]
        attributes["fill"] = fill.hexString
        appending(node: XMLNode(tag: "circle", attributes: attributes))
    }
}

// 静态派发 & 动态派发
//var sample = SVG()
//sample.addCircle(center: .zero, radius: 20, fill: .red)
//print(sample)

var sample: Drawing = SVG()
sample.addCircle(center: .zero, radius: 20, fill: .blue)
print(sample)

//: ## 三、协议的两种类型
/*:
1、带有关联类型的协议（可以看做是泛型协议） 2、 普通协议
参考：
 - [第十章：协议 Protocol Protocol-Oriented Programming](https://github.com/Liaoworking/Advanced-Swift/blob/master/%E7%AC%AC%E5%8D%81%E7%AB%A0%EF%BC%9A%E5%8D%8F%E8%AE%AE/10.2%20%E5%8D%8F%E8%AE%AE%E7%9A%84%E4%B8%A4%E7%A7%8D%E7%B1%BB%E5%9E%8B%20TwoTypesofProtocols.md)
 - [Swift 关联类型](https://swift.gg/2016/08/01/swift-associated-types/)
*/

struct MyIdType : Hashable {
    let id: String
}

/**
 @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
 public protocol Identifiable {

     /// A type representing the stable identity of the entity associated with
     /// an instance.
     associatedtype ID : Hashable

     /// The stable identity of the entity associated with this instance.
     var id: Self.ID { get }
 }

 */
    
struct A: Identifiable {
//    这句可以省略
//    typealias ID = String
    let id: String
}

struct B: Identifiable {
    typealias ID = Int
    let id: Int
}

struct C: Identifiable {
    typealias ID = MyIdType
    let id: MyIdType
}




//: ## 四、 类型抹除/类型擦除/类型抹消/Type Erasure
// 隐藏内部的实现，保证接口的简洁
//: [Swift 类型擦除](https://swift.gg/2018/10/11/friday-qa-2017-12-08-type-erasure-in-swift/)

/// IteratorProtocol 是一个关联类型的协议， 是一个不完整的类型
/// 我们可以将 IteratorProtocol 用作泛型参数的约束处理
func nextInt<I: IteratorProtocol>(iterator: inout I) -> Int? where I.Element == Int {
    return iterator.next()
}

class IteratorStore<I: IteratorProtocol> where I.Element == Int {
    var iterator: I
    init(iterator: I) {
        self.iterator = iterator
    }
}

/// 但是这种👆方式有缺点，存储的迭代器的指定类型“泄露”出来了，我们无法表达“元素类型是Int的任意迭代器”，我们无法创建一个数组，让它能同时存储 IteratorStore<ConstantIterator> 和 IteratorStore<FibsIterator> （序列章节）

struct ConstantIterator: IteratorProtocol {
    func next() -> Int? {
        return 1
    }
}

// 两种方式进行类型抹除
//: - 封装类
class IntIterator {
    var nextImpl: () -> Int?
    init<I: IteratorProtocol>(_ iterator: I) where I.Element == Int {
        var iteratorCopy = iterator
        self.nextImpl = { iteratorCopy.next() }
    }
}

extension IntIterator: IteratorProtocol {
    func next() -> Int? {
        return nextImpl()
    }
}

var iter =  IntIterator(ConstantIterator())
iter = IntIterator([1,2,3].makeIterator())

// 抽象Int并为迭代器的元素类型添加泛型参数
class AnyIterator<A>: IteratorProtocol {
    var nextImpl: () -> A?
    
    init<I: IteratorProtocol>(_ iterator: I) where I.Element == A {
        var iteratorCopy = iterator
        self.nextImpl = { iteratorCopy.next() }
    }
    
    func next() -> A? {
        return nextImpl()
    }
}

//: - 类继承 使用类继承的方式，使具体的迭代器类型隐藏在子类中
class IteratorBox<Element>: IteratorProtocol {
    func next() -> Element? {
        fatalError("this method is abstract")
    }
}

class IteratorBoxHelper<I: IteratorProtocol>: IteratorBox<I.Element> {
    var iterator: I
    init(iterator: I) {
        self.iterator = iterator
    }
    
    override func next() -> I.Element? {
        return iterator.next()
    }
}

let iter1: IteratorBox<Int> = IteratorBoxHelper(iterator: ConstantIterator())


//: ## 带有 Self 的协议
class IntegerRef: NSObject {
    let int: Int
    init(_ int: Int) {
        self.int = int
    }
    
    static func ==(lhs: IntegerRef, rhs: IntegerRef) -> Bool {
        return lhs.int == rhs.int
    }
}

/*:
 - Note: “== 运算符被定义为了类型的静态函数。换句话说，它不是成员函数，对该函数的调用将被静态派发。与成员函数不同，我们不能对它进行重写。如果你有一个实现了 Equatable 的类 (比如 NSObject)，你可能会在创建子类时遇到预想之外的行为”
 
 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
 */

let one = IntegerRef(1)
let otherOne = IntegerRef(1)
one == otherOne // true

let two: NSObject = IntegerRef(2)
let otherTwo: NSObject = IntegerRef(2)
two == otherTwo // false


//: ## 协议内幕

func f<C: CustomStringConvertible>(_ x: C) -> Int {
    return MemoryLayout.size(ofValue: x)
}

func g(_ x: CustomStringConvertible) -> Int {
    return MemoryLayout.size(ofValue: x)
}

f(5) // 8
g(5) // 40

//: [Next](@next)
