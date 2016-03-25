//
//  CCFPrivateMessageTableViewController.m
//  CCF
//
//  Created by WDY on 16/3/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFPrivateMessageTableViewController.h"
#import "CCFNavigationController.h"
#import "PrivateMessageTableViewCell.h"
#import "PrivateMessage.h"
#import "CCFPage.h"

@interface CCFPrivateMessageTableViewController (){
    int messageType;
}

@end


@implementation CCFPrivateMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180.0;
    
    [self.messageSegmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger index = Seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            messageType = 0;
            [self.tableView.mj_header beginRefreshing];
            [self refreshMessage:1];
            break;
        case 1:
            messageType = -1;
            [self.tableView.mj_header beginRefreshing];
            [self refreshMessage:1];
            break;
        default:
            messageType = 0;
            [self.tableView.mj_header beginRefreshing];
            [self refreshMessage:1];
            break;
    }
}

-(void)onPullRefresh{
    [self refreshMessage:1];
}


-(void) refreshMessage:(int)page{
    [self.ccfApi listPrivateMessageWithType:messageType andPage:page handler:^(BOOL isSuccess, CCFPage *message) {
        [self.tableView.mj_header endRefreshing];
        
        if (isSuccess) {
            
            [self.tableView.mj_footer endRefreshing];
            
            self.currentPage = 1;
            
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:message.dataList];
            
            [self.tableView reloadData];
        }
    }];
}



-(void)onLoadMore{
    [self.ccfApi listPrivateMessageWithType:messageType andPage:self.currentPage + 1 handler:^(BOOL isSuccess, CCFPage *message) {
        [self.tableView.mj_footer endRefreshing];
        if (isSuccess) {
            self.currentPage++;
            
            if (self.currentPage >= message.totalPageCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.dataList addObjectsFromArray:message.dataList];
            [self.tableView reloadData];
        }
    }];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PrivateMessageTableViewCell";
    PrivateMessageTableViewCell *cell = (PrivateMessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    PrivateMessage *message = self.dataList[indexPath.row];
    [cell setData:message];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"PrivateMessageTableViewCell" configuration:^(PrivateMessageTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(PrivateMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    [cell setData:self.dataList[indexPath.row]];
}




- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
