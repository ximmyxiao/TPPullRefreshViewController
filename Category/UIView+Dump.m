//
//  UIView+Dump.m
//  NSOperationTest
//
//  Created by brightshen on 13-11-6.
//  Copyright (c) 2013年 brightshen. All rights reserved.
//

#import "UIView+Dump.h"

@implementation UIView (Dump)

- (NSString*)dumpViewHierarchyForIndent:(int)indent{
    NSString *dumpResult = [NSString stringWithFormat:@"%*s - %@\n", indent, "", self];
    for (UIView *view in self.subviews) {
        dumpResult = [dumpResult stringByAppendingString:[view dumpViewHierarchyForIndent:indent+4]];
    }
    return dumpResult;
}

- (NSString*)dumpViewHierarchy{
    return [self dumpViewHierarchyForIndent:0];
}

+ (NSString*)dumpAllWindows{
    NSString *dumpResult = [NSString string];
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([dumpResult length]>0) {
            dumpResult = [dumpResult stringByAppendingString:@"----------------------------"];
        }
        dumpResult = [dumpResult stringByAppendingString:[window dumpViewHierarchy]];
    }
    return dumpResult;
}

@end
