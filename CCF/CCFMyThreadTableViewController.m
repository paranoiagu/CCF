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
#import "CCFShowThreadViewController.h"

@interface CCFMyThreadTableViewController ()

@end

@implementation CCFMyThreadTableViewController

-(void)onPullRefresh{
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
}

-(void)onLoadMore{
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
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"CCFSearchResultCell";
    CCFSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    CCFSearchThread * thread = self.dataList[indexPath.row];
    [cell setData:thread];
    
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

#pragma mark Controller跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"ShowThreadPosts"]){
        CCFShowThreadViewController * controller = segue.destinationViewController;
        self.transValueDelegate = (id<TransValueDelegate>)controller;
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        CCFSearchThread * thread = self.dataList[indexPath.row];
        
        [self.transValueDelegate transValue:thread];
        
    }
}


- (IBAction)showLeftDrawer:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
