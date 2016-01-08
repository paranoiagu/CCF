//
//  CCFThreadDetailTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFEntry.h"
#import "CCFPost.h"

@interface CCFThreadDetailTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<CCFPost *> * posts;

@property (nonatomic, strong) CCFEntry* entry;

@property (strong, nonatomic) IBOutlet UIToolbar *floatToolbar;

@property (weak, nonatomic) IBOutlet UITextField *floatTextView;
- (IBAction)floatReplyClick:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *inputText;
- (IBAction)back:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
