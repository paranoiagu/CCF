//
//  CCFSimpleReplyNavigationController.m
//  CCF
//
//  Created by 迪远 王 on 16/4/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSimpleReplyNavigationController.h"
#import "SimpleReplyTransValueDelegate.h"

@interface CCFSimpleReplyNavigationController ()<SimpleReplyTransValueDelegate>

@end

@implementation CCFSimpleReplyNavigationController


-(void)transValue:(CCFShowThreadViewController *)controller withThread:(CCFThread *)thread{
    self.controller = controller;
    self.transThread = thread;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
