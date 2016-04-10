//
//  CCFSimpleReplyViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/4/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSimpleReplyViewController.h"
#import "TransValueDelegate.h"

@interface CCFSimpleReplyViewController ()<TransValueDelegate>{
    CCFThread * transThread;
}

@end

@implementation CCFSimpleReplyViewController

-(void)transValue:(id)value{
    transThread = value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.replyContent.text = transThread.threadTitle;
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

- (IBAction)sendSimpleReply:(id)sender {
}

- (IBAction)back:(id)sender {
}
@end
