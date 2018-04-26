import Foundation
//定义在extension中的方法是不能被重定义的
extension Shape {
    //draw负责参数的确定
    func draw(color: Color = .red) {
        //doDraw负责方法的不同实现
        doDraw(color: color)
    }
}

class Shape {
    enum Color {case red, yellow, green}
    func doDraw(color: Color = .green) {
        print("A \(color) shape.")
    }
}

class Square: Shape {
    override func doDraw(color: Color = .yellow) {
        print("A \(color) square.")
    }
}
//在swift里,继承而来的方法调用,是在运行时动态派发的.swift会在运行时动态选择一个对象真正要调用的方法.
//但是方法的参数出于性能的考虑却是静态绑定的.编译器会根据调用方法的对象的字面类型绑定函数的参数.这样形成了派生类方法的实现,基类的参数
let s = Square()
s.draw() // red
let ss: Shape = Square()
ss.draw(color: .green)
ss.draw() //yellow
ss.doDraw()
/*
 A red square.
 A green square.
 A red square.
 A green square.
 */
