//: [Previous](@previous)

import Foundation

enum ParseError: Error {
    
}

//: ## 带有类型的错误
/// 想通过类型系统来指定一个函数可能抛出的错误类型
enum Result<A, ErrorType: Error> {
    case failure(ErrorType)
    case success(A)
}

func parseText(text: String) -> Result<[String], ParseError> {
    return Result.success(["success"])
}

// 一般使用Swift内建的错误处理，编译器会强制你使用Try

//: ## 错误和函数参数

// 检测文件的有效性
func checkFile(_ filename: String) throws -> Bool {
    if filename.isEmpty {
        return false
    }
    return true
}

func checkAllFiles(filenames: [String]) throws -> Bool {
    for filename in filenames {
        guard try checkFile(filename) else {
            return false
        }
    }
    return true
}

try checkAllFiles(filenames: ["halibote", "santi"]) // true

extension Int {
    var isPrime : Bool {
        get {
            return (self%2 != 0)
        }
    }
}

// 检测是否是质数
func checkPrimes(_ nums: [Int]) -> Bool {
    for num in nums {
        guard num.isPrime else {
            return false
        }
    }
    return true
}

checkPrimes([1,2,3,4]) // false
checkPrimes([1,3,5,7]) // true

// 对于这种模式，类似于 map 和 filter, 可以进行一个抽象
extension Sequence {
    func all(matching predicate:(Element) -> Bool) -> Bool {
        for element in self {
            guard predicate(element) else {
                return false
            }
        }
        return true
    }
}

// 这样就简洁了许多
func checkPrimes2(_ nums: [Int]) -> Bool {
    return nums.all{ $0.isPrime }
}

/*:
 - Note: “然而，我们还并不能用 all 重写 checkAllFiles，因为 checkFile 是被标记为 throws 的。我们可以很容易地把 all 重写为接受 throws 函数的版本，但是那样一来，我们也需要改变 checkPrimes，要么将它标记为 throws 并且用 try! 来调用，要么将对 all 的调用放到 do/catch 代码块中。我们还有一种做法，那就是定义两个版本的 all 函数：一个接受 throws，另一个不接受。除了 try 调用以外，它们的实现应该是相同的”
 */
//extension Sequence {
//    func all(matching predicate:(Element) throws -> Bool) -> Bool {
//        for element in self {
//            guard try! predicate(element) else {
//                return false
//            }
//        }
//        return true
//    }
//}
 

//: ## Rethrows
extension Sequence {
    func all(matching predicate:(Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            guard try predicate(element) else {
                return false
            }
        }
        return true
    }
}

func checkAllFiles2(_ filenames: [String]) throws -> Bool {
//  return try filenames.all(matching: checkFile)
    return try filenames.all(matching: checkFile(_:))
}

//: ## Defer

/*:
 
 - Note: “虽然 defer 经常会被和错误处理一同使用，但是在其他上下文中，这个关键字也很有用处。比如你想将代码的初始化工作和在关闭时对资源的清理工作放在一起时，就可以使用 defer。将代码中相关的部分放到一起可以极大提高你的代码可读性，这在代码比较长的函数中尤为有用。
 如果相同的作用域中有多个 defer 块，它们将被按照逆序执行。你可以把这种行为想象为一个栈。一开始，你可能会觉得逆序执行的 defer 很奇怪，不过你可以看看这个例子，你就能很快明白为什么要这样做了：
 
 ```
 guard let database = openDatabase(...) else { return }
 defer { closeDatabase(database) }
 guard let connection = openConnection(database) else { return }
 defer { closeConnection(connection) }
 guard let result = runQuery(connection, ...) else[…]”
```
 */

//: ## 错误链 (...)

//: ## 链结果
enum ResultOther<A> {
    case failure(Error)
    case success(A)
}

extension ResultOther {
    func flatMap<B>(transform: (A) -> ResultOther<B>) -> ResultOther<B> {
        switch self {
        case let .failure(m): return .failure(m)
        case let .success(x): return transform(x)
        }
    }
}

// 如何优雅的处理链式调用多个可能抛出错误的方法
// 通过使用 flatMap
/*:
 ```
 func checkFilesAndFetchProcessID(filenames: [String]) -> Result<Int> {
     return filenames
         .all(matching: checkFile)
         .flatMap { _ in contents(ofFile: "Pidfile") }
         .flatMap { contents in
             Int(contents).map(Result.success)
                 ?? .failure(ReadIntError.couldNotRead)
         }
 }
 ```
 (我们这里使用的 all(matching:)，checkFile 和 contents(ofFile:) 都是返回 Result 值的变种版本。它们具体的实现在此没有列出)

 即使这样，你也可以看到 Swift 的错误处理机制表现得更好，它比 Result 链式调用的代码更短，而且它显然更易读易懂
 */


//: ## 高阶函数与错误
//: - Note: 1、可选值和 Result 作用于类型，而 throws 只对函数类型起效。 2、在处理异步API回调，原声的错误处理不合适时，积极的使用Result这种类型错误。

//: [Next](@next)
