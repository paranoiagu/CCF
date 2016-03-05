//
//  ApiTestViewController.m
//  CCF
//
//  Created by WDY on 16/3/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "ApiTestViewController.h"
#import "CCFApi.h"

@interface ApiTestViewController ()

@end

@implementation ApiTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CCFApi * api = [[CCFApi alloc] init];
//     [api loginWithName:@"马小甲" andPassWord:@"CCF!@#456" handler:^(BOOL isSuccess, id message) {
//         
//     }];
    
//    [api sendPrivateMessageToUserName:@"马小甲" andTitle:@"2222222" andMessage:@"ppppp" handler:^(BOOL isSuccess, id message) {
//        if (isSuccess) {
//            NSLog(@"发送成功 %@", message);
//        } else{
//            NSLog(@"发送失败 %@", message);
//        }
//    }];

    
//    [api replyPrivateMessageWithId:@"2022896" andMessage:@"ttttttttt" handler:^(BOOL isSuccess, id handler) {
//        
//    }];
    
//    [api listMyAllThreads:^(BOOL isSuccess, id message) {
//        NSLog(@"我的Thread %@", message);
//    }];
    
    
//    [api listMyAllThreadPost:^(BOOL isSuccess, id message) {
//        NSLog(@"listMyAllThreadPost %@", message);
//    }];
    
    
    [api favoriteFormsWithId:@"19"];
    
}


@end
