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
@end
