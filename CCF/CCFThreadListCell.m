//
//  CCFThreadListCell.m
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListCell.h"
#import "CCFNormalThread.h"
#import "CCFUrlBuilder.h"
#import "NSString+Regular.h"
#import <UIImageView+AFNetworking.h>
#import "CCFCoreDataManager.h"
#import "CCFUserEntry+CoreDataProperties.h"
#import "CCFApi.h"

@implementation CCFThreadListCell{

    CCFCoreDataManager *_coreDateManager;
    CCFApi * ccfapi;
}

@synthesize threadAuthor = _threadAuthor;
@synthesize threadPostCount = _threadPostCount;
@synthesize threadTitle = _threadTitle;
@synthesize threadCreateTime = _threadCreateTime;
@synthesize threadType = _threadType;
@synthesize avatarImage = _avatarImage;

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {

        ccfapi = [[CCFApi alloc] init];
        _coreDateManager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryUser];
        
        [self.avatarImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.avatarImage.contentMode =  UIViewContentModeScaleAspectFit;
        self.avatarImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.avatarImage.clipsToBounds  = YES;

    }
    return self;
}


-(void)setThreadList:(CCFNormalThread *)threadList{
    self.threadAuthor.text = threadList.threadAuthorName;
    self.threadTitle.text = threadList.threadTitle;
    self.threadType.text = threadList.threadCategory;
    self.threadPostCount.text = threadList.postCount;
    
    
    NSMutableArray * users = [[_coreDateManager selectData:^NSPredicate *{
       return [NSPredicate predicateWithFormat:@"userID = %@", threadList.threadAuthorID];
    }] copy];
    
    if (users == nil || users.count == 0) {

        [ccfapi getAvatarWithUserId:threadList.threadAuthorID handler:^(BOOL isSuccess, NSString * avatar) {
            [_coreDateManager insertOneData:^(id src) {
                
                CCFUserEntry * user =(CCFUserEntry *)src;
                
                user.userID = threadList.threadAuthorID;
                user.userAvatar = avatar;
            }];
            
            [self.avatarImage setImageWithURL:[CCFUrlBuilder buildAvatarURL:avatar]];
        }];

    } else{
        
        CCFUserEntry * user = users.firstObject;
        if (user.userAvatar == nil) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"jpg"];
//            NSURL* url = [NSURL fileURLWithPath:path];
//            [self.avatarImage setImageWithURL:url];
            
            [self.avatarImage setImage:[UIImage imageNamed:@"logo.jpg"]];
        } else{
            
            NSLog(@"+++++++++++++++++++++++++++++++++++++++++++%@", user.userAvatar);
            
            NSURL * url = [CCFUrlBuilder buildAvatarURL:user.userAvatar];
            
            [self.avatarImage setImageWithURL:url];
        }
        
    }
    
    
}
@end
