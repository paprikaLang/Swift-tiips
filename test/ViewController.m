//
//  ViewController.m
//  test
//
//  Created by paprika on 2017/9/19.
//  Copyright © 2017年 paprika. All rights reserved.
//
#import "TestViewController.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import "ViewController+Hello.h"
#import "ViewController+World.m"
#define onExit __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^
@interface NSObject (Sark)
+ (void)foo;
@end
@implementation NSObject (Sark)
- (int)foo {
    NSLog(@"%p", __builtin_return_address(0)); // 根据这个地址能找到下面ret的地址
    
    NSLog(@"IMP: -[NSObject (Sark) foo]");
    return 1;
}
@end

static void fixup_class_arc(Class class) {
    struct {
        Class isa;
        Class superclass;
        struct {
            void *_buckets;
#if __LP64__
            uint32_t _mask;
            uint32_t _occupied;
#else
            uint16_t _mask;
            uint16_t _occupied;
#endif
        } cache;
        uintptr_t bits;
    } *objcClass = (__bridge typeof(objcClass))class;
#if !__LP64__
#define FAST_DATA_MASK 0xfffffffcUL
#else
#define FAST_DATA_MASK 0x00007ffffffffff8UL
#endif
    struct {
        uint32_t flags;
        uint32_t version;
        struct {
            uint32_t flags;
        } *ro;
    } *objcRWClass = (typeof(objcRWClass))(objcClass->bits & FAST_DATA_MASK);
#define RO_IS_ARR 1<<7
    objcRWClass->ro->flags |= RO_IS_ARR;
}

__attribute__((overloadable)) void logAnything(id obj) {
    NSLog(@"%@", obj);
}
__attribute__((overloadable)) void logAnything(int number) {
    NSLog(@"%@", @(number));
}
__attribute__((overloadable)) void logAnything(CGRect rect) {
    NSLog(@"%@", NSStringFromCGRect(rect));
}

static void printAge(int age)
    __attribute__((enable_if(age>0 && age<120, "你是地球人?"))) {
        printf("%d",age);
}


int sum(int a, int b);
@interface Sark : NSObject {
    __strong id _gayFriend; // 无修饰符的对象默认会加 __strong
    __weak id _girlFriend;
    __unsafe_unretained id _company;
}
@end
// 指定一个cleanup方法，注意入参是所修饰变量的地址，类型要一样
// 对于指向objc对象的指针(id *)，如果不强制声明__strong默认是__autoreleasing，造成类型不匹配
static void stringCleanUp(__strong NSString **string) {
    NSLog(@"%@", *string);
}
//假如一个作用域内有若干个cleanup的变量，他们的调用顺序是先入后出的栈式顺序；
//而且，cleanup是先于这个对象的dealloc调用的。
static void sarkCleanUp(__strong Sark **sark) {
    NSLog(@"这个是vc%@", *sark);
}
// void(^block)(void)的指针是void(^*block)(void)
static void blockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}
@implementation Sark
@end
@interface ViewController ()
@end

@implementation ViewController

+(void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSString *str =@"paprika";
        reference = str;//?will(null),did(paprika)?
        logAnything(23);
        [self one];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}
__unsafe_unretained id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"-----%d",sum(10, 12));//外链汇编 sum.s
    
    TestViewController *vc = [[TestViewController alloc] init];
    //view会不会按照调用方的frame设置显示,要看frame是在viewdidload还是之后的方法中设置.在ViewWillAppear中设值就不会影响此时的设值
    vc.view.frame = CGRectMake(0, 0, 500, 500);
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    //在这个string变量释放之后也就是这个{}走完去执行了stringCleanUp方法.所谓作用域结束，包括大括号结束、return、goto、break、exception等各种情况。
    __strong NSString *string __attribute__((cleanup(stringCleanUp))) = @"paprikaLang";
    __strong Sark *sark __attribute__((cleanup(sarkCleanUp),unused)) = [Sark new];
    // 加了个`unused`的attribute用来消除`unused variable`的warning
//    __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^{
//        NSLog(@"I'm dying...");
//    };
    NSRecursiveLock *aLock = [[NSRecursiveLock alloc] init];
    [aLock lock];
    onExit {
        [aLock unlock]; // 不用担心我忘写后半段了
        NSLog(@"2");
    };
    //本来写在中间的代码可以在后面想写多长写多长
    NSLog(@"1");

//    NSString *str =@"paprika";
    // str是一个autorelease对象，设置一个weak的引用来观察它
    @autoreleasepool {
      NSString *str = [NSString stringWithFormat:@"paprika"];
    }
//    reference = str;
//    NSLog(@"----didload%@", str);
    
//    printAge(121);
    printAge(12);
    logAnything(@[@"1", @"2"]);
    logAnything(233);
    logAnything(CGRectMake(1, 2, 3, 4));
    NSLog(@"%@", NSStringFromClass([One class])); //Two
    self.creditCardPassword = @"扩展";
    
    NSArray *items = @[@1, @2, @3];
    for (int i = -1; i < items.count; i++) {
        NSLog(@"%d", i);
    }
    
    //动态添加类,而成员变量又没有明确修饰符.不过ivar的修饰信息都存放在了Ivar Layout中,ivarlayout和weakIvarLayout分别记录了哪些ivar是strong或weak,都未记录的就是基本类型和__unsafe_unretained 的对象类型.
    Class class = objc_allocateClassPair(NSObject.class, "Hark", 0);
    class_addIvar(class, "_gayFriend", sizeof(id), log2(sizeof(id)), @encode(id));
    class_addIvar(class, "_girlFriend", sizeof(id), log2(sizeof(id)), @encode(id));
    class_addIvar(class, "_company", sizeof(id), log2(sizeof(id)), @encode(id));
    
    //如果strong ivar的ivarlayout值为0x012000,weak的为0x1200.都说明有一个strong和两个非strong
    //这步是在设置__weak或者__strong
    class_setIvarLayout(class, (const uint8_t *)"\x01\x12"); // <--- new
    class_setWeakIvarLayout(class, (const uint8_t *)"\x11\x10"); // <--- new
    objc_registerClassPair(class);
    
    //class的flags中有一个标记位记录这个类是否ARC,正常编译的类都标识了-fobjc-arc flag为1,动态创建的类没有设置.
    //这步是在运行时把标记位设置上去
    fixup_class_arc(class);
    //测试
    id hark = [class new];
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList(class, &ivarsCnt);
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; p++) {
        Ivar const ivar = *p;
        NSLog(@"ivar:%@",[NSString stringWithUTF8String:ivar_getName(ivar)]);
    }
    free(ivars);
    Ivar weakIvar = class_getInstanceVariable(class, "_girlFriend");
    Ivar strongIvar = class_getInstanceVariable(class, "_gayFriend");
    {
        id girl = [NSObject new];
        id boy = [NSObject new];
        object_setIvar(hark, weakIvar, girl);
        object_setIvar(hark, strongIvar, boy);
    } // ARC 在这里会释放大括号内的 girl，boy
    // 输出：weakIvar 为 nil，strongIvar 有值 :  (null), <NSObject: 0x60000000e8c0>
    NSLog(@"%@, %@", object_getIvar(hark, weakIvar), object_getIvar(hark, strongIvar));
}

+ (void)one {
    @TODO("shutup");
    NSLog(@"setup module");
    //静态实例地址mutable和immutable的地址永远差16位(根据这个16位,__NSPlacehodlerArray判断出alloc的类是不是可变的),如果是多个不可变空对象(字典数组集合等),地址指向同一个静态对象
    id objc1 = [NSArray alloc];//__NSPlacehodlerArray
    id objc2 = [NSMutableArray alloc];//__NSPlacehodlerArray
    id objc3 = [objc1 init];
    id objc4 = [objc2 init];
    
    //[NSObject foo]方法查找路线为 NSObject meta class –super-> NSObject class
    //对比ruby:如果调用方法在类中没有,则会转发到一个存在的方法上(很随性)
    [NSObject foo];
    int ret = [[NSObject new] foo];
    NSLog(@"%p",&ret);
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"----will%@", reference);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"----did%@",reference);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"----dis%@",reference);
    
}
@end
@interface Two : ViewController
@end
@implementation Two
+ (void)one {
    
}
@end



