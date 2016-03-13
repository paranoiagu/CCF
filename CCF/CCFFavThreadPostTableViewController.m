//
//  CCFFavThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFThreadList.h"
#import "CCFThreadListCell.h"

@interface CCFFavThreadPostTableViewController (){
    NSMutableArray<CCFThreadList*> * dataSourceList;
}

@end

@implementation CCFFavThreadPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSourceList = [NSMutableArray array];
    
    [self.ccfApi listFavoriteThreadPosts:^(BOOL isSuccess, NSMutableArray<CCFThreadList *> *message) {
        NSLog(@" 收藏的帖子---》 %@", message);
        
        [dataSourceList addObjectsFromArray:message];
        
        [self.tableView reloadData];
        
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSourceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"CCFThreadListCellIdentifier";
    CCFThreadListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CCFThreadList * list = dataSourceList[indexPath.row];
    [cell setThreadList:list];
    
    return cell;
}



- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
