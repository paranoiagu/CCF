//
//  CCFBrowser.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

#import "LoginCCFUser.h"

@class CCFThreadDetail;


typedef void(^Handler) (BOOL isSuccess, id result);

typedef void (^Reply) (BOOL isSuccess, id result);

typedef void (^CallBack) (NSString* token, NSString * hash, NSString* time );


@interface CCFBrowser : NSObject

@property (nonatomic, strong) AFHTTPSessionManager * browser;

-(void) browseWithUrl:(NSURL*) url : (Handler) callBack ;

-(void) loginWithName:(NSString*)name andPassWord:(NSString*)passWord : (Handler) callBack;

-(void) refreshVCodeToUIImageView:(UIImageView* ) vCodeImageView;

-(void) replyThreadWithId:(NSString *) threadId withMessage:(NSString *) message handler: (Handler) result;

-(LoginCCFUser *) getCurrentCCFUser;

-(void) searchWithKeyWord:(NSString*) keyWord searchDone:(Handler) callback;


-(void)createNewThreadWithFormId:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImages:(NSData *)image handler:(Handler)handler;

// 读取论坛站内私信   type 0 表示收件箱   1表示发件箱
-(void) privateMessageWithType:(int) type andpage:(int)page handler:(Handler) handler;

// 根据PM ID 显示一条私信内容
-(void) showPrivateContentById:(NSString*)pmId handler:(Handler)handler;

// 回复站内短信
-(void) replyPrivateMessageWithId:(NSString*)pmId andMessage:(NSString*) message handler:(Handler)handler;

// 发送站内短信
-(void) sendPrivateMessageToUserName:(NSString*)name andTitle:(NSString*)title andMessage:(NSString*) message handler:(Handler)handler;

// 获取收藏的论坛板块
-(void) listfavoriteForms:(Handler) handler;

// 显示我的回帖
-(void) listMyAllThreadPost:(Handler)handler;

// 显示我发表的主题
-(void) listMyAllThreads:(Handler)handler;

-(void)favoriteFormsWithId:(NSString *)formId handler:(Handler) handler;

@end
