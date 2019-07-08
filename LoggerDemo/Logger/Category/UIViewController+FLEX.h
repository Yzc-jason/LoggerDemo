//
//  UIViewController+FLEX.h
//  LoggerDemo
//
//  Created by 志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FLEX)<UIGestureRecognizerDelegate>

- (void)addUploadLogAndDBMethod:(UIView *)subview;

@end

NS_ASSUME_NONNULL_END
