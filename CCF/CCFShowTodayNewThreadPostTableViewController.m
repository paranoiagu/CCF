//
//  CCFShowTodayNewThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowTodayNewThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFSearchResultCell.h"
#import "CCFSearchThread.h"

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
    static NSString * identifier = @"CCFSearchResultCell";
    CCFSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CCFSearchThread * list = self.dataList[indexPath.row];
    [cell setData:list];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"CCFSearchResultCell" configuration:^(CCFSearchResultCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(CCFSearchResultCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    [cell setData:self.dataList[indexPath.row]];
}


- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
