//
//  CCFThreadDetailTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFEntry.h"

@interface CCFThreadDetailTableViewController : UITableViewController


@property (nonatomic, assign) CCFEntry* entry;
- (IBAction)back:(UIBarButtonItem *)sender;

@end
