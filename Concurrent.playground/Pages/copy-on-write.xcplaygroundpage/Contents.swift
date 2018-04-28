import Foundation
//swift的数组是值类型,符合copy on write原则. 数组只是保存一个引用的地址,数组里的元素存放在另外的堆内存中.只有引用的对象修改了数组,这个对象才会拷贝一份数组进行操作.
let num1 = [1,2,3,4,5]
var num2 = num1
num2[0] = 2
num2.append(3)
MemoryLayout.size(ofValue: num1)
MemoryLayout.size(ofValue: num2) //8: 64位地址占据的空间
//final 防止被其他class继承,泛型T是要封装的类型
final class Box<T> {
    var unbox: T
    init(_ unbox: T) {
        self.unbox = unbox
    }
}
struct MyArray {
    var data: Box<NSMutableArray>
    //2.所以,不仅array创建的时候要深度拷贝data,当修改data时也要重新深度拷贝data的值
    var dataCOW: NSMutableArray {
        //cant assign to propety:self is immutable
        mutating  get {
            if !isKnownUniquelyReferenced(&data) {
               self.data = Box(data.unbox.mutableCopy() as! NSMutableArray)
                print("copied")
            }
            //4.根据3讲述的缺陷,可以先判断修改MyArray时是几个对象在引用,如果只是一个则不必copy on write
            return self.data.unbox
        }
    }
    //1.每当创建新的MyArray时,要不止拷贝走对象的引用,还要拷贝值. 但data内容拷贝的处理方式没有改变,还是浅拷贝,也就是 uncopy on write.只有对象内部所有的成员都是深拷贝, 对象才是深拷贝
    // 也就是说即使 MyArray的创建对象是let,也可以data insert 修改内部的引用类型 data.
    init(data: NSMutableArray) {
        self.data = Box(data.mutableCopy() as! NSMutableArray)
    }
    mutating func append(element: Any) {
        //3.执行dataCOW.insert时,已经调用了dataCOW的get方法了,也就是深度拷贝完成.但是在不修改也就是没有调用dataCOW.insert时,还是用引用类型data来引用它的指针了.这样就实现了隐藏引用类型NSMutableArray数据存储而实现了 copy on write 的事实.
        //但结果还是有一个缺陷,就是在for循环中,只有最后一个循环结果有用,而循环过程中所有的data拷贝都是在浪费资源.
        dataCOW.insert(element,at: self.data.unbox.count)
    }
    
}

var m = MyArray(data:[1,2,3])
var n = m

m.append(element:11)

print(m.data === n.data)

var array = [1,2,3]
var h = array


class Demo {}
var mode1 = Demo()
var mode2 = mode1 //引用次数加一,isKnownUniquelyReferenced为false
print(isKnownUniquelyReferenced(&mode1))

var objArray: NSMutableArray = [1,2,3]
print(isKnownUniquelyReferenced(&objArray)) //类型为NSMutableArray时失灵,reference为1时也为false

var box = Box(objArray)
print(isKnownUniquelyReferenced(&box))
/*这样就好了,类似的封装类还有很多.
 例如如果struct的引用类型的成员过多,可以把这些成员封装在一个class里面,而这个class重新作为struct的唯一成员,再引用也只增加一个而已.
 struct Demo {
     var member: DemoWrapper = DemoWrapper()
 }
 class DemoWrapper {
     var website = NSURL(string: "http://")
     var name = NSString(string: "tiyo")
     var addr = NSString(string: "address")
 }
 var x = Demo()
 var y = x
 */

var arr: [MyArray] = [MyArray(data: [1,2,3]),MyArray(data: [4,5,6])]
//1.array 对于自身元素的引用不增加引用计数
arr[0].append(element: 4)

var item = arr[0]
item.append(element: 4)

var dic = ["key": MyArray(data: [1,2,3])]
//2.dictionary 对自身元素的引用增加元素的引用计数
dic["key"]?.append(element: 4)
