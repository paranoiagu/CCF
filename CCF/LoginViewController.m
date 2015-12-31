//
//  LoginViewController.m
//  CCF
//
//  Created by WDY on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "LoginViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import <AFImageDownloader.h>
#import<CommonCrypto/CommonDigest.h>
#import<Foundation/Foundation.h>

#import "CCFBrowser.h"

@interface LoginViewController (){

    CCFBrowser *_browser;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _browser = [[CCFBrowser alloc]init];
    
}



- (IBAction)login:(id)sender {
    
    
    NSString *name = @"";
    NSString *password = @"";
    
    [_browser loginWithName:name AndPassword:password :^(NSString *result) {
        NSLog(@"%@", result);
    }];
}


- (IBAction)refreshDoor:(id)sender {
    
    [_browser refreshVCodeToUIImageView:_doorImageView];
    
}

@end
