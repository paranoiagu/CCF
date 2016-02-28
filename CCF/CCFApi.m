//
//  CCFApi.m
//  CCF
//
//  Created by 迪远 王 on 16/2/28.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFApi.h"
#import "CCFBrowser.h"
#import "CCFParser.h"

#define kCCFCookie_User @"bbuserid"
#define kCCFCookie_LastVisit @"bblastvisit"
#define kCCFCookie_IDStack @"IDstack"
#define kCCFSecurityToken @"securitytoken"

@implementation CCFApi{
    CCFBrowser *_browser;
    CCFParser *_praser;
    
}

-(instancetype)init{
    if (self = [super init]) {
        _browser = [[CCFBrowser alloc] init];
        _praser = [[CCFParser alloc] init];
    }
    return self;
}


-(void)loginWithName:(NSString *)name andPassWord:(NSString *)passWord handler:(LoginHandler)handler{
    [_browser loginWithName:name andPassWord:passWord :^(NSString* result) {
        LoginCCFUser *user = [self getLoginUser];
        if (user.userID == nil) {
            NSString* faildMessage = [_praser parseLoginErrorMessage:result];
            handler(NO, faildMessage);
        } else{
            handler(YES, @"登录成功");
        }
    }];
}


-(LoginCCFUser *)getLoginUser{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    LoginCCFUser * user = [[LoginCCFUser alloc] init];
    
    for (int i = 0; i < cookies.count; i ++) {
        NSHTTPCookie * cookie = cookies[i];
        
        if ([cookie.name isEqualToString:kCCFCookie_LastVisit]) {
            user.lastVisit = cookie.value;
        } else if([cookie.name isEqualToString:kCCFCookie_User]){
            user.userID = cookie.value;
        } else if ([cookie.name isEqualToString:kCCFCookie_IDStack]){
            user.expireTime = cookie.expiresDate;
        }
    }
    return user;
}
@end
