//
//  ZCLogMacros.h
//  LoggerDemo
//
//  Created by 叶志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//

#ifndef ZCLogMacros_h
#define ZCLogMacros_h

#import <CocoaLumberjack/CocoaLumberjack.h>

#if DEBUG
    #define ddLogLevel            DDLogLevelVerbose
#else
    #if defined(LOG_ENABLE)
        #define ddLogLevel            DDLogLevelVerbose
    #else
        #define ddLogLevel            DDLogLevelInfo
    #endif

#endif

#define ZCLogError(frmt, ...) DDLogError((@"<❗️Error>%s [LINE %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define ZCLogWarn(frmt, ...)  DDLogWarn((@"<❓Warning>%s [LINE %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define ZCLogInfo(frmt, ...)  DDLogInfo((@"<💧Info>%s [LINE %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define ZCLogDebug(frmt, ...) DDLogDebug((@"<✅Debug>%s [LINE %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define ZCLogVerbose(frmt, ...)   DDLogVerbose((@"<🔤Verbose>%s [LINE %d]" frmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)

#endif
/* ZCLogMacros_h */
