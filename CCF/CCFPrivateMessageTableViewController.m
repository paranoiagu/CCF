//
//  CCFPrivateMessageTableViewController.m
//  CCF
//
//  Created by WDY on 16/3/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFPrivateMessageTableViewController.h"
#import "CCFNavigationController.h"

@interface CCFPrivateMessageTableViewController ()

@end

@implementation CCFPrivateMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}



- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
