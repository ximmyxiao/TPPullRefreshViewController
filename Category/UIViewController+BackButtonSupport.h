//
//  UIViewController+BackButtonSupport.h
//  QQMovieTicket
//
//  Created by brightshen on 14-2-26.
//  Copyright (c) 2014年 brightshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BackButtonSupport)

- (void)setupBackBarButton;
- (void)setupBackBarButtonWithTarget:(id)target andAction:(SEL)action;

@end
