//
//  CCFSearchViewController.m
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSearchViewController.h"
#import "CCFBrowser.h"
#import "CCFSearchThread.h"
#import "CCFApi.h"
#import "CCFSearchPage.h"
#import "CCFSearchResultCell.h"
#import "CCFShowThreadViewController.h"
#import "CCFProfileTableViewController.h"
#import <SVProgressHUD.h>


@interface CCFSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CCFThreadListCellDelegate>{
    NSString * redirectUrl;
    UIStoryboardSegue * selectSegue;
}

@end

@implementation CCFSearchViewController

-(void)viewDidLoad{
    self.searchBar.delegate = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self onLoadMore];
    }];
}

-(void)onLoadMore{

    if (redirectUrl == nil) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [self.ccfApi listSearchResultWithUrl:redirectUrl andPage:self.currentPage + 1 handler:^(BOOL isSuccess, CCFSearchPage* message) {
        [self.tableView.mj_footer endRefreshing];
        
        if (isSuccess) {

            self.currentPage++;
            self.totalPage = (int)message.totalPageCount;
            
            if (self.currentPage >= self.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.dataList addObjectsFromArray:message.dataList];
            [self.tableView reloadData];
        } else{
            NSLog(@"searchBarSearchButtonClicked   ERROR %@", message);
        }
    }];
    
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [SVProgressHUD showWithStatus:@"搜索中" maskType:SVProgressHUDMaskTypeBlack];
    
    [self.ccfApi searchWithKeyWord:searchBar.text handler:^(BOOL isSuccess, CCFSearchPage* message) {
        [SVProgressHUD dismiss];
        
        if (isSuccess) {
            redirectUrl = message.redirectUrl;
            
            self.currentPage = (int)message.currentPage;
            self.totalPage = (int)message.totalPageCount;
            
            [self.dataList removeAllObjects ];
            [self.dataList addObjectsFromArray:message.dataList];
            [self.tableView reloadData];
        } else{
            NSLog(@"searchBarSearchButtonClicked   ERROR %@", message);
        }
    }];
    
}

-(void)showUserProfile:(NSIndexPath *)indexPath{
    CCFProfileTableViewController * controller = (CCFProfileTableViewController *)selectSegue.destinationViewController;
    self.transValueDelegate = (id<TransValueDelegate>)controller;
    
    CCFSearchThread * thread = self.dataList[indexPath.row];
    
    [self.transValueDelegate transValue:thread];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *QuoteCellIdentifier = @"CCFSearchResultCell";
    
    CCFSearchResultCell *cell = (CCFSearchResultCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    cell.delegate = self;
    [cell setData:self.dataList[indexPath.row]];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"CCFSearchResultCell" configuration:^(CCFSearchResultCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(CCFSearchResultCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    [cell setData:self.dataList[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"ShowThreadPosts"]){
        CCFShowThreadViewController * controller = segue.destinationViewController;
        self.transValueDelegate = (id<TransValueDelegate>)controller;
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        CCFSearchThread * thread = self.dataList[indexPath.row];
        
        [self.transValueDelegate transValue:thread];
        
    } else if ([segue.identifier isEqualToString:@"ShowUserProfile"]){
        selectSegue = segue;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
