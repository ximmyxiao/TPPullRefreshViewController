//
//  TPPullRefreshViewController.m
//  TPCampus
//
//  Created by Piao Piao on 14-8-27.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import "TPPullRefreshViewController.h"
#define PULL_DOWN_THRESHHOLD_VALUE 40
#define PULL_UP_THRESHHOLD_VALUE 40

@implementation TPPullRefreshView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activity.center = CGPointMake(20, CGRectGetMidY(self.bounds));
        [self addSubview:self.activity];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];

    }
    return self;
}



- (void)setState:(TPPULL_REFRESH_STATE)state
{
    if (self.state != state)
    {
        _state = state;
        [self.activity stopAnimating];
        switch (self.state) {
            case TP_PULL_STATE_NORMAL:
                self.titleLabel.text = @"下拉加载更多";
                break;
                
            case TP_PULL_STATE_PULLING:
                self.titleLabel.text = @"释放加载更多";
                break;
                
            case TP_PULL_STATE_LOADING:
                self.titleLabel.text = @"正在加载...";
                [self.activity startAnimating];
                break;
            default:
                break;
        }
    }
    
}

@end

@interface TPPullRefreshViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) TPPullRefreshView* headView;
@end

@implementation TPPullRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setHeadView:(TPPullRefreshView *)headView
{
    if (_headView)
    {
        [_headView removeFromSuperview];
    }
    
    _headView = headView;
    self.headView.y_origin = - headView.height;
    [self.tableView addSubview:self.headView];
}


- (TPPullRefreshView*)headView
{
    if (_headView == nil)
    {
        if ([self respondsToSelector:@selector(headViewForPullRefresh)])
        {
            return [self headViewForPullRefresh];
        }
        else
        {

            
            TPPullRefreshView* headView = [[TPPullRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60 )];
            headView.state = TP_PULL_STATE_NORMAL;
            
            self.headView = headView;
            return headView;
        }

    }
    return _headView;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headView];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    static TPPULL_REFRESH_STATE lastState = TP_PULL_STATE_NORMAL;
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.tableView.contentOffset.y < 0)
        {
            CGFloat tableViewOffset = self.tableView.contentOffset.y;
            if (self.headView.state == TP_PULL_STATE_LOADING)
            {

            }
            else
            {
                BOOL loading = NO;
                if ([self respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading)]) {
                    loading = [self refreshTableHeaderDataSourceIsLoading];
                }
                
                if (self.headView.state == TP_PULL_STATE_PULLING && tableViewOffset > -PULL_DOWN_THRESHHOLD_VALUE && tableViewOffset < 0.0f && !loading)
                {
                    [self.headView setState:TP_PULL_STATE_NORMAL];
                }
                else if (self.headView.state == TP_PULL_STATE_NORMAL && tableViewOffset < -PULL_DOWN_THRESHHOLD_VALUE && !loading)
                {
                    [self.headView setState:TP_PULL_STATE_PULLING];
                }
                
                if (self.tableView.contentInset.top != 0) {
                    self.tableView.contentInset = UIEdgeInsetsZero;
                }
            }
            
//            self.headView.tableViewOffset = self.tableView.contentOffset.y;
//            //if (self.headView.tale)
//            if (self.headView.state == TP_PULL_STATE_HEADREFRESHING && lastState != TP_PULL_STATE_HEADREFRESHING)
//            {
//                CGFloat height = self.headView.height;
//                self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
//                [((UIActivityIndicatorView*)[self.headView viewWithTag:'acti']) startAnimating];
//                [self startHeaderRefresh];
//            }
        }
//        lastState = self.headView.state;

    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    BOOL loading = NO;
	if ([self respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading)])
    {
		loading = [self refreshTableHeaderDataSourceIsLoading];
	}
	
	if (scrollView.contentOffset.y <= -PULL_DOWN_THRESHHOLD_VALUE && !loading)
    {
		
		if ([self respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh)])
        {
			[self refreshTableHeaderDidTriggerRefresh];
		}
		
		[self.headView setState:TP_PULL_STATE_LOADING];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat height = self.headView.height;
            self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        }];

    }
		
}

- (void)refreshScrollViewDataSourceDidFinishedLoading
{
    self.reloading = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
	
	[self.headView setState:TP_PULL_STATE_NORMAL];
    
}

- (BOOL)refreshTableHeaderDataSourceIsLoading
{
    return self.reloading;
}
    
- (void)refreshTableHeaderDidTriggerRefresh
{
    self.reloading = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)finishHeaderLoading
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.headView.state = TP_PULL_STATE_NORMAL;
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end
