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


@interface CCFSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    NSString * redirectUrl;
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

    [self.ccfApi searchWithKeyWord:searchBar.text handler:^(BOOL isSuccess, CCFSearchPage* message) {
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


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *QuoteCellIdentifier = @"CCFSearchResultCell";
    
    CCFSearchResultCell *cell = (CCFSearchResultCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
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


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
