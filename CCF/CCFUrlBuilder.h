//
//  CCFUrlBuilder.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCFUrlBuilder : NSObject

+ (NSURL *) buildMemberURL:(NSString*)userId;

+ (NSURL *) buildFormURL:(NSString *)formId withPage:(NSString*) page;

+ (NSURL *) buildThreadURL: (NSString *) threadId withPage:(NSString *) page;

+ (NSURL *) buildIndexURL;

+ (NSURL *) buildLoginURL;

+ (NSURL *) buildVCodeURL;

+ (NSURL *) buildReplyURL:(NSString *)threadId;

+ (NSURL *) buildFavFormURL;

+ (NSURL *) buildSearchUrl;

+ (NSURL *) buildNewThreadURL:(NSString *)formId;

+ (NSURL *) buildManageFileURL:(NSString *)formId postTime:(NSString *)time postHash:(NSString *)hash;

+ (NSURL *) buildUploadFileURL;

+ (NSURL *) buildThreadFirtFloorByThreadId:(NSString *) threadID;

// https://bbs.et8.net/bbs/member.php
+ (NSURL *) buildAvatarURL:(NSString *) avatar;

+ (NSURL *) buildPrivateMessageInbox;

+ (NSURL *) buildPrivateMessageOutbox;


@end
