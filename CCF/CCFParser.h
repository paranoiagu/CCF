//
//  CCGParser.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "User.h"
#import "NormalThread.h"
#import "FormEntry+CoreDataProperties.h"
#import "ForumDisplayPage.h"
#import "ShowThreadPage.h"
#import "Forum.h"
#import "CCFSearchPage.h"
#import "CCFUserProfile.h"
#import "CCFShowPM.h"


@interface CCFParser : NSObject


- (ShowThreadPage *) parseShowThreadWithHtml:(NSString*)html;


- (ForumDisplayPage *) parseThreadListFromHtml: (NSString *) html withThread:(int) threadId andContainsTop:(BOOL)containTop;

- (ForumDisplayPage *) parseFavThreadListFormHtml: (NSString *) html;

- (NSString *) parseSecurityToken:(NSString *)html;

- (NSString *) parsePostHash:(NSString *)html;

- (NSString *) parserPostStartTime:(NSString *)html;


- (NSString *) parseLoginErrorMessage:(NSString *)html;

- (CCFSearchPage *) parseSearchPageFromHtml:( NSString*) html;

- (NSMutableArray<Forum *> *) parseFavFormFormHtml:(NSString *)html;

- (ForumDisplayPage*) parsePrivateMessageFormHtml:(NSString*) html;

- (CCFShowPM *) parsePrivateMessageContent:(NSString*) html;

- (NSString *) parseQuickReplyQuoteContent:(NSString*) html;

- (NSString *) parseQuickReplyTitle:(NSString *)html;

- (NSString *) parseQuickReplyTo:(NSString *)html;

- (NSString *) parseUserAvatar:(NSString *)html userId:(NSString*) userId;

- (NSString *) parseListMyThreadRedirectUrl:(NSString *)html;

- (CCFUserProfile *) parserProfile:(NSString*)html userId:(NSString*)userId;

- (NSArray<Forum *> *) parserForms:(NSString *) html;

@end
