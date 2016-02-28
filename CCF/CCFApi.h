//
//  CCFApi.h
//  CCF
//
//  Created by 迪远 王 on 16/2/28.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginCCFUser.h"

typedef void (^Handler) (id handler);

typedef void (^LoginHandler) (BOOL isSuccess, NSString* message);

@interface CCFApi : NSObject


// 登录论坛
-(void) loginWithName:(NSString*)name andPassWord:(NSString*) passWord handler:(LoginHandler) handler;

// 获取当前登录的账户信息
-(LoginCCFUser *) getLoginUser;

// 退出论坛
-(void) logout;

// 发表一个新的帖子
-(void) createNewThreadWithFormId:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImages:(NSArray *) images handler:(Handler) handler;

// 发表一个回帖
-(void) replyThreadWithId:(NSString*) threadId andMessage:(NSString*) message handler:(Handler) handler;

// 搜索论坛
-(void) searchWithKeyWord:(NSString*) keyWord handler:(Handler) handler;

// 读取论坛站内私信-收件箱
-(void) privateMessageInbox:(Handler) handler;

// 读取站内私信-发件箱
-(void) privateMessageOutbox:(Handler) handler;

// 发送站内短信
-(void) sendPrivateMessageToUserName:(NSString*)name andTitle:(NSString*)title andMessage:(NSString*) message handler:(Handler)handler;

// 获取收藏的论坛板块
-(void) listfavoriteForms:(Handler) handler;

// 收藏这个论坛
-(void) favoriteFormsWithId:(NSString*)formId;

// 取消收藏论坛
-(void) unfavoriteFormsWithId:(NSString*)formId;


// 获取收藏的主题帖子
-(void)listfavoriteThreadPosts:(Handler)handler;

// 收藏一个主题帖子
-(void)favoriteThreadPostWithId:(NSString *)threadPostId;

// 取消收藏一个主题帖子
-(void)unfavoriteThreadPostWithId:(NSString *)threadPostId;


// 查看新帖
-(void) fetchNewThreads:(Handler)handler;

// 查看今日新帖
-(void) fetchTodayNewThreads:(Handler)handler;

// 显示我的回帖
-(void) listMyAllThreadPost:(Handler)handler;

// 显示我发表的主题
-(void) listMyAllThreads:(Handler)handler;





@end
