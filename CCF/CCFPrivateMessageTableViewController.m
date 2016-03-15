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
    
    [self.ccfApi listPrivateMessageWithType:0 andPage:1 handler:^(BOOL isSuccess, PrivateMessagePage *message) {
        if (isSuccess) {
            [self.dataList addObjectsFromArray:message.inboxMessages];
            [self.tableView reloadData];
        }
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
