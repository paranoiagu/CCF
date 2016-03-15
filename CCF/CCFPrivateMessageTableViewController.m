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

@interface CCFPrivateMessageTableViewController ()

@end


@implementation CCFPrivateMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self.ccfApi listPrivateMessageWithType:0 andPage:1 handler:^(BOOL isSuccess, PrivateMessagePage *message) {
            if (isSuccess) {
                [self.dataList addObjectsFromArray:message.inboxMessages];
                [self.tableView reloadData];
            }
        }];
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    
    
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
