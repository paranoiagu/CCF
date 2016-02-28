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


typedef void(^success) (id result);

typedef void (^Reply) (BOOL isSuccess, id result);

typedef void (^CallBack) (NSString* token, NSString * hash, NSString* time );


@interface CCFBrowser : NSObject

@property (nonatomic, strong) AFHTTPSessionManager * browser;

-(void) browseWithUrl:(NSURL*) url : (success) callBack ;

-(void) loginWithName:(NSString*)name andPassWord:(NSString*)passWord : (success) callBack;

-(void) refreshVCodeToUIImageView:(UIImageView* ) vCodeImageView;

-(void) replyThreadWithId:(NSString *) threadId withMessage:(NSString *) message handler: (success) result;

-(LoginCCFUser *) getCurrentCCFUser;

-(void) searchWithKeyWord:(NSString*) keyWord searchDone:(success) callback;


-(void)createNewThreadWithFormId:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImages:(NSData *)image handler:(success)handler;

// 读取论坛站内私信-收件箱
-(void) privateMessageInbox:(success) handler;

// 读取站内私信-发件箱
-(void) privateMessageOutbox:(success) handler;

// 发送站内短信
-(void) sendPrivateMessageToUserName:(NSString*)name andTitle:(NSString*)title andMessage:(NSString*) message handler:(success)handler;


@end
