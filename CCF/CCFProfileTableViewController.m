//
//  CCFProfileTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/20.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFProfileTableViewController.h"
#import "CCFProfileTableViewCell.h"

@interface CCFProfileTableViewController ()<TransValueDelegate>{
    
    CCFUserProfile * userProfile;
    int userId;
}

@end

@implementation CCFProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(BOOL)setLoadMore:(BOOL)enable{
    return NO;
}

-(void)transValue:(CCFNormalThread *)value{
    userId = [value.threadAuthorID intValue];
}


-(void)onPullRefresh{
    NSString * userIdString = [NSString stringWithFormat:@"%d", userId];
    [self.ccfApi showProfileWithUserId:userIdString handler:^(BOOL isSuccess, CCFUserProfile* message) {
        userProfile = message;
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
    }];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return userProfile == nil ? 0: 1;
    } else if (section == 1){
        return 2;
    } else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *QuoteCellIdentifier = @"CCFProfileTableViewCell";
        CCFProfileTableViewCell *cell = (CCFProfileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
        [cell setData:userProfile];
        return cell;
    } else if (indexPath.section == 1){
        static NSString *QuoteCellIdentifier = @"CCFProfileActionCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"发表的主题";
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"给TA发站内短信";
        }
        return cell;
        
    } else{
        static NSString *QuoteCellIdentifier = @"CCFProfileShowCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"注册日期";
            cell.detailTextLabel.text = userProfile.profileRegisterDate;
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"最近活动时间";
            cell.detailTextLabel.text = userProfile.profileRecentLoginDate;
        } else if (indexPath.row == 2){
            cell.textLabel.text = @"帖子总数";
            cell.detailTextLabel.text = userProfile.profileTotalPostCount;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 56;
    } else if (indexPath.section == 1){
        return 44;
    } else{
        return 44;
    }
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
