//
//  CCFFavFormController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransValueDelegate.h"

@interface CCFFavFormController : UITableViewController

- (IBAction)showLeftDrawer:(id)sender;

@property (nonatomic, strong) id<TransValueDelegate> transValueDelegate;

@end
