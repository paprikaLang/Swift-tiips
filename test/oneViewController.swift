//
//  oneViewController.swift
//  test
//
//  Created by paprika on 2017/9/24.
//  Copyright © 2017年 paprika. All rights reserved.
//

import UIKit

class oneViewController: UIViewController {

 
    override func viewDidLoad() {
        super.viewDidLoad()
        run()
       let array = [1,1,1,1,2,3,3,4,4,5,5,6,6]
        var res = array[0]
        for i in 1..<array.count {
            res ^= array[i]//res = res^array[i]
        }
        print(res)
        print("run \(Thread.current)")
        //filter条件过滤
        let values = [1,3,5,7,9]
        let flattenResults = values.filter{ $0 % 3 == 0}
        print(flattenResults)
        //reduce本质是递归(需要前后两个结果,中间的变化在于另一个参数,像管道一样传递这个结果不停变化)
        let values1 = [1,3,5]
        let initialResult = 0
        var reduceResult = values1.reduce(initialResult, { (tempResult, element) -> Int in
            return tempResult + element
        })
        print(reduceResult)
        //等价
        func combine(tempResult: Int, element: Int) -> Int  {
            return tempResult + element
        }
        let  reduceresult1 = combine(tempResult: combine(tempResult: combine(tempResult: initialResult, element: 1), element: 3), element: 5)
        print(reduceresult1)
    }
    func run(){
        print("run \(Thread.current)")
    }


}
