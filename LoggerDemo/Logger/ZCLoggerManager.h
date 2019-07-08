//
//  ZCLoggerManager.h
//  LoggerDemo
//
//  Created by 叶志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ZCLoggerManager : NSObject
+ (instancetype)sharedManager;

- (void)configLogger;

- (NSArray<NSURL *> *)logPaths;

- (NSArray<NSString *> *)logRelativePaths;

@end
