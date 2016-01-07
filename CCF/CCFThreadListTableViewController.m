//
//  CCFThreadTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListTableViewController.h"


#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"
#import "CCFThreadListCell.h"
#import "CCFThreadDetailTableViewController.h"
#import "MJRefresh.h"
#import "WCPullRefreshControl.h"


@interface CCFThreadListTableViewController ()<WCPullRefreshControlDelegate>{
    int currentPage;
}

@property (strong,nonatomic)WCPullRefreshControl * pullRefresh;
@property (nonatomic, strong) CCFBrowser * browser;
@end

@implementation CCFThreadListTableViewController

@synthesize threadList = _threadList;
@synthesize threadTopList = _threadTopList;
@synthesize entry;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.threadList == nil) {
        self.threadList = [NSMutableArray array];
    }
    
    if (self.threadTopList == nil) {
        self.threadTopList = [NSMutableArray array];
    }
    
    if (self.browser == nil) {
        self.browser = [[CCFBrowser alloc]init];
    }
    
    
    NSLog(@"viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int page = currentPage +1;
        [self browserThreadList:page];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    self.pullRefresh.delegate = self;
    
    
    self.pullRefresh = [[WCPullRefreshControl alloc] initWithScrollview:self.tableView Action:^{
        [self browserThreadList:1];
    }];
    
    [self.pullRefresh startPullRefresh];
    
}

-(void) browserThreadList:(int) page{

    NSString * pageStr = [NSString stringWithFormat:@"%d", page];
    [self.browser browseWithUrl:[CCFUrlBuilder buildFormURL:entry.urlId withPage:pageStr ]:^(NSString* result) {
        
        CCFParser *parser = [[CCFParser alloc]init];
        
        NSMutableArray<CCFThreadList *> * threadList = [parser parseThreadListFromHtml:result withThread:entry.urlId andContainsTop:YES];
        if (page == 1) {
            [self.threadList removeAllObjects];
            [self.threadTopList removeAllObjects];
        }
        for (CCFThreadList * thread in threadList) {
            if (thread.isTopThread) {
                [self.threadTopList addObject:thread];
            }else{
                [self.threadList addObject:thread];
            }
        }
        
        
        [self.tableView reloadData];
        
        currentPage = page;
        
        [self.pullRefresh finishRefreshingSuccessully:YES];
        
    }];
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
    return self.threadList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFThreadListCellIdentifier";
    
    CCFThreadListCell *cell = (CCFThreadListCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
    if (indexPath.section == 0) {
        CCFThreadList *play = self.threadTopList[indexPath.row];
        
        cell.threadTitle.text = play.threadTitle;
    } else{
        CCFThreadList *play = self.threadList[indexPath.row];
        
        cell.threadTitle.text = play.threadTitle;
    }

    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CCFThreadDetailTableViewController * controller = segue.destinationViewController;
    
    if ([controller respondsToSelector:@selector(setEntry:)]) {
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        CCFThreadList * thread = nil;
        
        if (indexPath.section == 0) {
            thread = self.threadTopList[indexPath.row];
        } else{
            thread = self.threadList[indexPath.row];
        }

        
        CCFEntry * transEntry = [[CCFEntry alloc]init];
        
        transEntry.urlId = thread.threadID;
        
        transEntry.page = @"1";
        
        [controller setValue:transEntry forKey:@"entry"];

    }
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
