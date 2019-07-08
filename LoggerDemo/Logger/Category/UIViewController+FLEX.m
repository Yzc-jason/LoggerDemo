//
//  UIViewController+FLEX.m
//  LoggerDemo
//
//  Created by 志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//

#import "UIViewController+FLEX.h"
#import "NSObject+NilSafe.h"
#import "ZCLoggerManager.h"
#import "ZCLogMacros.h"
#import <SSZipArchive/SSZipArchive.h>

#if DEBUG
#import <FLEX/FLEXManager.h>
#endif


@implementation UIViewController (FLEX)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObject* obj = [[self alloc] init];
        [obj swizzleInstanceMethod:@selector(viewDidLoad) withMethod: @selector(hookViewDidLoad)];
    });
}

- (void)hookViewDidLoad {
    [self addTapGestureForFLEX];
    [self hookViewDidLoad];
}

- (void)addTapGestureForFLEX {
#if defined(DEBUG) || defined(FLEX_ENABLE)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    [tap setNumberOfTapsRequired:2];
    [tap setNumberOfTouchesRequired:1];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)doubleTapped:(id)sender {
    if ([FLEXManager sharedManager].isHidden) {
        [[FLEXManager sharedManager] showExplorer];
    } else {
        [[FLEXManager sharedManager] hideExplorer];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    Class class = NSClassFromString(@"UIKeyboardLayoutStar"); //防止键盘输入与手势冲突导致键盘输入时卡顿
    if ([touch.view isKindOfClass:class]) {
        return NO;
    }
    return YES;
#endif
}

# pragma mark - Log Export
- (void)exportLogs {
    if ([[[ZCLoggerManager sharedManager] logPaths] count] > 0) {
        NSString *path     = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"log.zip"];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[ZCLoggerManager sharedManager] logRelativePaths]];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([SSZipArchive createZipFileAtPath:filePath withFilesAtPaths:tempArray withPassword:[NSString stringWithFormat:@"yzc.log"]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showActivityWithFilePath:filePath];
                });
            }
        });
    }
}

- (void)showActivityWithFilePath:(NSString *)filePath {
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:filePath]] applicationActivities:nil];
    activity.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    activity.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray *_Nullable returnedItems, NSError *_Nullable activityError) {
        if (completed) {
            ZCLogInfo(@"导出数据成功");
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error) {
                ZCLogInfo(@"删除临时文件失败");
            }
        } else {
            if (activityError != nil) {
                ZCLogInfo(@"导出数据失败：%@", activityError);
            }
        }
    };
    [self presentViewController:activity animated:YES completion:^{}];
}

- (void)addUploadLogAndDBMethod:(UIView *)subview {
    subview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exportLogs)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired    = 3;
    [subview addGestureRecognizer:tap];
}


@end
