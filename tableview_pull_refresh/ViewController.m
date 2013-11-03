//
//  ViewController.m
//  tableview_pull_refresh
//
//  Created by Apple on 13-11-3.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize list = _list;
@synthesize tableView = _tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [_tableView  setSectionHeaderHeight:0.0f];
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		view = nil;
	}
    
    // Do any additional setup after loading the view, typically from a nib.
    /*NSArray *array = [[NSArray alloc] initWithObjects:@"美国", @"菲律宾",
                      @"黄岩岛", @"中国", @"泰国", @"越南", @"老挝",
                      @"日本" , nil];*/
    NSArray *array = [[NSArray alloc] initWithObjects:@"美国", @"菲律宾",
                      @"黄岩岛", @"中国" , nil];
    self.list = array;
    NSLog(@"viewDidLoad");
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
      NSLog(@"numberOfSectionsInTableView");
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRowsInSection %i",section);
    return _list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    NSUInteger row = [indexPath row];
   
    cell.textLabel.text = [self.list objectAtIndex:row];
    
     NSLog(@"cellForRowAtIndexPath %i %@",row,cell.textLabel.text);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
       NSLog(@"titleForHeaderInSection");
	return [NSString stringWithFormat:@"Section %i", section];
	
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
	_reloading = YES;
    NSLog(@"reloadTableViewDataSource");
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	    NSLog(@"doneLoadingTableViewData");
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	   NSLog(@"scrollViewDidEndDragging");
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
		   NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
		   NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
		   NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    		   NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    	   NSLog(@"viewDidUnload");
	_refreshHeaderView=nil;
      self.list = nil;
}


@end
