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

@interface CCFPrivateMessageTableViewController ()

@end


@implementation CCFPrivateMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)onPullRefresh{
    [self.ccfApi listPrivateMessageWithType:0 andPage:1 handler:^(BOOL isSuccess, CCFPage *message) {
        [self.tableView.mj_header endRefreshing];
        
        if (isSuccess) {
            
            [self.tableView.mj_footer endRefreshing];
            
            self.currentPage = 1;
            [self.dataList addObjectsFromArray:message.dataList];
            
            [self.tableView reloadData];
        }
    }];
}


-(void)onLoadMore{
    [self.ccfApi listPrivateMessageWithType:0 andPage:self.currentPage + 1 handler:^(BOOL isSuccess, CCFPage *message) {
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


- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
