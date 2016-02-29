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
#import "NSUserDefaults+CCF.h"
#import "CCFThreadDetail.h"
#import "CCFSearchResultPage.h"


#define kCCFCookie_User @"bbuserid"
#define kCCFCookie_LastVisit @"bblastvisit"
#define kCCFCookie_IDStack @"IDstack"
#define kCCFSecurityToken @"securitytoken"

#define kErrorMessageTooShort @"您输入的信息太短，您发布的信息至少为 5 个字符。"
#define kErrorMessageTimeTooShort @"此帖是您在最后 5 分钟发表的帖子的副本，您将返回该主题。"

#define kSearchErrorTooshort @"对不起，没有匹配记录。请尝试采用其他条件查询。"
#define kSearchErrorTooFast @"本论坛允许的进行两次搜索的时间间隔必须大于 30 秒。"

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


-(void)loginWithName:(NSString *)name andPassWord:(NSString *)passWord handler:(HandlerWithBool)handler{
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

-(void)logout{
    [[NSUserDefaults standardUserDefaults] clearCookie];
}

-(void)createNewThreadWithFormId:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImages:(NSData *)image handler:(HandlerWithBool)handler{
    [_browser createNewThreadWithFormId:fId withSubject:subject andMessage:message withImages:image handler:^(NSString* result) {
        NSString * error = kErrorMessageTimeTooShort;
        NSRange range = [result rangeOfString:error];
        if (range.location != NSNotFound) {
            handler(NO, error);
            return;
        }
        
        error = kErrorMessageTooShort;
        range = [result rangeOfString:error];
        if (range.location != NSNotFound) {
            handler(NO, error);
            return;
        }
        
        CCFThreadDetail * thread = [_praser parseShowThreadWithHtml:result];
        
        
        
        if(thread.threadPosts.count > 0){
            handler(YES, thread);
            
        } else{
            handler(NO, @"未知错误");
        }
    }];

}


-(void)replyThreadWithId:(NSString *)threadId andMessage:(NSString *)message handler:(HandlerWithBool)handler{
    [_browser replyThreadWithId:threadId withMessage:message handler:^(NSString* result) {
        NSString * error = kErrorMessageTimeTooShort;
        NSRange range = [result rangeOfString:error];
        if (range.location != NSNotFound) {
            handler(NO, error);
            return;
        }
        
        error = kErrorMessageTooShort;
        range = [result rangeOfString:error];
        if (range.location != NSNotFound) {
            handler(NO, error);
            return;
        }

        CCFThreadDetail * thread = [_praser parseShowThreadWithHtml:result];
        
        
        
        if(thread.threadPosts.count > 0){
            handler(YES, thread);
            
        } else{
            handler(NO, @"未知错误");
        }
    }];
}


-(void)searchWithKeyWord:(NSString *)keyWord handler:(HandlerWithBool)handler{
    [_browser searchWithKeyWord:keyWord searchDone:^(NSString* result) {
        
        NSRange range = [result rangeOfString:kSearchErrorTooshort];
        if (range.location != NSNotFound) {
            handler(NO,kSearchErrorTooshort);
            return;
        }
        
        range = [result rangeOfString:kSearchErrorTooFast];
        if (range.location != NSNotFound) {
            handler(NO, kSearchErrorTooFast);
            return;
        }

        CCFSearchResultPage * page = [_praser parseSearchPageFromHtml:result];
        
        if (page != nil && page.searchResults != nil && page.searchResults.count > 0) {
            handler(YES, page);
        } else{
            handler(NO, @"未知错误");
        }
    }];
}

-(void)privateMessageWithType:(int)type andPage:(int)page handler:(Handler)handler{
    [_browser privateMessageWithType:type andpage:page handler:^(id result) {
        PrivateMessagePage * page = [_praser parseInboxMessageFormHtml:result];
        handler(page);
    }];
}

-(void)showPrivateContentById:(NSString *)pmId handler:(Handler)handler{
    [_browser showPrivateContentById:pmId handler:^(NSString* result) {
        NSString * content = [_praser parsePrivateMessageContent:result];
        handler(content);
    }];
}


@end
