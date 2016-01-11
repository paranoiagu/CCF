//
//  CCFSearchResultPage.h
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>



@class CCFSearchResult;

@interface CCFSearchResultPage : NSObject


@property (nonatomic, strong) NSMutableArray<CCFSearchResult *> * searchResults;

@property (nonatomic, assign) NSUInteger searchResultTotalCount;

@property (nonatomic, assign) NSUInteger searchResultTotalPage;

@property (nonatomic, assign) NSUInteger searchCurrentPage;


@end
