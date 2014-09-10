//
//  TPPullRefreshViewController.h
//  TPCampus
//
//  Created by Piao Piao on 14-8-27.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPPullRefreshView;

@protocol TPPullRefreshHeadViewDataSource
@optional
- (TPPullRefreshView*)headViewForPullRefresh;
@end

typedef enum TPPULL_REFRESH_STATE
{
    TP_PULL_STATE_NORMAL = 0,
    TP_PULL_STATE_HEADREFRESHING,
    TP_PULL_STATE_FOOTERREFRESHING,
}TPPULL_REFRESH_STATE;

@interface TPPullRefreshView : UIView
@property(nonatomic,assign) TPPULL_REFRESH_STATE state;
@property(nonatomic,assign) CGFloat tableViewOffset;
@end


@interface TPPullRefreshViewController : UIViewController<TPPullRefreshHeadViewDataSource>
{
    TPPullRefreshView* _headView;
}
- (void)startHeaderRefresh;
- (void)finishHeaderLoading;
@end
