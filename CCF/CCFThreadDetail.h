//
//  CCFThread.h
//  CCF
//
//  Created by WDY on 15/12/29.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCFPost.h"

@interface CCFThreadDetail : NSObject

@property (nonatomic, strong) NSString* threadID;
@property (nonatomic, strong) NSString* threadLink;

@property (nonatomic, strong) NSString * threadTitle;

@property (nonatomic, strong) NSMutableArray<CCFPost *> * threadPosts;

@property (nonatomic, assign) NSUInteger threadTotalPostCount;

@property (nonatomic, assign) NSUInteger threadTotalPage;

@property (nonatomic, assign) NSUInteger threadCurrentPage;

@end
