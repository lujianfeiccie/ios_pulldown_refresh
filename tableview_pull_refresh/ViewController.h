//
//  ViewController.h
//  tableview_pull_refresh
//
//  Created by Apple on 13-11-3.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshView.h"

@interface ViewController : UIViewController
<RefreshViewDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    UITableView *_tableView;
    RefreshView *refreshView;
    NSArray *list;
}
@end
