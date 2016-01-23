//
//  MyTableViewController.h
//  MyTableView
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>     // for MFMailComposeViewControllerDelegate
#import "CCFFormHeaderView.h"    // for SectionHeaderViewDelegate

#import "CCFEntryDelegate.h"

#import "DrawerView.h"
@class CCFFormJSONModel;

@interface CCFFormTableViewController : UIViewController<MFMailComposeViewControllerDelegate, SectionHeaderViewDelegate, CCFEntryDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onLeftBarButtonItemClick:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSMutableArray<CCFFormJSONModel *> *forms;

@property (nonatomic, strong) DrawerView *leftDrawerView;

@end
