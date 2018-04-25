//: [Previous](@previous)

import Foundation
extension Optional {
    func withExtendedLifetime(_ body:(Wrapped) -> Void) {
        if let value = self {
            body(value)
        }
    }
}
class Role {
    var name: String
    //action使用了self,所以lazy修饰防止self还没有创建
    lazy var action: ()-> Void = { [weak self] in
        if let `self` = self {
             print("\(self) takes this action")
        }
       
    }
    func level() {
        let globalQueue = DispatchQueue.global()
        globalQueue.async { [weak self] in
            withExtendedLifetime(self, {
                print("Before: \(self!) level up ")
                usleep(1000)
                print("After: \(self!) level down")
            })
        }
    }
    func levelUp() {
        let globalQueue = DispatchQueue.global()
        globalQueue.async { [weak self] in
            self.withExtendedLifetime{
                print("Before: \($0) level up ")
                usleep(1000)
                print("After: \($0) level down")
            }
        }
    }
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) destroy")
    }
}

extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}

var i = 10
//var captureI = { print(i) }
var captureI = { [i] in print(i) }
i = 11
captureI()

class Demo {
    var value = " "
}
var demo = Demo()
//capture([demo]) 捕获的变量是当前 demo
var captureDemo = { [demo] in print(demo.value)}
demo.value = "update"
demo = Demo()

captureDemo()

if true {
    let boss = Role("boss")
    let fn = { [unowned boss] in print("\(boss)") }
    boss.action = fn
}




