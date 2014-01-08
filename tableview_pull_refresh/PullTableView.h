//
//  PullTableView.h
//  tableview_pull_refresh
//
//  Created by Apple on 14-1-8.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol PullTableViewDelegate <NSObject>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void) onRefresh;
@end
@interface PullTableView : UITableView
<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
}
 @property (strong, nonatomic) NSArray *list;
 @property id<PullTableViewDelegate> delegate_for_pull;

- (void)doneLoadingTableViewData;
@end
