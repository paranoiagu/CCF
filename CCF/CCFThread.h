//
//  CCFThread.h
//  CCF
//
//  Created by WDY on 15/12/29.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFPost.h"

@interface CCFThread : NSObject

@property (nonatomic, assign) NSString* threadID;
@property (nonatomic, assign) NSString* threadLink;
@property (nonatomic, assign) CCFPost* thresdPosts;

@property (nonatomic, assign) NSUInteger threadTotalPostCount;

@property (nonatomic, assign) NSUInteger threadTotalPage;

@property (nonatomic, assign) NSUInteger threadCurrentPage;

@end
