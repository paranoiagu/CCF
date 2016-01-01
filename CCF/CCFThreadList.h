//
//  CCFFormList.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFThreadList : NSObject

@property (nonatomic, assign) NSString* threadTitle;

@property (nonatomic, assign) NSString* threadID;
@property (nonatomic, assign) NSString* threadLink;
@property (nonatomic, assign) NSUInteger threadTotalPostCount;

@property (nonatomic, assign) NSString* threadAuthor;

@end
