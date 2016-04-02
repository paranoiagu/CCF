//
//  CCFMyProfileUITableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/21.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFMyProfileUITableViewController.h"
#import "CCFProfileTableViewCell.h"

#import "CCFFormTableViewController.h"
#import "CCFPrivateMessageTableViewController.h"
#import "CCFMyThreadPostTableViewController.h"
#import "CCFMyThreadTableViewController.h"
#import "CCFShowNewThreadPostTableViewController.h"
#import "CCFFavThreadPostTableViewController.h"
#import "CCFMyProfileUITableViewController.h"
#import "CCFNavigationController.h"

#import "UIStoryboard+CCF.h"

@interface CCFMyProfileUITableViewController (){
    CCFUserProfile * userProfile;
    
}

@end

@implementation CCFMyProfileUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(BOOL)setLoadMore:(BOOL)enable{
    return NO;
}

-(void)onPullRefresh{
    
    NSString * currentUserId = self.ccfApi.getLoginUser.userID;
    
    [self.ccfApi showProfileWithUserId:currentUserId handler:^(BOOL isSuccess, CCFUserProfile* message) {
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
        return userProfile == nil ? 0 : 1;;
    } else if (section == 1){
        return 4;
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
            cell.textLabel.text = @"设置";
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"注销";
        } else if (indexPath.row == 2){
            cell.textLabel.text = @"我收藏的主题";
        } else if (indexPath.row == 3){
            cell.textLabel.text = @"我发表的主题";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1){
        
    } else if (indexPath.row == 2){
        
        //CCFNavigationController * controller = (CCFNavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIStoryboard * storyboard = [UIStoryboard mainStoryboard];
        
        CCFFavThreadPostTableViewController * favThreadController = [storyboard instantiateViewControllerWithIdentifier:@"CCFFavThreadPostTableViewController"];
        
        [self.navigationController pushViewController:favThreadController animated:YES];
//        [controller setRootViewController:favThreadController];
        
        
    } else if (indexPath.row == 3){
//        CCFNavigationController * controller = (CCFNavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIStoryboard * storyboard = [UIStoryboard mainStoryboard];
        
        CCFMyThreadTableViewController * myThreadController = [storyboard instantiateViewControllerWithIdentifier:@"CCFMyThreadTableViewController"];
        
        [self.navigationController pushViewController:myThreadController animated:YES];
//        [controller setRootViewController:myThreadController];
    }
}

#pragma mark Controller跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    if([segue.identifier isEqualToString:@"ShowThreadPosts"]){
//        CCFShowThreadViewController * controller = segue.destinationViewController;
//        self.transValueDelegate = (id<TransValueDelegate>)controller;
//        
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        
//        CCFNormalThread * thread = nil;
//        
//        NSInteger section = indexPath.section;
//        
//        if ( section == 1) {
//            thread = self.threadTopList[indexPath.row];
//        } else if(section == 2){
//            thread = self.dataList[indexPath.row];
//        }
//        
//        
//        [self.transValueDelegate transValue:thread];
//        
//    } else if ([segue.identifier isEqualToString:@"ShowChildForm"]){
//        CCFThreadListForChildFormUITableViewController * controller = segue.destinationViewController;
//        self.transValueDelegate = (id<TransValueDelegate>)controller;
//        [self.transValueDelegate transValue:transForm];
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        [self.transValueDelegate transValue:childForms[indexPath.row]];
//        
//    } else if ([segue.identifier isEqualToString:@"ShowUserProfile"]){
//        selectSegue = segue;
//    }
//    
//    else if ([sender isKindOfClass:[UIButton class]]){
//        CCFProfileTableViewController * controller = segue.destinationViewController;
//        self.transValueDelegate = (id<TransValueDelegate>)controller;
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        
//        CCFNormalThread * thread = nil;
//        
//        if (indexPath.section == 0) {
//            thread = self.threadTopList[indexPath.row];
//        } else{
//            thread = self.dataList[indexPath.row];
//        }
//        
//        [self.transValueDelegate transValue:thread];
//    }
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
