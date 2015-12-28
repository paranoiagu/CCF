//
//  ViewController.m
//  CCF
//
//  Created by WDY on 15/12/28.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <TFHpple.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    

    [manager GET:@"https://bbs.et8.net/bbs/showthread.php?t=1331214" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"\n------>>>>\n%@", string);
        NSData* html = [string dataUsingEncoding:NSUTF8StringEncoding];

        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:html];

        //*[@id="posts"]/div[*]/div
        //*[@id="posts"]/div[2]/div
        NSArray * elements  = [doc searchWithXPathQuery:@"//*[@id='posts']/div[*]/div"];
        
        //TFHppleElement * element = [elements objectAtIndex:0];
        
        NSLog(@"\n------>>>>\n%@", elements);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
