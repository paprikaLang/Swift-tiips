
//: Playground - noun: a place where people can play

import UIKit
import Foundation

struct PointValue {
    var x: Int
    var y: Int
    
    mutating func move(to: PointValue) {
//        self.x = to.x
//        self.y = to.y
        //值类型可以给self直接复制,引用类型只能给对象的属性赋值
        self = to
    }
}

class PointRef {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func move(to: PointRef)  {
        self.x = to.x
        self.y = to.y
    }
}
let p1 = PointRef(x: 0, y: 0)
let p2 = PointValue(x: 0, y: 0)
//p2.x = 10 struct的属性值不能改变

//class关注的是对象,不能更改对象,但是对象的属性值class不关注
p1.x = 1
//p1 = PointRef(x: 1, y: 1)
var p3 = p1
var p4 = p2

p1 === p3
//p2 == p4 Binary operator '==' cannot be applied to two 'PointValue' operands
p3.x = 10
print(p1.x)

p4.x = 10
print(p2.x)


class Point2D {
    var x: Double
    var y: Double
    //memberwise init
    //真正初始化class属性的init方法，叫designated init，它们必须定义在class内部，而不能定义在extension里，否则会导致编译错误。
    init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
    //failable designated initializer
    init?(xy: Double) {
        guard xy>0 else {
            return nil
        }
        self.x = xy
        self.y = xy
    }
    convenience init(at: (Double, Double)) {
//        self.x = at.0 'self' used in property access 'x' before 'self.init' call 便利初始化方法一定要调用designated init
        self.init(x: at.0, y: at.1)
    }
    //failable initializer
    convenience init?(at: (String, String)) {
        guard let x = Double(at.0), let y = Double(at.1) else {
            return nil  //Only a failable initializer can return 'nil'
        }
        //最终只要调用了designated init方法就可以
        self.init(at: (x, y))
    }
}


//这个初始化方法要有默认值, var x: Double = 0这样. 编译器添加默认init
let origin = Point2D()
//当手动创建init之后,编译器就不会创建默认init方法了, 如果memberwise init的参数没有默认值.上面的Point2D()会报错
let point11 = Point2D(x: 11, y: 11)


//如果派生类没有定义任何designated init，那么它将自动继承所有基类的designated init. 但如果继承过来的init也不会给z属性赋值,那么最终不会继承任何designated init
class Point3D: Point2D {
//    var z: Double
}
class Pointt3D: Point2D {
    //设置z属性的默认值, 可以继承所有的init方法
    //如果一个派生类定义了所有基类的designated init，那么它也将自动继承基类所有的convenience init
        var z: Double = 0
}

Pointt3D()
Pointt3D(xy: 0)
Pointt3D(at: (1,2))
class Point3DD: Point2D {
    var z: Double
    //当派生类自己创建了designated init 方法之后,调用super.designated init方法获取x,y的值.但是这时由于继承不了所有的designated init方法,将不会继承基类所有的convenience init.  Point3DD(at: (1,2))会报错
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.z = z
        super.init(x: x, y: y)
    }
}

class Pointt3DD: Point2D {
    var z: Double
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        //************phase1***************
        self.z = z
        super.init(x: x, y: y)
        
        //************phase2***************
        transform(x: x, y: y, z: z)
    }
    
    func transform(x: Double, y: Double, z: Double) {
        self.x = round(x)
        self.y = round(y)
        self.z = round(z)
    }
    
    override  init(x: Double, y: Double) {
        //'self' used in property access 'x' before 'super.init' call. 派生类没有x,y属性,只有super.init之后才会继承过来这些属性
//        self.x = x
//        self.y = y
        self.z = 0
        super.init(x: x, y: y)
    }
    //failable designated init
    override init?(xy: Double) {
        guard xy>0 else {
            return nil
        }
        self.z = 0
       super.init(x: xy, y: xy)
//        self.x = xy
//        self.y = xy
    }
    //重写基类的便利方法无需override,因为说是重写,当内部调用的是派生类的designated init方法
    convenience init(at: (Double, Double)) {
        self.init(x: at.0, y: at.1, z:1)
    }
}
//重写所有designated init方法之后, 派生类自动继承了所有的convenient init方法
Pointt3DD(at: (1,2))
















