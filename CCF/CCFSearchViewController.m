//
//  CCFSearchViewController.m
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSearchViewController.h"
#import "CCFBrowser.h"

@interface CCFSearchViewController ()

@end

@implementation CCFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CCFBrowser * browser = [[CCFBrowser alloc]init];
    
    [browser searchWithKeyWord:@"CCF客户端" searchDone:^(id result) {
        
    }];
}


- (IBAction)back:(id)sender {
}
@end
