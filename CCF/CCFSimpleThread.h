//
//  CCFSimpleThread.h
//  CCF
//
//  Created by WDY on 16/3/17.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFSimpleThread : NSObject

@property (nonatomic, strong) NSString* threadID;
@property (nonatomic, strong) NSString* threadTitle;        // 主题
@property (nonatomic, strong) NSString* threadCategory;     // 主题分类
@property (nonatomic, strong) NSString* threadAuthorName;   // 作者
@property (nonatomic, strong) NSString* threadAuthorID;     // ---------------- 作者UserId
@property (nonatomic, strong) NSString* lastPostTime;       // 最后发表时间

@end
