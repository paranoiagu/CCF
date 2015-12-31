//
//  ViewController.m
//  CCF
//
//  Created by WDY on 15/12/28.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <IGHTMLQuery.h>
#import "CCFUser.h"
#import "CCFPost.h"
#import "CCFThread.h"

#import "LoginViewController.h"

#import "CCFParser.h"

#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"

#import "CCFFormDao.h"

#import "CCFFormTree.h"

#import "FormViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


     NSString *path = [[NSBundle mainBundle]pathForResource:@"ccf" ofType:@"json"];
    CCFFormTree * ccfFromTree = [[[CCFFormDao alloc]init] parseCCFForms:path];
    
    NSLog(@"%@", ccfFromTree);
    
    
    
//    CCFBrowser * browser = [[CCFBrowser alloc]init];
//    
//    NSString * userID = [browser getCurrentCCFUser];
//    
//    NSLog(@"%@", userID);
//    
//    [browser browseWithUrl:[CCFUrlBuilder buildThreadURL:@"1331214" withPage:@"1" ]:^(NSString* result) {
//        CCFParser *parser = [[CCFParser alloc]init];
//        NSMutableArray * posts = [parser parsePostFromThreadHtml:result];
//        
//        NSLog(@"%@", posts);
//    }];

}




- (IBAction)login:(UIButton *)sender {
    
    FormViewController * show = [[FormViewController alloc]init];
    [self presentViewController:show animated:YES completion:^{
        //
    }];
    
//    LoginViewController *login = [[LoginViewController alloc]init];
//    [self presentViewController:login animated:YES completion:^{
//        //
//    }];
}
@end
