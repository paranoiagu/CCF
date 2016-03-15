//
//  CCFFavThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFNormalThread.h"
#import "CCFThreadListCell.h"

@interface CCFFavThreadPostTableViewController (){
    int currentPage;
}

@end

@implementation CCFFavThreadPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.ccfApi listFavoriteThreadPosts:^(BOOL isSuccess, NSMutableArray<CCFNormalThread *> *message) {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dataList addObjectsFromArray:message];
            
            [self.tableView reloadData];
            
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.ccfApi listFavoriteThreadPosts:^(BOOL isSuccess, NSMutableArray<CCFNormalThread *> *message) {
            if (isSuccess) {
                
                [self.tableView.mj_footer endRefreshing];
                
                [self.dataList addObjectsFromArray:message];
                
                [self.tableView reloadData];
            }
            
        }];
    }];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);

}


#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"CCFThreadListCellIdentifier";
    CCFThreadListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CCFNormalThread * list = self.dataList[indexPath.row];
    [cell setThreadList:list];
    
    return cell;
}



- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
