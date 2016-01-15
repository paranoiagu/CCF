//
//  AFHTTPSessionManager+SimpleAction.h
//  CCF
//
//  Created by WDY on 16/1/15.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^RequestCallback) (NSString* html);

@interface AFHTTPSessionManager(SimpleAction)

-(void)GETWithURL:(NSURL*)url requestCallback:(RequestCallback) callback;

-(void)POSTWithURL:(NSURL*)url parameters:(id)parameters requestCallback:(RequestCallback) callback;

@end
