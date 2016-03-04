//
//  CCFUrlBuilder.m
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFUrlBuilder.h"

#define kCCFIndex @"https://bbs.et8.net/bbs/"

#define kCCFMember @"https://bbs.et8.net/bbs/member.php?u=%@"

#define kCCFFormDisplay @"https://bbs.et8.net/bbs/forumdisplay.php?f=%@&order=desc&page=%@"

#define kCCFShowThread @"https://bbs.et8.net/bbs/showthread.php?t=%@&page=%@"

#define kCCFLogin @"https://bbs.et8.net/bbs/login.php?do=login"

#define kCCFVCode @"https://bbs.et8.net/bbs/login.php?do=vcode"

#define kCCFReply @"https://bbs.et8.net/bbs/newreply.php?do=postreply&t=%@"

#define kCCFFavForm @"https://bbs.et8.net/bbs/usercp.php"

#define kCCFSearch @"https://bbs.et8.net/bbs/search.php"

#define kCCFNewThread @"https://bbs.et8.net/bbs/newthread.php?do=newthread&f=%@"

#define kCCFUploadFile @"https://bbs.et8.net/bbs/newattachment.php?do=manageattach&p="

#define kCCFManageFile @"https://bbs.et8.net/bbs/newattachment.php?f=%@&poststarttime=%@&posthash=%@"

#define kCCFThreadFloor @"https://bbs.et8.net/bbs/showpost.php?p=%@&postcount=1"

#define kCCFAvatar @"https://bbs.et8.net/bbs/customavatars/%@"

#define kCCFPrivateMessageInbox @"https://bbs.et8.net/bbs/private.php?folderid=0"

#define kCCFPrivateMessageOutbox @"https://bbs.et8.net/bbs/private.php?folderid=-1"

@implementation CCFUrlBuilder

+(NSURL *)buildMemberURL:(NSString *)userId{
    
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFMember, userId]];
}
+(NSURL *)buildFormURL:(NSString *)formId withPage:(NSString*) page{
    
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFFormDisplay, formId, page]];
}

+(NSURL *)buildIndexURL{
    return [NSURL URLWithString:kCCFIndex];
}

+(NSURL *)buildThreadURL:(NSString *)threadId withPage:(NSString *)page{
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFShowThread, threadId, page]];
}

+(NSURL *)buildLoginURL{
    return  [NSURL URLWithString:kCCFLogin];
}

+(NSURL *)buildVCodeURL{
    return [NSURL URLWithString:kCCFVCode];
}

+(NSURL *) buildReplyURL:(NSString *)threadId{
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFReply, threadId]];
}

+(NSURL *) buildFavFormURL{
    return [NSURL URLWithString:kCCFFavForm];
}

+(NSURL *)buildSearchUrl{
    return [NSURL URLWithString:kCCFSearch];
}

+(NSURL *)buildNewThreadURL:(NSString *)formId{
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFNewThread, formId]];
}

+(NSURL *)buildUploadFileURL{
    return [NSURL URLWithString:kCCFUploadFile];
}

+(NSURL *)buildManageFileURL:(NSString *)formId postTime:(NSString *)time postHash:(NSString *)hash{
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFManageFile, formId, time, hash]];
}

+(NSURL *)buildThreadFirtFloorByThreadId:(NSString *)threadID{
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFThreadFloor, threadID]];
}

+(NSURL *)buildAvatarURL:(NSString *)avatar{
    return [NSURL URLWithString:[NSString stringWithFormat:kCCFAvatar, avatar]];
}

+(NSURL *) buildPrivateMessageWithType:(int)type andPage:(int)page{
    NSString * url = @"https://bbs.et8.net/bbs/private.php?folderid=%d&pp=30&sort=date&page=%d";
    url = [NSString stringWithFormat:url, type,page];
    return [NSURL URLWithString:url];
}

+(NSURL *)buildShowPrivateMessageURLWithId:(NSString*)messageId{
    NSString * url = [@"https://bbs.et8.net/bbs/private.php?do=showpm&pmid=" stringByAppendingString:messageId];
    return [NSURL URLWithString:url];
}

+(NSURL *)buildReplyPrivateMessageURLWithReplyedID:(NSString *)pmId{
    NSString * url = [@"https://bbs.et8.net/bbs/private.php?do=insertpm&pmid=" stringByAppendingString:pmId];
    return [NSURL URLWithString:url];
}

+(NSURL *)buildSendPrivateMessageURL{
    //
    NSString * url = @"https://bbs.et8.net/bbs/private.php?do=insertpm&pmid=0";
    return [NSURL URLWithString:url];
}

+(NSURL *)buildNewPMUR{
    NSString * url = @"https://bbs.et8.net/bbs/private.php?do=newpm";
    return [NSURL URLWithString:url];
}

+(NSURL *)buildMyThreadPostsURLWithUserId:(NSString*)Id{
    NSString * url = [@"https://bbs.et8.net/bbs/search.php?do=finduser&userid=" stringByAppendingString:Id];
    return [NSURL URLWithString:url];
}

+(NSURL *)buildMyThreadWithName:(NSString *)name{
    NSString * url = [@"https://bbs.et8.net/bbs/search.php?do=process&showposts=0&starteronly=1&exactname=1&searchuser=" stringByAppendingString:name];
    return [NSURL URLWithString:url];
}
@end
