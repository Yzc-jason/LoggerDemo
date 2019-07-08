//
//  NSObjce+NilSafe.h
//  LoggerDemo
//
//  Created by 叶志成 on 2019/2/25.
//  Copyright © 2019 yzc. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//! Project version number for NSObjectSafe.
FOUNDATION_EXPORT double NSObjectSafeVersionNumber;

//! Project version string for NSObjectSafe.
FOUNDATION_EXPORT const unsigned char NSObjectSafeVersionString[];

@interface NSObject(Swizzle)
+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector;
- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector;
@end
