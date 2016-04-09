//
//  CCFApiBaseTableViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/3/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCFApi.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TransValueDelegate.h"

@interface CCFApiBaseTableViewController : UITableViewController


@property (nonatomic, strong) CCFApi *ccfApi;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int totalPage;

@property (weak, nonatomic) id<TransValueDelegate> transValueDelegate;

-(void)onPullRefresh;


-(void)onLoadMore;

-(BOOL)setPullRefresh:(BOOL) enable;

-(BOOL)setLoadMore:(BOOL) enable;

- (BOOL) autoPullfresh;
@end
