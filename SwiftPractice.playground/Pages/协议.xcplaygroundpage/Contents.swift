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

//: [Next](@next)
