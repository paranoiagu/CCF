//
//  CCFThreadTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFApiBaseTableViewController.h"


@interface CCFThreadListTableViewController : CCFApiBaseTableViewController



// 置顶
@property (nonatomic, strong) NSMutableArray * threadTopList;

- (IBAction)back:(UIBarButtonItem *)sender;


- (IBAction)createThread:(id)sender;


@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

@end
