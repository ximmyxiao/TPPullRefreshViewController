//
//  UIViewController+HierarchyAddition.m
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-5-6.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIViewController+HierarchyAddition.h"

@implementation UIViewController (HierarchyAddition)

- (UIViewController*)topMostViewController{
    if (self.presentedViewController!=nil) {
        return [self.presentedViewController topMostViewController];
    }
    else if ([self isKindOfClass:[UITabBarController class]]) {
        return [[(UITabBarController*)self selectedViewController] topMostViewController];
    }
    else if([self isKindOfClass:[UINavigationController class]]){
        return [[(UINavigationController*)self topViewController] topMostViewController];
    }
    else{
        return self;
    }
}

- (UIViewController*)topPresentedViewController{
    if (self.presentedViewController == nil) {
        return self;
    }
    else{
        return [self.presentedViewController topPresentedViewController];
    }
}

@end
