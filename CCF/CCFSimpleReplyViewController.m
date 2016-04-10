//
//  CCFSimpleReplyViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/4/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSimpleReplyViewController.h"
#import "CCFSimpleReplyNavigationController.h"
#import "SVProgressHUD.h"
#import "CCFShowThreadPage.h"
#import "UIStoryboard+CCF.h"
#import "CCFShowThreadViewController.h"

@interface CCFSimpleReplyViewController (){
    CCFThread * transThread;
}

@end

@implementation CCFSimpleReplyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CCFSimpleReplyNavigationController * navigationController = (CCFSimpleReplyNavigationController *)self.navigationController;
    
    transThread = navigationController.transThread;
    
    self.replyContent.text = transThread.threadTitle;
    
    [self.replyContent becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (IBAction)sendSimpleReply:(id)sender {
    
    [self.replyContent resignFirstResponder];

    [SVProgressHUD showWithStatus:@"正在回复" maskType:SVProgressHUDMaskTypeBlack];
    
    [self.ccfApi replyThreadWithId:transThread.threadID andMessage:self.replyContent.text handler:^(BOOL isSuccess, id message) {
        
        [SVProgressHUD dismiss];
        
        if (isSuccess) {
            
            self.replyContent.text = @"";
            
            CCFShowThreadPage * thread = message;
            
            
            CCFSimpleReplyNavigationController * navigationController = (CCFSimpleReplyNavigationController *)self.navigationController;
            
            
            self.delegate = (id<SimpleReplyDelegate>)navigationController.controller;

            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate transReplyValue:thread];
            }];
            
            
        } else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"发送失败" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
}


- (IBAction)back:(id)sender {
    [self.replyContent resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
