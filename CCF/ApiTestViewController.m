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
    [api sendPrivateMessageToUserName:@"马小甲" andTitle:@"2222222" andMessage:@"ppppp" handler:^(BOOL isSuccess, id message) {
        
    }];
    
}


@end
