//
//  UIViewController+BackButtonSupport.m
//  QQMovieTicket
//
//  Created by brightshen on 14-2-26.
//  Copyright (c) 2014年 brightshen. All rights reserved.
//

#import "UIViewController+BackButtonSupport.h"

@implementation UIViewController (BackButtonSupport)

- (void)setupBackBarButton{
    [self setupBackBarButtonWithTarget:self andAction:@selector(_backBarButtonAction_BackButtonSupport)];
}

- (void)setupBackBarButtonWithTarget:(id)target andAction:(SEL)action{
    UIImage* originImg = [UIImage imageNamed:@"ArrowBackWhite"];
    if (!IS_IOS7_AND_LATER)
    {
        CGSize newSize = CGSizeMake(originImg.size.width + 10, originImg.size.height);
        UIGraphicsBeginImageContextWithOptions(newSize,NO,0);
        [originImg drawInRect:CGRectMake(10, 0, originImg.size.width, originImg.size.height)];
        originImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext() ;
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:originImg forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)_backBarButtonAction_BackButtonSupport{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
