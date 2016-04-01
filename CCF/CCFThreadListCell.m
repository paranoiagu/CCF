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
    NSIndexPath * selectIndexPath;
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

-(void)setData:(CCFNormalThread *)data{
    self.threadAuthor.text = data.threadAuthorName;
    self.threadTitle.text = data.threadTitle;
    self.threadType.text = data.threadCategory;
    self.threadPostCount.text = data.postCount;
    self.threadCreateTime.text = data.lastPostTime;
    [self showAvatar:self.avatarImage userId:data.threadAuthorID];
}

-(void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath{
    selectIndexPath = indexPath;
    [self setData:data];
}

- (IBAction)showUserProfile:(UIButton *)sender {
    [self.delegate showUserProfile:selectIndexPath];
}
@end
