//ViewController  created on  2018/4/24 by paprika .

import UIKit
/*
 由于swift是一门集成了很多编程范式的语言,面向对象,面向协议,面向过程的.为了支持这些编程范式,尝试了所有常见的派发方式
 
 1.direct dispatch  面向过程     struct,  protocol 和 class 的 extension.不能重写定义在extension中的方法,非继承(继承方法的参数在有默认值的情况下容易出错,可以在基类的extension方法中添加这个参数,方法内部再调用继承方法)
 
 方法的地址直接编译到汇编指令里,称作 direct dispatch , 可以inline优化.
 
 
 2.table dispatch  witness table  面向对象 多态 虚函数表  protocol 和 class (除extension,不支持运行时获取函数内存地址)
 把一个class里的所有方法的地址放在一个数据结构里,通过这个数据结构(witness table)的地址偏移量获取每个方法的实际地址.调用方法的地址是在运行时获得的
 通过table内存地址获取调用方法的地址, 称作 table dispatch. 这也是最传统的多态实现方式
 
 3.message dispatch  @objc
 
 
 */

protocol MyProtocol {
    func bbb()
}
extension MyProtocol {
    func aaa() {
        print("hahh")
    }
    func bbb() {
        print("waaa")
    }
}
//NSOject 的派生class类的内部方法竟是table dispatch的,只有在extension中才是message dispatch,要想在extension中重写父类的方法,这个方法就要@objc和dynamic修饰.
//swift原生class也是table dispatch,但是extension中的方法是direct dispatch.不能被重写(继承)
class Base:NSObject, MyProtocol {
    @objc dynamic func method1() {
        print("base:message dispatch")
    }
    func method2() {}
    func aaa() {
        print("Base:hahh")
    }
    //@objc 仅仅是让OC的运行时识别(所以在使用selector时,也要添加@objc修饰), 并不会改变派发机制, dynamic可以,'dynamic' instance method 'ccc()' must also be '@objc'
    //final @nonobjc & dynamic @objc --- direct dispatch & message dispatch / 与运行时不可见 & 可见
    @objc dynamic func ccc(){
        print("base:ccc")
    }
 
}
class subClass: Base {
//    override func method1() {
//
//    }
    override func method2() {
        
    }
    func bbb() {
        print("sub:waaa")
    }
}
extension subClass {
    //NSOject的派生类extension方法是message dispatch,不会储存在 witness table 里,它的原生方法也要是dynamic修饰的,否则是table dispatch.
    override func ccc() {
        print("sub:ccc")
    }
}
struct MyStruct {
    func structFunc() {
        
    }
}

extension MyStruct {
    func structFunc1() {
    }
}


enum List {
    case end
    indirect case node(Int, next: List)
}
//indirect使得enum从值类型跳转到引用类型,这样多个node可以共用一个next:List
indirect enum Lisp {
    case end
    case node(Int,next: Lisp)
}
class ViewController: UIViewController {

    override func viewDidLoad() {
    
        let b = Base()
        let s = subClass()
        //callq  0x10405e060; symbol stub for: objc_msgSend  方法列表寻找 "method1"字符串
        b.method1()  //base:message dispatch
        s.method1()  //base:message dispatch 当派生类没有自己实现message dispatch方法时, 调用父类的默认实现
      
        /*
         ->  0x10405c83c <+44>:  movq   0x49ad(%rip), %rsi        ; "method1"
         0x10405c843 <+51>:  movq   -0x18(%rbp), %rdi
         0x10405c847 <+55>:  movq   %rax, -0x20(%rbp)
         0x10405c84b <+59>:  callq  0x10405e060               ; symbol stub for: objc_msgSend
         
         
         0x10405c850 <+64>:  movq   0x4999(%rip), %rsi        ; "method1"
         0x10405c857 <+71>:  movq   -0x20(%rbp), %rdi
         0x10405c85b <+75>:  callq  0x10405e060               ; symbol stub for: objc_msgSend
         */
        //callq  *%rsi  调用地址变成了间接内存引用
        //通过`register read rsi`读取寄存器rsi内容:dispatch-method`dispatch_method.subClass.method2() -> ()  rsi = 0x000000010f6a0250
        //di -s 0x000000010f6a0250 反汇编函数地址的内容: dispatch-method`subClass.method2(): dispatch-method`subClass.deinit:
        //method2,deinit这些方法都在table中相邻的位置上
        b.method2()
        s.method2()
        
        
        /*
         0x10f6a03f0 <+80>:  movq   -0x18(%rbp), %rax
         0x10f6a03f4 <+84>:  movq   (%rax), %rsi
         0x10f6a03f7 <+87>:  movq   0x50(%rsi), %rsi
         0x10f6a03fb <+91>:  movq   %rax, %r13
         0x10f6a03fe <+94>:  callq  *%rsi
         ->  0x10f6a0400 <+96>:  movq   -0x20(%rbp), %rax
         0x10f6a0404 <+100>: movq   (%rax), %rsi
         0x10f6a0407 <+103>: movq   0x50(%rsi), %rsi
         0x10f6a040b <+107>: movq   %rax, %r13
         0x10f6a040e <+110>: callq  *%rsi
         */
        let myStruct = MyStruct()
        //callq  0x10cd82390 ; dispatch_method.MyStruct.structFunc() -> ()  struct的方法或struct的extension的方法 是直接调用方法地址的汇编指令
        myStruct.structFunc()
        myStruct.structFunc1()
        
        /*
         0x10cd82410 <+80>:  callq  0x10cd823a0               ; dispatch_method.MyStruct.init() -> dispatch_method.MyStruct at ViewController.swift:19
         0x10cd82415 <+85>:  callq  0x10cd82390               ; dispatch_method.MyStruct.structFunc() -> () at ViewController.swift:20
         0x10cd8241a <+90>:  callq  0x10cd823b0               ; dispatch_method.MyStruct.structFunc1() -> () at ViewController.swift:26
         */
        
        let p: MyProtocol = b
        //只在 protocol 的 extension 中定义的方法是 direct dispatch, 非继承.
        b.aaa() //Base hahh
        p.aaa() //hahh
        s.aaa() //Base hahh
        
        let sub: MyProtocol = s
        //尽管base基类没有实现bbb方法但是还是继承了protocol内定义的方法在extension中的默认实现.不过可以在继承关系的class里override protocol定义的方法,比如base实现了aaa,那 sub自己实现aaa时就要加上override了
        s.bbb()  //sub:waaa
        sub.bbb() //waaa
        b.bbb()   //waaa
        let c: Base = subClass()
        c.ccc()   //sub:ccc
        
        
        let end = List.end
        _ = List.node(1, next: end)
        _ = List.node(2, next: end)
        //
        let end1 = Lisp.end
        _ = Lisp.node(1, next: end1)
        _ = Lisp.node(2, next: end1)
        
    }


}

