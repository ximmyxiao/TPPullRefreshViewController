//
//  UIViewController+QMLoading.h
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-4-22.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (QMLoading)

- (void)showLoadingView;
- (void)showLoadingViewWithDarkContent;
- (void)hideLoadingView;

- (void)showNoNetworkView;
- (void)hideNoNetworkView;
- (void)noNetworkViewTaped;

- (void)showErrorViewForError:(NSError*)e;

//for my order and cinema list page
- (UIView*)showNoDataViewWithText:(NSString*)text;
- (void)hideNoDataView;
- (UIView*)noDataViewWithText:(NSString*)text;

@end
