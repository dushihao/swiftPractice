//: [Previous](@previous)

import UIKit


// 面向协议编程
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

// 协议扩展
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

// 协议的两种类型
/*:
1、带有关联类型的协议 2、 普通协议
参考：[第十章：协议 Protocol Protocol-Oriented Programming](https://github.com/Liaoworking/Advanced-Swift/blob/master/%E7%AC%AC%E5%8D%81%E7%AB%A0%EF%BC%9A%E5%8D%8F%E8%AE%AE/10.2%20%E5%8D%8F%E8%AE%AE%E7%9A%84%E4%B8%A4%E7%A7%8D%E7%B1%BB%E5%9E%8B%20TwoTypesofProtocols.md)
 
*/

// 类型抹除/类型擦除/类型抹消 隐藏内部的实现，保证接口的简介
//: [Swift 类型擦除](https://swift.gg/2018/10/11/friday-qa-2017-12-08-type-erasure-in-swift/)

// TODO:Dush


//: [Next](@next)
