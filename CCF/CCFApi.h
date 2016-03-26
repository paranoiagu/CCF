//
//  CCFApi.h
//  CCF
//
//  Created by 迪远 王 on 16/2/28.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginCCFUser.h"
#import "CCFPage.h"
#import "CCFSearchThread.h"
#import "CCFSearchPage.h"
#import "CCFUserProfile.h"

typedef void (^HandlerWithBool) (BOOL isSuccess, id message);

@interface CCFApi : NSObject


// 登录论坛
-(void) loginWithName:(NSString*)name andPassWord:(NSString*) passWord handler:(HandlerWithBool) handler;

// 获取当前登录的账户信息
-(LoginCCFUser *) getLoginUser;

// 退出论坛
-(void) logout;

// 发表一个新的帖子
-(void) createNewThreadWithFormId:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImages:(NSData *) image handler:(HandlerWithBool) handler;

// 发表一个回帖
-(void) replyThreadWithId:(NSString*) threadId andMessage:(NSString*) message handler:(HandlerWithBool) handler;

// 搜索论坛
-(void) searchWithKeyWord:(NSString*) keyWord handler:(HandlerWithBool) handler;

// 根据PM ID 显示一条私信内容
-(void) showPrivateContentById:(int)pmId handler:(HandlerWithBool)handler;

// 发送站内短信
-(void) sendPrivateMessageToUserName:(NSString*)name andTitle:(NSString*)title andMessage:(NSString*) message handler:(HandlerWithBool)handler;

// 回复站内短信
-(void) replyPrivateMessageWithId:(int)pmId andMessage:(NSString*) message handler:(HandlerWithBool)handler;

// 收藏这个论坛
-(void) favoriteFormsWithId:(NSString*)formId handler:(HandlerWithBool)handler;

// 取消收藏论坛
-(void) unfavoriteFormsWithId:(NSString*)formId handler:(HandlerWithBool)handler;

// 收藏一个主题帖子
-(void)favoriteThreadPostWithId:(NSString *)threadPostId handler:(HandlerWithBool)handler;

// 取消收藏一个主题帖子
-(void)unfavoriteThreadPostWithId:(NSString *)threadPostId handler:(HandlerWithBool)handler;

//------------------------------读取API-----------------------------------------//
// 读取论坛站内私信List   type 0 表示收件箱   -1表示发件箱
-(void) listPrivateMessageWithType:(int) type andPage:(int)page handler:(HandlerWithBool) handler;

// 获取收藏的论坛板块
-(void) listFavoriteForms:(HandlerWithBool) handler;

// 获取收藏的主题帖子
-(void)listFavoriteThreadPostsWithPage:(int)page handler:(HandlerWithBool)handler;

// 查看新帖
-(void) listNewThreadPostsWithPage:(int)page handler:(HandlerWithBool)handler;

// 查看今日新帖
-(void) listTodayNewThreadsWithPage:(int) page handler:(HandlerWithBool)handler;

// 显示我的回帖
-(void) listMyAllThreadPost:(HandlerWithBool)handler;

// 显示我发表的主题
-(void) listMyAllThreadsWithPage:(int)page handler:(HandlerWithBool)handler;

// 显示主题帖子和所有回帖
-(void) showThreadWithId:(int) threadId andPage:(int)page handler:(HandlerWithBool)handler;

-(void) forumDisplayWithId:(NSString *) formId andPage:(int)page handler:(HandlerWithBool)handler;

-(void) getAvatarWithUserId:(NSString*)userId handler:(HandlerWithBool)handler;

-(void) listSearchResultWithUrl:(NSString *) url andPage:(int) page handler:(HandlerWithBool)handler;

// 显示用户信息页面
-(void) showProfileWithUserId:(NSString*)userId handler:(HandlerWithBool) handler;
@end
