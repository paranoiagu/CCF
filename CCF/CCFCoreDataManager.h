//
//  CCFCoreDataManager.h
//  CCF
//
//  Created by WDY on 16/1/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CoreDataManager.h"
#import "CCFFormJSONModel.h"

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



@interface CCFCoreDataManager : CoreDataManager

-(instancetype)initWithCCFCoreDataEntry:(CCFCoreDataEntry) enrty;

-(NSArray<CCFFormJSONModel *> *)selectFavForms:(NSArray *) ids;

@end
