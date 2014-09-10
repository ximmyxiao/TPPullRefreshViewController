//
//  UIViewController+QModalView.h
//  QQMovieTicketiPad
//
//  Created by 谌启亮 on 13-4-10.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    QModalViewStyleAlert = 0,
    QModalViewStyleFormSheet,
    QModalViewStyleZoomInAndCover,
    QModalViewStyleSimpleZoom,
    QModalViewStyleUnknown
}QModalViewStyle;

@interface UIViewController (QModalView)

//弹出一个模态View Controller，会根据displaySize自动居中显示。
- (void)presentQModalViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag;
- (void)presentQModalViewController:(UIViewController *)viewControllerToPresent displayedSize:(CGSize)displaySize animated:(BOOL)flag;

//销毁已经弹出的模态View Controller
- (void)dismissQModalViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissQModalViewControllerAnimated:(BOOL)flag;

@property(nonatomic) QModalViewStyle qModalViewStyle;
@property(nonatomic) UIViewController *qModalViewController;
@property(nonatomic) BOOL dismissWhenTouchedOutOfBound;

@end
