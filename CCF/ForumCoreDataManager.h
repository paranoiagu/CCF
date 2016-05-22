//
//  CCFCoreDataManager.h
//  CCF
//
//  Created by WDY on 16/1/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CoreDataManager.h"
#import "Forum.h"


typedef NS_ENUM(NSInteger, CCFCoreDataEntry) {
    CCFCoreDataEntryForm = 0,
    CCFCoreDataEntryPost,
    CCFCoreDataEntryUser
    
};


#pragma mark Form 相关
#define kFormEntry @"FormEntry"
#define kFormXcda @"Form"
#define kFormDBName @"Form.sqlite"

#define kUserEntry @"CCFUserEntry"



@interface ForumCoreDataManager : CoreDataManager

-(instancetype)initWithCCFCoreDataEntry:(CCFCoreDataEntry) enrty;

-(NSArray<Forum *> *)selectFavForms:(NSArray *) ids;

-(NSArray<Forum *> *)selectChildFormsForId:(int)formId;

-(NSArray<Forum *> *)selectAllForms;

@end
