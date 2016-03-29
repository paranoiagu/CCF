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
}




-(void)setData:(id)data{
    
}

-(void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)showAvatar:(UIImageView *)avatarImageView userId:(NSString*)userId{
    
    NSString * avatarInArray = [avatarCache objectForKey:userId];
    
    if (avatarInArray == nil) {
        NSMutableArray * users = [[coreDateManager selectData:^NSPredicate *{
            return [NSPredicate predicateWithFormat:@"userID = %@", userId];
        }] copy];
        
        if (users == nil || users.count == 0) {
            
            [ccfapi getAvatarWithUserId:userId handler:^(BOOL isSuccess, NSString * avatar) {
                [coreDateManager insertOneData:^(id src) {
                    
                    CCFUserEntry * user =(CCFUserEntry *)src;
                    
                    user.userID = userId;
                    user.userAvatar = avatar;
                }];
                
                [avatarImageView setImageWithURL:[CCFUrlBuilder buildAvatarURL:avatar]];
                
                [avatarCache setObject:avatar == nil ? @"defaultAvatar": avatar forKey:userId];
            }];
            
        } else{
            
            CCFUserEntry * user = users.firstObject;
            if (user.userAvatar == nil) {
                [avatarImageView setImage:defaultAvatar];
                
                [avatarCache setValue:@"defaultAvatar" forKey:user.userID];
                
            } else{
                NSURL * url = [CCFUrlBuilder buildAvatarURL:user.userAvatar];
                [avatarImageView setImageWithURL:url];
                
                [avatarCache setValue:user.userAvatar forKey:user.userID];
            }
            
            
        }
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
