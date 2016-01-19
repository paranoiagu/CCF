//
//  CCFThreadListCell.m
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListCell.h"
#import "CCFThreadList.h"
#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "NSString+Regular.h"
#import <UIImageView+AFNetworking.h>

@implementation CCFThreadListCell{
    CCFBrowser *_browser;
}

@synthesize threadAuthor = _threadAuthor;
@synthesize threadPostCount = _threadPostCount;
@synthesize threadTitle = _threadTitle;
@synthesize threadCreateTime = _threadCreateTime;
@synthesize threadType = _threadType;
@synthesize avatarImage = _avatarImage;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _browser = [[CCFBrowser alloc]init];
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setThreadList:(CCFThreadList *)threadList{
    self.threadAuthor.text = threadList.threadAuthorName;
    self.threadTitle.text = threadList.threadTitle;
    self.threadPostCount.text = [NSString stringWithFormat:@"%ld", threadList.threadTotalPostCount];
    
    NSURL * url = [CCFUrlBuilder buildMemberURL:threadList.threadAuthorID];
    
    [_browser browseWithUrl:url :^(NSString* result) {
        //https://bbs.et8.net/bbs/customavatars/thumbs/avatar46611_13.gif
        
        NSString * regular = [NSString stringWithFormat:@"/avatar%@_(\\d+).gif", threadList.threadAuthorID];
        
        NSString * avatar = [result stringWithRegular:regular];
        
        [self.avatarImage setImageWithURL:[CCFUrlBuilder buildAvatarURL:avatar]];
        
        NSLog(@"KKKKKKKKKKKKKKKKK %@", avatar);
    }];
    
}
@end
