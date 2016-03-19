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
}

-(instancetype)init{
    if (self = [super init]) {
        defaultAvatar = [UIImage imageNamed:@"logo.jpg"];
        
        ccfapi = [[CCFApi alloc] init];
        coreDateManager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryUser];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        defaultAvatar = [UIImage imageNamed:@"logo.jpg"];
        
        ccfapi = [[CCFApi alloc] init];
        coreDateManager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryUser];
    }
    return self;
}

-(void)setData:(id)data{
    [self setData:data];
}

-(void)showAvatar:(UIImageView *)avatarImageView userId:(NSString*)userId{
    
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
        }];
        
    } else{
        
        CCFUserEntry * user = users.firstObject;
        if (user.userAvatar == nil) {
            [avatarImageView setImage:defaultAvatar];
        } else{
            NSURL * url = [CCFUrlBuilder buildAvatarURL:user.userAvatar];
            [avatarImageView setImageWithURL:url];
        }
        
    }
}
@end
