//
//  CCFShowNewThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/6.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowNewThreadPostTableViewController.h"

@interface CCFShowNewThreadPostTableViewController ()

@end

@implementation CCFShowNewThreadPostTableViewController

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


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
