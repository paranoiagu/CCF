//
//  CCFSearchResult.h
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFSearchResult : NSObject


@property (nonatomic, strong) NSString* threadID;
@property (nonatomic, strong) NSString* threadTitle;
@property (nonatomic, strong) NSString* threadAuthor;
@property (nonatomic, strong) NSString* threadCreateTime;
@property (nonatomic, strong) NSString* threadBelongForm;

@end
