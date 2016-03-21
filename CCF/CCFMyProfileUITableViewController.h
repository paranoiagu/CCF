//
//  CCFMyProfileUITableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/3/21.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFApiBaseTableViewController.h"
#import "TransValueDelegate.h"

@interface CCFMyProfileUITableViewController : CCFApiBaseTableViewController

@property(nonatomic, weak) id<TransValueDelegate> transValueDelegate;
- (IBAction)back:(id)sender;

@end
