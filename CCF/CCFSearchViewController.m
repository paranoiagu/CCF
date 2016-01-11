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


@interface CCFSearchViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray<CCFSearchResult *> * searchResult;
    int currentPage;
    int maxPage;
}

@end

@implementation CCFSearchViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    CCFBrowser * browser = [[CCFBrowser alloc]init];
    
    [browser searchWithKeyWord:@"ccf" searchDone:^(CCFSearchResultPage* result) {
        
        [searchResult addObjectsFromArray:result.searchResults];
        
        [self.tableView reloadData];
        
    }];
}

-(void) initData{
    searchResult = [NSMutableArray array];
    currentPage = 0;
    maxPage = 0;
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
