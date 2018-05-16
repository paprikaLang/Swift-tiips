//: [Previous](@previous)

import Foundation


import UIKit

typealias Op = (Int, Int) -> Int
indirect enum Node {
    case value(Int)
    case op(Op, Node, Node)
    
    func evaluate() -> Int {
        switch self {
        case .value(let v):
            return v
        case .op(let op, let left, let right):
            return op(left.evaluate(),right.evaluate())
        }
    }
}

extension Node: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self = .value(value)
    }
}
let root: Node = .op(+, 1, .op(*,3,3))
root.evaluate()









struct Person: ExpressibleByArrayLiteral {
    var name: String = ""
    var job: String = ""
    typealias Element = String
    init(arrayLiteral elements: Person.Element...) {
        if elements.count == 2 {
            name = elements[0]
            job = elements[1]
        }
    }
}

var p1: Person = ["hack","teacher"]

print(p1.name)
print(p1.job)
