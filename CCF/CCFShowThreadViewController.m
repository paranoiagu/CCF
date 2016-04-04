//
//  CCFThreadDetailTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowThreadViewController.h"
#import "CCFThreadDetailCell.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"

#import "MJRefresh.h"
#import "CCFUITextView.h"

#import "CCFShowThreadPage.h"

#import "AlertProgressViewController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "TransValueDelegate.h"
#import "CCFApi.h"
#import "CCFThread.h"
#import "TransValueUITableViewCell.h"
#import "CCFProfileTableViewController.h"
#import "CCFNavigationController.h"
#import "UIStoryboard+CCF.h"
#import "CCFSeniorNewPostViewController.h"
#import "TransValueBundle.h"
#import <LCActionSheet.h>
#import "ActionSheetPicker.h"


@interface CCFShowThreadViewController ()< UITextViewDelegate, CCFUITextViewDelegate, CCFThreadDetailCellDelegate, TransValueDelegate, CCFThreadListCellDelegate>{
    
    NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeightDictionary;
    int currentPage;
    int totalPage;
    
    CCFApi * ccfapi;
    CCFUITextView * field;
    CCFApi *_api;
    
    CCFThread * transThread;
    
    UIStoryboardSegue * selectSegue;
    
    CCFShowThreadPage * currentThreadPage;
    
    LCActionSheet * itemActionSheet;
}

@end

@implementation CCFShowThreadViewController

@synthesize posts = _posts;


#pragma mark trans value
-(void)transValue:(CCFThread *)value{
    transThread = value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    field = [[CCFUITextView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    field.heightDelegate = self;
    field.delegate = self;

    [_floatToolbar sizeToFit];

    
    
    NSArray<UIBarButtonItem*> * items  = _floatToolbar.items;
    
    for (UIBarButtonItem * item in items) {
        if (item.customView != nil) {
            item.customView = field;
        }
        
        UIEdgeInsets insets = item.imageInsets;
        insets.bottom = - CGRectGetHeight(_floatToolbar.frame) + 44;
        item.imageInsets = insets;
        
        
    }
    
    CGRect screenSize = [UIScreen mainScreen].bounds;
    
    CGRect frame = _floatToolbar.frame;
    frame.origin.y = screenSize.size.height - 44;
    _floatToolbar.frame = frame;
    
    
    [self.view addSubview:_floatToolbar];
    
    _api = [[CCFApi alloc] init];
    
    ccfapi = [[CCFApi alloc]init];
    
    cellHeightDictionary = [NSMutableDictionary<NSIndexPath *, NSNumber *> dictionary];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    currentPage = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [ccfapi showThreadWithId:[transThread.threadID intValue] andPage:1 handler:^(BOOL isSuccess, CCFShowThreadPage * thread) {
            [self.tableView.mj_header endRefreshing];
            
            if (isSuccess) {
                currentPage = 1;
                
                [cellHeightDictionary removeAllObjects];
                
                totalPage = (int)thread.totalPageCount;
                
                if (currentPage >= totalPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                
                NSMutableArray<CCFPost *> * parsedPosts = thread.dataList;
                
                
                if (self.posts == nil) {
                    self.posts = [NSMutableArray array];
                }
                
                currentThreadPage = thread;
                
                [self.posts removeAllObjects];
                [self.posts addObjectsFromArray:parsedPosts];
                [self.tableView reloadData];
            }
            
        }];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [ccfapi showThreadWithId:[transThread.threadID intValue] andPage:currentPage + 1 handler:^(BOOL isSuccess, CCFShowThreadPage * thread) {
            
            [self.tableView.mj_footer endRefreshing];
            
            if (isSuccess) {
                currentPage ++;
                totalPage = (int)thread.totalPageCount;
                
                if (currentPage >= totalPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                NSMutableArray<CCFPost *> * parsedPosts = thread.dataList;
                
                if (self.posts == nil) {
                    self.posts = [NSMutableArray array];
                }
                
                currentThreadPage = thread;
                
                [self.posts addObjectsFromArray:parsedPosts];
                [self.tableView reloadData];
            }
            
        }];
        
    }];

    
    
    [self.tableView.mj_header beginRefreshing];
    
    self.titleNavigationItem.title = transThread.threadTitle;
    
}


-(void)textViewDidChange:(UITextView *)textView{
    
    [field showPlaceHolder:[textView.text isEqualToString:@""]];
}



-(void)heightChanged:(CGFloat)height{
    
    CGRect rect = _floatToolbar.frame;
    CGFloat addHeight = height - rect.size.height;
    
    rect.size.height = height + 14;
    rect.origin.y = rect.origin.y - addHeight - 14;
    
    _floatToolbar.frame = rect;
    
//    NSArray<UIBarButtonItem*> * items  = _floatToolbar.items;
//    for (UIBarButtonItem * item in items) {
//        UIEdgeInsets insets = item.imageInsets;
//        insets.bottom = -_floatToolbar.frame.size.height / 2;
//        item.imageInsets = insets;
//    }
    
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
    cell.detailDelegate = self;
    
    CCFPost *post = self.posts[indexPath.row];
    
//    [cell.content loadHTMLString:post.postContent baseURL:[CCFUrlBuilder buildIndexURL]];
//    [cell setPost:post];
    [cell setPost:post forIndexPath:indexPath];
    
    return cell;
}

-(void)relayoutContentHeigt:(NSIndexPath *)indexPath with:(CGFloat)height{
    NSNumber * nsheight = [cellHeightDictionary objectForKey:indexPath];
    if (nsheight == nil) {
        [cellHeightDictionary setObject:[NSNumber numberWithFloat:height] forKey:indexPath];
//        [self.tableView reloadData];
        NSIndexPath *indexPathReload=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathReload,nil] withRowAnimation:UITableViewRowAnimationNone];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber * nsheight = [cellHeightDictionary objectForKey:indexPath];
    if (nsheight == nil) {
        return  115.0;
    }
    return nsheight.floatValue;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 15 + [tableView fd_heightForCellWithIdentifier:@"CCFThreadDetailCellIdentifier" configuration:^(CCFThreadDetailCell *cell) {
//
//        [cell setPost:self.posts[indexPath.row]];
//    }];
//}

#pragma mark LCActionSheetDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CCFPost * selectPost = self.posts[indexPath.row];

    itemActionSheet = [LCActionSheet sheetWithTitle:selectPost.postUserInfo.userName buttonTitles:@[@"快速回复", @"@作者"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            UIStoryboard * storyboard = [UIStoryboard mainStoryboard];
            
            CCFSeniorNewPostViewController * myThreadController = [storyboard instantiateViewControllerWithIdentifier:@"CCFSeniorNewPostViewController"];
            self.transValueDelegate = (id<TransValueDelegate>)myThreadController;
            
            TransValueBundle * bundle = [[TransValueBundle alloc] init];
            
            [bundle putIntValue:[transThread.threadID intValue] forKey:@"THREAD_ID"];
            
            CCFPost * selectPost = self.posts[indexPath.row];
            
            [bundle putIntValue:[selectPost.postID intValue] forKey:@"POST_ID"];
            NSString * token = currentThreadPage.securityToken;
            
            [bundle putStringValue:token forKey:@"SECYRITY_TOKEN"];
            [bundle putStringValue:currentThreadPage.ajaxLastPost forKey:@"AJAX_LAST_POST"];
            
            [self.transValueDelegate transValue: bundle];
            
            [self.navigationController pushViewController:myThreadController animated:YES];
        } else if (buttonIndex == 1){
            UIStoryboard * storyboard = [UIStoryboard mainStoryboard];
            
            CCFSeniorNewPostViewController * myThreadController = [storyboard instantiateViewControllerWithIdentifier:@"CCFSeniorNewPostViewController"];
            self.transValueDelegate = (id<TransValueDelegate>)myThreadController;
            
            TransValueBundle * bundle = [[TransValueBundle alloc] init];
            
            [bundle putIntValue:[transThread.threadID intValue] forKey:@"THREAD_ID"];
            
            CCFPost * selectPost = self.posts[indexPath.row];
            
            [bundle putIntValue:[selectPost.postID intValue] forKey:@"POST_ID"];
            NSString * token = currentThreadPage.securityToken;
            
            [bundle putStringValue:token forKey:@"SECYRITY_TOKEN"];
            [bundle putStringValue:currentThreadPage.ajaxLastPost forKey:@"AJAX_LAST_POST"];
            
            [self.transValueDelegate transValue: bundle];
            
            [self.navigationController pushViewController:myThreadController animated:YES];
        }
    }];
    
    [itemActionSheet show];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(void)showUserProfile:(NSIndexPath *)indexPath{
    CCFProfileTableViewController * controller = selectSegue.destinationViewController;
    self.transValueDelegate = (id<TransValueDelegate>)controller;
    
    CCFPost * post = self.posts[indexPath.row];
    
    [self.transValueDelegate transValue:post];
}
#pragma mark Controller跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ShowUserProfile"]){
        selectSegue = segue;
    }
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showMoreAction:(UIBarButtonItem *)sender {
    itemActionSheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"复制帖子链接", @"在浏览器中查看",@"选择页码"] redButtonIndex:2 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1){
            
        } else if (buttonIndex == 2){
            
            NSMutableArray<NSString*> * pages = [NSMutableArray array];
            for (int i = 0 ; i < currentThreadPage.totalPageCount; i++) {
                NSString * page = [NSString stringWithFormat:@"第 %d 页", i + 1];
                [pages addObject:page];
            }
            
            ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择页面" rows:pages initialSelection:currentPage - 1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:sender];
            
            UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] init];
            cancelItem.title = @"取消";
            [picker setCancelButton:cancelItem];
            
            UIBarButtonItem * queding = [[UIBarButtonItem alloc] init];
            queding.title = @"确定";
            [picker setDoneButton:queding];
            
            
            [picker showActionSheetPicker];
        }
    }];
    
    [itemActionSheet show];
}
- (IBAction)floatReplyClick:(id)sender {
    
    [field resignFirstResponder];
    
    
    AlertProgressViewController * alertProgress = [AlertProgressViewController alertControllerWithTitle:@"" message:@"\n\n\n正在回复" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertProgress animated:YES completion:nil];
    
    [_api replyThreadWithId:transThread.threadID andMessage:field.text handler:^(BOOL isSuccess, id message) {
        [alertProgress dismissViewControllerAnimated:NO completion:nil];
        if (isSuccess) {
            
            field.text = @"";
            
            [self.posts removeAllObjects];
            
            CCFShowThreadPage * thread = message;
            
            [self.posts addObjectsFromArray:thread.dataList];
            
            totalPage = (int)thread.totalPageCount;
            currentPage = (int)thread.currentPage;
            
            [self.tableView reloadData];
            
            
        } else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"发送失败" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];

}
@end
