//
//  AddController.swift
//  test
//
//  Created by paprika on 2018/1/22.
//  Copyright © 2018年 paprika. All rights reserved.
//

import UIKit
class AddController : UIViewController {
    override func viewDidLoad() {
       print(add(a: 102, b: 26))
    }
    func add(a:Int,b:Int) -> Int {
        if(b==0){
            return a
        }
        let sum = a^b
        let carry = (a&b)<<1
        return add(a: sum,b: carry)
        
    }
}
