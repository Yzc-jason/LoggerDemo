//
//  ZCLoggerManager.m
//  LoggerDemo
//
//  Created by 叶志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//

#import "ZCLogFileFormatterDefault.h"
#import "ZCLoggerManager.h"

#define CACHE_PATH    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define LIBRARY_PATH  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
#define TEMP_PATH     NSTemporaryDirectory()

#define LOGS_FOLDER_NAME @"logs"


@implementation ZCLoggerManager

+ (instancetype)sharedManager {
    static ZCLoggerManager *_instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZCLoggerManager alloc] init];
    });
    
    return _instance;
}

/**
 Log 分级策略：
 Verbose: 一些底层数据 log，一般不显示也无妨，如 一些繁杂、底层 BLE的信息,只在必要的时候需要开启
 Debug: 能够帮助排查问题的 log，如 用户 Id，这个也是大部分的 log 等级
 Info: 重要信息的 log，如 重要业务、特殊信息
 Warning: 重要信息的 log，如网络请求失败、蓝牙命令失败等
 Error: 具有严重、致命错误的 log，如 支付相关的错误信息、app crash等
 
 Log 要求:
 Debug模式： file + console
 RZC: file(Debug)
 App Store: file(Info)
 */
- (void)configLogger {
#if DEBUG
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelVerbose];
#endif
    
    // File Log
    NSString *logsPath   = [CACHE_PATH stringByAppendingPathComponent:@"logs"];
    [[NSFileManager defaultManager] createDirectoryAtPath:logsPath withIntermediateDirectories:YES attributes:nil error:nil];
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logsPath];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    fileLogger.logFormatter = [[ZCLogFileFormatterDefault alloc] init];
    
#if defined(LOG_ENABLE) || DEBUG
    [DDLog addLogger:fileLogger withLevel:DDLogLevelDebug];
    
#else
    [DDLog addLogger:fileLogger withLevel:DDLogLevelInfo];
#endif
    
}

- (NSArray<NSURL *> *)logPaths {
    NSArray<NSString *> *subpaths;
    BOOL    isDir;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count] == 1) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString      *logsPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:LOGS_FOLDER_NAME];
        
        if ([fileManager fileExistsAtPath:logsPath isDirectory:&isDir] && isDir) {
            subpaths = [fileManager subpathsAtPath:logsPath];
            
            NSMutableArray<NSURL *> *fileURLs = [NSMutableArray new];
            for (NSString *filename in subpaths) {
                NSString *fullPath = [logsPath stringByAppendingPathComponent:filename];
                if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
                    [fileURLs addObject:[NSURL fileURLWithPath:fullPath isDirectory:NO]];
                }
            }
            return [fileURLs copy];
        }
    }
    
    return nil;
}

- (NSArray<NSString *> *)logRelativePaths{
    NSArray * urls = [self logPaths];
    NSMutableArray * relativePathArray = [NSMutableArray array];
    for (int i = 0; i < urls.count; i++) {
        NSURL * url = [urls objectAtIndex:i];
        [relativePathArray addObject:[url relativePath]];
    }
    return [relativePathArray copy];
}

@end
