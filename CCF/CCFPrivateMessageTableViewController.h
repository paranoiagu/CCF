//
//  CCFPrivateMessageTableViewController.h
//  CCF
//
//  Created by WDY on 16/3/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFApiBaseTableViewController.h"
#import "TransValueDelegate.h"

@interface CCFPrivateMessageTableViewController : CCFApiBaseTableViewController

- (IBAction)showLeftDrawer:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageSegmentedControl;
@property (nonatomic , strong) id<TransValueDelegate> transValueDelegate;

@end
