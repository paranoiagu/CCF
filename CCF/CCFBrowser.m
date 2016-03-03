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
#define kCCFCookie_LastVisit @"bblastvisit"
#define kCCFCookie_IDStack @"IDstack"
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



-(void)browseWithUrl:(NSURL *)url :(Handler)callBack{
    
    [_browser GETWithURL:url requestCallback:^(BOOL isSuccess, NSString *html) {
        if (isSuccess) {
            CCFParser * parser = [[CCFParser alloc]init];
            NSString * token = [parser parseSecurityToken:html];
            if (token != nil) {
                [self saveSecurityToken:token];
            }
            callBack(YES,html);
        } else{
            callBack(NO, html);
        }
    }];
}

-(void) loginWithName:(NSString *)name andPassWord:(NSString *)passWord :(Handler)callBack{
    NSURL * loginUrl = [CCFUrlBuilder buildLoginURL];
    NSString * md5pwd = [passWord md5HexDigest];
    
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
    
    [_browser POSTWithURL:loginUrl parameters:parameters requestCallback:^(BOOL isSuccess, NSString *html) {
        if (isSuccess) {
            callBack(YES,html);
            // 保存Cookie
            [self saveCookie];
        } else{
            callBack(NO,html);
        }
        
        
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

-(LoginCCFUser *)getCurrentCCFUser{
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


-(void)replyThreadWithId:(NSString *)threadId withMessage:(NSString *)message handler:(Handler)result{
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
    
    LoginCCFUser * user = [self getCurrentCCFUser];
    
    [parameters setValue:user.userID forKey:@"loggedinuser"];
    [parameters setValue:@"1" forKey:@"fromquickreply"];
    
    [parameters setValue:@"0" forKey:@"styleid"];
    [parameters setValue:@"0" forKey:@"wysiwyg"];
    
    
    [parameters setValue:@"" forKey:@"s"];
    
    [_browser POSTWithURL:loginUrl parameters:parameters requestCallback:^(BOOL isSuccess, NSString *html) {
        if (isSuccess) {
            // 保存Cookie
            [self saveCookie];
            
            result(YES,html);

        } else{
            result(NO,html);
        }
    }];
}


-(void)searchWithKeyWord:(NSString *)keyWord searchDone:(Handler)callback{

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
    
    [_browser GETWithURL:searchUrl requestCallback:^(BOOL isSuccess, NSString *html) {
        
        if (isSuccess) {
            CCFParser * parser = [[CCFParser alloc]init];
            NSString * token = [parser parseSecurityToken:html];
            if (token != nil) {
                [self saveSecurityToken:token];
            }
            
            NSString * securitytoken = [self readSecurityToken];
            [parameters setValue:securitytoken forKey:@"securitytoken"];
            
            [_browser POSTWithURL:searchUrl parameters:parameters requestCallback:^(BOOL isSuccess, NSString *html) {
                if (isSuccess) {
                    [self saveCookie];
                    
                    callback(YES, html);
                } else{
                    callback(NO, html);
                }
                
            }];
        } else{
            callback(NO,html);
        }
        
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

-(void)createNewThreadWithFormId:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImages:(NSData *)image handler:(Handler)handler{
    message = [message stringByAppendingString:@"\n[RIGHT][URL=\"https://bbs.et8.net/bbs/showthread.php?t=1332499\"]Test For: CCF Client[/URL][/RIGHT]"];
    
    // 准备发帖
    [self createNewThreadPrepair:fId :^(NSString *token, NSString *hash, NSString *time) {
        
        if (image != nil) {
            // 没有图片，直接发送主题
            [self doPostThread:fId withSubject:subject andMessage:message withToken:token withHash:hash postTime:time handler:^(BOOL isSuccess, id result) {
                handler(isSuccess,result);
            }];
        } else{
            // 如果有图片，先传图片
            [self uploadImagePrepair:fId startPostTime:time postHash:hash :^(BOOL isSuccess, NSString* result) {
                
                // 解析出上传图片需要的参数
                CCFParser * parser = [[CCFParser alloc]init];
                NSString * uploadToken = [parser parseSecurityToken:result];
                NSString * uploadTime = [[token componentsSeparatedByString:@"-"] firstObject];
                NSString * uploadHash = [parser parsePostHash:result];
                
                [self uploadImage:[CCFUrlBuilder buildUploadFileURL] :uploadToken fId:fId postTime:uploadTime hash:uploadHash :image callback:^(BOOL isSuccess, id result) {
                    [self doPostThread:fId withSubject:subject andMessage:message withToken:token withHash:hash postTime:time handler:^(BOOL isSuccess ,id result) {
                        handler(isSuccess, result);
                    }];
                }];
                
            }];
        }

    }];
}




// 正式开始发送
-(void) doPostThread:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withToken:(NSString*) token withHash:(NSString*) hash postTime:(NSString*)time handler:(Handler) handler{
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
    
    LoginCCFUser *user = [self getCurrentCCFUser];
    [parameters setValue:user.userID forKey:@"loggedinuser"];
    [parameters setValue:@"发表主题" forKey:@"sbutton"];
    [parameters setValue:@"1" forKey:@"parseurl"];
    [parameters setValue:@"9999" forKey:@"emailupdate"];
    [parameters setValue:@"4" forKey:@"polloptions"];
    
    NSURL * newPostUrl = [CCFUrlBuilder buildNewThreadURL:fId];
    
    [_browser POSTWithURL:newPostUrl parameters:parameters requestCallback:^(BOOL isSuccess, NSString *html) {
        if (isSuccess) {
            [self saveCookie];
        }
        handler(isSuccess, html);
        
    }];
}


// 进入图片管理页面，准备上传图片
-(void)uploadImagePrepair:(NSString*)formId startPostTime:(NSString*)time postHash:(NSString*)hash :(Handler) callback{
    NSURL * url = [CCFUrlBuilder buildManageFileURL:formId postTime:time postHash:hash];
    
    [_browser GETWithURL:url requestCallback:^(BOOL isSuccess, NSString *html) {
      callback(isSuccess, html);
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
    

    
    
    NSURL * uploadUrl = [CCFUrlBuilder buildUploadFileURL];
    
    //[_browser.requestSerializer setValue:@"multipart/form-data; boundary=----WebKitFormBoundaryG9KMXkoSxJnZByFF" forHTTPHeaderField:@"Content-Type"];

    [_browser POSTWithURL:uploadUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString * type = [self contentTypeForImageData:image];
        
        //[formData appendPartWithFileData:image name:@"attachment[]" fileName:@"abc123.jpeg" mimeType:type];
        
        UIImage *image = [UIImage imageNamed:@"test.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        
        
        [formData appendPartWithFileData:data name:@"attachment[]" fileName:fileName mimeType:type];
        
        //[formData appendPartWithFormData:data name:fileName];
        
    } requestCallback:^(BOOL isSuccess, NSString *html) {
        
        NSLog(@"上传结果-------->>>>>>>> :   %@", html);
        NSLog(@"上传结果-------->>>>>>>> 上传结束");
    }];
    
}


// 获取发新帖子的Posttime hash 和token
-(void) createNewThreadPrepair:(NSString *)formId :(CallBack) callback{
    
    NSURL * newThreadUrl = [CCFUrlBuilder buildNewThreadURL:formId];
    
    [_browser GETWithURL:newThreadUrl requestCallback:^(BOOL isSuccess, NSString *html) {
        
        if (isSuccess) {
            CCFParser * parser = [[CCFParser alloc]init];
            
            NSString * token = [parser parseSecurityToken:html];
            NSString * postTime = [[token componentsSeparatedByString:@"-"] firstObject];
            NSString * hash = [parser parsePostHash:html];
            
            callback(token, hash, postTime);
        } else{
            callback(nil, nil, nil);
        }
        
    }];

}

-(void) uploadImage:(NSURL *)url :(NSString *)token fId:(NSString *)fId postTime:(NSString *)postTime hash:(NSString *)hash :(NSData *) imageData callback:(Handler)callback{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    //[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString * cookie = [self loadCookie];
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
            callback(YES, responseString);
        } else{
            callback(NO, @"failed");
        }
    }];
}

-(void)privateMessageWithType:(int)type andpage:(int)page handler:(Handler)handler{
    [_browser GETWithURL:[CCFUrlBuilder buildPrivateMessageWithType:type andPage:page] requestCallback:^(BOOL isSuccess, NSString *html) {
        handler(isSuccess, html);
    }];
}

-(void)showPrivateContentById:(NSString *)pmId handler:(Handler)handler{
    [_browser GETWithURL:[CCFUrlBuilder buildShowPrivateMessageURLWithId:pmId] requestCallback:^(BOOL isSuccess, NSString *html) {
        handler(isSuccess, html);
    }];
}

-(void)replyPrivateMessageWithId:(NSString *)pmId andMessage:(NSString *)message handler:(Handler)handler{

    
    [_browser GETWithURL:[CCFUrlBuilder buildShowPrivateMessageURLWithId:pmId] requestCallback:^(BOOL isSuccess, NSString *html) {
        
        if (isSuccess) {
            CCFParser * parser = [[CCFParser alloc]init];
            NSString * token = [parser parseSecurityToken:html];
            
            NSString * quote = [parser parseQuickReplyQuoteContent:html];
            
            NSString * title = [parser parseQuickReplyTitle:html];
            NSString * name = [parser parseQuickReplyTo:html];
            
            
            NSURL * replyUrl = [CCFUrlBuilder buildReplyPrivateMessageURLWithReplyedID:pmId];
            NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
            
            NSString * realMessage = [[quote stringByAppendingString:@"\n"] stringByAppendingString:message];
            
            [parameters setValue:realMessage forKey:@"message"];
            [parameters setValue:@"0" forKey:@"wysiwyg"];
            [parameters setValue:@"6" forKey:@"styleid"];
            [parameters setValue:@"1" forKey:@"fromquickreply"];
            [parameters setValue:@"" forKey:@"s"];
            [parameters setValue:token forKey:@"securitytoken"];
            [parameters setValue:@"insertpm" forKey:@"do"];
            [parameters setValue:pmId forKey:@"pmid"];
            //[parameters setValue:@"0" forKey:@"loggedinuser"]; 经过测试，这个参数不写也行
            [parameters setValue:@"1" forKey:@"parseurl"];
            [parameters setValue:@"1" forKey:@"signature"];
            [parameters setValue:title forKey:@"title"];
            [parameters setValue:name forKey:@"recipients"];
            
            [parameters setValue:@"0" forKey:@"forward"];
            [parameters setValue:@"1" forKey:@"savecopy"];
            [parameters setValue:@"提交信息" forKey:@"sbutton"];
            
            [_browser POSTWithURL:replyUrl parameters:parameters requestCallback:^(BOOL isSuccess, NSString *html) {
                handler(isSuccess, html);
            }];
        } else{
            handler(NO, nil);
        }
        
    }];
    
    
    
}

-(void)sendPrivateMessageToUserName:(NSString *)name andTitle:(NSString *)title andMessage:(NSString *)message handler:(Handler)handler{

    
    [_browser GETWithURL:[CCFUrlBuilder buildNewPMUR] requestCallback:^(BOOL isSuccess,NSString *html) {
        if (isSuccess) {
            CCFParser * parser = [[CCFParser alloc]init];
            NSString * token = [parser parseSecurityToken:html];
            
            
            NSURL * sendPMUrl = [CCFUrlBuilder buildSendPrivateMessageURL];
            NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
            
            
            [parameters setValue:message forKey:@"message"];
            [parameters setValue:title forKey:@"title"];
            [parameters setValue:@"0" forKey:@"pmid"];
            [parameters setValue:name forKey:@"recipients"];
            [parameters setValue:@"0" forKey:@"wysiwyg"];
            [parameters setValue:@"" forKey:@"s"];
            [parameters setValue:token forKey:@"securitytoken"];
            [parameters setValue:@"0" forKey:@"forward"];
            [parameters setValue:@"1" forKey:@"savecopy"];
            [parameters setValue:@"提交信息" forKey:@"sbutton"];
            [parameters setValue:@"1" forKey:@"parseurl"];
            [parameters setValue:@"insertpm" forKey:@"do"];
            [parameters setValue:@"" forKey:@"bccrecipients"];
            [parameters setValue:@"0" forKey:@"iconid"];
            
            [_browser POSTWithURL:sendPMUrl parameters:parameters requestCallback:^(BOOL isSuccess, NSString *sendresult) {
                handler(isSuccess, sendresult);
            }];
        } else{
            handler(NO, nil);
        }
        
    
    }];
}

-(void)listfavoriteForms:(Handler)handler{
    [_browser GETWithURL:[CCFUrlBuilder buildFavFormURL] requestCallback:^(BOOL isSuccess, NSString *html) {
        if (isSuccess) {
            handler(YES, html);
        } else{
            handler(NO, html);
        }
    }];
}












@end
