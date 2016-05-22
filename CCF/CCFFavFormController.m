//
//  CCFFavFormController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavFormController.h"
#import "UrlBuilder.h"
#import "CCFParser.h"
#import "CCFCoreDataManager.h"
#import "NSUserDefaults+Extensions.h"

#import "Forum.h"
#import "CCFThreadListTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFApi.h"

@interface CCFFavFormController ()<TransValueDelegate>{

}

@end

@implementation CCFFavFormController



-(void)transValue:(Forum *)value{
    
}

-(BOOL)setPullRefresh:(BOOL)enable{
    return YES;
}

-(BOOL)setLoadMore:(BOOL)enable{
    return NO;
}

-(BOOL)autoPullfresh{
    return NO;
}


-(void)onPullRefresh{
    
    [self.ccfApi listFavoriteForms:^(BOOL isSuccess, NSMutableArray<Forum *> * message) {
        
        
        [self.tableView.mj_header endRefreshing];
        
        if (isSuccess) {
            self.dataList = message;
            [self.tableView reloadData];
        }

    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    
    if (userDef.favFormIds == nil) {
        [self.ccfApi listFavoriteForms:^(BOOL isSuccess, NSMutableArray<Forum *> * message) {
            self.dataList = message;
            [self.tableView reloadData];
        }];
    } else{
        CCFCoreDataManager * manager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryForm];
        NSArray* forms = [[manager selectFavForms:userDef.favFormIds] mutableCopy];
        
        [self.dataList addObjectsFromArray:forms];
        
        [self.tableView reloadData];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"CCFThreadListTableViewController"]) {
        CCFThreadListTableViewController * controller = segue.destinationViewController;
        
        self.transValueDelegate = (id<TransValueDelegate>)controller;
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        Forum * select = self.dataList[path.row];
        
        [self.transValueDelegate transValue:select];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID = @"CCFFavFormControllerCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    Forum * form = self.dataList[indexPath.row];
    
    cell.textLabel.text = form.formName;
    
    return cell;
}

- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
