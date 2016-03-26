//
//  CCFShowPrivateMessageViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/3/25.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFShowPrivateMessageViewController.h"

#import "CCFThreadDetailCell.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"

#import "MJRefresh.h"
#import "CCFUITextView.h"

#import "CCFShowThreadPage.h"

#import "AlertProgressViewController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CCFShowPM.h"
#import "CCFShowPMTableViewCell.h"


#import "CCFApi.h"

@interface CCFShowPrivateMessageViewController ()< UITextViewDelegate, CCFUITextViewDelegate, CCFThreadDetailCellDelegate, TransValueDelegate>{
    NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeightDictionary;

    int messageId;
    
    CCFApi * ccfapi;
    CCFUITextView * field;
    CCFApi *_api;
}

@end

@implementation CCFShowPrivateMessageViewController


-(void)transValue:(int)value{
    messageId = value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    
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
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [ccfapi showPrivateContentById:messageId handler:^(BOOL isSuccess, CCFShowPM* message) {
            [self.tableView.mj_header endRefreshing];
            
            if (isSuccess) {
                [self.dataList removeAllObjects];
                [self.dataList addObject:message];
                [self.tableView reloadData];
            }
        }];
    }];

    
    [self.tableView.mj_header beginRefreshing];
    
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
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFShowPMTableViewCell";
    
    CCFShowPMTableViewCell *cell = (CCFShowPMTableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    cell.delegate = self;
    
    CCFShowPM *privateMessage = self.dataList[indexPath.row];
    
    [cell setData:privateMessage forIndexPath:indexPath];
    
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


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)floatReplyClick:(id)sender {
    
    [field resignFirstResponder];
    
    
    AlertProgressViewController * alertProgress = [AlertProgressViewController alertControllerWithTitle:@"" message:@"\n\n\n正在回复" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertProgress animated:YES completion:nil];
    
    [_api replyPrivateMessageWithId:@""  andMessage:@"" handler:^(BOOL isSuccess, id message) {
        [alertProgress dismissViewControllerAnimated:NO completion:nil];
        
        if (isSuccess) {
            
            field.text = @"";
            
            [self.dataList removeAllObjects];
            
            CCFShowThreadPage * thread = message;
            
            [self.dataList addObjectsFromArray:thread.dataList];
            
            [self.tableView reloadData];
            
            
        } else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"发送失败" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
    
}


@end
