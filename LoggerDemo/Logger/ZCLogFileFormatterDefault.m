//
//  ZCLogFileFormatterDefault.m
//  LoggerDemo
//
//  Created by 叶志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//

#import "ZCLogFileFormatterDefault.h"

@interface ZCLogFileFormatterDefault ()
@property (nonatomic, strong) NSDateFormatter *cDateFormatter;
@end

@implementation ZCLogFileFormatterDefault
- (NSDateFormatter *)cDateFormatter {
    if (_cDateFormatter == nil) {
        _cDateFormatter = [[NSDateFormatter alloc] init];
        [_cDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; // 10.4+ style
        [_cDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    }
    
    return _cDateFormatter;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *dateAndTime = [self.cDateFormatter stringFromDate:(logMessage->_timestamp)];
    
    return [NSString stringWithFormat:@"[%@] %@", dateAndTime, logMessage->_message];
}

@end
