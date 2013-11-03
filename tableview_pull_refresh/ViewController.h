//
//  ViewController.h
//  tableview_pull_refresh
//
//  Created by Apple on 13-11-3.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@interface ViewController : UIViewController<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
  EGORefreshTableHeaderView *_refreshHeaderView;
    	BOOL _reloading;
   
}
 @property (strong, nonatomic) NSArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
