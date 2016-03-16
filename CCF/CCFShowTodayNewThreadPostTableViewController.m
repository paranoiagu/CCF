//
//  CCFShowTodayNewThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowTodayNewThreadPostTableViewController.h"
#import "CCFNavigationController.h"

@interface CCFShowTodayNewThreadPostTableViewController ()

@end

@implementation CCFShowTodayNewThreadPostTableViewController


-(void)onPullRefresh{
    [self.ccfApi listTodayNewThreadsWithPage:1 handler:^(BOOL isSuccess, id message) {
        
    }];
}

-(void)onLoadMore{
    [self.ccfApi listTodayNewThreadsWithPage:self.currentPage handler:^(BOOL isSuccess, id message) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataList.count;
}



- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
