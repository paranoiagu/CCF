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

#import "CCFSearchResultCell.h"


@interface CCFSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    NSMutableArray<CCFSearchThread *> * searchResult;
    int currentPage;
    int maxPage;
    CCFBrowser * browser;
    CCFApi * _api;
}

@end

@implementation CCFSearchViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    browser = [[CCFBrowser alloc]init];
    _api = [[CCFApi alloc] init];
    
    self.searchBar.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

}

-(void) initData{
    searchResult = [NSMutableArray array];
    currentPage = 0;
    maxPage = 0;
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"searchBarSearchButtonClicked");
    [_api searchWithKeyWord:searchBar.text handler:^(BOOL isSuccess, id message) {
        if (isSuccess) {
            CCFPage* result = message;
            [searchResult removeAllObjects ];
            [searchResult addObjectsFromArray:result.dataList];
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
    [cell setData:searchResult[indexPath.row]];
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return searchResult.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
