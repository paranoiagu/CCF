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

@interface CCFThreadListTableViewController ()<WCPullRefreshControlDelegate>{
    int currentPage;
    int totalPage;
    float verticalContentOffset;
}

@property (strong,nonatomic)WCPullRefreshControl * pullRefresh;
@property (nonatomic, strong) CCFApi * ccfapi;
@end

@implementation CCFThreadListTableViewController

@synthesize threadTopList = _threadTopList;
@synthesize entry;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    verticalContentOffset = 0;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180.0;
    
    if (self.threadTopList == nil) {
        self.threadTopList = [NSMutableArray array];
    }
    
    if (self.ccfapi == nil) {
        self.ccfapi = [[CCFApi alloc]init];
    }
    
    
    NSLog(@"viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int page = currentPage +1;
        [self browserThreadList:page type:TypeLoadMore];
        
    }];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
        
        [self browserThreadList:1 type:TypePullRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
//    self.pullRefresh.delegate = self;
//    self.pullRefresh = [[WCPullRefreshControl alloc] initWithScrollview:self.tableView Action:^{
//        [self browserThreadList:1 type:TypePullRefresh];
//    }];
//    [self.pullRefresh startPullRefresh];
    
//    
//    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
//
}


-(void) browserThreadList:(int) page type:(int) pullOrLoadMore{

    
    if (totalPage == 0 || currentPage < totalPage) {
        NSString * pageStr = [NSString stringWithFormat:@"%d", page];
        
        [self.ccfapi forumDisplayWithId:entry.urlId andPage:pageStr handler:^(BOOL isSuccess, NSMutableArray<CCFNormalThread *> * threadList) {
            totalPage = (int)threadList.lastObject.threadTotalListPage;
            
            if (page == 1) {
                [self.dataList removeAllObjects];
                [self.threadTopList removeAllObjects];
            }
            for (CCFNormalThread * thread in threadList) {
                if (thread.isTopThread) {
                    [self.threadTopList addObject:thread];
                }else{
                    [self.dataList addObject:thread];
                }
            }
            
//            CGFloat oldTableViewHeight = self.tableView.contentSize.height;
//            CGFloat currentContentOffsetY = self.tableView.contentOffset.y;
            
            [self.tableView reloadData];
            
//？】            CGFloat newTableViewHeight = self.tableView.contentSize.height;
            
//            [self.tableView setContentOffset:CGPointMake(0, verticalContentOffset)];
//            self.tableView.contentOffset = CGPointMake(0, currentContentOffsetY + newTableViewHeight -oldTableViewHeight);

            
            currentPage = page;
            if (pullOrLoadMore == TypePullRefresh) {
                [self.pullRefresh finishRefreshingSuccessully:YES];
            } else{
                [self.tableView.mj_footer endRefreshing];
            }
        }];

    } else{
        if (pullOrLoadMore == TypePullRefresh) {
            [self.pullRefresh finishRefreshingSuccessully:NO];
        } else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        

    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.pullRefresh updateWhenScrollDidEndDraging];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pullRefresh updateWhenScrollviewScroll];
}
-(void)DidStartRefreshingWithScrollview:(UIScrollView *)scrollview{
    //[self performSelector:@selector(reset) withObject:nil afterDelay:2.0];
    //[self.pullRefresh finishRefreshingSuccessully:YES];
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
    
    
    NSLog(@"prepareForSegue&&&&&&&&                 %@", sender);
    
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
