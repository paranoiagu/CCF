//
//  CCFThreadDetailTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadDetailTableViewController.h"
#import "CCFThreadDetailCell.h"
#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"

#import "MJRefresh.h"
#import "WCPullRefreshControl.h"

@interface CCFThreadDetailTableViewController ()<CCFThreadDetailCellDelegate>{
    
    NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeightDictionary;
    int currentPage;
    int totalPage;
    
    CCFBrowser * browser;
}


@property (strong,nonatomic)WCPullRefreshControl * pullRefresh;

@end

@implementation CCFThreadDetailTableViewController

@synthesize entry;
@synthesize posts = _posts;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    browser = [[CCFBrowser alloc]init];
    
    cellHeightDictionary = [NSMutableDictionary<NSIndexPath *, NSNumber *> dictionary];
    
    
    NSLog(@"CCFThreadDetailTableViewController viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int page = currentPage +1;
        [self browserThreadPosts:page];
        
    }];

//    self.pullRefresh = [[WCPullRefreshControl alloc] initWithScrollview:self.tableView Action:^{
//        [self browserThreadPosts:1];
//    }];
//    
//    [self.pullRefresh startPullRefresh];
    
    [self browserThreadPosts:1];
    
    
    NSString * message = @":blush;\n[RIGHT][URL=\"https://bbs.et8.net/bbs/showthread.php?p=16695603\"]For Test:Quick Reply[/URL][/RIGHT]";
    
//    [browser reply:entry.urlId :message];
}

-(void) browserThreadPosts:(int)page{
    if (totalPage == 0 || currentPage < totalPage) {
    
        NSString * pageStr = [NSString stringWithFormat:@"%d", page];
        
        [browser browseWithUrl:[CCFUrlBuilder buildThreadURL:entry.urlId withPage:pageStr]:^(NSString* result) {
            
            CCFParser *parser = [[CCFParser alloc]init];
            
            NSMutableArray<CCFPost *> * parsedPosts = [parser parsePostFromThreadHtml:result];
            
            if (self.posts == nil) {
                self.posts = [NSMutableArray array];
            }
            
            [self.posts addObjectsFromArray:parsedPosts];
            
            currentPage = page;
            
            if (currentPage < totalPage) {
                [self.tableView.mj_footer endRefreshing];
            } else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            [self.tableView reloadData];
            
        }];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFThreadDetailCellIdentifier";
    
    CCFThreadDetailCell *cell = (CCFThreadDetailCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    cell.delegate = self;
    
    //CCFThreadDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CCFThreadDetailCellIdentifier" owner:self options:nil] lastObject];
    
    
    CCFPost *post = self.posts[indexPath.row];
    
//    [cell.content loadHTMLString:post.postContent baseURL:[CCFUrlBuilder buildIndexURL]];
//    [cell setPost:post];
    [cell setPost:post with:indexPath];
    
    return cell;
}


-(void)relayoutContentHeigt:(NSIndexPath *)indexPath with:(CGFloat)height{
    if ([cellHeightDictionary objectForKey:indexPath] == nil) {
        CGFloat fixHeight = height < 44.f? 44.f : height + 10.f;
        
        [cellHeightDictionary setObject:[NSNumber numberWithFloat:fixHeight] forKey:indexPath];
        
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber * nsheight = [cellHeightDictionary objectForKey:indexPath];
    if (nsheight == nil) {
        return  44;
    }
    return nsheight.floatValue;
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
