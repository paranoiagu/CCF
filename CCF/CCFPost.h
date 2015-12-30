//
//  CCFPost.h
//  CCF
//
//  Created by WDY on 15/12/29.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFUser.h"


@interface CCFPost : NSObject

@property (nonatomic, strong) CCFUser* userInfo;
@property (nonatomic, strong) NSString* postLouCeng;    // 帖子楼层
@property (nonatomic, strong) NSString* postID;
@property (nonatomic, strong) NSString* postLink;
@property (nonatomic, strong) NSString* postTitle;
@property (nonatomic, strong) NSString* postTime;
@property (nonatomic, strong) NSString* postContent;


@end
