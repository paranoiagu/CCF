//
//  CCFMyThreadTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFMyThreadTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFSearchResultCell.h"

@interface CCFMyThreadTableViewController ()

@end

@implementation CCFMyThreadTableViewController

-(void)onPullRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self.ccfApi listMyAllThreadsWithPage:1 handler:^(BOOL isSuccess, CCFPage *message) {
           [self.tableView.mj_header endRefreshing];
           
           if (isSuccess) {
               [self.tableView.mj_footer endRefreshing];
               
               self.currentPage = 1;
               [self.dataList removeAllObjects];
               
               [self.dataList addObjectsFromArray:message.dataList];
               [self.tableView reloadData];
               
           }
           
       }];
    }];
}

-(void)onLoadMore{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.ccfApi listMyAllThreadsWithPage:self.currentPage + 1 handler:^(BOOL isSuccess, CCFPage *message) {
            [self.tableView.mj_footer endRefreshing];
            
            if (isSuccess) {
                self.currentPage ++;
                if (self.currentPage >= message.totalPageCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.dataList addObjectsFromArray:message.dataList];
                [self.tableView reloadData];
                
            }
        }];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"CCFSearchResultCell";
    CCFSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    CCFSearchThread * thread = self.dataList[indexPath.row];
    [cell setSearchResult:thread];
    
    return cell;
}

- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
