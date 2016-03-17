//
//  CCFThread.h
//  CCF
//
//  Created by WDY on 16/3/15.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFThread : NSObject

@property (nonatomic, strong) NSString* threadID;

@property (nonatomic, strong) NSString* threadTitle;        // 主题
@property (nonatomic, strong) NSString* threadAuthorName;   // 作者
@property (nonatomic, strong) NSString* threadAuthorID;     // ---------------- 作者UserId
@property (nonatomic, strong) NSString* lastPostTime;       // 最后发表时间
@property (nonatomic, strong) NSString* postCount;          // 回复数
@property (nonatomic, strong) NSString* openCount;          // 查看数量
@property (nonatomic, strong) NSString* lastPostAuthorName; // 最后发表的人

@end
