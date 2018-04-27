//: [Previous](@previous)

import Foundation

protocol FinishAlertViewDelegate {
    mutating func buttonPressed(at Index: Int)
}
class FinishAlertView {
    var buttons:[String] = ["Cancel","The Next"]
    var delegate: FinishAlertViewDelegate?
    func goToTheNext() {
        delegate?.buttonPressed(at: 1)
    }
    
}
//2.现在再看swift delegate的缺点: 值类型的delegate没有weak修饰易造成引用循环,而且值类型也不适合做delegate
struct PressCounter: FinishAlertViewDelegate {
    var count = 0
    mutating  func buttonPressed(at index: Int) {
        self.count += 1
    }
}
class EpisodeViewController: FinishAlertViewDelegate {
    var episodeAlert: FinishAlertView!
    var counter: PressCounter!
    init() {
        self.episodeAlert = FinishAlertView()
       //1.pressCounter 是值类型,当pressCounter赋值给delegate时,是值拷贝,delegate和counter引用的是两个对象.所以pressCounter的count增加和self.counter没关系和self.counter.count也没关系
        self.counter = PressCounter()
        self.episodeAlert.delegate = self.counter
    }
    func buttonPressed(at index: Int) {
        print("go to the next episode ")
    }
}

let evc = EpisodeViewController()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
print(evc.counter.count)  //0
print((evc.episodeAlert.delegate as! PressCounter).count)  //5

//protocol FinishAlertViewDelegate: class {
//    func buttonPressed(at Index: Int)
//}
//class FinishAlertView {
//    var buttons:[String] = ["Cancel","The Next"]
//    weak var delegate: FinishAlertViewDelegate?
//    func goToTheNext() {
//        delegate?.buttonPressed(at: 1)
//    }
//
//}
//class EpisodeViewController: FinishAlertViewDelegate {
//    var episodeAlert: FinishAlertView!
//    init() {
//        self.episodeAlert = FinishAlertView()
//        self.episodeAlert.delegate = self
//    }
//    func buttonPressed(at index: Int) {
//        print("go to the next episode ")
//    }
//}






/*
 
         var delegate: FinishAlertViewDelegate?
         func goToTheNext() {
              delegate?.buttonPressed(at: 1)
         }
 
         //用函数类型属性作为callback 代替 delegate
 
         var buttonPressed: ((Int)->Void)?
         func goToTheNext() {
             buttonPressed?(1)
         }
 
 */






class AlertView {
    var buttons:[String] = ["Cancel","The Next"]
    var buttonPressed: ((Int)->Void)?
    func goToTheNext() {
        buttonPressed?(1)
    }
    
}

struct Counter{
    var count = 0
    mutating  func buttonPressed(at index: Int) {
        self.count += 1
    }
}
class CounterCls{
    var count = 0
    func buttonPressed(at index: Int) {
        self.count += 1
    }
}
class ViewController {
    var episodeAlert: AlertView!
    var counter: Counter!
    init() {
        self.episodeAlert = AlertView()
        self.counter = Counter()
    }
    func buttonPressed(at index: Int) {
        print("go to the next episode ")
    }
}

let fav = AlertView()
var counter = Counter()
//partial application of 'mutating' method id not allowed
//语义不清,是拷贝counter对象还是让fav捕获counter
// self.episodeAlert.delegate = self.counter <= 捕获而非拷贝
//放在closure expression里,就可以捕获counter了
//OC 的 delegate 和 block `传参` 也是这个逻辑
fav.buttonPressed = { counter.buttonPressed(at: $0)}

fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
//捕获成功
print(counter.count)  //5


var counterCls = CounterCls()
//counter用引用类型,引用循环的危险就存在.
//fav.buttonPressed = counterCls.buttonPressed
fav.buttonPressed = { [weak counterCls] index in
    counterCls?.buttonPressed(at: index)
}
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
//捕获成功
print(counter.count)  //5





