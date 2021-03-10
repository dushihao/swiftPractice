//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

// swift lazy initialization
struct Person {
    init() {
        print("I'm a person")
    }
}

let tom = { () -> Person in
    let p = Person()
    return p
}

let realTom = tom()

let john = { () -> Person in
    let p = Person()
    return p
}()

let anotherJohn : Person = {
    let p = Person()
    return p
}()


// 应用
let testView: UIView = {
    $0.backgroundColor = .red
    $0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    return $0
}(UIView())

class ViewController: UIViewController {
    override func viewDidLoad() {
        
    }
}

PlaygroundPage.current.liveView = testView



//: [Next](@next)
