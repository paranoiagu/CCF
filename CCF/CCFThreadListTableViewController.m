//
//  CCFThreadTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListTableViewController.h"

#import "CCFUrlBuilder.h"
#import "CCFParser.h"
#import "CCFThreadListCell.h"
#import "CCFShowThreadViewController.h"
#import "MJRefresh.h"
#import "WCPullRefreshControl.h"
#import "CCFNewThreadViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"



#define TypePullRefresh 0
#define TypeLoadMore 1

@interface CCFThreadListTableViewController ()

@end

@implementation CCFThreadListTableViewController

@synthesize entry;


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180.0;
    
    if (self.threadTopList == nil) {
        self.threadTopList = [NSMutableArray array];
    }
}


-(void)onPullRefresh{
    [self.ccfApi forumDisplayWithId:entry.urlId andPage:1 handler:^(BOOL isSuccess, CCFPage *page) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (isSuccess) {
            self.totalPage = (int)page.totalPageCount;
            self.currentPage = 1;
            if (self.currentPage >= self.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.threadTopList removeAllObjects];
            [self.dataList removeAllObjects];
            
            for (CCFNormalThread * thread in page.dataList) {
                if (thread.isTopThread) {
                    [self.threadTopList addObject:thread];
                }else{
                    [self.dataList addObject:thread];
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

-(void)onLoadMore{
    [self.ccfApi forumDisplayWithId:entry.urlId andPage:self.currentPage + 1 handler:^(BOOL isSuccess, CCFPage *page) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if (isSuccess) {
            self.totalPage = (int)page.totalPageCount;
            self.currentPage ++;
            if (self.currentPage >= self.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.threadTopList removeAllObjects];
            [self.dataList removeAllObjects];
            
            for (CCFNormalThread * thread in page.dataList) {
                [self.dataList addObject:thread];
            }
            
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.threadTopList.count;
    }
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFThreadListCellIdentifier";
    
    CCFThreadListCell *cell = (CCFThreadListCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
    if (indexPath.section == 0) {
        CCFNormalThread *play = self.threadTopList[indexPath.row];
        [cell setThreadList:play];
    } else{
        CCFNormalThread *play = self.dataList[indexPath.row];
        [cell setThreadList:play];
    }

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"CCFThreadListCellIdentifier" configuration:^(CCFThreadListCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(CCFThreadListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    [cell setThreadList:self.dataList[indexPath.row]];
}




#pragma mark Controller跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        CCFNewThreadViewController * newPostController = segue.destinationViewController;
        
        if ([newPostController respondsToSelector:@selector(setEntry:)]) {

            CCFEntry * transEntry = [[CCFEntry alloc]init];
            
            transEntry.urlId = entry.urlId;
            
            [newPostController setValue:transEntry forKey:@"entry"];
            
        }
        
        
    } else if([sender isKindOfClass:[UITableViewCell class]]){
        CCFShowThreadViewController * controller = segue.destinationViewController;
        
        if ([controller respondsToSelector:@selector(setEntry:)]) {
            
            
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            
            CCFNormalThread * thread = nil;
            
            if (indexPath.section == 0) {
                thread = self.threadTopList[indexPath.row];
            } else{
                thread = self.dataList[indexPath.row];
            }
            
            
            CCFEntry * transEntry = [[CCFEntry alloc]init];
            
            transEntry.urlId = thread.threadID;
            
            transEntry.page = @"1";
            
            [controller setValue:transEntry forKey:@"entry"];
            
        }
    }
    

}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createThread:(id)sender {
}
@end
