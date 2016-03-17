//
//  CCFFavThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFSimpleThreadTableViewCell.h"

@interface CCFFavThreadPostTableViewController ()

@end

@implementation CCFFavThreadPostTableViewController

-(void)onPullRefresh{
    [self.ccfApi listFavoriteThreadPostsWithPage:1 handler:^(BOOL isSuccess, CCFPage* resultPage) {
        
        [self.tableView.mj_header endRefreshing];
        if (isSuccess) {
            
            [self.tableView.mj_header endRefreshing];
            
            self.currentPage = 1;
            self.totalPage = (int)resultPage.totalPageCount;
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:resultPage.dataList];
            [self.tableView reloadData];
        }
    }];
}

-(void)onLoadMore{
    [self.ccfApi listFavoriteThreadPostsWithPage:self.currentPage handler:^(BOOL isSuccess, CCFPage* resultPage) {
        
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
    static NSString * identifier = @"CCFSimpleThreadTableViewCell";
    CCFSimpleThreadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CCFSimpleThread * list = self.dataList[indexPath.row];
    [cell setData:list];
    
    return cell;
}



- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
