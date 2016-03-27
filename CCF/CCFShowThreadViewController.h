//
//  CCFThreadDetailTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFPost.h"

@interface CCFShowThreadViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<CCFPost *> * posts;


@property (strong, nonatomic) IBOutlet UIToolbar *floatToolbar;

- (IBAction)floatReplyClick:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)back:(UIBarButtonItem *)sender;

@end
