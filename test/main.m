//
//  main.m
//  test
//
//  Created by paprika on 2017/9/19.
//  Copyright © 2017年 paprika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
__attribute__((constructor))
static void beforeMain(void) {
    NSLog(@"beforeMain");
}
__attribute__((destructor))
static void afterMain(void) {
    NSLog(@"afterMain");
}
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
