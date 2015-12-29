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

@property (nonatomic, assign) CCFUser* userInfo;
@property (nonatomic, assign) NSString* postStrID;
@property (nonatomic, assign) NSUInteger postIntID;
@property (nonatomic, assign) NSString* postLink;
@property (nonatomic, assign) NSString* postTitle;
@property (nonatomic, assign) NSString* postTime;
@property (nonatomic, assign) NSString* postContent;


@end
