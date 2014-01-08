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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"PullTableView initWithFrame");
        // Initialization code
        // Do any additional setup after loading the view, typically from a nib.
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, frame.size.width, self.bounds.size.height)];
            view.delegate = self;
            self.delegate =self;
            self.dataSource = self;
            [self setSectionHeaderHeight:0.0f];
            [self addSubview:view];
            _refreshHeaderView = view;
            view = nil;
        }
    }
    return self;
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"PullTableView numberOfSectionsInTableView");
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"PullTableView numberOfRowsInSection %i",section);
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate_for_pull!=Nil) {
        return [_delegate_for_pull tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
    NSLog(@"PullTableView titleForHeaderInSection");
	return [NSString stringWithFormat:@"Section %i", section];
	
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
	_reloading = YES;
    NSLog(@"PullTableView reloadTableViewDataSource");
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    NSLog(@"PullTableView doneLoadingTableViewData");
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
	
	[self reloadTableViewDataSource];
    if (_delegate_for_pull!=Nil) {
        [_delegate_for_pull onRefresh];
    }
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    NSLog(@"PullTableView egoRefreshTableHeaderDidTriggerRefresh");
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
   // NSLog(@"PullTableView egoRefreshTableHeaderDataSourceIsLoading");
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    NSLog(@"PullTableView egoRefreshTableHeaderDataSourceLastUpdated");
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
