//
//  UIButton+SlideIn.m
//  QQMovieTicket
//
//  Created by Piao Piao on 14-8-13.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "UIButton+SlideIn.h"

@implementation UIView (SlideIn)
- (void)SlideIn
{
    
    static int key = 'slid';
    id obj = objc_getAssociatedObject(self, &key);
    if (obj != nil) {
        return ;
    }
    else{
        objc_setAssociatedObject(self, &key, [NSNumber numberWithFloat:1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    CGFloat origin = self.frame.origin.y;
    CGFloat from = [[UIScreen mainScreen] bounds].size.height + self.frame.size.height;
    self.y_origin = from;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.y_origin = origin;
    }];
}
@end
