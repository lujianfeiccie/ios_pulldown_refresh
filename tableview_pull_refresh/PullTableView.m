//
//  PullTableView.m
//  tableview_pull_refresh
//
//  Created by Apple on 14-1-8.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "PullTableView.h"

@implementation PullTableView
@synthesize list = _list;
@synthesize delegate_for_pull =_delegate_for_pull;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"PullTableView initWithFrame");
        // Initialization code
        // Do any additional setup after loading the view, typically from a nib.
        hasAddHeader = NO;
        hasAddFooter = NO;
        tips1 = @"加载中";
        tips2 = @"更多";
        [self createTableHeader:frame];
        [self createTableFooter];
        
    
    }
    return self;
}
-(void) showRefreshing{
    NSLog(@"showRefreshing");
    [self setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}
-(void)doneManualRefresh{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
}
-(void) createTableHeader:(CGRect)frame{
    if (!hasAddHeader) {
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, frame.size.width, self.bounds.size.height)];
            view.delegate = self;
            self.delegate =self;
            self.dataSource = self;
            [self setSectionHeaderHeight:0.0f];
            [self addSubview:view];
            _refreshHeaderView = view;
            view = nil;
            [_refreshHeaderView refreshLastUpdatedDate];
        }
        hasAddHeader = YES;
    }
}
// 创建表格底部
- (void) createTableFooter
{
    if(!hasAddFooter){
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 60.0f)];
        
        //加入载入更多提示
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore)];
        [self addGestureRecognizer:singleTap];
        
    
        loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 0.0f, 50.0f, 60.0f)];
        [loadMoreText setCenter:tableFooterView.center];
        [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        [loadMoreText setText:tips2];
        [tableFooterView addSubview:loadMoreText];
    
    
        activityIndicatorView = [[ UIActivityIndicatorView alloc ]
                initWithFrame:CGRectMake(self.bounds.size.width-50.0,14,30.0,30.0)];
    
        activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    
        [tableFooterView addSubview:activityIndicatorView];
    
    /*if (loading) {
        [activityIndicatorView startAnimating];
    }else{
        [activityIndicatorView stopAnimating];
    }*/
            
    self.tableFooterView = tableFooterView;
        hasAddFooter = YES;
    }
}
-(void)loadMore{
    if (!_reloading) {
        _reloading = YES;
        loadMoreText.text = tips1;
        [activityIndicatorView startAnimating];
        if (_delegate_for_pull!=Nil) {
            [_delegate_for_pull onMore];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   /* NSLog(@"content offsetY = %f content Size height =%f frame.height =%f"
          ,scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.frame.size.height);*/
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
        //滑到底部加载更多
//        NSLog(@"滑到底部加载更多");
        [self loadMore];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"PullTableView numberOfSectionsInTableView");
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"PullTableView numberOfRowsInSection %i",section);
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate_for_pull!=Nil) {
        return [_delegate_for_pull tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
   // NSLog(@"PullTableView titleForHeaderInSection");
	return [NSString stringWithFormat:@"Section %i", section];
	
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
	_reloading = YES;
    //NSLog(@"PullTableView reloadTableViewDataSource");
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    [activityIndicatorView stopAnimating];
    loadMoreText.text = tips2;
    //NSLog(@"PullTableView doneLoadingTableViewData");
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    //NSLog(@"PullTableView scrollViewDidScroll");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    //NSLog(@"PullTableView scrollViewDidEndDragging");
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	if (!_reloading) {
        [self reloadTableViewDataSource];
        if (_delegate_for_pull!=Nil) {
            [_delegate_for_pull onRefresh];
        }

    }
	    //NSLog(@"PullTableView egoRefreshTableHeaderDidTriggerRefresh");
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
   // NSLog(@"PullTableView egoRefreshTableHeaderDataSourceIsLoading");
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
   // NSLog(@"PullTableView egoRefreshTableHeaderDataSourceLastUpdated");
	return [NSDate date]; // should return date data source was last changed
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
