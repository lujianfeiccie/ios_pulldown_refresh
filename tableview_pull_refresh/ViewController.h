//
//  ViewController.h
//  tableview_pull_refresh
//
//  Created by Apple on 13-11-3.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "PullTableView.h"

@interface ViewController : UIViewController
<PullTableViewDelegate>
{
    UITableView *_tableView;
    NSArray *list;
}
@end
