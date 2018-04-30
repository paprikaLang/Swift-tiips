//
//  OptionalViewController.swift
//  test
//
//  Created by paprika on 2017/10/27.
//  Copyright © 2017年 paprika. All rights reserved.
//

import UIKit

class OptionalViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()

        option()
        
        let add2 = addFactory(2)
        let result = add2(3)
        print(result)
        
        sorty()
        //reduce模拟map
        let arr = [1, 3, 2]
        let res = arr.reduce([]) {
            (a: [Int], element: Int) -> [Int] in
            var t = Array(a)
            t.append(element * 2)
            return t
        }
        print(res)
        
        let arr1 = [1, 3, 2, 4]
        
        let res1: (Int, Int) = arr1.reduce((0, 1)) {
            (a :(Int, Int), element: Int) -> (Int, Int) in
            if element % 2 == 0 {
                return (a.0, a.1 * element)
            } else {
                return (a.0 + element, a.1)
            }
        }
        print(res1)
        
        let arr2 = [123,414231,122,115142123]
        let res2 = arr2.first.flatMap {
            arr2.reduce($0, max)
        }
        print(res2)
        
        
        let tq: Int? = 1
        let b = tq.map { (a: Int) -> Int? in
            if a % 2 == 0 {
                return a
            } else {
                return nil
            }
        }
        if let _ = b {
            print("not nil")
        }
        print(b,tq)//Optional(nil) Optional(1)
        
        // 闭包接受的是 Int 类型，返回的是一个 Optional（封装后的值）
        let tq1: Int? = 1
        let c = tq1.flatMap { (a: Int) -> Int? in
            if a % 2 == 0 {
                return a
            } else {
                return nil
            }
        }
        print(c,tq1)//nil Optional(1)
        
    }
    func option(){
        /*
         (lldb) fr v -R a
         (Swift.Optional<Swift.Int>) a = Some {
            Some = {
              value = 1
           }
         }
         
         (lldb) fr v -R b
         (Swift.Optional<Swift.Optional<Swift.Int>>) b = Some {
           Some = Some {
            Some = {
             value = 1
              }
           }
         }
         //多层嵌套的Optional树形结构
         (lldb) fr v -R c
         (Swift.Optional<Swift.Optional<Swift.Optional<Swift.Int>>>) c = Some {
         Some = Some {
           Some = Some {
             Some = {
               value = 1
                 }
               }
            }
         }
         */
        //在 LLDB 中输入 fr v -R foo，可以查看 foo 这个变量的内存构成
        //为什么会嵌套?是因为value需要的类型和赋值的类型不匹配,系统就会调用Optional的构造方法在外层再包裹一层Optional.Some(...),如果赋值为nil,多包裹的这一层会被 if let 认为是有值,返回给value.使得置空(nil)失效.注意 Optional<Optional<String>>.None和Optional.Some(<Optional<String>.None>)的差别
        /*
         public subscript(key: Key) -> Value? {
           get {
             return _variantStorage.maybeGet(key)
           }
           set(newValue) {
             if let x = newValue {
               _variantStorage.updateValue(x, forKey: key)
             }
             else {
                removeValueForKey(key)
             }
           }
         }
         */
        let a: Int? = 1
        let b: Int?? = a
        let c: Int??? = b
        
        /*
         var dict :[String:String?] = [:]        [:]
         dict = ["key": "value"]                [key:{Some"value"}]
         func justReturnNil() -> String? {
         return nil
         }
         dict["key"] = justReturnNil()            nil
         dict                                    [key: nil]
         */
       
    }
    //函数当返回值 注意((Int)->Int)是一个函数的类型(给一个数返回一个数的加法函数),当然也可以用typealias来定义函数的类型
    func addFactory(_ addValue:Int) -> ((Int)->Int){
        func adder(value:Int)->Int{
            return addValue + value
        }
        return adder
    }
    func sorty(){
        let array = [1, 3, 2, 4]
        let res = array.sorted {
            $0 > $1
        }
        let res1 = array.sorted()
        print(res,res1)
    }
    //Map函数: public func map<T>(@noescape transform: (Self.Generator.Element) throws -> T) rethrows -> [T]
//@noescape,专门修饰闭包的,表示该闭包不会跳出这个函数的生命期,这和@escaping正好相反
//当这个闭包有dispatch_async嵌套,这个闭包就在另一个线程中执行从而跳出了当前函数的生命期
//rethrows使得如果你传进去的闭包不会抛出异常的话,调用代码就不用写try
//map函数的参数是另一个函数,它接受数组元素作为参数返回一个新类型,这样map就可轻松做元素变换了
//一个+2的函数和一个+3的函数,得到一个+5的函数
//func funcBuild(f: Int -> Int, _ g: Int -> Int)-> Int -> Int 函数类型
//func funcBuild(f: IntFunction, _ g: IntFunction)-> IntFunction //typealias IntFunction = Int->Int
//func funcBuild<T, U, V>(f: T -> U, _ g: V -> T)-> V -> U 泛型
//三者比较,效果很明显,泛型的数据流可以很清晰的看清
    /*
     extension SequenceType {
     public func map<T>(transform: (Self.Generator.Element) -> T)
     -> [T]
     }
     /*
        flatMap
     */
     //1.降维的重载方法,接受闭包返回数组,当map的闭包函数返回的结果不是SequenceType的时候,flatMap就会调用第二种重载方法,这时和map的区别只是在于是不是过滤nil的情况
     extension SequenceType {
     public func flatMap<S : SequenceType>(transform: (Self.Generator.Element) -> S)
     -> [S.Generator.Element]
     }
     //相当于
     var arr = [1, 3, 2]
     arr.appendContentsOf([4, 5])
     // arr = [1, 3, 2, 4, 5]
     
     //2.(Self.Generator.Element)->T?->[T]的重载方法,去掉nil的项
     extension SequenceType {
     public func flatMap<T>(transform: (Self.Generator.Element) -> T?)
     -> [T]
     }
     */
    
    //optional
//    public enum Optional<Wrapped> : _Reflectable, NilLiteralConvertible {
//        case None
//        case Some(Wrapped)
//
//        public func map<U>( f: (Wrapped) throws -> U)
//            rethrows -> U?
//
//        public func flatMap<U>( f: (Wrapped) throws -> U?)
//            rethrows -> U?
//    }
    //Optional 的 map 和 flatMap 源码
    /*
     /// If `self == nil`, returns `nil`.
     /// Otherwise, returns `f(self!)`.
     public func map<U>(@noescape f: (Wrapped) throws -> U)
     rethrows -> U? {
     switch self {
     case .Some(let y):
     return .Some(try f(y))
     case .None:
     return .None
     }
     }
     
     /// Returns `nil` if `self` is `nil`,
     /// `f(self!)` otherwise.
     @warn_unused_result
     public func flatMap<U>(@noescape f: (Wrapped) throws -> U?)
     rethrows -> U? {
     switch self {
     case .Some(let y):
     return try f(y)
     case .None:
     return .None
     }
     }
     既然 Optional 的 map 和 flatMap 本质上是一样的，为什么要搞两种形式呢？这其实是为了调用者更方便而设计的。调用者提拱的闭包函数，既可以返回 Optional 的结果，也可以返回非 Optional 的结果。对于后者，使用 map 方法，即可以将结果继续转换成 Optional 的。结果是 Optional 的意味着我们可以继续链式调用，也更方便我们处理错误。
     var arr = [1, 2, 4]
     let res = arr.first.flatMap {
     arr.reduce($0, combine: max)
     }
     这段代码的功能是：计算出数组中的元素最大值，按理说，求最大值直接使用 reduce 方法就可以了。不过有一种特殊情况需要考虑：即数组中的元素个数为 0 的情况，在这种情况下，没有最大值。
     
     我们使用 Optional 的 flatMap 方法来处理了这种情况。arr 的 first 方法返回的结果是 Optional 的，当数组为空的时候，first 方法返回 .None，所以，这段代码可以处理数组元素个数为 0 的情况了。
     */
}













