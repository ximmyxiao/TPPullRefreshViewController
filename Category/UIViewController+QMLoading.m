//
//  UIViewController+QMLoading.m
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-4-22.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIViewController+QMLoading.h"
#import <objc/runtime.h>

static NSString *kUIViewControllerLoadingViewKey = @"kUIViewControllerLoadingViewKey";

@implementation UIViewController (QMLoading)

- (void)setLoadingViewEdgeInset:(UIEdgeInsets)loadingViewEdgeInset{
    objc_setAssociatedObject(self, (__bridge const void *)(kUIViewControllerLoadingViewKey), [NSValue valueWithUIEdgeInsets:loadingViewEdgeInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)loadingViewEdgeInset{
    NSValue *v = objc_getAssociatedObject(self, (__bridge const void *)(kUIViewControllerLoadingViewKey));
    if (v) {
        return [v UIEdgeInsetsValue];
    }
    else{
        return UIEdgeInsetsZero;
    }
}

- (CGPoint)contentCenterPoint{
    if (IS_IOS7_AND_LATER) {
        return CGPointMake(self.view.width/2, [self.topLayoutGuide length] + (self.view.height-[self.topLayoutGuide length]-[self.bottomLayoutGuide length])/2);
    }
    else{
        return CGPointMake(self.view.width/2, self.view.height/2);
    }
}

- (void)showLoadingView{
    if ([self isViewLoaded]&&[self.view viewWithTag:'load']==nil) {
        [[self.view viewWithTag:'load'] removeFromSuperview];
        [[self.view viewWithTag:'erro'] removeFromSuperview];
        [[self.view viewWithTag:'noda'] removeFromSuperview];
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:NO];
        }
        UIView *loadingView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, self.loadingViewEdgeInset)];
        loadingView.layer.zPosition = 100;
        loadingView.opaque = YES;
		loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        CGFloat r = 0 , g = 0, b = 0;
        BOOL ret = [self.view.backgroundColor getRed:&r green:&g blue:&b alpha:NULL];
        if (!ret || (r <= 0.0000001 && g <= 0.0000001 && b <= 0.0000001))
        {
            loadingView.backgroundColor = UICOLOR_WITH_RGB(33, 33, 33);
        }
        else
        {
            loadingView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        }
        loadingView.tag = 'load';
        
//        QLoadingIndicatorView *indicatorView = [[QLoadingIndicatorView alloc] initWithStyle:QLoadingIndicatorViewStyleRotation];
//        indicatorView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
//        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
//        [loadingView addSubview:indicatorView];
//        [indicatorView startAnimating];
        
        CGFloat white = 1.0;
        
        if(![loadingView.backgroundColor getWhite:&white alpha:NULL]){
            CGFloat r, g, b;
            if([loadingView.backgroundColor getRed:&r green:&g blue:&b alpha:NULL]){
                white = (r+g+b)/3;
            }
            else
            {
                white = 0;
            }
        }

        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:white>0.5?UIActivityIndicatorViewStyleGray:UIActivityIndicatorViewStyleWhite];
        indicatorView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        [loadingView addSubview:indicatorView];
        
        if (IS_IOS7_AND_LATER)
        {
            if (self.automaticallyAdjustsScrollViewInsets == YES && self.navigationController.navigationBar.translucent == YES)
            {
                if ([self.view isKindOfClass:[UITableView class]])
                {
                    indicatorView.y_origin -= 64;
                }
            }

        }
        [indicatorView startAnimating];

        
        [self.view addSubview:loadingView];
    }
}

- (void)showLoadingViewWithDarkContent{
    if ([self isViewLoaded]&&[self.view viewWithTag:'load']==nil) {
        [[self.view viewWithTag:'load'] removeFromSuperview];
        [[self.view viewWithTag:'erro'] removeFromSuperview];
        [[self.view viewWithTag:'noda'] removeFromSuperview];
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:NO];
        }
        UIView *loadingView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, self.loadingViewEdgeInset)];
        loadingView.layer.zPosition = 100;
        loadingView.opaque = YES;
		loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        loadingView.backgroundColor = self.view.backgroundColor;
        loadingView.tag = 'load';
        
        //        QLoadingIndicatorView *indicatorView = [[QLoadingIndicatorView alloc] initWithStyle:QLoadingIndicatorViewStyleRotation];
        //        indicatorView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        //        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        //        [loadingView addSubview:indicatorView];
        //        [indicatorView startAnimating];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        [loadingView addSubview:indicatorView];
        [indicatorView startAnimating];
        
        
        [self.view addSubview:loadingView];
    }
}

- (void)hideLoadingView{
    if ([self isViewLoaded]) {
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:YES];
        }
        [[self.view viewWithTag:'load'] removeFromSuperview];
    }
}

- (void)noNetworkViewTaped{
}

- (void)showNoNetworkView{
    if ([self isViewLoaded]&&[self.view viewWithTag:'erro']==nil) {
        [[self.view viewWithTag:'load'] removeFromSuperview];
        [[self.view viewWithTag:'erro'] removeFromSuperview];
        [[self.view viewWithTag:'noda'] removeFromSuperview];
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:NO];
        }
        UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [errorView setBackgroundColor:[UIColor colorWithRGB:0x1f2024]];
        errorView.opaque = YES;
		errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        errorView.tag = 'erro';
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IcoExclaNew"]];
        iconView.center = CGPointMake(150, 160 - iconView.height/2);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 300, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithRGB:0x919191];
        titleLabel.text = @"亲，网络暂时不可用哦";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 280, 40)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor colorWithRGB:0x919191];
        textLabel.text = @"建议您检查网络后再试试\n或者点击屏幕尝试重新连接";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.numberOfLines = 0;
        
        UIView *errorContentView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-300)/2, (self.view.bounds.size.height-290)/2, 300, 290)];
        [errorContentView addSubview:iconView];
        [errorContentView addSubview:titleLabel];
        [errorContentView addSubview:textLabel];
        errorContentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        
        [errorView addSubview:errorContentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noNetworkViewTaped)];
        [errorView addGestureRecognizer:tap];
        
        [self.view addSubview:errorView];
    }
}

- (void)hideNoNetworkView{
    if ([self isViewLoaded]) {
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:YES];
        }
        [[self.view viewWithTag:'erro'] removeFromSuperview];
    }
}

- (void)showErrorViewForError:(NSError*)e{
    QERR(@"ERROR: %@",e);
    if ([[e domain] isEqualToString:NSURLErrorDomain]) {
        [self showNoNetworkView];
    }
    else{
        [[self.view viewWithTag:'load'] removeFromSuperview];
        [[self.view viewWithTag:'erro'] removeFromSuperview];
        [[self.view viewWithTag:'noda'] removeFromSuperview];
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:NO];
        }
        UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [errorView setBackgroundColor:[UIColor colorWithRGB:0x1f2024]];
        errorView.opaque = YES;
		errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        errorView.tag = 'erro';
        
//        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_error_big"]];
//        iconView.center = CGPointMake(80, iconView.height/2);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRGB:0x919191];
        titleLabel.text = [e localizedDescription];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
//        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 140, 40)];
//        textLabel.backgroundColor = [UIColor clearColor];
//        textLabel.textColor = [UIColor colorWithRGB:0x919191];
//        textLabel.text = [e localizedDescription];
//        textLabel.textAlignment = NSTextAlignmentCenter;
//        textLabel.font = [UIFont systemFontOfSize:13];
//        textLabel.numberOfLines = 0;
        
        UIView *errorContentView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-160)/2, (self.view.bounds.size.height-40)/2, 160, 40)];
        //[errorContentView addSubview:iconView];
        [errorContentView addSubview:titleLabel];
        //[errorContentView addSubview:textLabel];
        errorContentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        
        [errorView addSubview:errorContentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noNetworkViewTaped)];
        [errorView addGestureRecognizer:tap];
        
        [self.view addSubview:errorView];
    }
}

- (UIView*)noDataViewWithText:(NSString*)text
{
    UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    v.backgroundColor = self.view.backgroundColor;
    v.tag = 'noda';
    [self.view addSubview:v];
    UILabel *tipsLabel = [UILabel labelWithFrame:CGRectZero fontSize:14 textColor:UICOLOR_WITH_VALUE(0xb4b4b4)];
    tipsLabel.text = text;
    [tipsLabel sizeToFit];
    tipsLabel.center = [self contentCenterPoint];
    [v addSubview:tipsLabel];
    return v;
}

- (UIView*)showNoDataViewWithText:(NSString*)text
{
    if([self isViewLoaded])
    {
        [[self.view viewWithTag:'noda'] removeFromSuperview];
        [[self.view viewWithTag:'erro'] removeFromSuperview];
        [[self.view viewWithTag:'load'] removeFromSuperview];
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:NO];
        }

        UIView *v = [self noDataViewWithText:text];
        [self.view addSubview:v];
        return v;
    }
    return nil;
}

- (void)hideNoDataView
{
    if ([self isViewLoaded])
    {
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.view setScrollEnabled:YES];
        }

        [[self.view viewWithTag:'noda'] removeFromSuperview];
    }
}

@end
