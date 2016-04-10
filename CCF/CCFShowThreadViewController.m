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
#import <SVProgressHUD.h>
#import "ActionSheetPicker.h"
#import "NSString+Regular.h"
#import "CCFThreadListTitleCell.h"


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
    
    NSMutableDictionary * postSet;
}

@end

@implementation CCFShowThreadViewController

#pragma mark trans value
-(void)transValue:(CCFThread *)value{
    transThread = value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    postSet = [NSMutableDictionary dictionary];

    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    field = [[CCFUITextView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    field.heightDelegate = self;
    field.delegate = self;
    field.scrollsToTop = NO;
    
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

                currentThreadPage = thread;

                [postSet setObject:parsedPosts forKey:[NSNumber numberWithInt:currentPage]];
                
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


                currentThreadPage = thread;
                
                [postSet setObject:parsedPosts forKey:[NSNumber numberWithInt:currentPage]];
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

    return 1 + postSet.count;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 100;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else{
        return [[postSet objectForKey:[NSNumber numberWithInteger:section]] count];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CCFThreadListTitleCell *cell = (CCFThreadListTitleCell*)[tableView dequeueReusableCellWithIdentifier:@"CCFThreadTitleId"];
        cell.threadTitle.text = transThread.threadTitle;
        return cell;
        
    } else{
        static NSString *QuoteCellIdentifier = @"CCFThreadDetailCellIdentifier";
        
        CCFThreadDetailCell *cell = (CCFThreadDetailCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
        cell.delegate = self;
        cell.detailDelegate = self;
        NSArray * posts = [postSet objectForKey:[NSNumber numberWithInteger:indexPath.section]];
        
        
        CCFPost *post = posts[indexPath.row];
        [cell setPost:post forIndexPath:indexPath];
        
        return cell;
    }

}

-(void)relayoutContentHeigt:(NSIndexPath *)indexPath with:(CGFloat)height{
    NSNumber * nsheight = [cellHeightDictionary objectForKey:indexPath];
    if (nsheight == nil) {
        [cellHeightDictionary setObject:[NSNumber numberWithFloat:height] forKey:indexPath];
        NSIndexPath *indexPathReload=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathReload,nil] withRowAnimation:UITableViewRowAnimationNone];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"CCFThreadTitleId" configuration:^(CCFThreadListTitleCell *cell) {
            
                    cell.threadTitle.text = transThread.threadTitle;
                }];
    } else{
        NSNumber * nsheight = [cellHeightDictionary objectForKey:indexPath];
        if (nsheight == nil) {
            return  115.0;
        }
        return nsheight.floatValue;
    }

}

#pragma mark LCActionSheetDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
     NSArray * posts = [postSet objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    
    CCFPost * selectPost = posts[indexPath.row];

    itemActionSheet = [LCActionSheet sheetWithTitle:selectPost.postUserInfo.userName buttonTitles:@[@"快速回复", @"@作者", @"复制链接"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            UIStoryboard * storyboard = [UIStoryboard mainStoryboard];
            
            CCFSeniorNewPostViewController * myThreadController = [storyboard instantiateViewControllerWithIdentifier:@"CCFSeniorNewPostViewController"];
            self.transValueDelegate = (id<TransValueDelegate>)myThreadController;
            
            TransValueBundle * bundle = [[TransValueBundle alloc] init];
            
            [bundle putIntValue:[transThread.threadID intValue] forKey:@"THREAD_ID"];
            
            CCFPost * selectPost = posts[indexPath.row];
            
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
            
            CCFPost * selectPost = posts[indexPath.row];
            
            [bundle putIntValue:[selectPost.postID intValue] forKey:@"POST_ID"];
            NSString * token = currentThreadPage.securityToken;
            
            [bundle putStringValue:token forKey:@"SECYRITY_TOKEN"];
            [bundle putStringValue:currentThreadPage.ajaxLastPost forKey:@"AJAX_LAST_POST"];
            [bundle putStringValue:selectPost.postUserInfo.userName forKey:@"USER_NAME"];
            
            [self.transValueDelegate transValue: bundle];
            
            [self.navigationController pushViewController:myThreadController animated:YES];
        } else if (buttonIndex == 2){
            NSString * louceng = [selectPost.postLouCeng stringWithRegular:@"\\d+"];
            
            NSString * postUrl = [NSString stringWithFormat: @"https://bbs.et8.net/bbs/showpost.php?p=%@&postcount=%@", transThread.threadID, louceng];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = postUrl;
            
            [SVProgressHUD showSuccessWithStatus:@"复制成功" maskType:SVProgressHUDMaskTypeBlack];
            
        }
    }];
    
    [itemActionSheet show];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(void)showUserProfile:(NSIndexPath *)indexPath{
    CCFProfileTableViewController * controller = selectSegue.destinationViewController;
    self.transValueDelegate = (id<TransValueDelegate>)controller;
    NSArray * posts = [postSet objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    CCFPost * post = posts[indexPath.row];
    
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
    

    itemActionSheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"复制帖子链接", @"在浏览器中查看",@"选择页码", @"刷新本页"] redButtonIndex:2 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [[CCFUrlBuilder buildThreadURL:[transThread.threadID intValue] withPage:0] absoluteString];
            
            [SVProgressHUD showSuccessWithStatus:@"复制成功" maskType:SVProgressHUDMaskTypeBlack];
            
            
        } else if (buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[CCFUrlBuilder buildThreadURL:[transThread.threadID intValue] withPage:1]];
        } else if (buttonIndex == 2){

            NSMutableArray<NSString*> * pages = [NSMutableArray array];
            for (int i = 0 ; i < currentThreadPage.totalPageCount; i++) {
                NSString * page = [NSString stringWithFormat:@"第 %d 页", i + 1];
                [pages addObject:page];
            }
            
            
            
            ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择页面" rows:pages initialSelection:currentPage - 1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                

                if (selectedIndex +1 != currentPage) {
                    

                    
                    [SVProgressHUD showWithStatus:@"正在切换" maskType:SVProgressHUDMaskTypeBlack];
                    
                    
                    [ccfapi showThreadWithId:[transThread.threadID intValue] andPage:(int)selectedIndex + 1 handler:^(BOOL isSuccess, CCFShowThreadPage * thread) {
                        
                        [SVProgressHUD dismiss];
                        
                        if (isSuccess) {
                            currentPage = (int)selectedIndex + 1;
                            
                            [cellHeightDictionary removeAllObjects];
                            
                            totalPage = (int)thread.totalPageCount;
                            
                            if (currentPage >= totalPage) {
                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                            }
                            
                            
                            NSMutableArray<CCFPost *> * parsedPosts = thread.dataList;
                            
                            
                            currentThreadPage = thread;
                            
                            [postSet setObject:parsedPosts forKey:[NSNumber numberWithInt:currentPage]];
                            
                            [self.tableView reloadData];
                        }
                        
                    }];
                }
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {

                
            } origin:sender];
            
            UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] init];
            cancelItem.title = @"取消";
            [picker setCancelButton:cancelItem];
            
            UIBarButtonItem * queding = [[UIBarButtonItem alloc] init];
            queding.title = @"确定";
            [picker setDoneButton:queding];
            
            
            [picker showActionSheetPicker];
        } else if(buttonIndex == 3){
            // 刷新本页
            [SVProgressHUD showWithStatus:@"正在刷新" maskType:SVProgressHUDMaskTypeBlack];
            
            
            [ccfapi showThreadWithId:[transThread.threadID intValue] andPage:currentPage handler:^(BOOL isSuccess, CCFShowThreadPage * thread) {
                
                [SVProgressHUD dismiss];
                
                if (isSuccess) {
                    
                    
                    [cellHeightDictionary removeAllObjects];
                    
                    totalPage = (int)thread.totalPageCount;
                    
                    if (currentPage >= totalPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    
                    NSMutableArray<CCFPost *> * parsedPosts = thread.dataList;
                    
                    
                    currentThreadPage = thread;
                    
                    [postSet setObject:parsedPosts forKey:[NSNumber numberWithInt:currentPage]];

                    [self.tableView reloadData];
                }
                
            }];
            
        }
    }];
    
    [itemActionSheet show];
}
- (IBAction)floatReplyClick:(id)sender {
    
    [field resignFirstResponder];
    
    [SVProgressHUD showSuccessWithStatus:@"正在回复" maskType:SVProgressHUDMaskTypeBlack];
    
    [_api replyThreadWithId:transThread.threadID andMessage:field.text handler:^(BOOL isSuccess, id message) {
        
        [SVProgressHUD dismiss];
        
        if (isSuccess) {
            
            field.text = @"";
            
            CCFShowThreadPage * thread = message;
            
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
