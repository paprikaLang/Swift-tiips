//
//  ViewController.h
//  test
//
//  Created by paprika on 2017/9/19.
//  Copyright © 2017年 paprika. All rights reserved.
//

#import <UIKit/UIKit.h>
//__attribute__((objc_subclassing_restricted))

@interface ViewController : UIViewController
+ (void)one __attribute__((objc_requires_super));
@end
__attribute__((objc_runtime_name("Two")))
@interface One: ViewController
@end
