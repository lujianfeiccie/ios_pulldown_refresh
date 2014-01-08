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
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
    [self.view addSubview:_tableView];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"美国", @"菲律宾",
                      @"黄岩岛", @"中国" , nil];
    
    list =array;
    
    ((PullTableView*)_tableView).list = list;
    ((PullTableView*)_tableView).delegate_for_pull = self;
    //[_tableView reloadData];
    NSLog(@"viewDidLoad");
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

-(void) onRefresh{
       NSLog(@"ViewController onRefresh");
    
      [((PullTableView*)_tableView) performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];

}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    		   NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    	   NSLog(@"viewDidUnload");
}


@end
