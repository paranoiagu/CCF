//
//  CCFFavThreadPostTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavThreadPostTableViewController.h"

@interface CCFFavThreadPostTableViewController ()

@end

@implementation CCFFavThreadPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
