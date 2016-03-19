//
//  CCFShowTodayNewThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowTodayNewThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFThreadListCell.h"
#import "CCFNormalThread.h"

@interface CCFShowTodayNewThreadPostTableViewController ()

@end

@implementation CCFShowTodayNewThreadPostTableViewController



-(void)onPullRefresh{
    [self.ccfApi listTodayNewThreadsWithPage:1 handler:^(BOOL isSuccess, CCFPage* resultPage) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (isSuccess) {
            
            [self.tableView.mj_footer endRefreshing];
            
            self.currentPage = 1;
            self.totalPage = (int)resultPage.totalPageCount;
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:resultPage.dataList];
            [self.tableView reloadData];
        }
    }];
}

-(void)onLoadMore{
    [self.ccfApi listTodayNewThreadsWithPage:self.currentPage handler:^(BOOL isSuccess, CCFPage* resultPage) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if (isSuccess) {
            self.totalPage = (int)resultPage.totalPageCount;
            self.currentPage ++;
            if (self.currentPage >= self.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.dataList addObjectsFromArray:resultPage.dataList];
            
            [self.tableView reloadData];
        }
    }];
}



#pragma mark - Table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"CCFThreadListCellIdentifier";
    CCFThreadListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CCFNormalThread * list = self.dataList[indexPath.row];
    [cell setData:list];
    
    return cell;
}


- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
