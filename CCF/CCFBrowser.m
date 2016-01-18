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

#import "CCFPost.h"
#import "CCFThreadDetail.h"
#import "NSUserDefaults+CCF.h"
#import "AFHTTPSessionManager+SimpleAction.h"


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
    
    [_browser GETWithURL:url requestCallback:^(NSString *html) {
        CCFParser * parser = [[CCFParser alloc]init];
        NSString * token = [parser parseSecurityToken:html];
        if (token != nil) {
            [self saveSecurityToken:token];
        }
        callBack(html);
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
    
    [_browser POSTWithURL:loginUrl parameters:parameters requestCallback:^(NSString *html) {
        callBack(html);
        // 保存Cookie
        [self saveCookie];
        
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
        [[NSUserDefaults standardUserDefaults] saveCookie];
}

-(NSString *) loadCookie{
    return [[NSUserDefaults standardUserDefaults] loadCookie];
}


-(void) saveSecurityToken:(NSString *) token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:kCCFSecurityToken];
}

- (NSString *) readSecurityToken{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCCFSecurityToken];
}


-(void)reply:(NSString *)threadId :(NSString *)message :(Reply)result{
    //NSString * testMesage = @"\n:blush;\n\n\n\n\n\n\n\n\n\n[RIGHT][URL=\"https://bbs.et8.net/bbs/showthread.php?p=16695603\"]Test For CCF iPhone Client[/URL][/RIGHT]";
    
    NSString * testMesage = @"\n[RIGHT][URL=\"https://bbs.et8.net/bbs/showthread.php?t=1332499\"][COLOR=\"Silver\"][I]SENDBY『CCF客户端』[/I][/COLOR][/URL][/RIGHT]";
    
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
    
    [_browser POSTWithURL:loginUrl parameters:parameters requestCallback:^(NSString *html) {
        // 保存Cookie
        [self saveCookie];
        
        NSString * error = @"此帖是您在最后 5 分钟发表的帖子的副本，您将返回该主题。";
        NSRange range = [html rangeOfString:error];
        if (range.location != NSNotFound) {
            result(NO, error);
            return;
        }
        
        error = @"您输入的信息太短，您发布的信息至少为 5 个字符。";
        range = [html rangeOfString:error];
        if (range.location != NSNotFound) {
            result(NO, error);
            return;
        }
        
        
        CCFParser * parser = [[CCFParser alloc]init];
        CCFThreadDetail * thread = [parser parseShowThreadWithHtml:html];
        
        
        
        if(thread.threadPosts.count > 0){
            result(YES, thread);
            
        } else{
            result(NO, @"未知错误");
        }
        
        NSLog(@"reply done --------------------->>>>>> \n%@", html);
        
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

-(void)searchWithKeyWord:(NSString *)keyWord searchDone:(success)callback{

    NSURL * searchUrl = [CCFUrlBuilder buildSearchUrl];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    
    [parameters setValue:@"" forKey:@"s"];
    [parameters setValue:@"process" forKey:@"do"];
    [parameters setValue:@"" forKey:@"searchthreadid"];
    [parameters setValue:keyWord forKey:@"query"];
    [parameters setValue:@"1" forKey:@"titleonly"];
    [parameters setValue:@"" forKey:@"searchuser"];
    [parameters setValue:@"0" forKey:@"starteronly"];
    [parameters setValue:@"1" forKey:@"exactname"];
    [parameters setValue:@"0" forKey:@"replyless"];
    [parameters setValue:@"0" forKey:@"replylimit"];
    [parameters setValue:@"0" forKey:@"searchdate"];
    [parameters setValue:@"after" forKey:@"beforeafter"];
    [parameters setValue:@"lastpost" forKey:@"sortby"];
    [parameters setValue:@"descending" forKey:@"order"];
    [parameters setValue:@"0" forKey:@"showposts"];
    [parameters setValue:@"" forKey:@"tag"];
    [parameters setValue:@"0" forKey:@"forumchoice[]"];
    [parameters setValue:@"1" forKey:@"childforums"];
    [parameters setValue:@"1" forKey:@"saveprefs"];
    
    [_browser GETWithURL:searchUrl requestCallback:^(NSString *html) {
        CCFParser * parser = [[CCFParser alloc]init];
        NSString * token = [parser parseSecurityToken:html];
        if (token != nil) {
            [self saveSecurityToken:token];
        }
        
        NSString * securitytoken = [self readSecurityToken];
        [parameters setValue:securitytoken forKey:@"securitytoken"];

        [_browser POSTWithURL:searchUrl parameters:parameters requestCallback:^(NSString *html) {
            
            [self saveCookie];
            NSLog(@"-----search: %@", html);
            CCFParser * parser = [[CCFParser alloc]init];
            
            CCFSearchResultPage * page = [parser parseSearchPageFromHtml:html];
            
            callback(page);

        }];
    }];
    
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}


-(void)createNewThreadForForm:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImage:(NSData *) image{
    
    message = [message stringByAppendingString:@"\n[RIGHT][URL=\"https://bbs.et8.net/bbs/showthread.php?t=1332499\"]Test For: CCF Client[/URL][/RIGHT]"];
    
    // 准备发帖
   [self createNewThreadPrepair:fId :^(NSString *token, NSString *hash, NSString *time) {
       // 如果有图片，先传图片
      [self uploadImagePrepair:fId startPostTime:time postHash:hash :^(NSString* result) {
          
          //[self doPostThread:fId withSubject:subject andMessage:message withToken:token withHash:hash postTime:time];
          
          
          
          CCFParser * parser = [[CCFParser alloc]init];
          
          NSString * uploadToken = [parser parseSecurityToken:result];
          NSString * uploadTime = [[token componentsSeparatedByString:@"-"] firstObject];
          NSString * uploadHash = [parser parsePostHash:result];
          
//          [self uploadFile:uploadToken fId:fId postTime:uploadTime hash:uploadHash image:image];

          [self uploadImage:[CCFUrlBuilder buildUploadFileURL] :uploadToken fId:fId postTime:uploadTime hash:uploadHash :image callback:^(id result) {
              [self doPostThread:fId withSubject:subject andMessage:message withToken:token withHash:hash postTime:time];
          }];
          
      }];
   }];
}


// 正式开始发送
-(void) doPostThread:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withToken:(NSString*) token withHash:(NSString*) hash postTime:(NSString*)time{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:subject forKey:@"subject"];
    [parameters setValue:message forKey:@"message"];
    [parameters setValue:@"0" forKey:@"wysiwyg"];
    [parameters setValue:@"0" forKey:@"iconid"];
    [parameters setValue:@"" forKey:@"s"];
    [parameters setValue:token forKey:@"securitytoken"];
    [parameters setValue:fId forKey:@"f"];
    [parameters setValue:@"postthread" forKey:@"do"];
    [parameters setValue:hash forKey:@"posthash"];
    
    
    [parameters setValue:time forKey:@"poststarttime"];
    [parameters setValue:[self getCurrentCCFUser] forKey:@"loggedinuser"];
    [parameters setValue:@"发表主题" forKey:@"sbutton"];
    [parameters setValue:@"1" forKey:@"parseurl"];
    [parameters setValue:@"9999" forKey:@"emailupdate"];
    [parameters setValue:@"4" forKey:@"polloptions"];
    
    NSURL * newPostUrl = [CCFUrlBuilder buildNewThreadURL:fId];
    
    [_browser POSTWithURL:newPostUrl parameters:parameters requestCallback:^(NSString *html) {
        
        [self saveCookie];
        //CCFParser * parser = [[CCFParser alloc]init];
        
    }];
}


// 进入图片管理页面，准备上传图片
-(void)uploadImagePrepair:(NSString*)formId startPostTime:(NSString*)time postHash:(NSString*)hash :(success) callback{
    NSURL * url = [CCFUrlBuilder buildManageFileURL:formId postTime:time postHash:hash];
    
    [_browser GETWithURL:url requestCallback:^(NSString *html) {
      callback(html);
    }];
}

// 开始上传图片
- (void)uploadFile:(NSString *)token fId:(NSString *)fId postTime:(NSString *)postTime hash:(NSString *)hash image:(NSData *)image {
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"" forKey:@"s"];
    [parameters setValue:token forKey:@"securitytoken"];
    [parameters setValue:@"manageattach" forKey:@"do"];
    [parameters setValue:@"" forKey:@"t"];
    [parameters setValue:fId forKey:@"f"];
    [parameters setValue:@"" forKey:@"p"];
    [parameters setValue:postTime forKey:@"poststarttime"];
    [parameters setValue:@"0" forKey:@"editpost"];
    [parameters setValue:hash forKey:@"posthash"];
    [parameters setValue:@"16777216" forKey:@"MAX_FILE_SIZE"];
    [parameters setValue:@"上传" forKey:@"upload"];
    [parameters setValue:@"" forKey:@"attachmenturl[]"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    [parameters setValue:fileName forKey:@"attachment[]"];
//    [parameters setValue:@"" forKey:@"attachment[]"];
//    [parameters setValue:@"" forKey:@"attachment[]"];
//    [parameters setValue:@"" forKey:@"attachment[]"];
//    [parameters setValue:@"" forKey:@"attachment[]"];
    

    
    
    NSURL * uploadUrl = [CCFUrlBuilder buildUploadFileURL];
    
    //[_browser.requestSerializer setValue:@"multipart/form-data; boundary=----WebKitFormBoundaryG9KMXkoSxJnZByFF" forHTTPHeaderField:@"Content-Type"];

    [_browser POSTWithURL:uploadUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString * type = [self contentTypeForImageData:image];
        
        //[formData appendPartWithFileData:image name:@"attachment[]" fileName:@"abc123.jpeg" mimeType:type];
        
        UIImage *image = [UIImage imageNamed:@"test.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        
        
        [formData appendPartWithFileData:data name:@"attachment[]" fileName:fileName mimeType:type];
        
        //[formData appendPartWithFormData:data name:fileName];
        
    } requestCallback:^(NSString *html) {
        
        NSLog(@"上传结果-------->>>>>>>> :   %@", html);
        NSLog(@"上传结果-------->>>>>>>> 上传结束");
    }];
    
}


// 获取发新帖子的Posttime hash 和token
-(void) createNewThreadPrepair:(NSString *)formId :(CallBack) callback{
    
    NSURL * newThreadUrl = [CCFUrlBuilder buildNewThreadURL:formId];
    
    [_browser GETWithURL:newThreadUrl requestCallback:^(NSString *html) {
        CCFParser * parser = [[CCFParser alloc]init];
        
        NSString * token = [parser parseSecurityToken:html];
        NSString * postTime = [[token componentsSeparatedByString:@"-"] firstObject];
        NSString * hash = [parser parsePostHash:html];
        
        callback(token, hash, postTime);
    }];

}

-(void) uploadImage:(NSURL *)url :(NSString *)token fId:(NSString *)fId postTime:(NSString *)postTime hash:(NSString *)hash :(NSData *) imageData callback:(success)callback{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    //[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString * cookie = [self loadCookie];
    NSLog(@"=================================>>>>>>>>> %@ <<<<<<<<<<<<<<<<<<<<", cookie);
    [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    
    NSString *boundary = @"----WebKitFormBoundaryuMLI1FFamzkfbSe5";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setValue:token forHTTPHeaderField:@"securitytoken"];
    
    
    
    // post body
    NSMutableData *body = [NSMutableData data];

    
    
    // add params (all params are strings)
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"" forKey:@"s"];
    [parameters setValue:token forKey:@"securitytoken"];
    [parameters setValue:@"manageattach" forKey:@"do"];
    [parameters setValue:@"" forKey:@"t"];
    [parameters setValue:fId forKey:@"f"];
    [parameters setValue:@"" forKey:@"p"];
    [parameters setValue:postTime forKey:@"poststarttime"];
    [parameters setValue:@"0" forKey:@"editpost"];
    [parameters setValue:hash forKey:@"posthash"];
    [parameters setValue:@"16777216" forKey:@"MAX_FILE_SIZE"];
    [parameters setValue:@"上传" forKey:@"upload"];
    [parameters setValue:@"" forKey:@"attachmenturl[]"];
    

    for (NSString *param in parameters) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"222222.jpg\"\r\n", @"attachment[]"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if(data.length > 0) {
            //success
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            callback(responseString);
        } else{
            callback(@"failed");
        }
    }];
}





@end
