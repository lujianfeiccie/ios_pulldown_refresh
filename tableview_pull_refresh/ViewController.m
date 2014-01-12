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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
    [self.view addSubview:_tableView];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"美国", @"菲律宾",
                      @"美国", @"菲律宾",
                      @"美国", @"菲律宾",
                      @"美国", @"菲律宾",
                      @"美国", @"菲律宾",
                     nil];
    list =array;
    
    //[_tableView reloadData];
    NSLog(@"viewDidLoad");
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    refreshView = [[RefreshView alloc] initWithOwner:_tableView delegate:self];
    // 初始刷新
    [self refresh];

}
// 停止，可以触发自己定义的停止方法
- (void)stopLoading {
    [refreshView stopLoading];
}
// 开始，可以触发自己定义的开始方法
- (void)startLoading {
    [refreshView startLoading];
    // 模拟3秒后停止
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3];
}
// 刷新
- (void)refresh {
    [self startLoading];
}
#pragma mark - RefreshViewDelegate
- (void)refreshViewDidCallBack {
    NSLog(@"refreshViewDidCallBack");
    [self refresh];
}
- (void) moreViewdDidCallBack{
     [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [list objectAtIndex:row];
    
    NSLog(@"PullTableView cellForRowAtIndexPath %i %@",row,cell.textLabel.text);
    return cell;
}
#pragma mark - Table view data source
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

@end

