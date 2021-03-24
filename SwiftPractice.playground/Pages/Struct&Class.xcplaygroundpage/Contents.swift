//: [Previous](@previous)

import Foundation

// 嵌套类型
// 外部引用类型 内部值类型

struct Inner {
    var value = 1
}

class Outer {
    var value = 1
    var inner = Inner()
}

var outer = Outer()
var outer1 = outer
//outer.value = 2
//print("outer1.value = \(outer1.value)")


//outer.inner.value = 2
outer1.inner.value = 3
outer1.value = 2
print("outer1.value = \(outer1.value), outer.value = \(outer.value) \n outer1.inner.value = \(outer1.inner.value) outer.inner.value = \(outer.inner.value)")


// 值类型 写时复制
final class Empty {}
struct COWStruct {
    var ref = Empty()
    
   mutating func change() -> String {
        if isKnownUniquelyReferenced(&ref) {
            return "No copy"
        } else {
            return "copy"
        }
    }
}

// 内存
struct Person  {
    let name: String
    var parents: [Person]
}

// 捕获列表
// 捕获列表就是在闭包中使用外部变量时，帮助闭包copy外部变量成为闭包的内部变量进行使用。
var closureArray: [() -> ()] = []
var i = 0
for _ in 1...5 {
    closureArray.append { print(i) }
    i += 1
}

closureArray[0]()
closureArray[1]()
closureArray[2]()
closureArray[3]()
closureArray[4]()

//class Human {
//    var lanuage = "Objc"
//    deinit {
//        print("deinit")
//    }
//}

class Human {
    var lanuage = "Objc"
    var block: (() -> Void)?
    deinit {
        print("deinit")
    }
    func recycle() -> () -> () {
//        let code = { print(self.lanuage) }
        let code = { [weak self] in
            print(self?.lanuage ?? "")
        }
        block = code
        return code
    }
}


var human: Human! = Human()
print(CFGetRetainCount(human)) // 2
let code = { [human] in // 产生强引用
    print(human!.lanuage)
}
print(CFGetRetainCount(human)) // 输出为3

//var human: Human! = Human()
//human.lanuage = "Swift"
//human.recycle()
//
//human = nil

//: [Next](@next)
