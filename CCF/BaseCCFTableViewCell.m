//
//  BaseCCFTableViewCell.m
//  CCF
//
//  Created by 迪远 王 on 16/3/19.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "BaseCCFTableViewCell.h"

@implementation BaseCCFTableViewCell{
    UIImage * defaultAvatar;
    
    CCFCoreDataManager *coreDateManager;
    CCFApi * ccfapi;
    
    NSMutableDictionary * avatarCache;
    
    NSMutableArray<CCFUserEntry*> * cacheUsers;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initData];
    }
    return self;
}

-(void) initData{
    defaultAvatar = [UIImage imageNamed:@"logo.jpg"];
    
    ccfapi = [[CCFApi alloc] init];
    coreDateManager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryUser];
    avatarCache = [NSMutableDictionary dictionary];
    
    if (cacheUsers == nil) {
        cacheUsers = [[coreDateManager selectData:^NSPredicate *{
            return [NSPredicate predicateWithFormat:@"userID > %d", 0];
        }] copy];
    }
    
    for (CCFUserEntry * user in cacheUsers) {
        [avatarCache setValue:user.userAvatar forKey:user.userID];
    }
}




-(void)setData:(id)data{
    
}

-(void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)showAvatar:(UIImageView *)avatarImageView userId:(NSString*)userId{
    
    // 不知道什么原因，userID可能是nil
    if (userId == nil) {
        [avatarImageView setImage:defaultAvatar];
        return;
    }
    NSString * avatarInArray = [avatarCache valueForKey:userId];
    
    if (avatarInArray == nil) {
        
        [ccfapi getAvatarWithUserId:userId handler:^(BOOL isSuccess, NSString *avatar) {
            // 存入数据库
            [coreDateManager insertOneData:^(id src) {
                CCFUserEntry * user =(CCFUserEntry *)src;
                user.userID = userId;
                user.userAvatar = avatar;
            }];
            // 添加到Cache中
            [avatarCache setValue:avatar == nil ? @"defaultAvatar": avatar forKey:userId];
            
            // 显示头像
            if (avatar == nil) {
                [avatarImageView setImage:defaultAvatar];
            } else{
                [avatarImageView setImageWithURL:[CCFUrlBuilder buildAvatarURL:avatar]];
            }
        }];
    } else{
        if ([avatarInArray isEqualToString:@"defaultAvatar"]) {
            [avatarImageView setImage:defaultAvatar];
        } else{
            NSURL * url = [CCFUrlBuilder buildAvatarURL:avatarInArray];
            [avatarImageView setImageWithURL:url];
        }
    }
}
@end
