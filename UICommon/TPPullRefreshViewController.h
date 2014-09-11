//
//  TPPullRefreshViewController.h
//  TPCampus
//
//  Created by Piao Piao on 14-8-27.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPPullRefreshView;

@protocol TPPullRefreshHeadViewDelegate
@optional
- (void)refreshScrollViewDataSourceDidFinishedLoading;
- (BOOL)refreshTableHeaderDataSourceIsLoading;
- (void)refreshTableHeaderDidTriggerRefresh;

@end


@protocol TPPullRefreshHeadViewDataSource
@optional
- (TPPullRefreshView*)headViewForPullRefresh;
@end

typedef enum TPPULL_REFRESH_STATE
{
    TP_PULL_STATE_NORMAL = 0,
    TP_PULL_STATE_PULLING,
    TP_PULL_STATE_LOADING,
}TPPULL_REFRESH_STATE;

@interface TPPullRefreshView : UIView
@property(nonatomic,assign) TPPULL_REFRESH_STATE state;
@property(nonatomic,strong) UILabel* titleLabel;
@property(nonatomic,strong) UIActivityIndicatorView* activity;
@end


@interface TPPullRefreshViewController : UIViewController<TPPullRefreshHeadViewDataSource,TPPullRefreshHeadViewDelegate>
{
    TPPullRefreshView* _headView;
}
@property(nonatomic,assign) BOOL reloading;
- (void)finishHeaderLoading;
@end
