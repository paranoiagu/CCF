//
//  CCFSearchViewController.m
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSearchViewController.h"
#import "CCFBrowser.h"
#import "CCFSearchResult.h"
#import "CCFSearchResultPage.h"
#import "CCFSearchResultCell.h"


@interface CCFSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    NSMutableArray<CCFSearchResult *> * searchResult;
    int currentPage;
    int maxPage;
    CCFBrowser * browser;
}

@end

@implementation CCFSearchViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    browser = [[CCFBrowser alloc]init];
    
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
    
    [browser searchWithKeyWord:searchBar.text searchDone:^(CCFSearchResultPage* result) {
        
        [searchResult removeAllObjects ];
        
        [searchResult addObjectsFromArray:result.searchResults];
        
        [self.tableView reloadData];
        
    }];
    
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldBeginEditing");
    

    
    return YES;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *QuoteCellIdentifier = @"CCFSearchResultCell";
    
    CCFSearchResultCell *cell = (CCFSearchResultCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    [cell setSearchResult:searchResult[indexPath.row]];
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return searchResult.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
