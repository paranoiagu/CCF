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
    int currentPage;
}

@end


@implementation CCFPrivateMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 1;
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self.ccfApi listPrivateMessageWithType:0 andPage:currentPage handler:^(BOOL isSuccess, CCFPage *message) {
            if (isSuccess) {
                currentPage ++;
                [self.dataList addObjectsFromArray:message.dataList];
                
                [self.tableView reloadData];
            }
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.ccfApi listPrivateMessageWithType:0 andPage:currentPage handler:^(BOOL isSuccess, CCFPage *message) {
            [self.tableView.mj_footer endRefreshing];
            if (isSuccess) {
                currentPage++;
                [self.dataList addObjectsFromArray:message.dataList];
                [self.tableView reloadData];
            }
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PrivateMessageTableViewCell";
    
    PrivateMessageTableViewCell *cell = (PrivateMessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];

    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++%@", cell);
    
    
    
    PrivateMessage *message = self.dataList[indexPath.row];
    [cell setData:message];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
