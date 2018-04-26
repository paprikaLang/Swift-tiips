import Foundation

final class Episode: NSObject {
    var title: String
    @objc var type: String
    @objc var length: Int
    init(title: String,type: String,length: Int) {
        self.title = title
        self.type = type
        self.length = length
    }
    override var description: String {
        return title + "\t" + type + "\t" + String(length)
    }
}
let episodes = [
    Episode(title: "title 1", type: "Free", length: 100),
    Episode(title: "title 2", type: "Paid", length: 300),
    Episode(title: "title 3", type: "Free", length: 130),
    Episode(title: "title 4", type: "Paid", length: 180),
    Episode(title: "title 5", type: "Paid", length: 210),
    Episode(title: "title 6", type: "Free", length: 190)
]
let typeDescriptor = NSSortDescriptor(
    //1.编译的时候发现不了语法错误,没有类型检查.等到运行时就有可能出现故障如: Episode.length和localizedCompare在编译时是没有问题的
    key:  #keyPath(Episode.type),
    ascending: true,
    //2.不仅是运行时特性,这样的方法比较还要要求对象本身是class,并继承于NSObject,属性要@objc修饰.数组在Array和NSArray之间转换,Any和model之间转换,非常麻烦.
    selector: #selector(NSString.localizedCompare(_:))
    //解决的方案:1.swift中的函数可以用 closure expression 来代替.用函数名(类型)代替#selector
    //keyPath 也可以用函数类型表达
)

let lengthDescriptor = NSSortDescriptor(
    key: #keyPath(Episode.length),
    ascending: true
)
let descriptors = [typeDescriptor,lengthDescriptor]
let sortedEpisodes = (episodes as NSArray).sortedArray(using: descriptors)
sortedEpisodes.forEach{print($0 as! Episode)}




/*
     函数类型替代OC中的KVC 和 selector,方便类型检查. 泛型函数代替OC引用类型
     key:@escaping (Key) ->Value,     =>   key:  #keyPath(Episode.type)
     _ isAscending: @escaping(Value, Value) -> Bool  => selector: #selector(NSString.localizedCompare(_:))
 */




typealias SortDescriptor<T> = (T,T) -> Bool
let stringDescritor: SortDescriptor<String> = {
    $0.localizedCompare($1) == .orderedAscending
}
let lengthesDescriptor: SortDescriptor<Episode> = {
    $0.length < $1.length
}

func makeDescriptor<Key,Value> (
    key:@escaping (Key) ->Value,
    _ isAscending: @escaping(Value, Value) -> Bool
    ) -> SortDescriptor<Key>
{
    return { isAscending(key($0),key($1))}
}

func shift<T>(_ compare: @escaping SortDescriptor<T>) -> SortDescriptor<T?>{
    return { l, r in
        switch (l,r) {
        case (nil, nil):
            return false
        case (nil, _):
            return false
        case (_, nil):
            return true
        case let (l?, r?):
            return compare(l, r)
        default:
            fatalError()
        }
        
    }
}


let stringsDescritor: SortDescriptor<Episode> = makeDescriptor(key: { $0.type }, {
    $0.localizedCompare($1) == .orderedAscending
})

let lengthsDescriptor: SortDescriptor<Episode> = makeDescriptor(key: {$0.length}, <)

episodes.sorted(by: stringsDescritor).forEach({print("\nsingle\($0)")})

infix operator |>: LogicalDisjunctionPrecedence

func |> <T>(l: @escaping SortDescriptor<T>,
            r: @escaping SortDescriptor<T>) -> SortDescriptor<T> {
    return {
        if l($0, $1) {
            return true
        }
        if l($1, $0) {
            return false
        }
        if r($0, $1) {
            return true
        }
        return false
    }
}

func combine<T>(rules: [SortDescriptor<T>]) -> SortDescriptor<T> {
    return { l,r in
        for rule in rules {
            if rule(l,r) {
                return true
            }
            if rule(r,l) {
                return false
            }
        }
        return false
    }
}

let mixDescriptor = combine(rules: [stringsDescritor,lengthsDescriptor])
episodes.sorted(by: mixDescriptor).forEach({print($0)})
episodes.sorted(by: stringsDescritor |> lengthsDescriptor).forEach({ print($0) })


let nums = ["Five","2","3","1","Four"]
let intDescriptor: SortDescriptor<String> = makeDescriptor(key: {Int($0)},shift(<))
nums.sorted(by: intDescriptor).forEach({print($0)})
