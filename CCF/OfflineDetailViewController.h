//
//  OfflineDetailViewController.h
//  OfficialDemo3D
//
//  Created by xiaoming han on 14-5-5.
//  Copyright (c) 2014年 songjian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OfflineDetailViewController : UIViewController

@property(nonatomic, strong) NSArray *cities;

@property(nonatomic, strong) NSArray *sectionTitles;
@property(nonatomic, strong) NSArray *provinces;


@property(nonatomic, strong) NSMutableSet *downloadingItems;
@property(nonatomic, strong) NSMutableDictionary *downloadStages;

@property(nonatomic, assign) BOOL needReloadWhenDisappear;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationBar *offlineNavigationBar;

- (IBAction)backClick:(UIBarButtonItem *)sender;

@end
