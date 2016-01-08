//
//  CCFBrowser.m
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFBrowser.h"
#import "NSString+Kit.h"
#import "CCFUrlBuilder.h"
#import <AFImageDownloader.h>
#import <UIImageView+AFNetworking.h>
#import "CCFUtils.h"
#import "CCFParser.h"


#define kCCFCookie @"CCF-Cookies"
#define kCCFCookie_User @"bbuserid"
#define kCCFSecurityToken @"securitytoken"

@implementation CCFBrowser


-(id)init{
    
    if (self = [super init]) {
        _browser = [AFHTTPSessionManager manager];
        _browser.responseSerializer = [AFHTTPResponseSerializer serializer];
        _browser.responseSerializer.acceptableContentTypes = [_browser.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [self loadCookie];
    }
    
    return self;
}



-(void)browseWithUrl:(NSURL *)url :(success)callBack{
    [_browser GET:[url absoluteString] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *html = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] replaceUnicode];
        
        // 保存token
        CCFParser * parser = [[CCFParser alloc]init];
        NSString * token = [parser parseSecurityToken:html];
        if (token != nil) {
            [self saveSecurityToken:token];
        }
        
        
        callBack(html);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];

}


-(void)loginWithName:(NSString *)name AndPassword:(NSString *)pwd :(success)callBack{
    
    NSURL * loginUrl = [CCFUrlBuilder buildLoginURL];
    NSString * md5pwd = [pwd md5HexDigest];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:name forKey:@"vb_login_username"];
    [parameters setValue:@"" forKey:@"vb_login_password"];
    [parameters setValue:@"1" forKey:@"cookieuser"];
    [parameters setValue:@"" forKey:@"vcode"];
    [parameters setValue:@"" forKey:@"s"];
    [parameters setValue:@"guest" forKey:@"securitytoken"];
    [parameters setValue:@"login" forKey:@"do"];
    [parameters setValue:md5pwd forKey:@"vb_login_md5password"];
    [parameters setValue:md5pwd forKey:@"vb_login_md5password_utf"];
    
    [_browser POST:[loginUrl absoluteString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSString *html = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] replaceUnicode];
        callBack(html);
        // 保存Cookie
        [self saveCookie];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];

}

-(void)refreshVCodeToUIImageView:(UIImageView* ) vCodeImageView{
    
    NSURL *vCodeUrl = [CCFUrlBuilder buildVCodeURL];
    NSString * url = [vCodeUrl absoluteString];
    
    AFImageDownloader *downloader = [[vCodeImageView class] sharedImageDownloader];
    id <AFImageRequestCache> imageCache = downloader.imageCache;
    [imageCache removeImageWithIdentifier:url];
    
    
    
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    UIImageView * view = vCodeImageView;
    
    [vCodeImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

        [view setImage:image];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {

        NSLog(@"refreshDoor failed");
    }];

}
-(void)logout{
    
}

-(NSString *)getCurrentCCFUser{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for (int i = 0; i < cookies.count; i ++) {
        NSHTTPCookie * cookie = cookies[i];
        if ([cookie.name isEqualToString:kCCFCookie_User]) {
            return cookie.value;
        }
    }
    return nil;
}

-(void) saveCookie{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCCFCookie];
}

-(void) loadCookie{
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kCCFCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}


-(void) saveSecurityToken:(NSString *) token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:kCCFSecurityToken];
}

- (NSString *) readSecurityToken{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCCFSecurityToken];
}



//message	:blush;
//
//[RIGHT][URL="https://bbs.et8.net/bbs/showthread.php?p=16695603"]For Test[/URL][/RIGHT]
//wysiwyg	0
//iconid	0
//s
//securitytoken	1452154683-4031b805ac9b34c26256eb6fb4878d39e2fb227d
//do	postreply
//t	1332499
//p
//specifiedpost	0
//posthash	1bbdf96a3924c5e374f5d1a419709082
//poststarttime	1452154683
//loggedinuser	71250
//multiquoteempty
//sbutton	提交回复
//parseurl	1
//emailupdate	9999











//securitytoken	1452155065-ad50b435ca02e154a4280ef99dcf12bbe274b5ce
//ajax	1
//ajax_lastpost	1452155059
//message	message	:blush;
//
//[RIGHT][URL="https://bbs.et8.net/bbs/showthread.php?p=16695603"]For Test:Quick Reply[/URL][/RIGHT]
//

-(void)reply:(NSString *)threadId :(NSString *)message{
    NSString * testMesage = @"\n:blush;\n\n\n\n\n\n\n\n\n\n[RIGHT][URL=\"https://bbs.et8.net/bbs/showthread.php?p=16695603\"]Test For CCF iPhone Client[/URL][/RIGHT]";
    NSString *test = [message stringByAppendingString:testMesage];
    
    NSURL * loginUrl = [CCFUrlBuilder buildReplyURL:threadId];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];

    NSString * securitytoken = [self readSecurityToken];
    
    [parameters setValue:securitytoken forKey:@"securitytoken"];
    [parameters setValue:test forKey:@"message"];
    
    [parameters setValue:@"postreply" forKey:@"do"];
    [parameters setValue:threadId forKey:@"t"];
    [parameters setValue:@"who cares" forKey:@"p"];
    
    [parameters setValue:@"0" forKey:@"specifiedpost"];

    [parameters setValue:@"1" forKey:@"parseurl"];
    
    [parameters setValue:[self getCurrentCCFUser] forKey:@"loggedinuser"];
    [parameters setValue:@"1" forKey:@"fromquickreply"];
    
    [parameters setValue:@"0" forKey:@"styleid"];
    [parameters setValue:@"0" forKey:@"wysiwyg"];
    
    
    [parameters setValue:@"" forKey:@"s"];
    
    [_browser POST:[loginUrl absoluteString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSString *html = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] replaceUnicode];
        
        
        
        
        //callBack(html);
        // 保存Cookie
        [self saveCookie];
        
        NSLog(@"reply done --------------------->>>>>> \n%@", html);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}



-(NSString *)getSessionhash{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for (int i = 0; i < cookies.count; i ++) {
        NSHTTPCookie * cookie = cookies[i];
        if ([cookie.name isEqualToString:@"bbsessionhash"]) {
            return cookie.value;
        }
    }
    return nil;
}
































@end
