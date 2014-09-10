//
//  UIViewController+HierarchyAddition.h
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-5-6.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HierarchyAddition)

- (UIViewController*)topMostViewController;
- (UIViewController*)topPresentedViewController;

@end
