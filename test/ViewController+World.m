//
//  ViewController+World.m
//  test
//
//  Created by paprika on 2018/2/22.
//  Copyright © 2018年 paprika. All rights reserved.
//

#import "ViewController+World.h"
#warning paprika
//#error paprika
#pragma message "paprika"
_Pragma("message \"paprika\"")
#pragma GCC warning "paprika"
//#pragma GCC error "paprika"
//如果是上述带#开头的警告是不能被#define作为宏的.  _Pragma("message \"paprika\"")则可以

#define SOME_WARNING _Pragma("message \"paprika\"")
// 转成字符串
#define STRINGIFY(S) #S
// 需要解两次才解开的宏
#define DEFER_STRINGIFY(S) STRINGIFY(S)

#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))

// 为warning增加更多信息
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)

// 使宏前面可以加@
#define KEYWORDIFY try {} @catch (...) {}

// 最终使用的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))
@implementation ViewController (World)
SOME_WARNING
PRAGMA_MESSAGE("HELLO")

@end
