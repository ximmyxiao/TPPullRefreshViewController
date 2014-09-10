//
//  UIView+Dump.h
//  NSOperationTest
//
//  Created by brightshen on 13-11-6.
//  Copyright (c) 2013年 brightshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Dump)

- (NSString*)dumpViewHierarchy;
+ (NSString*)dumpAllWindows;

@end
