//: [Previous](@previous)

import Foundation

// 函数作为代理
/**
   在代理和协议的模式中，并不适合使用结构体
 */

class AlertView {
    var buttons: [String]
    var buttonTapped: ((_ buttonIndex: Int) -> ())?
    
    init(buttons: [String] = ["Ok", "Cancel"]) {
        self.buttons = buttons
    }
    
    func fire() {
        buttonTapped?(1)
    }
}

struct TapLogger {
    var taps: [Int] = []
    
    mutating func logTap(index: Int) {
        taps.append(index)
    }
}

let alert = AlertView()
var logger = TapLogger()

alert.buttonTapped = { print("Button \($0) was tapped") }
alert.fire

class ViewController {
    let alert: AlertView
    init() {
        alert = AlertView(buttons: ["OK", "Cancel"])
        alert.buttonTapped = self.buttonTapped(atIndex:)
        
        alert.fire
    }
    func buttonTapped(atIndex index: Int) {
        print("Button tapped: \(index)")
    }
}


// 下标进阶
/// 异值字典 修改嵌套值
var japan: [String: Any] = ["name": "japan",
                            "capital": "tokyo",
                            "population": 126_740_0000,
                            "coordinates": ["latitude": 35.0,
                                            "longitude": 139.0]]

extension Dictionary {
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get {
            return self[key] as? Result
        }
        set {
            guard let value = newValue as? Value else {
                return
            }
            self[key] = value
        }
    }
}

japan["coordinates", as: [String: Double].self]?["latitude"] = 36.0
japan["coordinates"]


// 自动闭包

//: [Next](@next)
