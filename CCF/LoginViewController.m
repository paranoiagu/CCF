//
//  LoginViewController.m
//  CCF
//
//  Created by WDY on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "LoginViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import <AFImageDownloader.h>
#import<CommonCrypto/CommonDigest.h>
#import<Foundation/Foundation.h>



@interface LoginViewController (){

    BOOL  isLogin;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    isLogin = NO;
    
    
    NSURL *URL = [NSURL URLWithString:@"https://bbs.et8.net/bbs/login.php?do=vcode"];

    [_doorImageView setImageWithURL:URL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)login:(id)sender {
    
    
    NSString *name = @"马小甲";
    NSString *password = @"CCF!@#456";
    
    NSString * ND5_PWD = [self md5HexDigest: password];
    
    NSLog(@"%@", ND5_PWD);
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    

    [parameters setValue:name forKey:@"vb_login_username"];
    
    [parameters setValue:@"" forKey:@"vb_login_password"];
    [parameters setValue:@"1" forKey:@"cookieuser"];
    [parameters setValue:@"" forKey:@"vcode"];
    [parameters setValue:@"" forKey:@"s"];
    [parameters setValue:@"guest" forKey:@"securitytoken"];
    [parameters setValue:@"login" forKey:@"do"];
    
    [parameters setValue:ND5_PWD forKey:@"vb_login_md5password"];
    [parameters setValue:ND5_PWD forKey:@"vb_login_md5password_utf"];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:@"https://bbs.et8.net/bbs/login.php?do=login" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        html = [self replaceUnicode:html];
        
        NSLog(@"%@", html);
        
        
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
        NSLog(@"===================================");
        
        NSLog(@"%@", cookies);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CCF-Cookies"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
    
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr{
    
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


- (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (IBAction)refreshDoor:(id)sender {
    
    NSLog(@"refreshDoor ===========");
    AFImageDownloader *downloader = [[_doorImageView class] sharedImageDownloader];
    id <AFImageRequestCache> imageCache = downloader.imageCache;
    [imageCache removeImageWithIdentifier:@"https://bbs.et8.net/bbs/login.php?do=vcode"];
    
    
    
    NSURL *URL = [NSURL URLWithString:@"https://bbs.et8.net/bbs/login.php?do=vcode"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [_doorImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        //
        _doorImageView.image = image;
        [_doorImageView setImage:image];
        
        NSLog(@"refreshDoor success");
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //
        NSLog(@"refreshDoor failed");
    }];
    
}
- (IBAction)tttttt:(id)sender {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    [manager GET:@"https://bbs.et8.net/bbs/member.php?u=71250" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        html = [self replaceUnicode:html];
        NSLog(@"%@", html);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];

}
@end
