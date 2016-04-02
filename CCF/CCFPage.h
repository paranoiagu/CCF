//
//  CCFPage.h
//  CCF
//
//  Created by WDY on 16/3/16.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFPage : NSObject

@property (nonatomic, strong) NSMutableArray * dataList;

@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, assign) NSUInteger totalPageCount;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign) NSString * securityToken;
@property (nonatomic, assign) NSString * ajaxLastPost;


@end
