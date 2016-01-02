//
//  CCFFormList.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFThreadList : NSObject

@property (nonatomic, strong) NSString* threadTitle;

@property (nonatomic, strong) NSString* threadID;

@property (nonatomic, assign) NSUInteger threadTotalPostCount;

@property (nonatomic, strong) NSString* threadAuthor;

@end
