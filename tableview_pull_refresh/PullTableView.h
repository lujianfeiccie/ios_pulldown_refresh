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
-(void) onMore;
@end
@interface PullTableView : UITableView
<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    UIView *tableFooterView; //底部视图
    UILabel *loadMoreText; //标签
    UIActivityIndicatorView* activityIndicatorView;//底部动画
    
    NSString* tips1; //加载中
    NSString* tips2; //加载更多
    
    BOOL hasAddHeader;
    BOOL hasAddFooter;
}
 @property (strong, nonatomic) NSArray *list;
 @property id<PullTableViewDelegate> delegate_for_pull;

- (void)doneLoadingTableViewData;
@end
