//
//  CCFApiBaseTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFApiBaseTableViewController.h"

@interface CCFApiBaseTableViewController ()

@end

@implementation CCFApiBaseTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self onPullRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self onLoadMore];
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-44, 0, 0, 0);
}

-(void)onPullRefresh{
    
}

-(void)onLoadMore{
    
}


#pragma mark initData
- (void)initData {
    self.ccfApi = [[CCFApi alloc]init];
    self.dataList =[[NSMutableArray alloc]init];
}


#pragma mark override-init
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

#pragma mark overide-initWithCoder
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initData];
    }
    return self;
}

#pragma mark overide-initWithName
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initData];
    }
    return self;
}

#pragma mark overide-initWithStyle
-(instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        [self initData];
    }
    return self;
}

#pragma mark overide-numberOfRowsInSection
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}


@end