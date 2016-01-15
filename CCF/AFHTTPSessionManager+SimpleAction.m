//
//  AFHTTPSessionManager+SimpleAction.m
//  CCF
//
//  Created by WDY on 16/1/15.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "AFHTTPSessionManager+SimpleAction.h"
#import "NSString+Kit.h"

@implementation AFHTTPSessionManager(SimpleAction)


-(void)GETWithURL:(NSURL *)url requestCallback:(RequestCallback)callback{
 
    [self GET:[url absoluteString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSString *html = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] replaceUnicode];
        callback(html);
    } failure:nil];
}

-(void)POSTWithURL:(NSURL *)url parameters:(id)parameters requestCallback:(RequestCallback)callback{
    [self POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] replaceUnicode];
        callback(html);
    } failure:nil];
}
@end
