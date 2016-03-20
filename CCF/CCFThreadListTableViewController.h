//
//  CCFThreadTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFEntry.h"
#import "CCFApiBaseTableViewController.h"
#import "TransValueDelegate.h"

@interface CCFThreadListTableViewController : CCFApiBaseTableViewController



// 置顶
@property (nonatomic, strong) NSMutableArray * threadTopList;

@property (nonatomic, strong) CCFEntry * entry;

- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)createThread:(id)sender;


@property(nonatomic, assign) id<TransValueDelegate> transValueDelegate;

@end
