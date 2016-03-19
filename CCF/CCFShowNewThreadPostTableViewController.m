//
//  CCFShowNewThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowNewThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFPage.h"
#import "CCFSearchThread.h"
#import "CCFSearchResultCell.h"
#import "CCFSearchThread.h"

@interface CCFShowNewThreadPostTableViewController ()

@end

@implementation CCFShowNewThreadPostTableViewController

-(void)onPullRefresh{
    [self.ccfApi listNewThreadPostsWithPage:1 handler:^(BOOL isSuccess, CCFPage *message) {
        [self.tableView.mj_header endRefreshing];
        if (isSuccess) {
            [self.tableView.mj_footer endRefreshing];
            
            self.currentPage = 1;
            self.totalPage = (int)message.totalPageCount;
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:message.dataList];
            [self.tableView reloadData];
        }
        
    }];
}

-(void)onLoadMore{
    [self.ccfApi listNewThreadPostsWithPage:self.currentPage + 1 handler:^(BOOL isSuccess, CCFPage *message) {
        [self.tableView.mj_footer endRefreshing];
        if (isSuccess) {
            self.currentPage++;
            self.totalPage = (int)message.totalPageCount;
            if (self.currentPage >= self.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.dataList addObjectsFromArray:message.dataList];
            [self.tableView reloadData];
        }
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"CCFSearchResultCell";
    CCFSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    CCFSearchThread * thread = self.dataList[indexPath.row];
    [cell setData:thread];
    
    return cell;
}


- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
