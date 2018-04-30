//
//  test.swift
//  test
//
//  Created by paprika on 2017/9/19.
//  Copyright © 2017年 paprika. All rights reserved.
//

import Foundation
public protocol NamespaceWrappable {
    //其实泛型的目的只有两个,实现多继承;遵守指定的泛型
    //associatedtype强制实现者必须遵守自己指定的泛型约束
    associatedtype WrapperType
    var hk: WrapperType { get }
    static var hk: WrapperType.Type { get }
}
//extension可以使实现时不会强制实现这个方法(这里使用计算型属性也相当于一个方法了)
public extension NamespaceWrappable {
    var hk: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var hk: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
