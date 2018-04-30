//
//  TestViewController.m
//  test
//
//  Created by paprika on 2018/2/26.
//  Copyright © 2018年 paprika. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width*0.3, self.view.bounds.size.height*0.3);
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    
//    - (UIView *)view {
//        if (!_view) {
//            [self loadView];
//            [self viewDidLoad];
//        }
//    }
   

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width*0.3, self.view.bounds.size.height*0.3);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

@end
