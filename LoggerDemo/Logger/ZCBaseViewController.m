//
//  ZCBaseViewController.m
//  HuntReward
//
//  Created by 叶志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//

#import "ZCBaseViewController.h"

@interface ZCBaseViewController ()

@end

@implementation ZCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZCLogInfo(@"%@ viewDidLoad", NSStringFromClass([self class]));
}

- (void)dealloc {
    ZCLogInfo(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ZCLogInfo(@"%@ viewDidAppear", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    ZCLogInfo(@"%@ viewWillDisappear", NSStringFromClass([self class]));
}

@end
