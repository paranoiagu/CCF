//
//  CCFThreadTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFEntry.h"

@interface CCFThreadListTableViewController : UITableViewController



// 置顶
@property (nonatomic, strong) NSMutableArray * threadTopList;

@property (nonatomic, strong) NSMutableArray * threadList;

@property (nonatomic, strong) CCFEntry * entry;

- (IBAction)back:(UIBarButtonItem *)sender;

@end
