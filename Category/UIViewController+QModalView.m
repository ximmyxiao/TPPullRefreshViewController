//
//  UIViewController+QModalView.m
//  QQMovieTicketiPad
//
//  Created by 谌启亮 on 13-4-10.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIViewController+QModalView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


@interface UIViewController ()
@property(nonatomic, retain) UIControl *modalBackgroundView;
@property(nonatomic, retain) UIImageView *screenShotView;
@end

@implementation UIViewController (QModalView)
SYNTHESIZE_CATALOG_OBJ_PROPERTY(qModalViewController, setQModalViewController:)
SYNTHESIZE_CATALOG_OBJ_PROPERTY(modalBackgroundView, setModalBackgroundView:)
SYNTHESIZE_CATALOG_OBJ_PROPERTY(screenShotView, setScreenShotView:)
SYNTHESIZE_CATALOG_VALUE_PROPERTY(QModalViewStyle, qModalViewStyle, setQModalViewStyle:)
SYNTHESIZE_CATALOG_VALUE_PROPERTY(BOOL, isDismissWhenTouchedOutOfBound, setDismissWhenTouchedOutOfBound:)

- (void)presentQModalViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag{
    [self presentQModalViewController:viewControllerToPresent displayedSize:viewControllerToPresent.view.frame.size animated:flag];
}

- (void)presentQModalViewController:(UIViewController *)viewControllerToPresent displayedSize:(CGSize)displaySize animated:(BOOL)flag{
    if (self.qModalViewController!=nil) {
        QERR(@"Can not present two modal view controller at same time!");
        return;
    }
    if (!CGSizeEqualToSize(displaySize, CGSizeZero)) {
        viewControllerToPresent.view.frame = CGRectMake((self.view.bounds.size.width-displaySize.width)/2, (self.view.bounds.size.height-displaySize.height)/2, displaySize.width, displaySize.height);
    }
    self.modalBackgroundView = [[UIControl alloc] initWithFrame:self.view.bounds];
    self.modalBackgroundView.opaque = YES;
    [self.modalBackgroundView addTarget:self action:@selector(qModalViewBackgroundTaped) forControlEvents:UIControlEventTouchUpInside];
    self.qModalViewController = viewControllerToPresent;
    [self addChildViewController:viewControllerToPresent];
    if (viewControllerToPresent.qModalViewStyle==QModalViewStyleAlert) {
        self.modalBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:self.modalBackgroundView];
        [self.view addSubview:viewControllerToPresent.view];
        if (flag) {
            CABasicAnimation *backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            backgroundAnimation.fromValue = @0.0f;
            [self.modalBackgroundView.layer addAnimation:backgroundAnimation forKey:nil];
            [viewControllerToPresent.view.layer addAnimation:[self popupAnimation] forKey:nil];
        }
    }
    else if (viewControllerToPresent.qModalViewStyle==QModalViewStyleFormSheet){
        [self.view addSubview:self.modalBackgroundView];
        [self.view addSubview:viewControllerToPresent.view];
        self.modalBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        if (flag) {
            CABasicAnimation *backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            backgroundAnimation.fromValue = @0.0f;
            [self.modalBackgroundView.layer addAnimation:backgroundAnimation forKey:nil];
            CABasicAnimation *offsetAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            offsetAnimation.duration = 0.3;
            offsetAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height, 0)];
            offsetAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [viewControllerToPresent.view.layer addAnimation:offsetAnimation forKey:nil];
        }
    }
    else if (viewControllerToPresent.qModalViewStyle==QModalViewStyleZoomInAndCover){
        viewControllerToPresent.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, viewControllerToPresent.view.frame.size.height);
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.screenShotView = [[UIImageView alloc] initWithImage:image];
        
        [self.view addSubview:self.modalBackgroundView];
        self.modalBackgroundView.backgroundColor = [UIColor blackColor];
        [self.modalBackgroundView addSubview:self.screenShotView];
        
        [self.view addSubview:viewControllerToPresent.view];
        
        [self.screenShotView.layer addAnimation:[self zoomInAndCoverAnimationGroupForward:YES] forKey:@"pushedBackAnimation"];
        [UIView animateWithDuration:0.5 animations:^{
            viewControllerToPresent.view.frame = CGRectMake(0, self.view.bounds.size.height-viewControllerToPresent.view.frame.size.height, self.view.frame.size.width, viewControllerToPresent.view.frame.size.height);
            self.screenShotView.alpha = 0.5;
        }];
    }
    else if (viewControllerToPresent.qModalViewStyle == QModalViewStyleSimpleZoom)
    {
        viewControllerToPresent.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, viewControllerToPresent.view.frame.size.height);
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.screenShotView = [[UIImageView alloc] initWithImage:image];
        
        [self.view addSubview:self.modalBackgroundView];
        self.modalBackgroundView.backgroundColor = [UIColor blackColor];
        [self.modalBackgroundView addSubview:self.screenShotView];
        
        [self.view addSubview:viewControllerToPresent.view];
        
        //[self.screenShotView.layer addAnimation:[self simpleAnimationGroupForward:YES] forKey:@"pushedBackAnimation"];
        [UIView animateWithDuration:0.5 animations:^{
            viewControllerToPresent.view.frame = CGRectMake(0, self.view.bounds.size.height-viewControllerToPresent.view.frame.size.height, self.view.frame.size.width, viewControllerToPresent.view.frame.size.height);
            self.screenShotView.alpha = 0.5;
        }];
    }
}

- (BOOL)dismissWhenTouchedOutOfBound{
    if (objc_getAssociatedObject(self, @selector(isDismissWhenTouchedOutOfBound))==nil) {
        if (self.qModalViewStyle==QModalViewStyleZoomInAndCover || self.qModalViewStyle == QModalViewStyleSimpleZoom) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return [self isDismissWhenTouchedOutOfBound];
    }
}

- (void)qModalViewBackgroundTaped{
    if (self.qModalViewController.dismissWhenTouchedOutOfBound) {
        
        if (self.qModalViewController.qModalViewStyle != QModalViewStyleSimpleZoom)
        {
            [self dismissQModalViewControllerAnimated:YES];
        }
        else
        {
            [self dismissQModalViewControllerAnimatedForSimpleMode:YES completion:NULL];

        }
    }
}

- (CAAnimationGroup*)popupAnimation{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    alphaAnimation.duration = 0.3;
    alphaAnimation.fromValue = (id)[UIColor clearColor].CGColor;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[popAnimation,alphaAnimation];
    return animations;
}

- (CAAnimationGroup*)simpleAnimationGroupForward:(BOOL)_forward {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    //t1.m34 = 1.0/-900;
    //t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    //t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height*-0.08, 0);
    //t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = 0.5/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;

}

- (CAAnimationGroup*)zoomInAndCoverAnimationGroupForward:(BOOL)_forward {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = 0.5/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

- (void)dismissQModalViewControllerAnimated:(BOOL)flag{
    [self dismissQModalViewControllerAnimated:flag completion:NULL];
}

- (void)dismissQModalViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    if (self.qModalViewController.qModalViewStyle==QModalViewStyleAlert) {
        [UIView animateWithDuration:flag?0.2:0 animations:^{
            self.modalBackgroundView.alpha = 0;
            self.qModalViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.modalBackgroundView removeFromSuperview];
            self.modalBackgroundView = nil;
            [self.qModalViewController removeFromParentViewController];
            [self.qModalViewController.view removeFromSuperview];
            self.qModalViewController = nil;
            if(completion) completion();
        }];
    }
    else if (self.qModalViewController.qModalViewStyle==QModalViewStyleFormSheet){
        [UIView animateWithDuration:flag?0.2:0 animations:^{
            self.modalBackgroundView.alpha = 0;
            self.qModalViewController.view.transform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height);
        } completion:^(BOOL finished) {
            [self.modalBackgroundView removeFromSuperview];
            self.modalBackgroundView = nil;
            [self.qModalViewController removeFromParentViewController];
            [self.qModalViewController.view removeFromSuperview];
            self.qModalViewController = nil;
            if(completion) completion();
        }];
    }
    else if (self.qModalViewController.qModalViewStyle==QModalViewStyleZoomInAndCover){
        
        [UIView animateWithDuration:flag?0.5:0 animations:^{
            self.qModalViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.qModalViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self.modalBackgroundView removeFromSuperview];
            self.modalBackgroundView = nil;
            [self.qModalViewController removeFromParentViewController];
            [self.qModalViewController.view removeFromSuperview];
            self.qModalViewController = nil;
            [self.screenShotView removeFromSuperview];
            self.screenShotView = nil;
            if(completion) completion();
        }];
        [self.screenShotView.layer addAnimation:[self zoomInAndCoverAnimationGroupForward:NO] forKey:@"bringForwardAnimation"];
        [UIView animateWithDuration:flag?0.5:0 animations:^{
            self.screenShotView.alpha = 1;
        }];
    }
    else if (self.qModalViewController.qModalViewStyle== QModalViewStyleSimpleZoom)
    {
        [UIView animateWithDuration:flag?0.3:0 animations:^{
            self.qModalViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.qModalViewController.view.frame.size.height);
            [self.screenShotView removeFromSuperview];
            [self.modalBackgroundView removeFromSuperview];


        } completion:^(BOOL finished) {
            self.qModalViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.qModalViewController.view.frame.size.height);
            
            self.modalBackgroundView = nil;
            [self.qModalViewController removeFromParentViewController];
            [self.qModalViewController.view removeFromSuperview];
            self.qModalViewController = nil;
            self.screenShotView = nil;
            if(completion) completion();
        }];
            

        //[self.screenShotView.layer addAnimation:[self simpleAnimationGroupForward:NO] forKey:@"bringForwardAnimation"];
//        [UIView animateWithDuration:flag?0.5:0 animations:^{
//            self.screenShotView.alpha = 1;
//        }];
    }
}

- (void)dismissQModalViewControllerAnimatedForSimpleMode:(BOOL)flag completion:(void (^)(void))completion{
    if (self.qModalViewController.qModalViewStyle== QModalViewStyleSimpleZoom)
    {
        [UIView animateWithDuration:flag?0.3:0 animations:^{
            self.qModalViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.qModalViewController.view.frame.size.height);
            [self.screenShotView removeFromSuperview];
            [self.modalBackgroundView removeFromSuperview];
            
            
        } completion:^(BOOL finished) {
            
            self.modalBackgroundView = nil;
            [self.qModalViewController removeFromParentViewController];
            [self.qModalViewController.view removeFromSuperview];
            self.qModalViewController = nil;
            self.screenShotView = nil;
            if(completion) completion();
        }];
        
        
        //[self.screenShotView.layer addAnimation:[self simpleAnimationGroupForward:NO] forKey:@"bringForwardAnimation"];
        //        [UIView animateWithDuration:flag?0.5:0 animations:^{
        //            self.screenShotView.alpha = 1;
        //        }];
    }
}


@end
