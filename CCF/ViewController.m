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
        string = [self replaceUnicode:string];
        
        //NSLog(@"\n------>>>>\n%@", string);
        NSData* html = [string dataUsingEncoding:NSUTF8StringEncoding];

        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:html];

        
        
        // 回帖
        //div[@id='posts']/div[*]/div
        
        // 回帖人
        //*[@id="post*"]/tbody/tr[1]/td[1]
        
        
        NSArray * elements  = [doc searchWithXPathQuery:@"//div[@id='posts']/div[*]/div/div"];
        

        for (int i = 0 ; i < 1; i ++) {
            //TFHppleElement *element = [elements[i]children][1];
            
            NSLog(@"\n------>>>>\n%@", [[elements[i]children][1] raw]);
            
            //NSLog(@"\n------>>>>\n%@", [[element firstChildWithClassName:@"tborder"] raw]);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
