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

#define kCCFCookie @"CCF-Cookies"
#define kCCFCookie_User @"bbuserid"

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

@end
