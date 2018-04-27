//: [Previous](@previous)

import Foundation

let numbers: [Int] = []
if !numbers.isEmpty && numbers[0] > 0 {
    
}
//2.可以用函数()->Bool 来代替Bool.这样参数的评估就要延后到函数执行时了
func logicAnd(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
    guard l else {
        return false
    }
    //3.在这里执行函数
    return r()
}
//1.与if语句不同,函数在运行之前会评估函数的参数,所以numbers[0]在空数组时会提前被发现运行时错误,而函数内部guard语句也执行不到了
//4.但是closure expression: `{numbers[0]>0}` 的表达很奇怪,@autoclosure 就是省略{}的语法糖,作用还是延后执行结果
logicAnd(!numbers.isEmpty, numbers[0]>0 )


