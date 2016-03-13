//
//  CCFShowNewThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowNewThreadPostTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFSearchResultPage.h"
#import "CCFSearchResult.h"

@interface CCFShowNewThreadPostTableViewController (){
    NSMutableArray<CCFSearchResult*> * dataSourceList;
}

@end

@implementation CCFShowNewThreadPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSourceList = [NSMutableArray array];
    
    [self.ccfApi listNewThreadPosts:^(BOOL isSuccess, CCFSearchResultPage *message) {
        
        if (isSuccess) {
            [dataSourceList addObjectsFromArray:message.searchResults];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataSourceList.count;
}


- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
