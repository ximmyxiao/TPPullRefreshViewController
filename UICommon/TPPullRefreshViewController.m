//
//  TPPullRefreshViewController.m
//  TPCampus
//
//  Created by Piao Piao on 14-8-27.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import "TPPullRefreshViewController.h"
#define PULL_DOWN_THRESHHOLD_VALUE -40
#define PULL_UP_THRESHHOLD_VALUE 40

@implementation TPPullRefreshView

- (void)setTableViewOffset:(CGFloat)tableViewOffset
{
    if (tableViewOffset < PULL_DOWN_THRESHHOLD_VALUE)
    {
        self.state = TP_PULL_STATE_HEADREFRESHING;
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
            UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            act.tag = 'acti';
            
            TPPullRefreshView* headView = [[TPPullRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, act.frame.size.height + 20 )];
            headView.backgroundColor = [UIColor greenColor];
            act.center = CGPointMake(CGRectGetMidX(headView.bounds), CGRectGetMidY(headView.bounds));
            [headView addSubview:act];
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
    static TPPULL_REFRESH_STATE lastState = TP_PULL_STATE_NORMAL;
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.tableView.contentOffset.y < 0)
        {

            
            self.headView.tableViewOffset = self.tableView.contentOffset.y;
            //if (self.headView.tale)
            if (self.headView.state == TP_PULL_STATE_HEADREFRESHING && lastState != TP_PULL_STATE_HEADREFRESHING)
            {
                CGFloat height = self.headView.height;
                self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
                [((UIActivityIndicatorView*)[self.headView viewWithTag:'acti']) startAnimating];
                [self startHeaderRefresh];
            }
            lastState = self.headView.state;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startHeaderRefresh
{
    
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
