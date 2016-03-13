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

-(instancetype)init{
    if (self = [super init]) {
        _ccfApi = [[CCFApi alloc] init];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _ccfApi = [[CCFApi alloc] init];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _ccfApi = [[CCFApi alloc] init];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        _ccfApi = [[CCFApi alloc] init];
    }
    return self;
}


@end