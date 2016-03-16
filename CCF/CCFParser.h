//
//  CCGParser.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFPost.h"
#import "CCFUser.h"
#import "CCFNormalThread.h"
#import "FormEntry+CoreDataProperties.h"
#import "CCFPage.h"
#import "CCFShowThreadPage.h"
#import "CCFForm.h"


@interface CCFParser : NSObject


- (CCFShowThreadPage *) parseShowThreadWithHtml:(NSString*)html;


- (CCFPage *) parseThreadListFromHtml: (NSString *) html withThread:(NSString *) threadId andContainsTop:(BOOL)containTop;

- (CCFPage *) parseFavThreadListFormHtml: (NSString *) html;

- (NSString *) parseSecurityToken:(NSString *)html;

- (NSString *) parsePostHash:(NSString *)html;

- (NSString *) parseLoginErrorMessage:(NSString *)html;

- (CCFPage *) parseSearchPageFromHtml:( NSString*) html;

- (NSMutableArray<CCFForm *> *) parseFavFormFormHtml:(NSString *)html;

- (CCFPage*) parseInboxMessageFormHtml:(NSString*) html;

- (NSString *) parsePrivateMessageContent:(NSString*) html;

- (NSString *) parseQuickReplyQuoteContent:(NSString*) html;

- (NSString *) parseQuickReplyTitle:(NSString *)html;

- (NSString *) parseQuickReplyTo:(NSString *)html;

- (NSString *) parseUserAvatar:(NSString *)html userId:(NSString*) userId;

- (NSString *) parseListMyThreadRedirectUrl:(NSString *)html;

@end
